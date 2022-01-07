/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20211026-W44-Ultra Trail Running;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="race.csv" out=race dbms=csv replace;
run;

proc import datafile="ultra_rankings.csv" out=ultra_rankings dbms=csv replace;
run;

data plot_data;
	set race;
	where aid_stations^=0 and participants^=0 and distance^=0;
	participation=ifc(participation="Solo", "solo", participation);
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

title bold height=16pt "Aid station count in Ultra Trail Running";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgscatter data=plot_data dattrmap=map;
	label aid_stations="Aid station count"  participants="N of participants" distance="Distance in Km"
		participation="Participation type";
/*	matrix distance aid_stations participants;*/
/*	compare y=(aid_stations) x=(participants distance);*/
	plot (aid_stations)*(participants distance) / JITTER group=participation attrid=myid;
run;

title;

ods _all_ close;
ods html;
