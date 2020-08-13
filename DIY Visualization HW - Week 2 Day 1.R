#We usually create a data frame with vectors. Create 3 vectors with 2 elements

name = c("Angela", "Shondra") #Example: Names of patients
age = c(25,50)                     #Add Age of patients
  ins = c(FALSE,TRUE)                   #Add Insurance - do they have insurance True/False values
  
  #Create a data frame named patients and pass the 3 vectors nm, ag, ins
patients.df=data.frame(name,age,ins)
patients.df
##ANSWER should like below
##     nm ag ins
## 1  Angela   27      TRUE
## 2 Shondra   36      TRUE

#We can also create a data frame with different column names and this is how you do it. Run the statement
patients.df = data.frame("names"=name, "ages" = age, "insurance"=ins)
##     names    ages    insurance
## 1  Angela   27      TRUE
## 2 Shondra   36      TRUE

#We may wish to add rows or columns to our data. We can do this with: #rbind() #cbind(). remember it as r(row)bind..
#For example we can go back to our patient data and say we wish to add another #patient we could just do the following
newPatient = c(names="Liu Jie", age=45, insurance=TRUE)
patients=rbind(patients.df, newPatient)
##     names ages insurance
## 1  Angela   27      TRUE
## 2 Shondra   36      TRUE
## 3 Liu Jie   45      TRUE
## You may get a Warning in `[=.factor`(`*tmp*`, ri, value = "Liu Jie"): invalid factor
## level, NA generated. OR it may not have added the row..
#This warning serves as a reminder to always know what your data type is. 
# In this case R has read our data in as a factor so use as.character 
# patients$names = as.character(patients$names) #this is ensuring all patients names as character
# patients = rbind(patients, newPatient)
# patients

#if we decide to  place another column of data in we could use cbind function
# Next appointments
next.appt = c("09/23/2016", "04/14/2016", "02/25/2016")

#Lets R know these are dates
next.appt = as.Date(next.appt, "%m/%d/%Y")
next.appt

## [1] "2016-09-23" "2016-04-14" "2016-02-25"
#We then have a vector of dates which we can cbind (column bind) in R.
patients = cbind(patients, next.appt)
patients
##     names ages insurance  next.appt
## 1  Angela   27      TRUE 2016-09-23
## 2 Shondra   36      TRUE 2016-04-14
## 3 Liu Jie   45      TRUE 2016-02-25

##### getting information on a particular column you the format dataframeName$columnName
patients$names
# [1] "Angela"  "Shondra" "Liu Jie"

#print ages of all patients using the example above

############################TITANIC: Accessing Data Frames
#we will use  built in data on Titanic from R. In this case, lets create a new data frame from Titanic
library(datasets)
titanic = data.frame(Titanic)

#Print Summary of the Titanic dataframe

# Answer
# Class       Sex        Age     Survived      Freq       
# 1st :8   Male  :16   Child:16   No :16   Min.   :  0.00  
# 2nd :8   Female:16   Adult:16   Yes:16   1st Qu.:  0.75  
# 3rd :8                                   Median : 13.50  
# Crew:8                                   Mean   : 68.78  
# 3rd Qu.: 77.00  
# Max.   :670.00  

#We can look at the different columns that we have in the data set:
colnames(titanic)
## [1] "Class"    "Sex"      "Age"      "Survived" "Freq"


#print value of Age column using the syntax dataframeName$columNname


#ANS
# [1] Child Child Child Child Child Child Child Child Adult Adult Adult Adult Adult Adult Adult Adult Child Child Child Child Child Child Child
# [24] Child Adult Adult Adult Adult Adult Adult Adult Adult
# Levels: Child Adult

#Observe the Levels information above Levels: Child Adult. This means how many unique values are there for a particular column. 
#Similar to unique() function. Let's use this instead. Use unique(pass the column name. 
# Remember: use the syntax dataframeName$columNname for refer to a column.

uniqueAge = unique(dataframeName$columnName) # ask for help on this
uniqueAge
# ANS
#Levels: Child Adult


#Now let's print information based on various conditions
# if you need all rows or all columns, simply pass ',' without quotes. else provide indexes based on the
#rules learned during vectors
##to print all rows and all columns.***
titanic[,]

#Print first 2 rows of data with all columns using indexing and :.
titanic[2,]
# titanic[2,]
# Class  Sex   Age Survived Freq
# 2   2nd Male Child       No    0
