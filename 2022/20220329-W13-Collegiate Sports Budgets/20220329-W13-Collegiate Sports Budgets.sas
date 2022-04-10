/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220329-W13-Collegiate Sports Budgets;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="sports.csv" out=sports dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data prepare;
	set sports(where=(not(sum_partic_men=0 and sum_partic_women=0)));
	total_partic_menwomen = sum_partic_men + sum_partic_women;
	pct_male = sum_partic_men / total_partic_menwomen;
	pct_female = sum_partic_women / total_partic_menwomen;
run;

proc sort data=prepare;
	by sports;
run;

proc summary data=prepare mean;
	by sports;
	var 	total_partic_menwomen pct_male pct_female;
	output out=out mean=/autoname;
run;

proc sort data=out(where=(sports ^contains "Track")) out=plotdata;
	by pct_female_Mean;
run;

data plotdata;
	set plotdata;
	pct_male_Mean=-pct_male_Mean;
	y=0;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=1000 height=600;

title bold height=1.9 "Proportion of men and women participation in sports";
footnote j=r italic "#TidyTuesday | @CPXOPZ";
proc sgplot data=plotdata noborder noautolegend;
	vbarparm category=sports response=pct_male_Mean /displaybaseline=off fillattrs=(color=CX669bbc);
	vbarparm category=sports response=pct_female_Mean /displaybaseline=off fillattrs=(color=CXC7604B);
	text x=sports y=y text=sports / rotate=90 textattrs=(weight=bold size=10) backlight=0.5;
	inset " " "Sports played mostly by women"/position=topleft textattrs=(color=CXC7604B size=15);
	inset "Sports played mostly by women" " " /position=bottomright textattrs=(color=CX669bbc size=15);
	xaxis display=none offsetmax=0.04 offsetmin=0.04;
	yaxis display=(noticks nolabel noline) grid offsetmax=0.02 offsetmin=0.02;
run;

ods _all_ close;
ods html;
