# How to read a json file into R
# This is done with the rjson package
# https://cran.r-project.org/web/packages/rjson/index.html


# install.packages("rjson")

# Load the package required to read JSON files.
library("rjson")




# for more info: 
# https://www.geeksforgeeks.org/working-with-json-files-in-r-programming/

# Give the input file name to the function.
Tropy <- fromJSON(file = "./Metadata/Tropy_metadata.json")

# this is returned as a list...it takes some practice, but you can work with and 
# edit these or use to hem to search for stufff. 
# you'll have to read up on lists, but try looking these.

Tropy[[1]]
Tropy[[2]]
Tropy[[3]]


Tropy[[2]][[1]][[1]]
Tropy[[2]][[1]][[5]]
Tropy[[2]][[1]][[10]]
Tropy[[2]][[1]][[10]]
Tropy[[2]][[1]][[10]][[1]]

# Convert the file into dataframe

# Give the input file name to the function.
# Convert JSON file to a data frame.
# Tropy_json_data_frame <- as.data.frame(___)

print(Tropy_json_data_frame)

# Print the result.
print(result)
