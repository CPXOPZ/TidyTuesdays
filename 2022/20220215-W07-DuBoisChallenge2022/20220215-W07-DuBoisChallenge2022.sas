/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220215-W07-DuBoisChallenge2022;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="data.csv" out=data dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data plot_data;
	set data end=last;
	if _n_ in (1,9) then freel=strip(free)||"%";
	else freel=put(free,best3.1);
	free=free/100;
	label freel="PERCENT OF FREE NEGROES";
	if last then free=0.1;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=400 height=600;

title1 height=1.2 " ";
title2 bold height=1.3 "SLAVES AND FREE NEGROES.";
title3 height=1 " ";
footnote height=1 " ";
footnote2 j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend pad=(left=12.5pct right=12.5pct bottom=10pct);
	format free percent.;
	styleattrs backcolor=CXDDD1C5 wallcolor=CXDDD1C5;
	band  y=year upper=free lower=0 / x2axis fillattrs=(color=CXD20335);
	band  y=year upper=100 lower=free / x2axis  fillattrs=(color=CX000000);
	series x=free y=year / x2axis lineattrs=(color=CXDDD1C5);
	refline 1790 to 1870 by 10 / lineattrs=(color=CXDDD1C5);
	yaxis reverse values=(1790 to 1870 by 10) display=(noline noticks nolabel);
	x2axis reverse max=3 display=(noline noticks nolabel) values=(0 to 0.03 by 0.01);
	yaxistable freel / position=right labelattrs=(size=2) valuejustify=center;
run;

ods _all_ close;
ods html;
