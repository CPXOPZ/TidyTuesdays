/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210907-W37-Formula 1 Races;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="constructors.csv" out=constructors dbms=csv replace;
run;
proc import file="races.csv" out=races dbms=csv replace;
run;
proc import file="results.csv" out=results dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc sort data=results(where=(positionText="1")) out=result_o;
	by raceid;
run;
proc sort data=races;
	by raceid;
run;

data mer_result;
	merge result_o(in=a) races;
	by  raceid;
	if a;
run;

proc sort data=mer_result;
	by constructorId;
run;
proc sort data=constructors;
	by constructorId;
run;

data plot_data;
	merge mer_result(in=a) constructors;
	by  constructorId;
	if a;
	times=input(milliseconds,best.)/1000/60/60;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300 style=rtf;
ods graphics on / reset outputfmt=png imagename="&name" noborder;

title height=1.8 bold "Formula 1 Winning Times";
title2 height=0.3 " ";
title3 height=1.3 color=DABGR "A sharp drop in the late 1950s, and continued to decrease until the 1970s.";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	scatter x=year y=times / group=nationality markerattrs=(symbol=circlefilled) transparency=0.5;
	pbspline x=year y=times / nomarkers lineattrs=(thickness=3 color=black) transparency=0.5;
	xaxis grid display=(nolabel noline noticks);
	yaxis grid label="Winning Time(hours)" display=(noline noticks);
	keylegend / location=inside position=top across=3 noborder;
run;

ods _all_ close;
ods html;
