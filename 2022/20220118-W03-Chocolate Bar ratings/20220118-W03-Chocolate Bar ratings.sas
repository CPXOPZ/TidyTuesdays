/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220118-W03-Chocolate Bar ratings;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="chocolate.csv" out=chocolate dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc sql;
	create table top_country(where=(country_of_bean_origin^="Blend" and count>=50)) as
		select country_of_bean_origin, count(country_of_bean_origin) as count
		from chocolate
		group by country_of_bean_origin
		order by calculated count desc;
quit;

proc freq data=chocolate noprint;
	table country_of_bean_origin*rating / out=rating_f;
run;

proc sql;
	create table grades as 
		select *
		from rating_f
		where country_of_bean_origin in (select country_of_bean_origin from top_country);

	create table plot_data as 
		select *, sum(count) as total, count/calculated total*100 as percent
		from grades(drop=percent)
		group by country_of_bean_origin;
quit;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250 style=word;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title bold height=1.4 "Percent of ratings in each grade(1 to 4), for each country of bean origin";
footnote j=r "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	scatter x=rating y=country_of_bean_origin / markerattrs=(symbol=SquareFilled size=15)
		colorresponse=percent colormodel=(CXFEF5D9 CX8B4614);
	xaxis label="Grades" display=(noline noticks);
	yaxis  display=(noline noticks nolabel);
	gradlegend / title="Percent of ratings per country" position=bottom noborder outerpad=(left=100px right=100px);
	yaxistable total / label="Total ratings (N)" location=inside labelpos=bottom valuejustify=center;
run;

ods _all_ close;
ods html;
