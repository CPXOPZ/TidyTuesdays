/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210824-W35-Lemurs;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="lemur_data.csv" out=lemur dbms=csv replace;
run;
proc import file="taxonomy.csv" out=taxonomy dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data weight;
	set lemur;
/*	Gender=ifc(sex="F","Female","Male");*/ *not just male and female;
	if sex="F" then Gender="Female";
		else if  sex="M" then Gender="Male";
		else Gender="NA";
	select(age_category);
		when("young_a") age_cat="Young-Adult";
		when("IJ") age_cat="Infant-Juvenile";
		when("adult") age_cat="Adult";
		otherwise;
	end;
	Group=strip(age_cat)||" "||strip(Gender);
run;

proc sort data=weight;
	by dlc_id weight_date;
run;

data plot_data;
	set weight;
	by dlc_id weight_date;
	if last.dlc_id then output;
	keep Group weight_g;
	run;

data map;
	length value $5;
	input id $6. value $  fillcolor $8. +1 linecolor $8. ;
datalines;
gender Men CXFF863A CXFF863A
gender Mixed CXD03B35 CXD03B35
gender Women CX77A6A9 CX77A6A9
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=200;
ods graphics on / reset outputfmt=png imagename="&name" noborder width=700;

title j=l height=2.5 bold "Weight of lemurs";
title2 j=l height=1.3 color=DABGR "by age category and gender(latest date by specimen ID), where Young Adult Females have the highest median weight at 2155 grams";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend;
	scatter x=group y=weight_g / group=group markerattrs=(symbol=plus) transparency=0.9 discreteoffset=-0.1;
	vbox weight_g / category=group group=group boxwidth=0.2 discreteoffset=0.1 nooutliers;
	xaxis label="Age and gender group";
	yaxis label="Latest weight recorded(in grams)";
run;

title;
title2;
footnote;

ods _all_ close;
ods html;
