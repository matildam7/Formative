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