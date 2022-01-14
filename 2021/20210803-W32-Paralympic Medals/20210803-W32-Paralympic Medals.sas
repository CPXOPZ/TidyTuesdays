/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210803-W32-Paralympic Medals;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="athletes.csv" out=athletes dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data map;
	length value $5;
	input id $6. value $  fillcolor $8. +1 linecolor $8. ;
datalines;
gender Men CXFF863A CXFF863A
gender Mixed CXD03B35 CXD03B35
gender Women CX77A6A9 CX77A6A9
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics on / reset outputfmt=png imagename="&name" noborder;

title j=l height=2.5 bold "Paralympics Sport and Gender";
title2 j=l height=1.3 color=grey "Proportion of gender by type of sport, from 1980 to 2016";
footnote j=l italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=athletes pctlevel=group dattrmap=map noborder;
	hbar type / barwidth=0.65 group=gender grouporder=ascending stat=pct displaybaseline=off attrid=gender;
	keylegend / title="Gender" position=topleft noborder;
	xaxis grid display=(nolabel noline noticks);
	yaxis display=(nolabel noline noticks);
run;

title;
title2;
footnote;

ods _all_ close;
ods html;
