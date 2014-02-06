NamespaceEditor
===============

Command-line Ruby app to edit/replace namespaces. Useful for Android whitelabel apps.

##DESCRIPTION

**namespace_editor** is a command-line Ruby app to edit/replace namespaces found within src files, which may be necessary when creating Android whitelabel apps where an app is licenced to different organisations who wish to use their own namespaces. The new namespace replaces the existing namespace in each source file found in the given source path whose extension is one of those in the given list of extensions.

##OPTIONS
* '-n', '--new_namespace': The new namespace
* '-x', '--existing_namespace':	The namespace to be replaced
* '-s', '--src_path': The path to the directory containing the source files to be processed. Files in sub-folders will also be processed
* '-e',  '--extensions': The list of extensions the source files to be processed have. For multiple extensions this must be a comma separated list
* '--list': Switches on list-style output
* '--overwrite': Makes changes to the files - default is to only report the number of discovered src files
* '-v', '--version': Prints the version number. All other options will be ignored
	
##EXAMPLES
Replace the namespace **com.example.something** with the namespace **com.example.anotherexample** in java and cpp files located at C:\projects\my_project:

`C:\>namespace_editor -n com.example.anotherexample -x com.example.something -s C:\projects\my_project -e java,cpp --overwrite`

##INSTALLATION
`gem install namespace_editor`

##LICENCE
BSD 2-Clause

##AUTHOR
Barry Drinkwater<br>
email: [barry@penrillian.com](mailto:barry@penrillian.com)<br>
web: [www.penrillian.com](http://www.penrillian.com)<br>

##SEE ALSO
web: [https://github.com/Penrillian/NamespaceEditor](https://github.com/Penrillian/NamespaceEditor)
