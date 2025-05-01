#loading packages ----
library(pacman)
pacman::p_load(tidyverse, tidycensus, openxlsx)


#Importing Mortality data ----
FLVDRS <- read_excel("File path", sheet = 1)

# Connect R to Census APi (only needs to be run once ) -----
census_api_key("Enter Key", install = TRUE, overwrite = TRUE)

## generates a cached list of all applicable variable names; cache stores values to the  computer -----
VarNames <- load_variables(2020,"acs5", cache = TRUE)

# Importing County Population data by sex -----
#5 year estimates (2017-2021) 

sex_vars <- c(                #declares variables for get_acs function 
  Male = "B01001_002",
  Female = "B01001_026"
)

Fl_sex <- get_acs(
  geography = "county",
  state = "Fl",
  variables = sex_vars,
  summary_var = "B01001_001",
  year = 2021,
  survey = "acs5"
) |> mutate(  #creates separate columns for county and state names 
  separate(
    Fl_sex,
    NAME,
    into = c("county","state"),
    sep = ","
)) |> mutate( #renames headers for the append step 
  rename(
    Fl_sex,
    sex = variable,
    pop = estimate,
    total = summary_est
  )
)

# Importing County Population data by Race/Ethnicity -----
#5 year estimates (2017-2021) 

race_vars <- c(                  #declares variables for get_acs function 
  White = "B03002_003",
  Black = "B03002_004",
  Native = "B03002_005",
  Asian = "B03002_006",           #need to merge with HIPI bc of VDRS data 
  HIPI = "B03002_007",                   
  Hispanic = "B03002_012",
  Two = "B03002_009",
  Other = "B03002_008"
)

Fl_race <- get_acs(
  geography = "county",
  state = "Fl",
  variables = race_vars,
  summary_var = "B03002_001",
  year = 2021,
  survey = "acs5"
) |> mutate( 
  separate( #creates separate columns for county and state names 
    Fl_race,
    NAME,
    into = c("county","state"),
    sep = ","
)) |> mutate( #renames headers for the append step 
  rename(
    Fl_race,
    race = variable,
    race_pop = estimate,
    total = summary_est
  )
)
 
# Creating a list of unique variables for the expand.grid function. -----
#This ensures that each df has an equal number of rows to the for the creation of master population file 

#declare variables of interest

u_county <- unique(Fl_sex$county)
u_county_tot <- unique(Fl_sex$total)
u_sex <-  unique(Fl_sex$sex)
u_sex_pop <- unique(Fl_sex$pop)
u_race <-  unique(Fl_race$race)
u_race_pop <-  unique(Fl_race$race_pop)

# Merging Census population data with State Injury Mortality Data ----
# Sex
pop_template_sex <- expand.grid(
  county    = u_county,
  sex       = u_sex
)

pop_county_sex_final <- pop_template_sex |>
  left_join(., Fl_sex, by = c("county", "sex")) |>
  select(county, sex, pop) |>
  mutate(county = str_replace(county, " County", ""))

# Race 
pop_template_race <- expand.grid(
  county    = u_county,
  race      = u_race
)

pop_county_race_final <- pop_template_race |>
  mutate(race2  = ifelse(race %in% c("Asian", "HIPI"), "AHIPI", race)) |>
  left_join(Fl_race, by = c("county", "race")) |>
  mutate(race2 = case_when(
        race2 == "1" ~ "White",
        race2 == "2" ~ "Black",
        race2 == "3" ~ "Native American",
        race2 == "AHIPI" ~ "AHIPI",
        race2 == "6" ~ "Other",
        race2 == "7" ~ "Two or more races",
        race2 == "8" ~ "Hispanic",
        TRUE ~ race2
  )) |>
  filter(race2 != "Hispanic") |>
  select(county, race2, race_pop) |>
  rename(pop    = race_pop) |>
  mutate(county = str_replace(county, " County", "")) #gets rid of "county" string from census data 
  
# Checking values ----
summarytools::freq(pop_template_race$race)
summarytools::freq(Fl_race$race)


#Declaring death and population vars ----
deaths <- FLVDRS$NumberDeaths
std_pop <- sum(u_county_tot)
print(std_pop)

                                                  #### calculating Rates ####

head(pop_county_sex_final)
head(FLVDRS)

# SEX Specific Rates ----

# Count number of deaths by county and sex -> creates an aggregate of sex and county deaths 
deaths_county_sex_final <- FLVDRS |>
  group_by(County, Sex) |>
  summarise(deaths = sum(NumberDeaths, na.rm = T)) |>
  ungroup() |>
  rename(county = County, sex = Sex)

head(deaths_county_sex_final)

county_sex_final <- pop_county_sex_final |>
  left_join(deaths_county_sex_final, by = c("county", "sex")) |>
  mutate(
    deaths    = if_else(is.na(deaths), 0, deaths),
    sex_rate_100k = deaths/pop*100000
  ) 

openxlsx::write.xlsx(county_sex_final, file = "Z:/Data analysis/Quantitative/RStudio", colNames = TRUE)

head(county_sex_final)


# RACE Specific Rates ----

# Count number of deaths by county and sex -> creates an aggregate of sex and county deaths 
deaths_county_race_final <- FLVDRS |>
  group_by(County, Race) |>
  mutate(Race = str_replace(Race, "Asian", "AHIPI"))|>
  summarise(deaths = sum(NumberDeaths, na.rm = T)) |>
  ungroup() |>
  rename(county = County, race2 = Race)

head(deaths_county_race_final, 10)

county_race_final <- pop_county_race_final |>
  left_join(deaths_county_race_final, by = c("county", "race2")) |>
  rename(race = race2)|>
  mutate(
    deaths    = if_else(is.na(deaths), 0, deaths),
    race_rate_100k = deaths/pop*100000
  ) 

openxlsx::write.xlsx(county_race_final, file = "Z:/Data analysis/Quantitative/RStudio", colNames = TRUE)


head(county_race_final, 10)
view(county_race_final)

                                                  ### ETHNITCITY ###
summarytools::freq(FLVDRS$Race)
summarytools::freq(FLVDRS$Ethnicity)
summarytools::freq(Fl_race$race)


Fl_race2 <- Fl_race |>
  mutate(ethnicity = if_else(race == "Hispanic", "Hispanic", "Non-Hispanic")) |>
  mutate(AHIPI = summarise(race== "Asian"+ "HIPI"))

Fl_ethnicity <- Fl_race2 |>
  group_by(county, ethnicity) |>
  summarise(pop = sum(race_pop, na.rm = T)) |>
  ungroup()

head(Fl_ethnicity, 20)


# Create the county-ethnicity population file
pop_template_ethnicity <- expand.grid(
  county    = unique(Fl_ethnicity$county),
  ethnicity = unique(Fl_ethnicity$ethnicity)
)

pop_county_ethnicity_final <- pop_template_ethnicity |>
  left_join(., Fl_ethnicity, by = c("county", "ethnicity")) |>
  select(county, ethnicity, pop) |>
  mutate(county = str_replace(county, " County", ""))

# Count number of deaths by county and ethnicity
deaths_county_ethnicity_final <- FLVDRS |>
  group_by(County, Ethnicity) |>
  summarise(deaths = sum(NumberDeaths, na.rm = T)) |>
  ungroup() |>
  rename(county = County, ethnicity = Ethnicity)

head(deaths_county_ethnicity_final)

county_ethnicity_final <- pop_county_ethnicity_final |>
  left_join(deaths_county_ethnicity_final, by = c("county", "ethnicity")) |>
  mutate(
    deaths    = if_else(is.na(deaths), 0, deaths),
    eth_rate_100k = deaths/pop*100000
  )
openxlsx::write.xlsx(county_ethnicity_final, file = "Z:/Data analysis/Quantitative/RStudio",colNames  = TRUE,)


dim(county_ethnicity_final)
head(county_ethnicity_final)

