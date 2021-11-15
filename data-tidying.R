library(tidyverse)
library(tidyr)
library(tidyselect)
library(stringr)
library(dplyr)
library(readr)
library(utils)
library(data.table)
library(stringi)

# load the datasets from their path folder, but first change working directory
setwd("C:/Users/Glow9/Documents/MCITxMisk-DSI-2021/Capstone/data-tidying")

megalist <- list.files(pattern = "*.csv") %>%
  map_df(~fread(.))

write.csv(megalist, file = "raw-scraped-teas.csv")

summary(megalist)

#remove columns that are irrelevant for recommendations (Availability, Image, and ID already exists in "item_ID") 
#and columns created by the webscraper extension (web-scraper-order, pagination)

megalist$`web-scraper-order` <- NULL
megalist$pagination <- NULL
megalist$Pagination <- NULL
megalist$ID <- NULL
megalist$Availability <- NULL
megalist$`Image-src` <- NULL
megalist$`web-scraper-start-url`
#here, we can see which variables remain

ls(megalist)

print(megalist$Benefits)
#change variable names from V4 to "Benefits"
#and web-scraper-start-url to "Brand"

renamed <- rename(megalist, Brand = `web-scraper-start-url`)

megalist$HBenefits <- paste(megalist$Benefits,megalist$V4)

print(megalist$HBenefits)

write.csv(megalist, file = "megalist.csv")

megalist$V4 <- NULL
megalist$Benefits <- NULL

mrenamed <- rename(megalist, Benefits = HBenefits,
                   Brand = `web-scraper-start-url`)

mrenamed$Brands <- paste(mrenamed$Link,mrenamed$`Link-href`,mrenamed$`link-href`)

mrenamed$Brand <- NULL
mrenamed$Link <- NULL
mrenamed$`link-href` <- NULL
#we'll keep "Link-href" to preserve a links variable
#also, remove link variable because it is a duplicate of the Name variable
mrenamed$link <- NULL

mrenamed <- rename(mrenamed, Links = `Link-href`)

write.csv(mrenamed, file = "megalist.csv")

#now, we only have columns of interest 
ls(mrenamed)

#for convenience, we'll remove the original "megalist.df" from our environment 
#and change the name of the updated dataframe "renamed" to "megalist"
remove(megalist)

megalist <- mrenamed

remove(mrenamed)

#notice the 'Price' column has currency labels ($ and SAR),
#we can remove them using the base R gsub() function

megalist$Price = as.numeric(gsub("\\$", "", megalist$Price))

#we can see the type for the 'Price' variable changed from character to double
typeof(megalist$Price)

#another column that needs character removal is 'Steeping',
#we'll remove the text using the stringr mutate() function

megalist <- megalist %>%
  mutate_at("Steeping", str_replace, "minutes", "")
megalist <- megalist %>%
  mutate_at("Steeping", str_replace, "Steep for", "")

#lastly, the 'Brands' column needs tidying. we must remove text from the url 
#surrounding the brand names, but first we need a new column for Links to 
#avoid losing the urls. We'll call it 'URL'

megalist$URL <- paste(megalist$Links,megalist$Brands)

#we can delete the 'Links' column
megalist$Links <- NULL

#now, we are ready to remove text from the urls in the 'Brands' column
#*and the 'URL' column

megalist <- megalist %>%
  mutate_at("URL", str_replace, "NA NA NA", "")
megalist <- megalist %>%
  mutate_at("Brands", str_replace, "NA NA", "")

#testing multiple approaches 
testing <- megalist %>%
  mutate_at("Brands", str_replace, "https://www.", "")
test2 <- testing %>%
  mutate_at("Brands", str_replace, ".com/us_en/", "")
test3 <- test2 %>%
  mutate_at("Brands", str_replace, "https://", "")
test4 <- test3 %>%
  mutate_at("Brands", str_trim, side = c("both"))

megalist$Brand <- str_extract(testing$Brands, "^(.*?com)")

#finish removing extra strings from the 'Brand' column

megalist$Brand <- stri_extract_all_regex(megalist$Brand, '(davidstea|machiitea|numitea|rishi-tea|teabox|theteahaus|thefeelgoodtea|vahdam|yogi)') %>% unlist()

#check the changes
tail(megalist$Brand)
lst(megalist$Brand)

#remove extra NAs from columns
megalist <- megalist %>%
  mutate_at("Benefits", str_replace, "NA NA", "")

#drop extra columns generated from above steps
megalist$X.1 <- NULL
megalist$X.2 <- NULL

#save changes
write.csv(megalist, file = "megalist.csv")

#now, we can begin tidying the values and filling in missing values. we'll begin 
#with the 'Caffeine' column and replace wordy strings with Y/N. 
#for unique categories, we use the base R unique() function
unique(megalist$Caffeine)

megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Caffeine-free", "no")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "High Caffeine", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Medium Caffeine", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Low Caffeine", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Caffeine None", "no")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Caffeine Medium", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Caffeine High", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "High", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Low", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "None", "yes")
megalist <- megalist %>%
  mutate_at("Caffeine", str_replace, "Medium", "yes")

unique(megalist$Caffeine)

#again, remove additional columns generated by Rstudio
megalist$X.2 <- NULL
megalist$X.1 <- NULL
#now we have a dataframe "megalist" with 1347 observations of 18 variables.

#we still have long strings that need fixing, other columns have similarly long strings of text
#to avoid losing information, we will extract values manually from other columns that got mixed up in 
#the web scraping process. we'll fill in missing information not found in columns manually. 

#to do so, we'll save the .csv file to save progress and work on it in excel.
setwd("C:/Users/Glow9/Documents/MCITxMisk-DSI-2021/Capstone/data-tidying")
write.csv(megalist, file = "megalist.csv")

caf_na <- which(is.na(megalist.manual$Caffeine))
fla_na <- which(is.na(megalist.manual$Flavor))
desc_na <- which(is.na(megalist.manual$Description))
stee_na <- which(is.na(megalist.manual$Steeping))
nam_na <- which(is.na(megalist.manual$Name))
cate_na <- which(is.na(megalist.manual$Category))
typ_na <- which(is.na(megalist.manual$Type))
orig_na <- which(is.na(megalist.manual$Origin))
tim_na <- which(is.na(megalist.manual$Time))
colo_na <- which(is.na(megalist.manual$Color))
ingre_na <- which(is.na(megalist.manual$Ingredients))
ID_na <- which(is.na(megalist.manual$item_ID))
pric_na <- which(is.na(megalist.manual$Price))
brnd_na <- which(is.na(megalist.manual$Brand))

#looking at the numbers of the NA values, we can prioritize
#the columns with the most # of missing values. 
#most to least NAs: type, origin, category, color, flavor, 
#steeptime, price, caffeine content, brand, time, and name.

#once we are finished filling in missing strings,
#we'll combine the categories and types in one column.
#we'll rename the new column 'Type'

megalist <- read.csv("C:/Users/Glow9/Documents/MCITxMisk-DSI-2021/Capstone/data-tidying/850megalist.csv")

megalist$Type <- NULL
megalist$Type <- paste(megalist$Category)

#delete irrelevent columns, the benefits column is no longer important because the health problems
#explain the benefits, e.g. if one tea is associated with the health problem "indigestion", it
#means that the benefit is improving digestion. No need for adding another feature to the model.
megalist$Category <- NULL
megalist$item_ID <- NULL
megalist$Benefits <- NULL
megalist$Steeping <- NULL
megalist$X <- NULL

#rename the Rstudio generated column "ï..X" to "ID"
#it can be used as an identifier to the tea Names
megalist <- rename(megalist, ID = ï..X)

#combine URL and Link into a new variable called 'urls'
#add "://" between them to make a link (link was split from earlier splitting)
megalist$urls <- str_c(megalist$URL, "://", megalist$Link)

#delete URL and Link
megalist$URL <- NULL
megalist$Link <- NULL

#remove commas from Description
megalist <- megalist %>%
  mutate_at("Description", str_replace, ",", "")
megalist <- megalist %>%
  mutate_at("Description", str_replace, "Description:", "")

#remove redundancies from Flavor and Ingredients columns:
megalist <- megalist %>%
  mutate_at("Flavor", str_replace, "How it tastes", "")
megalist <- megalist %>%
  mutate_at("Flavor", str_replace, ":", "")
megalist <- megalist %>%
  mutate_at("Flavor", str_replace, "Flavor", "")

megalist <- megalist %>%
  mutate_at("Ingredients", str_replace, "Ingredients:Ã,Â", "")
megalist <- megalist %>%
  mutate_at("Ingredients", str_replace, "Ingredidents:Ã,Â", "")
megalist <- megalist %>%
  mutate_at("Ingredients", str_replace, "Ingredients:", "")
megalist <- megalist %>%
  mutate_at("Ingredients", str_replace, "Ingredients", "")

setwd("C:/Users/Glow9/Documents/MCITxMisk-DSI-2021/Capstone/data-tidying")

write.csv(megalist, file = "clean_megalist.csv")
