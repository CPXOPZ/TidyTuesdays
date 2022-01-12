/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20211012-W42-Global Seafood;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="fish-stocks-within-sustainable-levels.csv" out=stock dbms=csv replace;
run;

proc datasets library=work nolist;
	modify stock;
		rename Share_of_fish_stocks_within_bio=sustainable  Share_of_fish_stocks_that_are_o=overexploited;
run;

data plot_data;
	set stock(where=(Entity="World"));
	sustainable=-1*sustainable;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics  /reset outputfmt=png imagename="&name" noborder height=400px width=500px;

title bold height=16pt "Fish stocks are overexploited";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noautolegend;
	vbar year / response=sustainable transparency=0.15;
	vbar year / response=overexploited transparency=0.15;
	yaxis grid ranges=(-100 - 50) label="Share of Fish Stocks (Percent)";
	xaxis display=(nolabel);
	inset "Overexploited share" / position=top textattrs=(size=15pt color="CXBC3343");
	inset "Sustainable share" / position=bottom textattrs=(size=15pt color=CX3A38D8);
run;

ods _all_ close;
ods html;
