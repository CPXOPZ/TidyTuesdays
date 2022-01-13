/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20210727-W31-Olympic Medals;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="olympics.csv" out=olympics dbms=csv replace;
run;

proc import datafile="regions.csv" out=regions dbms=csv replace;
run;

proc sort data=olympics;
	by noc;
run;

proc sort data=regions;
	by noc;
run;

data pre;
	merge olympics regions;
	by noc;
run;

data pre1;
	set pre;
	where medal^="" and year>=1988 and season="Summer";
run;

proc freq data=pre1 noprint;
	table year*region / out=pre2(drop=percent);
run;

proc sort data=pre2;
	by year region;
run;

proc rank data=pre2 out=rank ties=low descending;
	by year;
	var count;
	ranks rank;
run;

proc sort data=rank;
	by region year;
run;

data plot_data;
	set rank;
	where rank<=7 and region in ("USA", "Russia", "Germany", "China", "Australia");
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=16pt "Countries With the Most Olympic Medals by Year";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noautolegend noborder;
	series x=year y=rank / group=region transparency=0.5 curvelabel lineattrs=(thickness=5 pattern=solid)
		curvelabelattrs=(size=12 weight=bold);
	scatter  x=year y=rank / group=region markerattrs=(size=15 symbol=circlefilled) ;
	xaxis grid display=(nolabel noline noticks) values=(1988 to 2016 by 4);
	yaxis reverse grid display=(noline noticks)  label="Rank";
run;

title;

ods _all_ close;
ods html;
