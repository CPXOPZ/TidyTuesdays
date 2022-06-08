/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=%str(D:\@M\TidyTuesdays\2022\20220525-W21-Women%'s Rugby);
%let name=%qsysfunc(translate(%qscan(&dir,-1,"\"),"__","- "));
x "cd &dir";

proc import datafile="fifteens.csv" out=fifteens dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data plot_data;
	set fifteens;
	where team_1 ="China" or team_2 = "China";
	if  not(winner ="China") then margin_of_victory=margin_of_victory*(-1);
	win=margin_of_victory>1;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=250 style=highcontrast;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=600 height=450;

title bold height=1.9 "THE WOMEN'S CHINA RUGBY TEAM";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend;
	series x=date y=margin_of_victory / lineattrs=(color=CXF3F1F0) transparency=0.7;
	styleattrs datacontrastcolors=(CXF3F1F0 red) backcolor=CX2e1600 wallcolor=CX2e1600 ;
	refline 0 / axis=y lineattrs=(pattern=dash);
	scatter  x=date y=margin_of_victory / group=win markerattrs=(size=8 symbol=circlefilled) transparency=0.2;
	xaxis display=(nolabel noline noticks );
	yaxis label="SCORE MARGIN" display=(noline noticks );
run;

ods _all_ close;
ods html;
