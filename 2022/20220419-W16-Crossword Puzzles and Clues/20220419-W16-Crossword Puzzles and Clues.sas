/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220419-W16-Crossword Puzzles and Clues;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="times.csv" out=times dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data times;
	set times;
	first=substr(answer,1,1);
	length=length(answer);
run;

proc freq data=times;
	tables first*length / out=counts(where=(first ^="" and 15>= length>2));
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=700 height=700;

title bold height=1.9 "A NEW YORK TIMES CROSSWORD HEATMAP";
title2 "Frequencies of the first letter & answer length from over 100,000 answers";
footnote j=l italic "#TidyTuesday | @CPXOPZ";
proc sgplot data=counts noborder noautolegend;
	heatmapparm x=first y=length colorresponse=Count / colormodel=(CXFBE3C2 CX92351E);
	xaxis display=(noline noticks nolabel);
	yaxis display=(noline noticks nolabel) values=(3 to 15);
run;

ods _all_ close;
ods html;
