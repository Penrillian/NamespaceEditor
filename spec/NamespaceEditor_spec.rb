require 'spec_helper.rb'

describe NamespaceEditor do

	before :all do
		@new_namespace = "some.new.namespace"
		@old_namespace = "some.old.namespace"
		@src_text = [@old_namespace, "\nclass HelloWorld", "\n{", "\n\tHelloWorld()", "\n\t{", "\n\t}", "\n}"]
	end
	
	before :each do
		 @namespace_editor = NamespaceEditor.new @new_namespace, @old_namespace, $Test_src_dir, ["cpp"]
	end
	
	describe "#new" do
		it "returns a new NamespaceEditor object" do
			@namespace_editor.should be_an_instance_of NamespaceEditor
		end
		
		it "throws an ArgumentError when given less than 4 params" do
			lambda { namespace_editor = NamespaceEditor.new "new.namespace", "srcPath" }.should raise_exception ArgumentError
		end
	end
	
	describe "#new_namespace" do
		it "returns the new namespace" do
			@namespace_editor.new_namespace.should eql @new_namespace
		end
	end
	
	describe "#old_namespace" do
		it "returns the old namespace" do
			@namespace_editor.old_namespace.should eql @old_namespace
		end
	end
	
	describe "#src_path" do
		it "returns the path to the src files" do
			@namespace_editor.src_path.should eql $Test_src_dir
		end
	end
		
	describe "#extension" do
		it "returns the extensions of src files to inject" do
			@namespace_editor.extensions.should eql ["cpp"]
		end
	end
	
	describe "#replace_old_namespace" do
		# after :all do
		# 	remove_test_src_dir
		# end
		
		before :each do
			create_fake_source_files(1, @src_text, ".cpp")
		end
		
		# after :each do
		# 	remove_fake_source_files(1, ".cpp")
		# end
		
		it "replaces the existing namespace with a new namespace" do
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.do_replace_namespace($Test_src_dir + "0.cpp").should eql 1
			@namespace_editor.changed_files_count.should eql 1
			get_file_content($Test_src_dir + "0.cpp").should_not include(@old_namespace)
			get_file_content($Test_src_dir + "0.cpp").should include(@new_namespace)
		end
	end

	describe "#replace_old_licence" do
		after :all do
			remove_test_src_dir
		end
		
		before :each do
			create_fake_source_files(1, @src_text, ".cpp")
		end
		
		after :each do
			remove_fake_source_files(1, ".cpp")
		end
		
		it "does not change file if --overwrite flag is not passed" do
			overwrite = false
			@namespace_editor = NamespaceEditor.new @new_namespace, @old_namespace, "srcPath", ["cpp"], false, overwrite
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.do_replace_namespace($Test_src_dir + "0.cpp")
			get_file_content($Test_src_dir + "0.cpp").should include(@old_namespace)
			get_file_content($Test_src_dir + "0.cpp").should_not include(@new_namespace)
		end
	end

	describe "#replace_old_licence" do
		after :all do
			remove_test_src_dir
		end
		
		before :each do
			create_fake_source_files(1, @src_text, ".cpp")
		end
		
		after :each do
			remove_fake_source_files(1, ".cpp")
		end
		
		it "does not increment file count if old namespace is not present in file" do
			@namespace_editor = NamespaceEditor.new @new_namespace, "a.fake.namespace", "srcPath", ["cpp"]
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.do_replace_namespace($Test_src_dir + "0.cpp").should eql 0
			get_file_content($Test_src_dir + "0.cpp").should_not include(@new_namespace)
			@namespace_editor.changed_files_count.should eql 0
		end
	end
		
	describe "#all occurrences of namespace is changed, not just the first occurrence" do
		after :all do
			remove_test_src_dir
		end
		
		before :each do
			src_text_with_many_occurrences_of_namespace = [@old_namespace + ".activites", "\n" + @old_namespace + ".activites", "\n" + @old_namespace + ".activites", "\nclass HelloWorld", "\n" + @old_namespace + ".customtextbox", "\n{", "\n\tHelloWorld()", "\n\t{", "\n\t}", "\n}"]
			create_fake_source_files(1, src_text_with_many_occurrences_of_namespace, ".cpp")
		end
		
		after :each do
			remove_fake_source_files(1, ".cpp")
		end
		
		it "changes all occurrences of namespace" do
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.do_replace_namespace($Test_src_dir + "0.cpp").should eql 1
			@namespace_editor.changed_files_count.should eql 1
			get_file_content($Test_src_dir + "0.cpp").should eql ([@new_namespace + ".activites", "\n" + @new_namespace + ".activites", "\n" + @new_namespace + ".activites", "\nclass HelloWorld", "\n" + @new_namespace + ".customtextbox", "\n{", "\n\tHelloWorld()", "\n\t{", "\n\t}", "\n}"].join)
		end
	end
	
	describe "#handle multiple src files" do
		after :all do
			remove_test_src_dir
		end
		
		before :each do
			create_fake_source_files(25, @src_text, ".cpp")
		end
		
		after :each do
			remove_fake_source_files(25, ".cpp")
		end
		
		it "replaces the existing namespace with a new namespace in multiple files" do
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.replace_namespace
			@namespace_editor.changed_files_count.should eql 25
			25.times do | x |
				get_file_content($Test_src_dir + x.to_s + ".cpp").should_not include(@old_namespace)
				get_file_content($Test_src_dir + x.to_s + ".cpp").should include(@new_namespace)
			end
		end
	end
	
	describe "#handle multiple file extensions" do
		after :all do
			remove_test_src_dir
		end
		
		before :each do
			create_fake_source_files(25, @src_text, ".cpp")
			create_fake_source_files(25, @src_text, ".java")
			create_fake_source_files(25, @src_text, ".h")
		end
		
		after :each do
			remove_fake_source_files(25, ".cpp")
			remove_fake_source_files(25, ".java")
			remove_fake_source_files(25, ".h")
		end
		
		it "replaces the existing namespace with a new namespace in files of multiple extensions" do
			@namespace_editor = NamespaceEditor.new @new_namespace, @old_namespace, $Test_src_dir, ["cpp","java","h"]
			@namespace_editor.changed_files_count.should eql 0
			@namespace_editor.replace_namespace
			@namespace_editor.changed_files_count.should eql 75
			25.times do | x |
				get_file_content($Test_src_dir + x.to_s + ".cpp").should_not include(@old_namespace)
				get_file_content($Test_src_dir + x.to_s + ".cpp").should include(@new_namespace)
			end
			25.times do | x |
				get_file_content($Test_src_dir + x.to_s + ".java").should_not include(@old_namespace)
				get_file_content($Test_src_dir + x.to_s + ".java").should include(@new_namespace)
			end
			25.times do | x |
				get_file_content($Test_src_dir + x.to_s + ".h").should_not include(@old_namespace)
				get_file_content($Test_src_dir + x.to_s + ".h").should include(@new_namespace)
			end
		end
	end
end