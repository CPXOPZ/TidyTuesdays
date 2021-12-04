
%let dir=%str(D:\@M\TidyTuesdays\2021\20211130-W49-World Cup Cricket);
%let name=20211130-W49-World Cup Cricket;

libname raw "&dir";
/*libname xptfile xport "&dir\xptfile.xpt";*/

proc import datafile="D:\@M\TidyTuesdays\2021\20211130-W49-World Cup Cricket\matches.csv" 
			out=raw.matches dbms=csv replace;
	getnames=yes;
run;

proc freq data=raw.matches order=freq;
	table ground_country /out=out;
run;

proc sgplot data=out noborder;
	title "Cricket World Cup Playing Countries";
	hbar ground_country/response=count;
	yaxis discreteorder=data;
run;
title;

ods listing gpath="&dir" dpi=300;

ods graphics on/imagename="&name" outputfmt=png;
proc sgplot data=out noborder;
	title "Cricket World Cup Playing Countries";
	hbar ground_country/response=count;
	yaxis discreteorder=data label="Ground Country";
run;
title;
ods listing close;

*****************************************************************************************;

ods graphics on/imagename="&name" outputfmt=EPS;
proc sgplot data=out;
	title "";
	hbar ground_country/response=count;
run;
title;

ods graphics on/imagename="&name" outputfmt=TIF;
proc sgplot data=out noborder;
	title "";
	hbar ground_country/response=count;
run;
title;

**************************************;

ods printer printer=Postscript FILE="C:\Users\CUI\Desktop\myeps2.eps" dpi=300;

proc sgplot data=out;
	title "";
	hbar ground_country/response=count;
run;
title;
ods printer close;

ods printer printer=tiff FILE="C:\Users\CUI\Desktop\mytiff2.tiff" dpi=300;

proc sgplot data=out;
	title "";
	hbar ground_country/response=count;
run;
title;
ods printer close;

*****************************************************************************************;
/**/

proc datasets lib=work ;
	modify out;
		rename ground_country=country;
run;

/*count with data */
proc sort data=raw.matches out=test;
	by ground_country;
run;

data test2;
	set test;
	by ground_country;
	retain count;
	if first.ground_country then 
		do;
			count=0;
		end;
	count+1;
	if last.ground_country;
	keep ground_country count;
	rename ground_country=country;
run;

/*xpt file create*/

proc copy in=raw out=xptfile memtype=data;
/*	select matches;*/
run;
