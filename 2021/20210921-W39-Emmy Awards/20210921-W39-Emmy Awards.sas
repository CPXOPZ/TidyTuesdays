/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210921-W39-Emmy Awards;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="nominees.csv" out=nominees dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data df;
	set nominees;
	if distributor in ("HBO", "HBO Max") then distributor="HBO/HBO Max";
	keep category year type title distributor producer page_id;
run;

proc sort data=df nodupkey;
	by _all_;
run;

proc freq data=df(where=(type="Winner")) order=freq noprint;
	table distributor / out=winner;
run;
data winner;
	set winner(obs=20);
run;

proc sort data=df;
	by distributor;
run;
proc sort data=winner;
	by distributor;
run;
data data;
	merge df winner(keep=distributor in=b);
	by distributor;
	if b;
run;

data plot_data;
	set data;
	by distributor;
	retain maxyear win nom minyear;
	if first.distributor then 
		do;
			maxyear=0;
			nom=0;
			win=0;
			minyear=9999;
		end;
	nom=nom+1;
	if type="Winner" then win=win+1;
	minyear=min(minyear, year);
	maxyear=max(maxyear, year);
	if last.distributor then output;
	keep distributor minyear maxyear win nom;
run;

data plot_data;
	set plot_data;
	ratio=win/nom;
	format ratio 4.2;
	years=strip(minyear)||"-"||strip(maxyear);
run;

proc sort data=plot_data;
	by descending win;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300 style=excel;
ods graphics on / reset outputfmt=png imagename="&name" noborder;

title height=1.6 j=l bold "Top 20 Show Distributors, by Emmy Awards Winners";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder;
	hbarbasic distributor / response=nom barwidth=0.8 legendlabel="Nominees"
		fillattrs=(color=CX3d5a80) outlineattrs=(color=CX3d5a80);	
	hbarbasic distributor / response=win barwidth=0.4 legendlabel="Winners"
			fillattrs=(color=CXf8961e) outlineattrs=(color=CXf8961e);	
	text x=nom y=distributor text=ratio / position=right legendlabel="Winner to nominees ratio";
	yaxistable years/ position=left location=inside nolabel;
	yaxis display=(nolabel noline noticks);
	xaxis display=(nolabel noline noticks);
	keylegend /across=1 location=inside position=bottomright noborder;
run;

ods _all_ close;
ods html;
