/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220405-W14-Digital Publications;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="news_orgs.csv" out=news dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc freq data=news(where=(year_founded>=2010 and year_founded<2021));
	table year_founded*is_owner_founder/ out=out outpct;
run;

data plot_data;
	set out end=eof;
	retain trans;
	if is_owner_founder="Yes" then do; percent_l=0;percent_u=trans;end;
	else if is_owner_founder="No" then  do; percent_l=100-PCT_ROW;percent_u=100;end;
	trans=100-PCT_ROW;
	output;
	if eof then
		do;
			percent_l=.;percent_u=.;x=2019; y=15;text="Yes";output;
			percent_l=.;percent_u=.;x=2013; y=55;text="No";output;
		end;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=800 height=600;

title j=l bold height=1.9 "Is the owner the founder?";
title2 j=l "Percentage of recently founded digitally focused local news organizations in the US and Canada";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noautolegend;
	styleattrs datacolors=(CX808080 CXEFDB3C);
	band x=year_founded lower=percent_l upper=percent_u / group=is_owner_founder curvelabelloc=inside;
	text x=x y=y text=text/ textattrs=(size=28 weight=bold ) transparency=0.6;
	yaxis display=none offsetmax=0.01 offsetmin=0.01;
	xaxis label="Year founded" offsetmax=0.006 offsetmin=0.006;
run;

ods _all_ close;
ods html;
