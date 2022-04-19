/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220412-W15-Indoor Air Pollution;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="indoor_pollution.csv" out=indoor_pollution dbms=csv replace;
run;
proc import datafile="fuel_gdp.csv" out=fuel_gdp dbms=csv replace;
run;


/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data Fuel_gdp;
	set Fuel_gdp;
	length zhou $4;
	if _n_=1 then zhou=Continent;
	retain zhou;
	if Continent^="" then zhou=Continent;
run;

data death;
	set indoor_pollution(where=(year=2016));
run;

data access;
	set fuel_gdp(where=(year=2016 and access^=.));
run;

data plot_data(where=(death^=. and access^=. and gdp^=.));
	merge access death(drop=code year);
	by Entity;
/*	death=death/100;*/
/*	Access=Access/100;*/
/*	format death Access percent10.2;*/

run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250 style=word;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=900 height=650;

title bold height=1.9 "Access to Clean Fuels for Cooking VS Indoor Death Rate in 2016";
title2 j=c "Bubble size is GDP Per Capita";
footnote j=r italic "#TidyTuesday | @CPXOPZ";
proc sgplot data=plot_data noborder;
	bubble x=death y=Access size=GDP / transparency=0.6 group=zhou;
	loess x=death y=Access / nomarker transparency=0.1 smooth=0.3 lineattrs=(color=darkgrey);
	xaxis label="Death Percent" display=(noline);
	yaxis label="% of population having access to clean fuels for cooking" display=(noline);
	keylegend /location=inside position=topright noborder;
run;

ods _all_ close;
ods html;
