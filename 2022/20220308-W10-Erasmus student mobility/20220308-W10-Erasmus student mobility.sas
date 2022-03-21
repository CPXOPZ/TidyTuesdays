/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220308-W10-Erasmus student mobility;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="erasmus.csv" out=erasmus dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
/*proc freq data=erasmus(where=(academic_year= "2019-2020")) noprint;*/
/*	tables sending_country_code*academic_year/ out=send_2020;*/
/*run;*/

/*%macro count_freq(year=, type=,out=);*/
/*	proc freq data=erasmus(where=(academic_year= "&year")) noprint;*/
/*		tables &type*academic_year/ out=&out;*/
/*	run;*/
/*%mend;*/
/**/
/*%count_freq(year=2019-2020,type=sending_country_code,out=send_2020);*/
/*%count_freq(year=2019-2020,type=receiving_country_code,out=rec_2020);*/
/*%count_freq(year=2014-2015,type=sending_country_code,out=send_2014);*/
/*%count_freq(year=2014-2015,type=receiving_country_code,out=rec_2014);*/


%macro count_f(year=,out=);
	proc freq data=erasmus(where=(academic_year= "&year")) noprint;
		tables sending_country_code*academic_year/ out=data1(rename=(sending_country_code=country) drop=percent);
	run;

	proc freq data=erasmus(where=(academic_year= "&year")) noprint;
		tables receiving_country_code*academic_year/ out=data2(rename=(receiving_country_code=country) drop=percent);
	run;

	data &out;
		merge data1(in=a rename=(count=send)) data2(in=b rename=(count=receive));
		by country;
		if a and b;
	run;

	proc datasets lib=work nolist;
		delete data:;
	run;
%mend;

%count_f(year=2019-2020,out=year_2020)
%count_f(year=2014-2015,out=year_2014)

data plot_data;
	merge year_2014(in=a rename=(send=send_14 receive=receive_14))
		year_2020(in=b rename=(send=send_20 receive=receive_20));
	by country;
	if a and b;
	drop academic_year;

	total_14=send_14+receive_14;
	total_20=send_20+receive_20;
	total=total_20+total_14;
	diff=total_20-total_14;
	category=ifc(diff<0,"Decrease","Increae");
run;

proc sort data=plot_Data;
	by descending total;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=800 height=600;

title bold height=1.9 "Participation in The ERASMUS program has soared";
title2 "In 2020,most European countries sent and received vastly more ERASMUS participants compared to 2014";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	hbarparm category=country response=total_20/ barwidth=0.8 nozerobars fillattrs=(color=CXD1D4D9) legendlabel="Total in 2020";
	scatter y=country x=total_14/ markerattrs=(size=8 symbol=circlefilled color=CX4D4D4D) legendlabel="Total in 2014";
	highlow y=country high=total_20 low=total_14/ type=bar barwidth=0.45 highcap=BARBEDARROW fillattrs=(color=CX7391A9)  legendlabel="Increase";
	highlow y=country high=total_14 low=total_20/ type=bar barwidth=0.45 lowcap=BARBEDARROW fillattrs=(color=CXEE2C2C) legendlabel="Descrease";
	yaxis display=(noline nolabel noticks);
	xaxis display=(nolabel) grid;
	keylegend/ location=inside position=bottomright across=1;
run;

ods _all_ close;
ods html;
