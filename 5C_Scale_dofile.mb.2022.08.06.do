import delimited "/Users/maiyablock/Desktop/Flu Vaccination Survey_May 6, 2021 (numeric).csv"

import delimited "/Users/maiyablock/Desktop/Covid:flu/cleaner Vaccine Hesitancy Data_AVL_2021.12.17.mb.dta"

summarize

*Generate categorical variables


*DV: INTENTION


*Reverse coded
gen int_cvd_final = int_cvd 
replace int_cvd_final= "1" if int_cvd == "Extremely unlikely"
replace int_cvd_final= "2" if int_cvd == "Unlikely"
replace int_cvd_final= "3" if int_cvd == "Neither likely nor unlikely"
replace int_cvd_final= "4" if int_cvd == "Likely"
replace int_cvd_final= "5" if int_cvd == "Extremely likely"

destring int_cvd_final, generate (int_cvd_n)



*3 categories
gen intend = int_cvd_n
replace intend=1 if int_cvd_n < 3
replace intend=2 if int_cvd_n ==3
replace intend=3 if int_cvd_n > 3

*Binary variable
gen int_cvd1 = int_cvd_n
replace int_cvd1 = 0 if int_cvd_n < 3
replace int_cvd1 = 1 if int_cvd_n >=3




*DV: COVID Vaccination
generate covidvaccine = currentcvd
replace covidvaccine = 2 if currentcvd==1
replace covidvaccine = 1 if currentcvd==2




*COVARIATES - DEMOGRAPHICS*


*GENDER
gen gender1 = gender
replace gender1 = 3 if gender == "Other"
replace gender1 = 3 if gender == "Non-binary / third gender"
replace gender1 = 3 if gender == "Prefer not to say"



*RACE
gen race2=1 if race=="1"
replace race2=2 if race=="2"
replace race2=5 if race=="3"
replace race2=4 if race=="4"
replace race2=5 if race=="5"

*Race variable where it's just white and non-white

gen race1=1 if race=="1"
replace race1=2 if race=="2"
replace race1=2 if race=="3"
replace race1=2 if race=="4"
replace race1=2 if race=="5"
replace race1=2 if race2==. & race != ""


*Might include this variable of Prefer Not To Say with Missing Data in analyses in future
replace race1=. if race=="6"
replace race2=. if race=="6"


*Create mixed variable for if they are missing in new race2 variable and have a value for original race
replace race2=7 if race2==. & race != ""

* Add Race2=Prefer not to say to Other
replace race2=6 if race == "Prefer not to say"



*FINAL RACE VARIABLE

gen racefinal == race2
replace racefinal=1 if race=="White"
replace racefinal=2 if race=="Black or African American"
replace racefinal=3 if race=="Asian"
replace racefinal=4 if race=="Native Hawaiian, other Pacific Islander, American Indian or Alaska Native"
replace racefinal=5 if race=="Other"
replace racefinal=99 if race == "Prefer not to say"
replace racefinal=7 if racefinal==. & race != ""

tab racefinal

*EDUCATION

gen collegegrad = school
replace collegegrad = 0 if school <= 5 & school >=1
replace collegegrad = 1 if school == 6

*Keep Prefer not to say in College Grad variable?
replace collegegrad = 99 if school == "Prefer not to say"

tab collegegrad


*INCOME

gen income_ = income
replace income_ = "1" if income == "Less than $10,000"
replace income_ = "2" if income == "$10,000 to less than $15,000"
replace income_ = "3" if income == "$15,000 to less than $20,000"
replace income_ = "4" if income == "$20,000 to less than $25,000"
replace income_ = "5" if income == "$25,000 to less than $35,000"
replace income_ = "6" if income == "$35,000 to less than $50,000"
replace income_ = "7" if income == "$50,000 to less than $75,000"
replace income_ = "8" if income == "$75,000 or more"
replace income_ = "99" if income == "Prefer not to say"

destring income_, generate(income_n)


gen income_n1 = income_n
replace income_n1 = 1 if income_n == 2 | income_n == 3 | income_n == 4
replace income_n1 = 2 if income_n == 5 | income_n == 6
replace income_n1 = 3 if income_n == 7
replace income_n1 = 4 if income_n == 8



*POLITICS

gen politics_conservative = politics
replace politics_conservative = "1" if politics == "Liberal"
replace politics_conservative = "2" if politics == "Moderate"
replace politics_conservative = "3" if politics == "Prefer not to say"
replace politics_conservative = "4" if politics == "Conservative"

*Conservative generated as numeric version

destring politics_conservative, generate(conservative)


gen politics_conservative1 = politics
replace politics_conservative1 = "1" if politics == "Liberal"
replace politics_conservative1 = "2" if politics == "Moderate"
replace politics_conservative1 = "4" if politics == "Conservative"
replace politics_conservative1 = "99" if politics == "Prefer not to say"


*Conservative generated as numeric version

destring politics_conservative1, generate(conservative1)





*HISPANIC

gen hispanic1 = hispanic
replace hispanic1 = 1 if hispanic == "Yes"
replace hispanic1 = 0 if hispanic == "No"
replace hispanic1 = 99 if hispanic == "Prefer not to say" | hispanic == "Dont know/not sure"

*MARITAL STATUS
gen marital = maritalstatus
replace marital =2 if maritalstatus == 4 | maritalstatus ==3
replace marital =0 if maritalstatus == 6 | maritalstatus ==5
replace marital = . if maritalstatus ==7
replace marital = 99 if maritalstatus == "Prefer not to say"



*IV 5C VARIABLES: 



gen Conf_cvd =1 if attitudecvd1 ==5
replace Conf_cvd=2 if attitudecvd1 == 4
replace Conf_cvd=3 if attitudecvd1 ==3
replace Conf_cvd=4 if attitudecvd1==2
replace Conf_cvd=5 if attitudecvd1==1

gen Compl_cvd =1 if attitudecvd2 ==5
replace Compl_cvd=2 if attitudecvd2 == 4
replace Compl_cvd=3 if attitudecvd2 ==3
replace Compl_cvd=4 if attitudecvd2==2
replace Compl_cvd=5 if attitudecvd2==1

gen Const_cvd =1 if attitudecvd3 ==5
replace Const_cvd=2 if attitudecvd3 == 4
replace Const_cvd=3 if attitudecvd3 ==3
replace Const_cvd=4 if attitudecvd3==2
replace Const_cvd=5 if attitudecvd3==1 

gen Calc_cvd =1 if attitudecvd4 ==5
replace Calc_cvd=2 if attitudecvd4 == 4
replace Calc_cvd=3 if attitudecvd4 ==3
replace Calc_cvd=4 if attitudecvd4==2
replace Calc_cvd=5 if attitudecvd4==1

rename attitudecvd5 CollR_cvd

*Test for age assumptions:

summarize age 

*graph age int_cvd1
*scatter age int_cvd1, mlabel(responseid)
*graph box age
*logit int_cvd1 age
*predict r
*sort r
*list responseid r in 1/10
*list responseid r in -10/l
*list r age if abs(r) >2

*predict lev, leverage
*stem lev


*disp (2*13 + 2)/1075
*list age lev if lev > 
*lvr2plot, mlabel(responseid)



*Generating categorical variables


gen agecat = age
replace agecat = 1 if age <=19 & age >17
replace agecat = 2 if age >=20 & age <40
replace agecat = 3 if age >= 40 & age <60
replace agecat = 4 if age >= 60
replace agecat=. if age<=17

sum age

replace age = 40 if age >90




*Eligibility Variable for missing variables
 gen elig = 1 if gender1!=. & hispanic1!=. & race2!=. & marital!=. & school1!=. & income!=. & politics1!=. & agecat!=. & int_cvd1!=. & Conf_cvd!=. & Compl_cvd!=. & Const_cvd!=. & Calc_cvd != . & CollR_cvd !=.
 replace elig = 0 if elig == .

sum elig

*Labeling variables 

label define covidvaccine 1 "Both doses" 2 "One dose" 3 "Will wait and get later" 4 "No will not get it"
label values covidvaccine covidvaccine

label define gender1  1 "Male" 2 "Female" 3 "Nonbinary"

label values  gender1  gender1

label define racefinal 1 "White" 2 "Black" 3 "Asian" 4 "Indigenous" 5 "Other Race" 7 "Mixed Race" 99 "Prefer Not to Say"

label values racefinal racefinal


label define collegegrad 1 "Less than college graduate" 2 " College graduate or more" 99 "Prefer Not to Say"

label values collegegrad collegegrad
 
 
label define income_n 1 "Less than $10,000 " 2 "$10,000 to less than $15,000" 3 "$15,000 to less than $20,000" 4 "$20,000 to less than $25,000" 5 "$25,000 to less than $35,000" 6 "$35,000 to less than $50,000" 7 "$50,000 to less than $75,000" 8 "$75,000 or more" 99 "Prefer Not To Say" 

label values income_n income_n

label define income_n1 1 "Less than  $25,000" 2 "$25,000 to $50,000" 3 "$50,000 to less than $75,000" 4 "$75,000 or more" 99 "Prefer Not To Say" 

label values income_n1 income_n1

label define conservative1 1 "Liberal" 2 "Moderate" 3 "Conservative" 99 "Prefer Not To Say" 
 
label values conservative1 conservative1

label define conservative 1 "Liberal" 2 "Moderate" 4 "Conservative" 3 "Prefer Not To Say" 
 
label values conservative conservative

label define marital 0 "Single" 1 "Married/Partnered" 2 "Divorced/Separated/Widowed" 99 "Prefer Not to Say"

label values marital marital

label define agecat 1 "≤19 years" 2 "20-39" 3 "40-59" 4 "60+"

label values agecat agecat

label define hispanic1 1 "Hispanic" 0 "Non Hispanic" 99 "Prefer Not to Say"

label values hispanic1 hispanic1

label define int_cvd_n 1 "Extremely unlikely" 2 "Unlikely" 3 "Neither likely nor unlikely" 4 "Likely" 5 "Extremely likely"

label values int_cvd_n int_cvd_n






































*Ben's data July 2022
*use "/Users/maiyablock/Desktop/5C Covid article/VaccineHesitancySurveyDeident6-2.dta"

*Updated data, Maiya, August 2022
use "/Users/maiyablock/Desktop/5C Covid article/AVLSurvey_08.06.2022.dta"




* Sensitivity analysis with all data


ologit int_cvd_n Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd, or

ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative, or


ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative Conf_cvd, or

ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd, or









*Drop fishy variables

 tab fishy3emailagree5m1
 
 drop if fishy3emailagree5m1 == 1
 
gen ben = benjamindisputeresolution1
replace ben = 0 if benjamindisputeresolution1 == .

drop if ben == 2
drop if ben ==1
 
 
*Drop ineligible data => 948 observations remaining





 
 *Descriptive Statistics

tab gender1 intend, row chi2
tab gender1
tab hispanic1 intend, row chi2
tab hispanic1
tab racefinal intend, row chi2
tab racefinal
tab collegegrad intend, row chi2
tab collegegrad
tab marital intend, row chi2
tab marital
tab income_n1 intend, row chi2
tab income_n1
tab conservative intend, row chi2
tab conservative

sum age
sum age if intend==1
sum age if intend==2
sum age if intend==3






*Primary Analysis: Ordinary Logistic Regression
 


ologit int_cvd_n Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd, or

ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative, or


ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative Conf_cvd, or

ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n1 i.conservative Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd, or





















*Marginal Effects calc

mfx, predict (outcome(1))

mfx, predict (outcome(2))

mfx, predict (outcome(3))

mfx, predict (outcome(4))

mfx, predict (outcome(5))



*Ordered logit predicted probabilities

predict p1ologit p2ologit p3ologit p4ologit p5ologit

summarize p1ologit p2ologit p3ologit p4ologit p5ologit



*Ordered probit model coefficients

oprobit int_cvd Conf_cvd

oprobit int_cvd Compl_cvd

oprobit int_cvd Const_cvd

oprobit int_cvd Calc_cvd

oprobit int_cvd CollR_cvd


oprobit int_cvd Conf_cvd Compl_cvd Const_cvd Calc_cvd CollR_cvd




*Marginal Effects calc


oprobit int_cvd gender hispanic1 race2 marital school1 income1 politics1 age Conf_cvd Compl_cvd Const_cvd Calc_cvd CollR_cvd


*margins
mfx, predict (outcome(1))

mfx, predict (outcome(2))

mfx, predict (outcome(3))

mfx, predict (outcome(4))

mfx, predict (outcome(5))



























 * Looking at observations with small time duration
 

scatter durationinseconds int_cvd1, mlabel(responseid)
graph box durationinseconds
logit int_cvd1 durationinseconds
predict r
sort r
list responseid r in 1/10
list responseid r in -10/l
list r durationinseconds if abs(r) >2

predict lev
stem lev


disp (2*13 + 2)/1075
list durationinseconds lev if lev > .02604651
lvr2plot, mlabel(responseid)

gen duration = durationinseconds
replace duration = 1 if durationinseconds <=100
replace duration =2 if durationinseconds >100 & durationinseconds<=1000
replace duration = 3 if durationinseconds >1000 & durationinseconds<=10000
replace duration = 4 if durationinseconds >10000 & durationinseconds<=100000
replace duration = 5 if durationinseconds >100000 & durationinseconds<=1000000
replace duration = 6 if durationinseconds >1000000 & durationinseconds<=10000000
replace duration = 7 if durationinseconds >10000000

tab duration int_cvd1

 sum durationinseconds if elig==0
 sum durationinseconds if elig==1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  *Examining missing variables
 
 
tab gender1 elig, row chi2
 
tab gender1 int_cvd3, row chi2
tab gender1 int_cvd2, row chi2


tab hispanic1 elig, row chi2

tab hispanic1 int_cvd3, row chi2
tab hispanic1 int_cvd2, row chi2



tab race2 elig, row chi2

tab race2 int_cvd3, row chi2
tab race2 int_cvd2, row chi2



tab marital elig, row chi2

tab marital int_cvd3, row chi2
tab marital int_cvd2, row chi2




tab school1 elig, row chi2

tab school1 int_cvd3, row chi2
tab school1 int_cvd2, row chi2



tab income1 elig, row chi2

tab income1 int_cvd3, row chi2
tab income1 int_cvd2, row chi2



tab politics1 elig, row chi2

tab politics1 int_cvd3, row chi2
tab politics1 int_cvd2, row chi2

tab agecat elig, row chi2

tab agecat int_cvd3, row chi2
tab agecat int_cvd2, row chi2


sum age if elig==0 
sum age if elig==1


summarize gender1 if elig==0 
summarize gender1 if elig==1
summarize hispanic1 if elig==0 
summarize hispanic1 if elig==1
summarize race2 if elig==0 
summarize race2 if elig==1
summarize marital if elig==0 
summarize marital if elig==1
summarize school1 if elig==0 
summarize school1 if elig==1
summarize income1 if elig==0 
summarize income1 if elig==1
summarize politics1 if elig==0 
summarize politics1 if elig==1
 

 
 
 *Collinearity


collin intend gender1 hispanic1 race2 marital school income politics1 age Conf_cvd Compl_cvd Const_cvd Calc_cvd CollR_cvd


collin int_cvd1 gender1
collin int_cvd1 hispanic

sum hispanic1

*No VIF less than 0.1 or Tolerance less than 0.1, so no issue with collinearity



 
 
 
 
 


*Weighting

*pweights
* [pweight = varname]
* varname = weight variable


*Weighting using Raking by hand method 
**possible problem combining some categories like other with mixed race
**possible problem giving weight of 1 to those who are missing

gen weight_race = 1
replace weight_race = 1.191027523 if racefinal == 1
replace weight_race = 0.991609756 if racefinal == 2
replace weight_race = 0.586384615 if racefinal ==3
replace weight_race = 1.888173913 if racefinal ==4
replace weight_race = 0.21 if racefinal ==5 |racefinal == 7

svyset _n [pweight=weight_race], vce(linearized) singleunit(missing)





***Data gathered from US Census Bureau
* https://www.census.gov/quickfacts/fact/table/pimacountyarizona/LND110210


*White 84.3
*Black 4.4
*AIAN 4.5
*Asian 3.3
* Native Hawaiian and other pacific islander 0.2
* Mixed race1 3.3
*Hispanic 38.5
*College graduate 33.6
*Female 50.5



***Create binary variables
gen white = 0
replace white = 1 if racefinal == 1

gen black = 0
replace black = 1 if racefinal ==2

gen asian = 0
replace asian = 1 if racefinal ==3

gen indig =0
replace indig = 1 if racefinal ==4

gen mixed = 0
replace mixed = 1 if racefinal ==7

gen his = hispanic1
replace his=0 if hispanic1==99

gen college = collegegrad
replace college=0 if collegegrad==99

gen female = gender1
replace female = 0 if gender1 == 1 | gender1 == 3
replace female = 1 if gender1==2
tab female


ipfweight white black asian indig mixed his college female, gen(weight) val(84.3 15.7 4.4 95.6 4.5 95.5 4.7 95.3 3.3 96.7 38.5 61.5 33.6 66.4 50.5 49.5) maxit(25) st(sampleweight)




svyset _n [pweight=weight], vce(linearized) singleunit(missing)


*Primary Analysis: Ordinary Logistic Regression with survey weights

svy linearized : ologit int_cvd_n Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd

svy linearized : ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n i.conservative

svy linearized : ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n i.conservative Conf_cvd

svy linearized : ologit int_cvd_n age i.gender1 i.hispanic1 i.racefinal i.collegegrad i.marital i.income_n i.conservative Conf_cvd CollR_cvd Compl_cvd Const_cvd Calc_cvd









