/*
 Logan Maurer
 Chris Lee
 30/11/2018
 Semester Project
 
 Chicago, being a large city with a high crime rate, has a lot of crime data to analyze.
 This program performs chi squared test to compare arrest rates by community area and to 
 compare arrest rates by type of crime.
 */

proc import
	out = crime2001_2004
	datafile = '/home/lmaurer1/sasuser.v94/semesterProject/Chicago_Crimes_2001_to_2004.csv'
	dbms = csv;
run;

proc import
	out = crime2005_2007
	datafile = '/home/lmaurer1/sasuser.v94/semesterProject/Chicago_Crimes_2005_to_2007.csv'
	dbms = csv;
run;

proc import
	out = crime2008_2011
	datafile = '/home/lmaurer1/sasuser.v94/semesterProject/Chicago_Crimes_2008_to_2011.csv'
	dbms = csv;
run;

proc import
	out = crime2012_2017
	datafile = '/home/lmaurer1/sasuser.v94/semesterProject/Chicago_Crimes_2012_to_2017.csv'
	dbms = csv;
run;

data allCrime;
	set crime2001_2004(drop = IUCR 'fbi code'N)
		crime2005_2007(drop = IUCR 'fbi code'N)
		crime2008_2011(drop = IUCR 'fbi code'N)
		crime2012_2017(drop = IUCR 'fbi code'N);
	year = datepart(date);
	rename 'Primary Type'N = primeType;
	rename 'Location Description'N = locDescr;
	rename 'Community Area'N = commArea;
	if _n_ = 1513590 then delete;
	if upcase('Community Area'N) = 0 then delete;
	if upcase('Primary Type'N) = 'NARCOTIC' then 'Primary Type'N = 'NARCOTICS';
	if upcase('Primary Type'N) = 'OTHER NA' then 'Primary Type'N = 'NARCOTICS';
	if upcase('Primary Type'N) = 'OTHER NARCOTIC VIOL' then 'Primary Type'N = 'NARCOTICS';
	if upcase('Primary Type'N) = 'OTHER NARCOTIC VIOLATI' then 'Primary Type'N = 'NARCOTICS';
	if upcase('Primary Type'N) = 'OTHER NARCOTIC VIOLATION' then 'Primary Type'N = 'NARCOTICS';
	if upcase('Primary Type'N) = 'OTHER OF' then 'Primary Type'N = 'OTHER OFFENSE';
	if upcase('Primary Type'N) = 'MOTOR VE' then 'Primary Type'N = 'MOTOR VEHICLE THEFT';
	if upcase('Primary Type'N) = 'DECEPTIV' then 'Primary Type'N = 'DECEPTIVE PRACTICE';
	if upcase('Primary Type'N) = 'PROSTITU' then 'Primary Type'N = 'PROSTITUTION';
	if upcase('Primary Type'N) = 'WEAPONS' then 'Primary Type'N = 'WEAPONS VIOLATION';
	if upcase('Primary Type'N) = 'PUBLIC P' then 'Primary Type'N = 'PUBLIC PEACE VIOLATION';
	if upcase('Primary Type'N) = 'PUBLIC PEACE VIOLAT' then 'Primary Type'N = 'PUBLIC PEACE VIOLATION';
	if upcase('Primary Type'N) = 'CRIM SEX' then 'Primary Type'N = 'CRIMINAL SEXUAL ASSAULT';
	if upcase('Primary Type'N) = 'CRIM SEXUAL ASSAULT' then 'Primary Type'N = 'CRIMINAL SEXUAL ASSAULT';
	if upcase('Primary Type'N) = 'OFFENSE INVOLVING C' then 'Primary Type'N = 'OFFENSE INVOLVING CHILDREN';
	if upcase('Primary Type'N) = 'OFFENSE INVOLVING CHIL' then 'Primary Type'N = 'OFFENSE INVOLVING CHILDREN';
	if upcase('Primary Type'N) = 'SEX OFFE' then 'Primary Type'N = 'SEX OFFENSE';
	if upcase('Primary Type'N) = 'LIQUOR L' then 'Primary Type'N = 'LIQUOR LAW VIOLATION';
	if upcase('Primary Type'N) = 'LIQUOR LAW VIOLATIO' then 'Primary Type'N = 'LIQUOR LAW VIOLATION';
	if upcase('Primary Type'N) = 'INTERFERENCE WITH P' then 'Primary Type'N = 'INTERFERENCE WITH PUBLIC O';
	if upcase('Primary Type'N) = 'INTERFERENCE WITH PUBL' then 'Primary Type'N = 'INTERFERENCE WITH PUBLIC O';
	if upcase('Primary Type'N) = 'INTIMIDA' then 'Primary Type'N = 'INTIMIDATION';
	if upcase('Primary Type'N) = 'OBSCENIT' then 'Primary Type'N = 'OBSCENITY';
	if upcase('Primary Type'N) = 'OTHER OF' then 'Primary Type'N = 'OTHER OFFENSE';
	if upcase('Primary Type'N) = 'PUBLIC I' then 'Primary Type'N = 'PUBLIC INDECENCY';
	if upcase('Primary Type'N) = 'NON-CRIM' then 'Primary Type'N = 'NON - CRIMINAL';
	if upcase('Primary Type'N) = 'NON-CRIMINAL (SUBJECT' then 'Primary Type'N = 'NON - CRIMINAL';
	if upcase('Primary Type'N) = 'NON-CRIMINAL' then 'Primary Type'N = 'NON - CRIMINAL';
	if upcase('Primary Type'N) = 'KIDNAPPI' then 'Primary Type'N = 'KIDNAPPING';
run;

proc freq data = allCrime
	order = freq;
	format year year4.;
	tables arrest commArea*arrest primeType*arrest;
run;

proc gchart data = allCrime;
	title "Pie Chart of Type of Crime by Arrest";
	pie primeType / group = arrest percent = inside;
run;

proc gchart data = allCrime;
	title "Stacked Vertical Bar Chart of Crimes by Community Area";
	vbar commArea / subgroup = arrest discrete;
	where commArea < 38;
run;

proc gchart data = allCrime;
	vbar commArea / subgroup = arrest discrete;
	where commArea >= 38;
run;

proc freq data = allCrime;
	title "Chi-Squared Tests";
	tables arrest * (commArea primeType) / chisq expected;
run;