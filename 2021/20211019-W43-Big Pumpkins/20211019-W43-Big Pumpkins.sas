/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20211019-W43-Big Pumpkins;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="pumpkins.csv" out=pumpkins dbms=csv replace;
run;

data type;
	input type $1 types & $20.;
datalines;
F Field Pumpkin
L Long Gourd
P Giant Pumpkin
S Giant Squash
T Tomato
W Giant Watermelon
;
run;

data pumpkins;
	set pumpkins(where=(country^="" AND place="1"));
	year=scan(id,1,"-")+0;
	type=scan(id,2,"-");
run;

proc sort data=pumpkins;
	by type;
run;
proc sort data=type;
	by type;
run;

data plot_data;
	merge pumpkins type;
	by type;
run;

data map;
length markercolor $ 15 markersymbol $ 20;
input ID $ value $ markercolor $ markersymbol $ markertransparency;
datalines;
myid  solo MediumBlue Circle 0.7
myid  team MediumRed diamondfilled 0.1
;
run;
/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder height=800px width=1000px;

title bold height=16pt "No.1s In Giant Pumpkins by Types";
title2 " ";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgpanel data=plot_data noautolegend;
	panelby types / novarname headerattrs=(size=13) noborder noheaderborder;
	hbar country / group=country seglabel;
	rowaxis display=(nolabel noline notickets) grid gridattrs=(pattern=dash);
run;

title;
title2;

ods _all_ close;
ods html;
