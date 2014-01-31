$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'namespace_editor_version.rb'

Gem::Specification.new do |s|
	s.name			= "namespace_editor"
	s.version		= Namespace_Editor::VERSION
	s.authors		= ["Barry Drinkwater"]
	s.email			= ["barry@penrillian.com"]
	s.homepage		= "https://github.com/Penrillian/NamespaceEditor"
	s.summary		= %q{Replaces namespaces in source files}
	s.description	= %q{namespace_editor replaces existing namespaces with a new namespace in each source file found at the given source path whose extension is one of those in the given list of extensions. Useful for Android white label apps}
	s.files			= ["lib/NamespaceEditor.rb", "lib/namespace_editor_version.rb"]
	s.executables	= ["namespace_editor"]
	s.license		= "BSD Clause 2"
	
	s.add_development_dependency("rspec","~> 2.14.1")
	s.add_development_dependency("rdoc","~> 4.0.1")
	s.add_development_dependency("rake","~> 10.1.0")
end