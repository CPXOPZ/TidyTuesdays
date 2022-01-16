/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220111-W02-Bee Colony losses;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="colony.csv" out=colony dbms=csv replace;
run;

proc import datafile="stressor.csv" out=stressor dbms=csv replace;
run;

data colony;
	set colony;
	if months="2019" then months="April-June";
	if year = '6/' then year ="2019";
run;
data stressor;
	set stressor;
	if months="2019" then months="April-June";
	if year = '5/' then year ="2019";
run;

proc sort data=colony; 
	by year months state;
run;
proc sort data=stressor; 
	by year months state;
run;
data bees;
	merge colony(keep=year months state colony_lost) stressor;
	by year months state;
	colony_lost_stress = colony_lost * (stress_pct/100)/1000;
run;

proc sort data=bees; 
	by year months stressor;
run;

proc means data=bees noprint;
	by year months stressor;
	var colony_lost_stress;
	output out=sum sum=Sum;
run;

data plot_data;
	set sum;
	where stressor^="";
	year=year+0;
	select(months);
		when("January-March") month=1;
		when("April-June") month=2;
		when("July-September") month=3;
		when("October-Decembe") month=4;
	end;
run;

proc format;
	value mm
		1="January-March"
		2="April-June"
		3="July-September"
		4="October-Decembe";
run;

data map;
	length value$20 fillcolor $8 linecolor $8;
	input id$ value fillcolor $ linecolor $;
datalines;
bar January-March CXA04543 CXA04543
bar April-June CXDE6A4E CXDE6A4E
bar July-September CXEAA053 CXEAA053
bar October-December CXF6D868 CXF6D868
;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder height=400 width=1000px;

title bold height=3 "Honey bee colony loss";
title2 "Colony stressors in the United States from 2015 to 2021";
title3 "Absolute loss per thousand colonies in y-axis";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgpanel data=plot_data dattrmap=map;
	format month mm.;
	panelby stressor / novarname noborder noheaderborder sort=descmean;
	vbar year / group=month groupdisplay=cluster response=Sum nozerobars attrid=bar;
/*		colormodel=(CXA04543 CXDE6A4E CXEAA053 CXF6D868);*/
	colaxis grid display=(nolabel noline noticks);
	rowaxis grid display=(nolabel noline noticks);
	keylegend / title="" noborder position=top;
run;

ods _all_ close;
ods html;
