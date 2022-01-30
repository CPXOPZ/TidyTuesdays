/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220125-W04-Board games;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="details.csv" out=details dbms=csv replace;
run;
proc import datafile="ratings.csv" out=ratings dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc means data=ratings(where=(year >= 2000 & year <= 2021)) mean maxdec=2;
	var average bayes_average;
	output out=avg_rating mean(average bayes_average)=avg AVG_Bayes;
run;

proc means data=ratings(where=(year >= 2000 & year <= 2021)) mean maxdec=2;
	class year;
	var average bayes_average;
	output out=plot_data(rename=(_FREQ_=count) where=(_type_=1)) n=num mean(average bayes_average)=avg avg_bayes;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder height=600px width=450px;

title j=l bold height=1.4 "Are board games getting better in the new millennium?";
title2 j=l color=DAPGR  "The mean yearly rating of the considered board gamesis higher than the overall average since 2016";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend;
	format avg best4.2;
	hbarbasic year / response=avg baseline=6.53 barwidth=0.1 transparency=0.3 fillattrs=(color=black)
		baselineattrs=(pattern=dash color=red thickness=2);
	scatter x=avg y=year / markerattrs=(size=20 color=black symbol=circlefilled) transparency=0.1
		datalabel=avg datalabelpos=center datalabelattrs=(color=white weight=bold);
/*	text x=7 y=2004 text="Overall average rating = 6.53";*/
	inset "Overall average rating = 6.53      " / position=right textattrs=(weight=bold color=DER);
	yaxis reverse display=(noline noticks nolabel);
	xaxis  display=none;
run;

ods _all_ close;
ods html;
