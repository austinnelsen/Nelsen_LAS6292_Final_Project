
library(tesseract)
library(tidyverse)

#ensure that you have already downloaded Tesseract's Portuguese language. 
#If not use tesseract_download("por") before proceeding
tesseract::tesseract_info()

#create the dataframe that will link filenames with OCR text for easy association
files <- list.files(path = "./raw_cover_images", pattern = "*.JPG", full.names = T)

#begin OCR process
raw_data <- sapply(files, tesseract::ocr, engine = "por", simplify=TRUE) %>% 
  bind_rows(.id = "id")
raw_data <- pivot_longer(raw_data,cols = starts_with("./raw_cover_images"),names_to="files")

#basic cleanup of the OCR-generated text. The text will still need minor edits when adding into Tropy
dirty_text <- raw_data$value
dirty_text <- gsub("\n", " ", dirty_text)
dirty_text <- gsub("AHU ACL CU 015", "AHU_ACL_CU_015", dirty_text)
dirty_text <- gsub("\\n", " ", dirty_text)
dirty_text <- gsub(" | ig ", " ", dirty_text)
dirty_text <- gsub(" |  E nda CTT crer Serem o ", " ", dirty_text)
dirty_text <- gsub(" im O reina qe E | a 2 —", " ", dirty_text)
dirty_text <- gsub(" al = ", " ", dirty_text)
dirty_text <- gsub(" ce a a ", " ", dirty_text)
dirty_text <- gsub("“o Sd 1103- ", " ", dirty_text)
dirty_text <- gsub(" TA ", " ", dirty_text)

#creation of final dataframe, trimming unnecessary columns, write file to directory
raw_data["clean_text"] <- dirty_text
clean_text <-subset(raw_data, select = -c(1,3))
write.csv(clean_text,".\\clean_OCR_text.csv", row.names = FALSE)



