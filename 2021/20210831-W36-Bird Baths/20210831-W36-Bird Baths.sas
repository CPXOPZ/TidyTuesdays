/* -------------------------------------------------------------------
   setting & import
   ------------------------------------------------------------------- */

%let dir=D:\@M\TidyTuesdays\2021\20210831-W36-Bird Baths;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

proc import file="bird_baths.csv" out=bird dbms=csv replace;
run;

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

data birds;
	set bird;
	where bird_count = 1 and survey_year^=.;
run;

proc freq data=birds order=freq noprint;
	table bird_type / out=freq;
run;


data plot_data;
	set freq(obs=10);
	percent_l=strip(put(percent, 3.1))||"%  ";
	if _n_=1 then percent_lb=percent_l||"OF ALL BIRD SIGHTINGS   ";
		else percent_lb=percent_l;
run;

proc sql outobs=10;	
	create table sql_data as
	select bird_type, count(bird_type) as count, 
		calculated count/sum(calculated count) as percent
	from birds
	group by bird_type
	order by calculated count desc;
quit;

data map;
	retain id "bird_type";
	length value $18  fillcolor $8  linecolor $8;
	input  fillcolor linecolor value $ &;
datalines;
CXFBACBE CXFBACBE Noisy Miner 
CXA18276 CXA18276 Australian Magpie 
CXB9D2B1 CXB9D2B1 Rainbow Lorikeet 
CXB3B3B3 CXB3B3B3 Red Wattlebird
CXB3B3B3 CXB3B3B3 Superb Fairy-wren
CXB3B3B3 CXB3B3B3 Magpie-lark
CXB3B3B3 CXB3B3B3 Pied Currawong 
CXB3B3B3 CXB3B3B3 Crimson Rosella
CXB3B3B3 CXB3B3B3 Eastern Spinebill
CXB3B3B3 CXB3B3B3 Spotted Dove
;
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */

ods html close;
ods listing dpi=300;
ods graphics on / reset outputfmt=png imagename="&name" noborder;

title height=1.5 bold "NOISY MINERS ARE THE BULLIES OF THE BIRD BATHS";
title2 height=1.3 color=DABGR "THE TOTAL NUMBER OF SIGHTINGS OF THE TOP 10 DOMINATING BIRDS FOUND ABIRD BATHS ACROSS AUSTRAILIA";
footnote j=r italic "#TidyTuesday | @CPXOPZ";

proc sgplot data=plot_data noborder noautolegend dattrmap=map;
	hbarbasic bird_type / response=count nozerobars attrid=bird_type group=bird_type;
	text y=bird_type x=count text=percent_lb / position=left;
	xaxis grid label="NUMBER OF SIGHTINGS" display=(noline noticks);
	yaxis grid label="BIRD TYPE" display=(noline noticks);
run;

ods _all_ close;
ods html;
