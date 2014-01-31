class NamespaceEditor

attr_accessor :new_namespace, :old_namespace, :src_path, :extensions
attr_reader :changed_files_count

	def initialize(new_namespace, old_namespace, src_path, file_extensions, list = false, overwrite = true)
		@new_namespace = new_namespace
		@old_namespace = old_namespace
		@src_path = src_path
		@extensions = file_extensions
		@list = list
		@overwrite = overwrite

		@changed_files_count = 0
	end
	
	def read_file file_path
		File.open file_path, "r"  do | file |
			file.read
		end
	end
	
	def replace_namespace
		@changed_files_count = 0
		@extensions.each do | extension |
			unless @list
				puts "\tprocessing #{extension} files in #{@src_path}"
				print "\t"
			end
			Dir.glob(@src_path + "/**/*.#{extension}") do |file|	#find src files in current folder and all subfolders
				do_replace_namespace file
			end
			unless @list
				puts
			end
		end
		unless @list
			puts
		end
		unless @list
			if @overwrite
				puts "There were #{@changed_files_count} changes made"
			else
				puts "#{@changed_files_count} file(s) were found. Use the --overwrite flag to make changes to the files"
			end
		end
	end
	
	def do_replace_namespace file
		src = read_file file
		
		src_after_replacing_namespace = src.gsub(@old_namespace, @new_namespace)

		unless src_after_replacing_namespace === src
			if @overwrite
				begin
					output = File.new(file, "w")
					output.write src_after_replacing_namespace
					output.close
				rescue
					puts
					STDERR.puts "ERROR: There was a problem writing to '#{file}"
					exit 1
				end
			end
			
			if @list
				puts File.absolute_path(file)
			else
				print "."
			end
			@changed_files_count += 1
		end
		@changed_files_count
	end
end