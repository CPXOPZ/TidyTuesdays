/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220510-W19-NYTimes best sellers;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="nyt_titles.csv" out=titles dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */
data plot_data;
	set titles;
	where best_rank between 1 and 15 or debut_rank between 1 and 15;
	if best_rank>=1 and best_rank<=15 then best_rank_p=best_rank;
	if debut_rank>=1 and debut_rank<=15 then debut_rank_p=debut_rank;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */
proc template;
	define statgraph butter;
		begingraph;
			entrytitle "How many weeks is gonna stay there?" / textattrs=(size=16);
			entryfootnote halign=left "#TidyTuesday | @CPXOPZ" / textattrs=(style=italic);

			layout lattice / columns=2 columnweights=(0.485 0.515) rowdatarange=union;

				layout overlay / walldisplay=none xaxisopts=(reverse=true display=(ticks tickvalues)) yaxisopts=(display=none);
					entry halign=left "Best Rank"/ valign=top textattrs=(size=12);
					boxplot x=best_rank_p y=total_weeks /orient=horizontal;
				endlayout;

				layout overlay / walldisplay=none yaxisopts=(display=(tickvalues) tickvaluehalign=center offsetmax=0.08) xaxisopts=(display=(ticks tickvalues));
					entry halign=right "Debute Rank"/ valign=top textattrs=(size=12);
					boxplot x=debut_rank_p y=total_weeks /orient=horizontal;
				endlayout;

			endlayout;

		endgraph;
	end;
run;

ods html close;
ods listing dpi=300 style=ocean;
ods graphics /reset outputfmt=png imagename="&name" noborder width=600 height=450;

proc sgrender data=plot_data template=butter;
run;

ods _all_ close;
ods html;

/*title bold height=1.9 "";*/
/*footnote j=r italic "#TidyTuesday | @CPXOPZ";*/
