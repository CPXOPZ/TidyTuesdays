
%let dir=%str(D:\@M\TidyTuesdays\2021\20211130-W49-World Cup Cricket);

libname raw "&dir";

proc import datafile="D:\@M\TidyTuesdays\2021\20211130-W49-World Cup Cricket\matches.csv" 
			out=raw.matches dbms=csv replace;
	getnames=yes;
run;

proc freq data=raw.matches order=freq;
	table ground_country /out=out;
run;

proc sgplot data=out;
	hbar ground_country/responce=count;
run;

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
