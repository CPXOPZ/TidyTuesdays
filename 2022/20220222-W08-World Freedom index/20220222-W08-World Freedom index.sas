/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220222-W08-World Freedom index;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="freedom.csv" out=freedom dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc sort data=freedom;
	by Region_Name year;
run;

proc freq data=freedom noprint;
	by  Region_Name year;
	tables Status / out=freq;
run;

data plot_data;
	set freq;
	select(status);
		when("F") statu=1;
		when("PF") statu=2;
		when("NF") statu=3;
		otherwise;
	end;
run;

proc format;
	value  sta
		1="Free "
		2="Partially Free"
		3="Not Free"
	;
run;

data dis;
	length fillcolor $8 value $14;
	input id $ fillcolor $ value &$ ;
datalines;
status CXC9ECB4 Free
status CX92D3AB Partially Free
status CX181510 Not Free
;


/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=280 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=1.9 "Freedom in the World";
title2 height=0.9 color=dbg "~40%-50%of countries in the Asia and African regions are considered to be not free.Europe and Oceania have the highest proportion offree countries.The countries in text are those which have been considered not free every year for the past 25 years(1995-2020).";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgpanel data=plot_data dattrmap=dis;
/*	styleattrs backcolor=CX181510 wallcolor=CX181510;*/
	panelby Region_Name / onepanel rows=1 novarname noheaderborder noborder headerbackcolor=white;
/*		headerbackcolor=CX181510 headerattrs=(color=white);*/
	format statu sta.;
	vbarparm category=year response=percent / group=statu grouporder=descending
		barwidth=1 nozerobars nooutline attrid=status;
	colaxis display=none;
	rowaxis display=none;
	keylegend / title="" noborder;
run;

ods _all_ close;
ods html;


/*proc sgplot data=plot_data noborder dattrmap=dis;*/
/*	format statu sta.;*/
/*	where Region_Name="Africa";*/
/*	vbarparm category=year response=percent / group=statu grouporder=descending*/
/*		barwidth=1 nozerobars nooutline attrid=status;*/
/*	yaxis display=none;*/
/*	xaxis display=none;*/
/*run;*/
