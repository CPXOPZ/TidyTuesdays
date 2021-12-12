%macro multi_import(directory=, type=);
/*  
Sample:
directory=C:\Users\CUI\Desktop\
type=csv
*/
	filename DIRLIST pipe "dir &directory*.&type /b ";

	data dirlist ;
		infile dirlist lrecl=200 truncover;
		input file_name $100.;
	run;

	data _null_;
	   set dirlist end=end;
	   count+1;
	   call symputx('read'||put(count,4.-l),cats("&directory",file_name));
	   call symputx('dset'||put(count,4.-l),scan(file_name,1,'.'));
	   if end then call symputx('max',count);
	run;

   %do i=1 %to &max;
		proc import datafile="&&read&i" out=&&dset&i dbms=&type replace;
		run;
   %end;

%mend;

%let dir=D:\@M\TidyTuesdays\2021\20211123-W48-DrWho\;
/*%let name=%sysfunc(translate("20211207-W50-Spiders","_","-"));*/
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"_","-"));

%multi_import(directory=D:\@M\TidyTuesdays\2021\20211123-W48-DrWho\, type=csv)

/*libname raw "&dir";*/

data plot_data;
	set imdbs;
	episode+1;
	by season;
	if first.season then Season_num=season;
run;

ods listing gpath="&dir" dpi=300;
ods graphics on / reset imagename="&name" outputfmt=png;

proc sgplot data=plot_data;
	title "Doctor Who TV Series";
	title2 "IMDb rating trending lower after poor episode ratings in Seasons 11 and 12";
	footnote "#TidyTuesday | @CPXOPZ";
	scatter x=episode y=rating /  TRANSPARENCY=0.3 markerattrs=(symbol=circlefilled);
	reg x=episode y=rating / nomarkers  clm degree=2 TRANSPARENCY=0.8 clmTRANSPARENCY=0.5;
	yaxis grid label="IMDb Ratings";
	xaxis grid label="Episodes over time";
	keylegend / location=inside position=bottomleft across=1; 
run;

title;
title2;
footnote;


ods listing close;
