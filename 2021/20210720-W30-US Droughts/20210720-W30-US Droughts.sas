/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20210720-W30-US Droughts;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="drought.csv" out=drought dbms=csv replace;
run;


data data;
	set drought;
	where pop_total^=0;
	year=year(valid_start);
	keep year valid_start drought_lvl area_pct;
run;

proc sort data=data;
	by year valid_start drought_lvl;
run;

proc means data=data mean noprint;
	by year valid_start drought_lvl;
	var area_pct;
	output out=plot_data(drop=_TYPE_ _FREQ_) mean=Average;
run;

proc sort data=plot_data;
	by year valid_start drought_lvl;
run;

proc transpose data=plot_data out=plot_data;
	by year valid_start;
	id drought_lvl;
	var Average;
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
ods listing dpi=300;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=16pt "Drought in the USA-2001 to 2020";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data;
	band  x=valid_start lower=0 upper=D0/ transparency=0.5 legendlabel="Abnormally dry";
	band  x=valid_start lower=0 upper=D1/ transparency=0.5 legendlabel="Moderate dry";
	band  x=valid_start lower=0 upper=D2/ transparency=0.5 legendlabel="Severe dry";
	band  x=valid_start lower=0 upper=D3/ transparency=0.5 legendlabel="Extreme dry";
	band  x=valid_start lower=0 upper=D4/ transparency=0.5 legendlabel="Exceptional  dry";
	keylegend / location=inside position=topright;
	yaxis label="Percent";
	xaxis display=(nolabel);
run;

title;

ods _all_ close;
ods html;
