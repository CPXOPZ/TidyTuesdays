/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220315-W11-CRANBIOC Vignettes;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="bioc.csv" out=bioc dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data data;
	set bioc;
	year=year(datepart(date));
run;

proc sort data=data;
	by package year;
run;
data data2;
	set data;
	by package year;
	if first.package;
run;

proc freq data=data2 noprint;
	tables year/out=data3(where=(year>1970));
run;

data plot_Data;
	set data3 end=last;
	yearc=put(year,5.);
	retain total;
	total+count;
	begin=lag(total);
	if  _n_=1 then begin=0;
	if last then
	do;
		yearc="Total";
		begin=0;
		count=total;
	end;
run;


/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=600 height=400;

footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_Data noborder;
	highlow x=yearc low=begin high=total/ type=bar highlabel=count;
	yaxis display=(nolabel noline noticks) grid;
	xaxis display=(nolabel noline noticks) grid valuesrotate=vertical;
	inset   " " "  Number of packages" "    released by year"/ position=topleft textattrs=(size=20 weight=bold);
run;

ods _all_ close;
ods html;
