/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20211221-W52-Starbucks drinks;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="starbucks.csv" out=starbucks dbms=csv replace;
run;

data colormap;
	retain id "myid";
	length min $ 5 max $ 5;
	input min $ max $ colormodel1 $ colormodel2 $ colormodel3 $;
datalines;
_min_   _max_ yellow orange red
;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=16pt "Starbucks Drinks: Carbohydrates and Sugar";
title2 j=l  italic "               Carbs + Sugar = Calories!";
footnote j=r "#TidyTuesday | @CPXOPZ";
proc  sgplot data=starbucks rattrmap=colormap;
	label Sugar_g="Sugar (grams) ";
/*	bubble x=Total_Carbs_g y=Calories size=Sugar_g / FILLATTRS=(transparency=.5) colorresponse=Sugar_g rattrid=myid;*/
	scatter x=Total_Carbs_g y=Calories  / markerattrs=(symbol=circlefilled) transparency=.5
		colorresponse=Sugar_g colormodel=(yellow orange red) name="s";
	reg x=Total_Carbs_g y=Calories  / nomarkers transparency=.7 name="r";
	xaxis grid label="Carbohydrates (grams)" offsetmin=0.035;
	yaxis grid label="Calories" offsetmin=0.05 offsetmax=0.05;
/*	keylegend "r" / location=inside position=bottomright;*/
/*	keylegend "s" / location=outside;*/
run;

title;
footnote;

ods _all_ close;
