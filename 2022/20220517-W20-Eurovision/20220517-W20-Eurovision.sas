/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220517-W20-Eurovision;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="eurovision.csv" out=euro dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data plot_data;
	set euro;
	where year >= 2005 and section= "grand-final";
	if rank<=3 then do; total=total_points; rank_t=rank;end;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250 style=dove;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=600 height=600;

title bold height=1.9 "EUROVISION points are trending upwards";
title2 color=grey60 "The upward gradual trend reflects that countries need more points to come first,second,and thirdwith each new edition";
footnote j=l italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noautolegend noborder;
	styleattrs datacontrastcolors=(CXF68511 CX4046CA CX0FB5AE);
	series x=year y=total_points / group=rank lineattrs=(color=grey thickness=0.5 pattern=solid) transparency=0.6;
	series x=year y=total / group=rank_t lineattrs=(thickness=2 pattern=solid) name="top";
	yaxis label="Total points" grid display=(noline noticks);
	xaxis grid display=(noline noticks nolabel);
	keylegend "top" / title="Rank" exclude=(".") location=inside position=topleft across=1 noborder sortorder=ascending;
run;


ods _all_ close;
ods html;
