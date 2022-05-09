/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220503-W18-Solar_Wind utilities;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="solar.csv" out=solar dbms=csv replace;
run;
proc import datafile="wind.csv" out=wind dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
/*wrong direction */

/*data data;*/
/*	merge solar wind;*/
/*	by date;*/
/*	n=_n_;*/
/*run;*/
/**/
/*proc transpose data=data out=data2(drop=n rename=(col1=value)) name=cat;*/
/*	by  date n;*/
/*	var solar_mwh solar_capacity wind_mwh wind_capacity;*/
/*run;*/

data solar1;
	set solar;
	type="solar";
	metric="mwh";
run;

data wind1;
	set wind;
	type="wind";
	metric="mwh";
run;

data plotdata;
	set solar1(rename=(solar_mwh=mwh solar_capacity=capacity))
	 wind1(rename=(wind_mwh=mwh wind_capacity=capacity));
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=800 height=500;

title bold height=1.9 "The price of " color=CXff6f61 "solar" color=black " and " color=CX92a8d1 "wind" color=black " power has fallen from 2009 to 2021";
footnote j=r italic "#TidyTuesday | @CPXOPZ";
proc sgplot data=plotdata noborder noautolegend;
	styleattrs datacolors=(CXff6f61 CX92a8d1) datacontrastcolors=(black);
	bubble x=date y=mwh size=capacity / group=type bradiusmin=4 bradiusmax=15 transparency=0.1;
	yaxis label="$per megawatt hour" grid display=(nolabel noline noticks);
	xaxis display=(nolabel noline noticks) ;
/*	keylegend / location=inside position=topright noborder;*/
run;

ods _all_ close;
ods html;


ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="aaa" noborder width=800 height=500;

proc template;
	define statgraph bub;
		begingraph / border=false ;
			entrytitle "The price of solar and wind power has fallen from 2009 to 2021";
			entryfootnote "#TidyTuesday | @CPXOPZ" ;
			layout overlay /border=false xaxisopts=(display=(tickvalues)) yaxisopts=(display=(label tickvalues) label="$per megawatt hour");
				bubbleplot x=date y=mwh size=capacity / group=type bubbleradiusmin=4 bubbleradiusmax=15 name="b";
				discretelegend "b";
			endlayout;
		endgraph;
	end;
run;

proc sgrender data=plotdata template=bub;
run;
ods _all_ close;
ods html;
