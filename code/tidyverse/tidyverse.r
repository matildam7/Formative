#Section 1: loading demographics data-------------------------------------

#Load in the tidyverse, dpylr and haven packages
#haven is a package that can read xpt files
library(this.path)
library(tidyverse)
library(dplyr)
library(haven)
#set the working directory to the formative directory
setwd(paste0(this.dir(), "/../../"))
#read in the DEMO data
demo <- read_xpt("data/original/DEMO_D.xpt")
head(demo)
glimpse(demo)
#make a Tibble containing participant ID (respondent sequence number), gender, age and ethnicity. 
demo_tibble <- demo |> select(SEQN, RIAGENDR, RIDAGEYR, RIDRETH1)
#rename the variables in the tibble just created
demo_tibble <- demo_tibble |> rename("participant_ID" = `participant ID`)
demo_tibble <- demo_tibble |> rename("gender" = RIAGENDR)
demo_tibble <- demo_tibble |> rename("age" = RIDAGEYR)
demo_tibble <- demo_tibble |> rename("ethnicity" = RIDRETH1)
#check that the tibble was created correctly
head(demo_tibble)

#Section 2: merging demographics data-------------------------------------
#read in the body measurements data
bmx_data <- read.csv("data/original/BMX_D.csv")
#reformatting the variable names to lowercase
bmx_data <- bmx_data |> rename_with(tolower)
demo_tibble <- demo_tibble |> rename_with(tolower)
bmx_data <- bmx_data |> rename("participant_ID" = SEQN) 
merged_bmx_demo <- bmx_data |> left_join(demo_tibble, by = join_by(participant_id))
#moving the demographics data to the left of the bmx data after participant id
merged_bmx_demo <- merged_bmx_demo |> relocate(participant_id, age, gender, ethnicity)

#Section 3: merging sample information-------------------------------------
#read in the sample file
sample_data <- read.csv("data/derived/sample.csv")
#rename the id number so it matches the other two sets of data
sample_data <- sample_data |> rename("participant_id" = SEQN) 
#merging with the previously merged demographics data
merged_bmx_demo <- merged_bmx_demo |> left_join(sample_data, by = join_by(participant_id))
#renaming the insample variable to in_sample
merged_bmx_demo <- merged_bmx_demo |> rename("in_sample" = insample)
#moving the "in sample" variable to the right of "participant id"
merged_bmx_demo <- merged_bmx_demo |> relocate(participant_id, in_sample)

#Section 4: creating an obesity variable-------------------------------------
#creating an obesity variable where people over the age of 20 are put into the obese category if their bmi is over 30
merged_bmx_demo <- merged_bmx_demo |> mutate(obesity = if_else(age >= 20, if_else(bmxbmi >= 30, 1, 0), NA))

#Section 5: summarising the data-------------------------------------
#Obesity percentages----------------------------------------------

#filters out the people with no obesity data, then groups by obesity
#counts the number of obese and non obese people, then counts the number of
#people that have acceleromter data
#number of people with accelerometer data is divided by the total number if people in that group (obese or not)
#and then multiplied by 100 to work out a percentage
merged_bmx_demo |> filter (!is.na(obesity)) |>
  group_by(obesity) |>
  summarise( n = n(),
    n_with_accel = sum(in_sample == 1),
    percent_with_accel = (n_with_accel/ n ) * 100
  )

#gender percentages
merged_bmx_demo |>
  group_by(gender) |>
  summarise( n = n(),
    n_with_accel = sum(in_sample == 1),
    percent_with_accel = (n_with_accel/ n ) * 100
  )

#73.6% of males have activity monitor data compared with 75.7% of females

#maximum reported child height
merged_bmx_demo |> filter (age < 16, in_sample == 1) |>
  summarise(max_height = max(bmxht, na.rm = TRUE))
#maximum height of under 16s that are in the sample was 190.7cm