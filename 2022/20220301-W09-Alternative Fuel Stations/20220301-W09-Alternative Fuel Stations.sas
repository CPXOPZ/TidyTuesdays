/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220301-W09-Alternative Fuel Stations;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="stations.csv" out=stations dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */


/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=800 height=400;

title bold height=1.9 "Alternative Fuel Stations in Lower 48 States";
title2 height=0.4" ";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgpanel data=stations noautolegend;
	where fuel_type_code in ("ELE" "LPG" "BD" "CNG" "E85"  "LNG")   ;
/*	styleattrs  datasymbols=(circlefilled);*/
	panelby fuel_type_code / novarname noheaderborder noborder;
	scatter x=longitude y=latitude / group=fuel_type_code markerattrs=(symbol=circlefilled size=2.4) transparency=0.75;
	colaxis display=none min=-124.736342  max=-66.945392;
	rowaxis display=none  min=24.521208 max=49.382808;
run;

ods _all_ close;
ods html;


/*proc sgplot data=stations noborder;*/
/*	where fuel_type_code="LPG";*/
/*	scatter x=longitude y=latitude;*/
/*	xaxis display=none min=-124.736342  max=-66.945392;*/
/*	yaxis display=none  min=24.521208 max=49.382808;*/
/*run;*/
