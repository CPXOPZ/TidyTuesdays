/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220322-W12-Baby names;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/*direct from github, seems that big file can't work*/
/*filename probly temp;*/
/*proc http*/
/*	 url="https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-22/applicants.csv"*/
/*	 method="GET"*/
/*	 out=probly;*/
/*run;*/
/**/
/*proc import*/
/*	  file=probly*/
/*	  out=work.probly replace*/
/*	  dbms=csv;*/
/*run;*/

proc import datafile="babynames.csv" out=babynames dbms=csv replace;
run;

/*https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-22/babynames.csv*/


/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data plot_data;
	set babynames;
	where year=1996 and sex="M";	
run;

proc sort data=plot_data;
	by descending n;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=600 height=800;

title bold height=2 "Top 10 baby names in 1996";
footnote j=r italic "#TidyTuesday | @CPXOPZ";
proc sgplot data=plot_data(obs=20) noborder noautolegend;
/*	format n 5.;*/
	hbarparm category=name response=n/ group=name displaybaseline=off
	groupdisplay=cluster datalabel datalabelfitpolicy=insidepreferred datalabelattrs=(size=9);
/*	text x=n y=name text=n/ position=left backfill fillattrs=(color=white);*/
	yaxis display=(noline nolabel noticks);
	xaxis display=none;
run;

ods _all_ close;
ods html;
