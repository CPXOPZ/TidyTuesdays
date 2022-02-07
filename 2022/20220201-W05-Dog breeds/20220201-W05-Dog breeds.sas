/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220201-W05-Dog breeds;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="breed_rank.csv" out=breed_rank dbms=csv replace;
run;
proc import datafile="breed_traits.csv" out=breed_traits dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data year_filter;
	do year=2013 to 2020;
		fil="<10";
		filter="_"||strip(year)||"_Rank"||fil;
		output;
	end;
run;
proc sql noprint;
	select filter into: filter separated by " and "
	from year_filter;
run;
%put &filter;


proc sort data=breed_rank(where=(&filter));
	by breed;
run;
proc transpose data=breed_rank(drop=links image) out=rank_long(rename=(col1=rank)) name=year_c;
	by breed;
	var _numeric_;
run;

data plot_data;
	set rank_long;
	where rank^=.;
	years=compress(year_c, ,"dk")+0;
	drop year_c;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

title j=l bold height=1.6 "Breed popularity rankings 2013-2020";
title2 j=l color=DAPGR  "The Labrador Retriever has consistently remained the most popular breed";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend;
/*	pbspline  x=years y=rank / nomarkers group=breed lineattrs=(pattern=solid thickness=5) transparency=0.4;*/
	series  x=years y=rank / group=breed lineattrs=(pattern=solid thickness=5) transparency=0.4
				curvelable curvelabelpos=max smoothconnect;
	scatter x=years y=rank / group=breed markerattrs=(size=17 symbol=circlefilled)
		datalabel=rank datalabelpos=center datalabelattrs=(color=gray weight=bold size=9);
	yaxis reverse display=none;
	xaxis display=(noline noticks nolabel) values=(2013 to 2020);
run;

ods _all_ close;
ods html;
