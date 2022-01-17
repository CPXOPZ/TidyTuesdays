/* -------------------------------------------------------------------
   directory & data import
   ------------------------------------------------------------------- */
%let dir=D:\@M\TidyTuesdays\2021\20210817-W34-Star Trek Voice Commands;
%let name=%sysfunc(translate(%sysfunc(scan(&dir,-1,"\")),"__","- "));
x "cd &dir";

/* -------------------------------------------------------------------
   data prepare
   ------------------------------------------------------------------- */

proc import datafile="computer.csv" out=computer dbms=csv replace;
run;

proc freq data=computer;
	tables char_type*domain / out=FreqOut(where=(Percent^=. ));
run;

data FreqOut;
	set FreqOut;
	label char_type="Person or Computer" domain="Domain of interaction";
run;

/* -------------------------------------------------------------------
   plot
   ------------------------------------------------------------------- */
/*How to add an annotation to a mosaic plot in SAS - The DO Loop
https://blogs.sas.com/content/iml/2019/07/08/add-annotation-mosaic-plot-sas.html*/

ods html close;
ods listing dpi=250;
ods graphics  /reset outputfmt=png imagename="&name" noborder;

proc template;
  define statgraph mosaicPlotParm;
  dynamic _VERTVAR _HORZVAR _FREQ _TITLE;
    begingraph;
      entrytitle _TITLE;
      entryfootnote  "#TidyTuesday | @CPXOPZ";
      layout region;          /* REGION layout, so can't overlay text! */
      MosaicPlotParm category=(_HORZVAR _VERTVAR) count=_FREQ / 
             datatransparency=0.5
             colorgroup=_VERTVAR name="mosaic";
      endlayout;
    endgraph;
  end;
run;
 
proc sgrender data=FreqOut template=mosaicPlotParm;
dynamic _VERTVAR="char_type" _HORZVAR="domain" _FREQ="Count"
        _TITLE="Domain of interaction by Computer and Person";
run;
 
ods _all_ close;
