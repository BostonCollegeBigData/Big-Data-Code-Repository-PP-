/*******************************************************************************
Title: Mobile vs. Email Analysis
By: Teamclickbait
Date: 9/20/2016
*******************************************************************************/


*************
* SETUP
*************

use "/Users/palanza/Documents/BC - Big Data Econometrics/Summary Data 5pct Sample.dta", clear
set more off 

***rename mill_id as constituent_id so they can be merged 
rename mill_id constituent_id

***merge the two datasets 
merge m:1 constituent_id using "/Users/palanza/Documents/BC - Big Data Econometrics/WORK_WCAS_DATA_CLASS.dta" ///

tabulate _merge
	*Master only (1) - 19.09%
	*Using only (2) - 7.73%
	*Matched (3) 0 - 73.18%
	
*save new dataset
export delimited using "/Users/palanza/Documents/BC - Big Data Econometrics/5pct Summary & Demographics.csv", replace


*************************************
* Variable Generation/Transformation
*************************************

**** Dummy Variable for Donate
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


*** Drop Detailed Date Variables/Replace With New Ones
drop date_sent
rename date_sent_redef date_sent

drop open_date
rename open_date_redef open_date

drop click_date
rename click_date_redef click_date


*** Drop top 5% of donors 
sum fy16_cash, detail
sum fy15_cash, detail
	*We decided to drop the top 5% of observations.
	*In FY16 the 95th percentile donation was $750, in FY15 it was $645

drop if fy16_cash>750
	*Dropped 269,473
drop if fy15_cash>645
	*Dropped 10,102

sum lifetime_cash
	*new mean is $1786

*Save Transformed Data
export delimited using "/Users/palanza/Documents/BC - Big Data Econometrics/5pct Summary & Demographics.csv", replace


********************
* Questions Answered
********************


*Email open on mobile or desktop?
tabulate email_open mobile
	*72.3 % of emails went unopened. The 27.7% breaks out as: 
	*14.1% were opened only on mobile 
	*13.3% were opened only on desktop


*Email Clicked on Mobile or Desktop?
tabulate mobile click
	*2.58% of all emails were “clicked”. Of those clicked:
		*53.2% were on desktop
		*45.7% were on mobile

*Count contacts by campaign/email 
tabulate campaign


