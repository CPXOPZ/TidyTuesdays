/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220531-W22-Company reputation poll;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="reputation.csv" out=reputation dbms=csv replace;
	guessingrows=500;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
proc sql;
	select mean(score) into: meanscore
	from reputation(where=(name="GROWTH"));
quit;


data plot_Data;
	set reputation;
	where name="GROWTH";
	if industry in ("Retail", "Tech", "Food & Beverage", "Financial Services", "Automotive");
	base=&meanscore;
run;

proc sort data=plot_data;
	by score;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

proc template;
	define statgraph bars;
		begingraph;
			entrytitle halign=left "Growth Prospects" / textattrs=(size=16);
			entryfootnote halign=center "#TidyTuesday | @CPXOPZ" / textattrs=(style=italic);

			layout overlay / walldisplay=none yaxisopts=(display=none) xaxisopts=(display=none);
				referenceline y=76.76;
/*				highlowplot x=company low=base high=score ;*/
				barchartparm category=company response=score / baselineintercept=76.76 barwidth=0.2 datatransparency=0.6;
				scatterplot x=company y=score / group=industry markerattrs=(symbol=circlefilled) name="a";
				discretelegend "a" / border=false across=2 location=inside halign=right valign=0.3 ;
				drawtext textattrs=(size=8pt) "Averag growth prospects" /xspace=wallpercent yspace=wallpercent  x=5 y=75 ;
				entry halign=left  "According to the Axios and Harris poll,growth prospects varies substantially" / valign=top ;
				entry halign=left "between different companies.Target is placed well above average while"/ valign=top pad=(top=15px);
				entry halign=left  "The Kroger Company is far below."/ valign=top pad=(top=30px) ;
	
			endlayout;

		endgraph;
	end;
run;



ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=600 height=450;

proc sgrender data=plot_data template=bars;
	
run;

ods _all_ close;
ods html;

