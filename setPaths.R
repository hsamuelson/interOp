#
# Henry Samuelon 9/5/2018
#
# This processes the centralized funcitons that determine the paths 
# To run respective langauges

# Reasoning:
  # Do not run path lookups while calling functions because it will become
  # Redunant and really should be done in the initilization. 


  # *DEV NOTE* In paths.csv paths that are added with C:\\ with the double "\\"
  # will become "\\\\" to avoid this only add one "\"

# Read file paths from paths.csv
# Then get them into system vars that can be accessed later.
path_list <- read.csv("dataTypes/paths.csv")

# The R path has to be different given the os_version (system var)
if(os_version == 0){
  # Windows
  # This looks for your R version are runs
  r_path <- paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse ="")
} else {
  # Unix 
  r_path <- "Rscript"
}
python_path <- path_list$path[2]
js_path <- path_list$path[3]
lua_path <- path_list$path[4]
go_path <- path_list$path[5]
elixir_path <- path_list$path[6]
#bat_path <- path_list$path[7] #not needed as default in windows
rust_path <- path_list$path[8]
ruby_path <- path_list$path[9]
perl_path <- path_list$path[10]
dart_path <- path_list$path[11]
java_path <- path_list$path[12]
