/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210810-W33-BEA Infrastructure Investment;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="chain_investment.csv" out=chain dbms=csv replace;
run;
proc import datafile="investment.csv" out=investment.csv dbms=csv replace;
run;
proc import datafile="ipd.csv" out=ipd dbms=csv replace;
run;

data plot_data;
	set chain;
	where meta_cat contains "Digital";
	gross_inv_chain=gross_inv_chain*1e6;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=2 "Real Digital Infrastructure Investment";
title2 "In chained (2012) dollars";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	format gross_inv_chain dollar12.;
	series x=year y=gross_inv_chain / group=category transparency=0.1 lineattrs=(pattern=solid thickness=4) y2axis name="a";
	yaxis grid display=(nolabel noline noticks);
	y2axis grid display=(nolabel noline noticks);
	keylegend "a" / location=inside position=topleft noborder;
run;

ods _all_ close;
ods html;
