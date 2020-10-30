read_csv("data-raw/Y101_Y102_Y201_Y202_Y101-5.csv")
filesol <- "data-raw/Y101_Y102_Y201_Y202_Y101-5.csv"

sol <- read_csv(filesol, skip = 2) %>%
  janitor::clean_names()
#skip first two rows and use the janitor to improve col names
#:: gives you access to packages functions without the library()

#filtering data, keeping human proteins identified by more than one peptide
sol <- sol %>%
  filter(str_detect(description, "OS=Homo sapiens")) %>%
  filter(x1pep == "x")
#two filter statements
#description = column name when OS= data is present 
#str_detect(string,pattern) returns logical vector according to whether the pattern is found in the string
#want to get rid of any row that has an x in it as they have one pep so cannot be certain 
#want to get rid of any that are OS = Bos taurus

sol$description[1]
one_description <- sol$description[1]
#extract the first row [1] of the description to work 
#GN (gene name) you want to seperate out and is hidden within the description column, so it would be useful to make this into a new column

str_extract(one_description, "GN=[^\\s]+")
#extract part of the string after GN using regex (pattern matches to text)
#[] means some characters
#^ not when inside [], not white space
#\s means white space 
#\ escape character to indicate the next character
#+ means one or more
#{GN=AHNAK} PE=1 SV=2 (regex is choosing to just select AHNAK, stops when we get to a white space)

str_extract(one_description, "GN=[^\\s]+") %>%
  str_replace("GN=", "")
#drop the GN part to leave nothing, just the extra characters after it
#replaces GN= with an empty string. just gives AHNAK

sol <- sol %>%
  mutate(genename =  str_extract(description,"GN=[^\\s]+") %>% 
           str_replace("GN=", ""))
#mutate adds new variables and preserves existing ones 
#creating a column called genename, where the result that we filtered out before will be put, will apply to all columns
#name=value pairs of expressions 
#name = name for a new variable 
#value = value it takes, normally an expression