/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2022\20220208-W06-Tuskegee Airmen;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import datafile="airmen.csv" out=breed_rank dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc freq data=breed_rank  order=freq noprint;
	table state / out=freq(where=(state^=""));
run;

data plot_data;
	set freq;
	where count>=20;
	nl=n+10;
run;
/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=280 style=daisy;
ods graphics  /reset outputfmt=png imagename="&name" noborder width=640 height=360;

footnote bold height=1.9 "S T A T E S      W I T H      M O S T      A I R M E N";
footnote2 height=0.2 " ";
footnote3 j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend;
	styleattrs backcolor=CXE9D7A5 wallcolor=CXE9D7A5;
	vbarparm category=state response=count / colorresponse=count datalabel datalabelattrs=(size=15 weight=bold)
		colormodel=(CX005F73 CXBB3F03);
	text x=state y=nl text=state / textattrs=(size=15 weight=bold color=black);
	yaxis display=none;	
	xaxis label=" " display=(noticks noline) reverse labelattrs=(size=0.2) valueattrs=(size=13);
run;

ods _all_ close;
ods html;
