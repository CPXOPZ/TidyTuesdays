/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210914-W38-Billboard Top 100;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="audio_features.csv" out=features dbms=csv replace;
run;
proc import file="billboard.csv" out=billboard dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data df;
	set billboard;
	date=input(week_id, mmddyy10.);
	year=year(date);
run;

proc sort data=df;
	by song_id;
run;
proc sort data=features;
	by song_id;
run;
data join;
	length song_id $70;
	merge df(in=a) features(keep=song_id loudness);
	by song_id;
	if a;
run;

data plot_data;
	set join;
	by song_id;
	where loudness^=. and loudness<0;
	if first.song_id;
	label loudness="Loudness (in dB)" ;
run;




/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=200 style=Daisy;
ods graphics on / reset outputfmt=png imagename="&name" noborder;

title height=1.6 j=l bold "Loudness of Billboard Top 100 Songs";
title2 j=l color=gray "Changes in music track loudness(in decibels)by year. Includes songs listed on Billboard Top 100 from Aug 02, 1958 to May 29, 2021";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	refline 0 -10 -20 / label axis=y labelloc=outside labelpos=min transparency=0.4;
	refline 1960 1970 1980 1990 2000 2010 2020 / label axis=x lineattrs=(pattern=dot) labelloc=outside  labelpos=min transparency=0.4;  
	vbox loudness / category=year outlierattrs=(size=3) nofill nomean lineattrs=(thickness=1.1);
	xaxis display=(nolabel noline noticks novalues);
	yaxis display=(noline noticks) valueattrs=(color=white);
run;

ods _all_ close;
ods html;
