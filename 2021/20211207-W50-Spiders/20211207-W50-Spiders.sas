
%let dir=%str(D:\@M\TidyTuesdays\2021\20211207-W50-Spiders);
%let name=%sysfunc(translate("20211207-W50-Spiders","_","-"));

libname raw "&dir";

proc import datafile="&dir/spides.csv" out=raw.spides dbms=csv replace;
run;

data temp;
	set raw.spides(where=(distribution contains "China"));
/*	where distribution contain "China";*/
	
run;

proc sql outobs=10;
	create table freq_plot as
	select family, count(*) as count
	from temp
	group by family
	order by calculated count desc;
quit;

proc sort data=temp;
	by year;
run;

proc freq data=temp;
	table year / out=num_plot outcum outexpect;
run;

****************************************;

ods listing gpath="&dir" dpi=300;
ods graphics on / reset imagename=&name outputfmt=png;

proc sgplot data=freq_plot noborder;
	title "Top 10 most prevalent families in China";
	footnote "#TidyTuesday | @CPXOPZ";
	hbar family/response=count datalabel=count;
	yaxis discreteorder=data display=(nolabel);
	xaxis grid label="Count";
run;
title;
footnote;

ods listing close;

*************************************;

ods listing gpath="&dir" dpi=300;
ods graphics on / reset imagename=&name outputfmt=png;

proc sgplot data=num_plot noborder;
	title "Number of species discovered in China (1793-2021)";
	footnote "#TidyTuesday | @CPXOPZ";
	series x=year y=CUM_FREQ ;
run;
title;
footnote;

ods listing close;
