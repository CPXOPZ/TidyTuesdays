/* -------------------------------------------------------------------
   data imput macro
   ------------------------------------------------------------------- */
%macro multi_import(directory=, type=);
/*  
Sample:
type=csv
*/
	filename DIRLIST pipe "dir *.&type /b ";

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

/* -------------------------------------------------------------------
   setting & data import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20211214-W51-Spice Girls\;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));

x "cd &dir";

%multi_import(directory=D:\@M\TidyTuesdays\2021\20211214-W51-Spice Girls\, type=csv)

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc freq data=lyrics order=freq;
	table lyrics_album_name*lyrics_section_artist/ out=freq;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods _all_ close;

ods listing dpi=300;
ods graphics / reset=index imagename="&name" outputfmt=png noborder;
proc sgplot data=freq;
	title "Which Spice Girl sang the most lines solo?";
	footnote "#TidyTuesday | @CPXOPZ";
	label COUNT="Count";
	where lyrics_section_artist in ("Baby" ,"Scary","Sporty" ,"Ginger" ,"Posh");
	refline 25 / label="25" labelpos=min transparency=0.2;
/*	vbar lyrics_section_artist / response=COUNT stat=sum group=lyrics_album_name  categoryorder=respdesc outline  datalabel ;*/
	vbar lyrics_section_artist / response=COUNT stat=sum group=lyrics_album_name groupdisplay=cluster
		categoryorder=respdesc  datalabel  FILLATTRs=GraphData datalabelpos=bottom;
	keylegend / title="Album" location=inside position=topright across=1;
	xaxis label="Spice Girl";
	yaxis label="Solo Lines" grid offsetmax=0.05;
run;

title;
footnote;

ods _all_ close;
