
library(tesseract)
library(tidyverse)

#ensure that you have already downloaded Tesseract's Portuguese language. 
#If not use tesseract_download("por") before proceeding
tesseract::tesseract_info()

#create the dataframe that will link filenames with OCR text for easy association

files <- list.files(path = "./raw_data/raw_cover_images", pattern = "*.JPG", full.names = T)

#begin OCR process
raw_data <- sapply(files, tesseract::ocr, engine = "por", simplify=TRUE) %>% 
  bind_rows(.id = "id")


# when things start with punctuation or or slashes they can be a bit complicated 
# to deal with. I changed the names of the columns to remove 
# the `./raw_data/raw_cover_images/`

# create a vector with names of cols
names_cols<-names(raw_data) 
# convert it to a tibble 
names_cols <- as_tibble(names_cols) 
# remove the `./raw_data/raw_cover_images/`
names_cols$value <- gsub("./raw_data/raw_cover_images/","",names_cols$value)
# reassign the names of the columns based on these new ones
names(raw_data) <- names_cols$value

## Once you do that, you can change your `starts_with`

raw_data <- pivot_longer(raw_data,
                         cols = starts_with("IMG"),
                         names_to="files")

# Now how about changing that id to be unique? We can use the numberic portion
# of the photo

raw_data$id <- raw_data$files
raw_data$id <- gsub("IMG_","",raw_data$id)
raw_data$id <- gsub(".JPG","",raw_data$id)


#basic cleanup of the OCR-generated text. The text will still need minor edits when adding into Tropy


# You don't have to create a new dataframe, you can use the same one and point to 
# the column you are editing in the gsub statement
# dirty_text <- raw_data$value
raw_data$value <- gsub("\n", " ", dirty_text)
raw_data$value <- gsub("AHU ACL CU 015", "AHU_ACL_CU_015", raw_data$value)
raw_data$value <- gsub("\\n", " ", raw_data$value)
raw_data$value <- gsub(" | ig ", " ", raw_data$value)
raw_data$value <- gsub(" |  E nda CTT crer Serem o ", " ", raw_data$value)
raw_data$value <- gsub(" im O reina qe E | a 2 —", " ", raw_data$value)
raw_data$value <- gsub(" al = ", " ", raw_data$value)
raw_data$value <- gsub(" ce a a ", " ", raw_data$value)
raw_data$value <- gsub("“o Sd 1103- ", " ", raw_data$value)
raw_data$value <- gsub(" TA ", " ", raw_data$value)

#creation of final dataframe, trimming unnecessary columns, write file to directory
# Instead of this next line
# raw_data["clean_text"] <- dirty_text
# you can reassign like this:
clean_text <- raw_data

# how about we rename the columns?

clean_text <- clean_text %>% rename("file"="files",
                                    "label_text"="value")

# no need to select them...we have them.
# clean_text <-subset(raw_data, select = -c(1,3))

write.csv(clean_text,".\Clean_Data\clean_OCR_text.csv", row.names = FALSE)



