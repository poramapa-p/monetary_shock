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

label variable stoxx50e_rel "STOXX50E"
label variable sx7e_rel "SX7E"
label variable eur_rel "EUR"

label variable stoxx50e_con "STOXX50E"
label variable sx7e_con "SX7E"
label variable eur_con "EUR"

label variable ratefactor1 "Target"
label variable conffactor1 "Timing"
label variable conffactor2 "FG"
label variable conffactor3 "QE"

//##############################################################################
// Intraday Regressions
//##############################################################################

// ===========================================================================
// TABLE 4 -- Release OIS/DE full sample
// ===========================================================================
reg ois_de_re~1m ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~3m ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~6m ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1y ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~2y ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~5y ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~10y ratefactor1, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 4 -- Conference OIS/DE full sample
// ===========================================================================

reg ois_de_co~1m conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~3m conffactor* surprise_std,
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~6m conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1y conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~2y conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~5y conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~10y conffactor* surprise_std, rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf.tex, tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 5, 6 and 7 -- Release OIS/DE subsamples
// ===========================================================================

reg ois_de_re~1m ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1m ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1m ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~3m ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~3m ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~3m ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~6m ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~6m ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~6m ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1y ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1y ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~1y ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~2y ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~2y ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~2y ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~5y ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~5y ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~5y ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~10y ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~10y ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub2.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_re~10y ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_rel_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


// ===========================================================================
// TABLE 5, 6 and 7 -- Conference OIS/DE subsample
// ===========================================================================

reg ois_de_co~1m conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1m conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1m conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~3m conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~3m conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~3m conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~6m conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~6m conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~6m conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1y conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1y conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~1y conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~2y conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~2y conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~2y conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~5y conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~5y conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~5y conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~10y conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub1.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~10y conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub2.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg ois_de_co~10y conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_ois_de_hf_conf_sub3.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


// ===========================================================================
// TABLE 8 -- Release IT bonds subsamples
// ===========================================================================

reg it2y_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex, tex(frag) nonot label nocons dec(2) sdec(2)   cttop(,"Jan-02/Dec-07")

reg it10_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex, tex(frag) nonot label nocons dec(2) sdec(2)


reg it2y_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)  cttop(,"Jan-08/Dec-13")

reg it10_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


reg it2y_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg it10_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 8 -- Conference IT bonds subsamples
// ===========================================================================

reg it2y_conf conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_conf conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex, tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg it10_conf conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


reg it2y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg it10_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


reg it2y_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg it5y_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg it10_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_itasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 9 -- Release ES bonds subsamples
// ===========================================================================

reg es2y_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex, replace tex(frag) nonot label nocons dec(2) sdec(2) noni

reg es5y_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex, tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg es10_rel ratefactor1 if date<="2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg es2y_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg es5y_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg es10_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg es2y_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg es5y_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg es10_rel ratefactor1 if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_rel_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 9 -- Conference ES bonds subsamples
// ===========================================================================

reg es2y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg es5y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-02/Dec-07")

reg es10_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)


reg es2y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg es5y_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-08/Dec-13")

reg es10_conf conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg es2y_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg es5y_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2) cttop(,"Jan-14/Sep-18")

reg es10_conf conffactor* surprise_std if date>="2014-01-01", rob
outreg2 using code/scode/output_table/reg_sov_hf_conf_esasub.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

// ---------------------------------------------------------------------------
// TABLE 10 -- Release Exchange Rates full sample and subsamples
// ---------------------------------------------------------------------------

reg eur_rel ratefactor1, rob
outreg2 ratefactor1 using code/scode/output_table/reg_exch_rel.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg eur_rel ratefactor1 if date<="2007-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_exch_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg eur_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_exch_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

reg eur_rel ratefactor1 if date>="2014-01-01", rob
outreg2 ratefactor1 using code/scode/output_table/reg_exch_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

// ---------------------------------------------------------------------------
//  TABLE 10 -- Conference Exchange Rates full sample and subsamples
// ---------------------------------------------------------------------------

reg eur_con conffactor* surprise_std, rob
outreg2 conffactor* using code/scode/output_table/reg_exch_con.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg eur_con conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_exch_con.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg eur_con conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_exch_con.tex,   tex(frag) label nocons dec(2) sdec(2)

reg eur_con conffactor* surprise_std if date>="2014-01-01", rob
outreg2 conffactor* using code/scode/output_table/reg_exch_con.tex,   tex(frag) label nocons dec(2) sdec(2)


// ---------------------------------------------------------------------------
// TABLE 11 -- Release STOXX50E full and subsamples
// ---------------------------------------------------------------------------

reg stoxx50e_rel ratefactor1, rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_rel ratefactor1 if date<="2007-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_rel ratefactor1 if date>="2014-01-01", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

// ===========================================================================
// TABLE 11 -- Release SX7E full and subsamples
// ===========================================================================

reg sx7e_rel ratefactor1, rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_rel ratefactor1 if date<="2007-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_rel ratefactor1 if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_rel ratefactor1 if date>="2014-01-01", rob
outreg2 ratefactor1 using code/scode/output_table/reg_stock_rel.tex,   tex(frag) nonot label nocons dec(2) sdec(2)


// ---------------------------------------------------------------------------
// TABLE 11 -- Conference STOXX50E full and subsamples
// ---------------------------------------------------------------------------

reg stoxx50e_con conffactor* surprise_std, rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex, replace tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_con conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_con conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

reg stoxx50e_con conffactor* surprise_std if date>="2014-01-01", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,   tex(frag) nonot label nocons dec(2) sdec(2)


// ---------------------------------------------------------------------------
// TABLE 11 -- Conference SX7E full and subsamples
// ---------------------------------------------------------------------------

reg sx7e_con conffactor* surprise_std, rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex, tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_con conffactor1 conffactor2 surprise_std if date<="2007-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,  tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_con conffactor1 conffactor2 surprise_std if date>"2007-12-31" & date<="2013-12-31", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,   tex(frag) nonot label nocons dec(2) sdec(2)

reg sx7e_con conffactor* surprise_std if date>="2014-01-01", rob
outreg2 conffactor* using code/scode/output_table/reg_stock_con.tex,   tex(frag) nonot label nocons dec(2) sdec(2)
