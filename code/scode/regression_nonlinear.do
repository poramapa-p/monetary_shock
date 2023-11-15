set more off

*- DON'T CHANGE. This is used by makefile to set the path programmatically.
*- If you want to run this file as a stand alone, cd to the directory containing
*-  the do file BELOW.
**--> cd BASEDIRECTORY

//##############################################################################
// Import dataset
//##############################################################################

import delimited data/dailydataset.csv, clear

recode surprise_std (.=0)
label variable surprise_std "IJC"

label variable it2y_rel "IT 2Y"
label variable it5y_rel "IT 5Y"
label variable it10_rel "IT 10Y"

label variable es2y_rel  "ES 2Y"
label variable es5y_rel  "ES 5Y"
label variable es10_rel  "ES 10Y"

label variable it2y_con "IT 2Y"
label variable it5y_con "IT 5Y"
label variable it10_con "IT 10Y"

label variable es2y_con  "ES 2Y"
label variable es5y_con  "ES 5Y"
label variable es10_con  "ES 10Y"

label variable ois_de_re~1m "OIS 1M"
label variable ois_de_re~3m "OIS 3M"
label variable ois_de_re~6m "OIS 6M"
label variable ois_de_re~1y "OIS 1Y"
label variable ois_de_re~2y "OIS 2Y"
label variable ois_de_re~5y "OIS 5Y"
label variable ois_de_re~10y "OIS 10Y"

label variable ois_de_co~1m "OIS 1M"
label variable ois_de_co~3m "OIS 3M"
label variable ois_de_co~6m "OIS 6M"
label variable ois_de_co~1y "OIS 1Y"
label variable ois_de_co~2y "OIS 2Y"
label variable ois_de_co~5y "OIS 5Y"
label variable ois_de_co~10y "OIS 10Y"

label variable ratefactor1 "Target"
label variable conffactor1 "Timing"
label variable conffactor2 "FG"
label variable conffactor3 "QE"

gen neg_ratefactor1 = ratefactor1 < 0
gen neg_conffactor1 = conffactor1 < 0
gen neg_conffactor2 = conffactor2 < 0
gen neg_conffactor3 = conffactor3 < 0
gen interaction_ratefactor1 =  c.ratefactor1#i1.neg_ratefactor1
gen interaction_conffactor1 =  c.conffactor1#i1.neg_conffactor1
gen interaction_conffactor2 =  c.conffactor2#i1.neg_conffactor2
gen interaction_conffactor3 =  c.conffactor3#i1.neg_conffactor3

label variable neg_ratefactor1 "Target<0"
label variable neg_conffactor1 "Timing<0"
label variable neg_conffactor2 "FG<0"
label variable neg_conffactor3 "QE<0"
label variable interaction_ratefactor1 "Targetx(Target<0)"
label variable interaction_conffactor1 "Timingx(Timing<0)"
label variable interaction_conffactor2 "FGx(FG<0)"
label variable interaction_conffactor3 "QEx(QE<0)"

//##############################################################################
// Intraday Regressions
//##############################################################################

// ===========================================================================
// TABLE 12 -- Release OIS/DE full sample
// ===========================================================================

reg ois_de_re~1m ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~3m ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~6m ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~1y ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~2y ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~5y ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_re~10y ratefactor1  interaction_ratefactor1  neg_ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)


// ===========================================================================
//  TABLE 12 -- Conference OIS/DE full sample
// ===========================================================================

reg ois_de_co~1m conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~3m conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~6m conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~1y conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~2y conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~5y conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg ois_de_co~10y conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_nl.tex, tex(frag) nonot nocons label dec(2) sdec(2)


// ===========================================================================
// TABLE 13 -- Release IT bonds subsamples
// ===========================================================================

reg it2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg it5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex, tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg it10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex, tex(frag) nonot nocons label dec(2) sdec(2)

reg it2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex, tex(frag) nonot nocons label dec(2) sdec(2) 

reg it5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg it10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) 

reg it2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)

reg it5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg it10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)


// ===========================================================================
// TABLE 13 -- Conference IT bonds subsamples
// ===========================================================================

reg it2y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2 neg_conffactor1 neg_conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg it5y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex, tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg it10_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)


reg it2y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2 neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) 

reg it5y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg it10_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) 


reg it2y_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)

reg it5y_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg it10_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_itasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)


// ===========================================================================
// TABLE 14 -- Release ES bonds subsamples
// ===========================================================================

reg es2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg es5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex, tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg es10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex, tex(frag) nonot nocons label dec(2) sdec(2)


reg es2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex, tex(frag) nonot nocons label dec(2) sdec(2) 

reg es5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg es10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) 


reg es2y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)

reg es5y_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg es10_rel ratefactor1  interaction_ratefactor1  neg_ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)

// ===========================================================================
// TABLE 14 -- Conference ES bonds subsamples
// ===========================================================================

reg es2y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2 neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex, replace tex(frag) nonot nocons label dec(2) sdec(2)

reg es5y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg es10_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)


reg es2y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2 neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) 

reg es5y_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg es10_conf conffactor1 conffactor2  interaction_conffactor1 interaction_conffactor2  neg_conffactor1 neg_conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)


reg es2y_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)

reg es5y_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)  cttop(,"Jan-14/Sep-18")

reg es10_conf conffactor*  interaction_conffactor1 interaction_conffactor2 interaction_conffactor3 neg_conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_nl_esasub.tex,  tex(frag) nonot nocons label dec(2) sdec(2)
