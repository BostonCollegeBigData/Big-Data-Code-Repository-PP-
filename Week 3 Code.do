/*******************************************************************************
Title: Descriptive Statistics for BC Donor Data
By: Philip Palanza
Date: 9/11/2016
Description: Summary stats, variable generation, and testing relationships in BC
			 giving office data set.
*******************************************************************************/

********************
* Settings
********************

set more off
log using "/Users/palanza/Documents/BC - Big Data Econometrics/Log Files/Week 3 Assignment Log.log"
cd "/Users/palanza/Documents/BC - Big Data Econometrics"
use "/Users/palanza/Documents/BC - Big Data Econometrics/WORK_WCAS_DATA_CLASS.dta"

********************************************************************************
							* Small Data Set *
********************************************************************************

***************
*Notes on Data
**************

* n = 197,710
* 51 variables (after manipulation)

*************************************
* Variable Generation/Transformation
*************************************

**** Dummy Variable for Donations
gen donate = 0
replace donate = 1 if lifetime_cash > 0
label var donate "Donation Y/N"


**** Dummy Variable for FY15 Donations
gen fy15donate = 0
replace fy15donate = 1 if fy15_cash > 0
label var fy15donate "Donation FY15 Y/N"

**** Dummy Variable for FY16 Donations
gen fy16donate = 0 
replace fy16donate = 1 if fy16_cash > 0
label var fy16donate "Donation FY16 Y/N"


**** Encode String Year Variables
encode gas_year, generate (gasyear)
encode parent_year, generate (parentyear)


**** Change Email Preference String Dummies to Numeric Dummies
tabulate no_affinity_email, generate(dum)
drop dum1
drop no_affinity_email
rename dum2 no_affinity_email
label var no_affinity_email "Opt Out Affinity-Email"

tabulate no_blast_email, generate(dum)
drop dum1
drop no_blast_email 
rename dum2 no_blast_email 
label var no_blast_email "Opt Out Blast Email"

tabulate no_chapter_email, generate(dum)
drop dum1
drop no_chapter_email 
rename dum2 no_chapter_email 
label var no_chapter_email "Opt Out Chapter Email"

tabulate no_donor_email, generate(dum)
drop dum1
drop no_donor_email 
rename dum2 no_donor_email 
label var no_donor_email "Opt Out Donor Email"

tabulate no_evt_week_email, generate(dum)
drop dum1
drop no_evt_week_email
rename dum2 no_evt_week_email
label var no_evt_week_email "Opt Out Event Week Email"

tabulate no_general_email, generate(dum)
drop dum1
drop no_general_email 
rename dum2 no_general_email 
label var no_general_email "Opt Out General Email"

tabulate no_school_email, generate(dum)
drop dum1
drop no_school_email 
rename dum2 no_school_email 
label var no_school_email "Opt Out School Email"

tabulate no_solic_email, generate(dum)
drop dum1
drop no_solic_email 
rename dum2 no_solic_email 
label var no_solic_email "Opt Out Solicit Email"

tabulate no_spirit_email, generate(dum)
drop dum1*
drop no_spirit_email  
rename dum2 no_spirit_email  
label var no_spirit_email  "Opt Out Spirit Email"

tabulate no_survey_email, generate(dum)
drop dum1
drop no_survey_email 
rename dum2 no_survey_email   
label var no_survey_email "Opt Out Survey Email"

tabulate is_deceased, generate(dum)
drop dum1
drop is_deceased
rename dum2 is_deceased   
label var is_deceased "Is Deceased"


**** Create Dummies for Home State
*tabulate home_state, generate(homestate)
**** Create Dummies for Work State
*tabulate work_state, generate(workstate)

/* Above commands generate a new dummy variable for each home state, but it takes
a 0 value for yes and a missing value for no. Need to write a loop to fix or find
a different command. */

*Should generate variables for ranges of donations for cross tabulations.


save "/Users/palanza/Documents/BC - Big Data Econometrics/WORK_WCAS_DATA_CLASS_wk2.dta"


*************************************
* Summary Statistics/CrossTabulations 
*************************************

* How much are people donating?
sum lifetime_cash, detail
	*mean lifetime donation is 6039 
	*median lifetime donation is 50
	*Standard deviation is quite large - 164,646
graph hbox lifetime_cash

* How many people are donating?
tabulate donate 
	*63.54% (125,618) of observations donated, 36.46% (72,094) did not 

* How many FY15 donors vs. FY16 donors? Both/Neither?
tabulate fy15donate fy16donate
	*Raw number of donations increased from 33,170 to 34,630
	* 23,802 observations donated both years, 153,712 didn't donate either year
	
* Average FY15 vs. FY16?
sum fy15_cash fy16_cash
	*Average 2015 give was $396, average 2016 give was $376
sum fy15_commit fy16_commit
	*AverageFY15

*Donate (Y/N) by undergrad school
tabulate ugrad_school donate
	*Total of 135,184 undergrad degree obs listed
	*97,935 obs donated, 37,,249 did not 
	*CSOM has the best participation rate, Morrissey next best
	*Nursing and education grads appear less likely to donate
	*Woods is about 50/50

*Donate Y/N by undergrad year
tabulate ugrad_year donate


*Donate Y/N by State
tabulate home_state donate
tabulate work_state donate

*Who's Alive?
tabulate ugrad_year is_deceased
	*Graduating year of 1956 is the inflection point where more observations are
	*alive than deceased

*Donation rate by parent year
tabulate parent_year donate

* What Classes donated to the LTW Campaign?
tabulate ugrad_year ltw_cash


********************************************************************************
					* 5% Sample from Summary Data Set *
********************************************************************************

use "/Users/palanza/Documents/BC - Big Data Econometrics/Summary Data 5pct Sample.dta", clear

*Email delivered? 
tabulate bounce 
*99.07% were delivered

* Email opened?
tabulate email_open
	*72.6% open rater overall
	*sample is still too large to do this by the individual 


*Email clicked?
tabulate click

*Email open on mobile or desktop?
tabulate email_open mobile
	*tabulate email_open desktop

	
*Count contacts by campaign/email 
tabulate campaign




********************************************************************************
							* Summary Data Set *
********************************************************************************

/*import delimited "/Users/palanza/Documents/BC - Big Data Econometrics/Summary Data.csv"

**** NOTE: These commands take a very long time to process!! 


*Email delivered? 
tabulate bounce 
	*99.09% of emails were delivered/did not bounce

* Email opened?
tabulate email_open
	* 72.6% unopened, 27.4% opened
	* 15.61 million didn't open, 5.89 million opened
	
tabulate email_open mobile
	*21.5 million emails went out, 15.6 million were unopened, only 5.89 were opened 
	* of the 5.89 million opened, 3.1 million were mobile, 2.7 million were desktop
	
*tabulate email_open desktop
	*inverse of previous command

* Email Click?
tabulate click
	*97.4% unclicked, 2.6% clicked
	
*Unsubscribe rate
tabulate unsubscribe
	*This variable is a discrete categorical 0-5, 99.93% of obs were 0

*Contacts by campaign/email 
tabulate campaign
	/*Might be best to look at the observations by campaign to try to control 
	for implicit factors not quantified here*/
	
*tabulate email_subject 
*	tabulate email_subject email_open
*	tabulate email_subject mobile desktop

*tabulate email_name
*	tabulate email_name email_open
*	tabulate email_name mobile desktop


*/


