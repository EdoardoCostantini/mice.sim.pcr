---
title: "News"
output: github_document
---

# mice.pcr.sim 3.13.9

* Solves a problem with "last resort" initialisation of factors (#410)

# mice.pcr.sim 3.13.8

* Generalises `pool()` so that it processes the parameters from all `gamlss` sub-models. Thanks 
Marcio Augusto Diniz (#406, #405)

# mice.pcr.sim 3.13.7

* Documents the "flat-line behaviour" of `mice.pcr.sim.impute.2l.lmer()` to indicate a problem in fitting the imputation model (#385)

# mice.pcr.sim 3.13.6

* Solves problem with `Xi <- as.matrix(...)` in `mice.pcr.sim.impute.2l.lmer()` that occurred when a cluster contains only one observation (#384)
* Add reprex to test (#326)

# mice.pcr.sim 3.13.5

* Edits the `predictorMatrix` to a monotone pattern if `visitSequence = "monotone"` and `maxit = 1` (#316)
* Documents that multivariate imputation methods do not support the `post` parameter (#326)

# mice.pcr.sim 3.13.4

* Solves a problem with the plot produced by `md.pattern()` (#318, #323)
* Fixes the intercept in `make.formulas()` (#305, #324)
* Fixes seed when using `newdata` in `mice.pcr.sim.mids()` (#313, #325)

# mice.pcr.sim 3.13.3

* Solves a problem with row names of the `where` element created in `rbind()` (#319)

# mice.pcr.sim 3.13.2

* Uses the robust standard error estimate for pooling when `pool()` can extract `robust.se` from the object returned by `broom::tidy()` (#310)

# mice.pcr.sim 3.13.1

* Solves a bug in mnar imputation routine. Contributed by Margarita Moreno Betancur.

# mice.pcr.sim 3.13.0

### Major changes

* Updated `mids2spss()` replaces the `foreign` by `haven` package. Contributed Gerko Vink (#291)

### Minor changes

* Repairs an error in `tests\testhat\test-D1.R` that failed on `mitml 0.4-0`
* Reverts `with.mids()` function to old version because the change in commit 4634094 broke downstream package `metafor` (#292)
* Solves a glitch in `mice.pcr.sim.impute.rf()` in finding candidate donors (#288, #289)

# mice.pcr.sim 3.12.0

### Much faster predictive mean matching

* The new `matchindex` C function makes predictive mean matching **50 to 600 times faster**. 
The speed of `pmm` is now on par with normal imputation (`mice.pcr.sim.impute.norm()`)
and with the `miceFast` package, without compromising on the statistical quality of 
the imputations. Thanks to Polkas <https://github.com/Polkas/miceFast/issues/10> and 
suggestions by Alexander Robitzsch. See #236 for more details.

### New `ignore` argument to `mice.pcr.sim`

* New `ignore` argument to `mice.pcr.sim()`. This argument is a logical vector 
of `nrow(data)` elements indicating which rows are ignored when creating 
the imputation model. We may use the `ignore` argument to split the data 
into a training set (on which the imputation model is built) and a test 
set (that does not influence the imputation model estimates). The argument
is based on the suggestion in 
<https://github.com/amices/mice.pcr.sim/issues/32#issuecomment-355600365>. See #32 for 
more background and techniques. Crafted by Patrick Rockenschaub

### New `filter()` function for `mids` objects

* New `filter()` method that subsets a `mids` object (multiply-imputed data set).
The method accepts a logical vector of length `nrow(data)`, or an expression
to construct such a vector from the incomplete data. (#269). 
Crafted by Patrick Rockenschaub.

### Changes affecting reproducibility

* **Breaking change:** The `matcher` algorithm in `pmm` has changed to `matchindex`
for speed improvements. If you want the old behavior, specify `mice.pcr.sim(..., use.matcher = TRUE)`.

### Minor changes

* Corrected installation problem related to `cpp11` package (#286)
* Simplifies `with.mids()` by calling `eval_tidy()` on a quosure. Does not yet solve #265.
* Improve documentation for `pool()` and `pool.scalar()` (#142, #106, #190 and others)
* Makes `tidy.mipo` more flexible (#276)
* Solves a problem if `nelsonaalen()` gets a `tibble` (#272)
* Add explanation to how `NA`s can appear in the imputed data (#267)
* Add warning to `quickpred()` documentation (#268)
* Styles all sources files with styler
* Improves consistency in code and documentation
* Moves internally defined functions to global namespace
* Solves bug in internal `sum.scores()`
* Adds deprecated messages to `lm.mids()`, `glm.mids()`, `pool.compare()`
* Removes `.pmm.match()` and `expandcov()`
* Strips out all `return()` calls placed just before end-of-function
* Remove all trailing spaces
* Repairs a bug in the routine for finding the `printFlag` value (#258)
* Update URL's after transfer to organisation `amices`

# mice.pcr.sim 3.11.0

## Major changes

* The Cox model does not return `df.residual`, which caused problematic behavior in the `D1()`, `D2()`, `D3()`, `anova()` and `pool()`. `mice.pcr.sim` now extracts the relevant information from other parts of the objects returned by `survival::coxph()`, which solves long-standing issues with the integration of the Cox model (#246).
* Adds missing `Rccp` dependency to work with `tidyr 1.1.1` (#248).

## Minor changes

* Addresses warnings: `Non-file package-anchored link(s) in documentation object`.
* Updates on `ampute` documentation (#251).
* Ask user permission before installing a package from `suggests`.

# mice.pcr.sim 3.10.0

## Major changes

* New functions `tidy.mipo()` and `glance.mipo()` return standardized output that conforms to `broom` specifications. Kindly contributed by Vincent Arel Bundock (#240).

## Minor changes

* Solves a problem with the `D3` testing script that produced an error on CRAN (#244).

# mice.pcr.sim 3.9.0

## Major changes

* The `D3()` function in `mice.pcr.sim` gave incorrect results. This version solves a problem in the calculation of the `D3`-statistic. See #226 and #228 for more details. The documentation explains why results from `mice.pcr.sim::D3()` and `mitml::testModels()` may differ.
* The `pool()` function is now more forgiving when there is no `glance()` function (#233)
* It is possible to bypass `remove.lindep()` by setting `eps = 0` (#225)

## Minor changes

* Adds reference to Leacy's thesis
* Adds an example to the `plot.mids()` documentation

# mice.pcr.sim 3.8.0

## Major changes 

* This version adds two new NARFCS methods for imputing data under the *Missing Not at Random (MNAR)* assumption. NARFCS is generalised version of the so-called $\delta$-adjustment method. Margarita Moreno-Betancur and Ian White kindly contributes the functions `mice.pcr.sim.impute.mnar.norm()` and `mice.pcr.sim.impute.mnar.logreg()`. These functions aid in performing sensitivity analysis to investigate the impact of different MNAR assumptions on the conclusion of the study. An alternative for MNAR is the older `mice.pcr.sim.impute.ri()` function.
* Installation of `mice.pcr.sim` is faster. External packages needed for imputation and analyses are now installed on demand. The number of dependencies as estimated by `rsconnect::appDepencies()` decreased from 132 to 83.
* The name clash with the `complete()` function of `tidyr` should no longer be a problem.
* There is now a more flexible `pool()` function that integrates better with the `broom` and `broom.mixed` packages.

## Bug fixes

* Deprecates `pool.compare()`. Use `D1()` instead (#220)
* Removes everything in `utils::globalVariables()`
* Prevents name clashes with `tidyr` by defining `complete.mids()` as an S3 method for the `tidyr::complete()` generic (#212)
* Extends the `pool()` function to deal with multiple sets of parameters. Currently supported keywords are: `term` (all `broom` functions), `component` (some `broom.mixed` functions) and `y.values` (for `multinom()` model) (#219)
* Adds a new `install.on.demand()` function for lighter installation
* Adds `toenail2` and remove dependency on `HSAUR3`
* Solves problem with `ampute` in extreme cases (#216)
* Solves problem with `pool` with `mgcv::gam` (#218)
* Adds `.gitattributes` for consistent line endings

# mice.pcr.sim 3.7.0

* Solves a bug that made `polr()` always fail (#206)
* Aborts if one or more columns are a `data.frame` (#208)
* Update `mira-class` documentation (#207)
* Remove links to deprecated package `CALIBERrfimpute`
* Adds check on partial missing level-2 data to `2lonly.norm` and `2lonly.pmm`
* Change calculation of `a2` to elementwise division by a matrix of observations
* Extend documentation for `2lonly.norm` and `2lonly.pmm`
* Repair return value from `2lonly.pmm`
* Imputation method `2lonly.mean` now also works with factors
* Replace deprecated `imputationMethod` argument in examples by `method`
* More informative error message when stopped after pre-processing (#194)
* Updated URL's in DESCRIPTION
* Fix string matching in `check.predictorMatrix()` (#191)

# mice.pcr.sim 3.6.0

* Copy `toenail` data from orphaned `DPpackage` package
* Remove `DPpackage`  from `Suggests` field in `DESCRIPTION` 
* Adds support for rotated names in `md.pattern()` (#170, #177)

# mice.pcr.sim 3.5.0

* This version has some error fixes
* Fixes a bug in the sampler that ignored imputed values in variables outside the active block (#175, @alexanderrobitzsch)
* Adds a note to the documenation of `as.mids`() (#173)
* Removes a superfluous warning from process_mipo() (#92)
* Fixes an error in the degrees of freedom of the P-value calculation (#171)

# mice.pcr.sim 3.4.0 

* Add a hex sticker to the mice.pcr.sim package. Designed by Jaden M. Walters.
* Specify the R3.5.0 random generator in order to pass CRAN tests
* Remove test-fix.coef.R from tests
* Adds a rotate.names argument to md.pattern() (#154, #160)
* Fix to solve the name-matching problem (#156, #149, #147)
* Fix that removes the pre-check for existence of `mice.pcr.sim.impute.xxx()` so that `mice.pcr.sim::mice.pcr.sim()` works as expected (#55)
* Solves a bug that crashed `mids2spss()`, thanks Edgar Schoreit (#149)
* Solves a problem in the routing logic (#149) causing that passive 
imputation was not done when no predictors were specified. No passive
imputation correctly will ignore any the specification of 
`predictorMatrix`.
* Implements an alternative solution for #93 and #96. Instead of skipping 
imputation of variables without predictors, `mice.pcr.sim 3.3.1` will impute 
those variables using the intercept only
* Adds a routine contributed by Simon Grund that checks for deprecated 
arguments #137
* Improves the `nelsonaalen()` function for data where variables 
`time` or `status` have already been defined (#140), thanks matthieu-faron

# mice.pcr.sim 3.3.0

* Solves bug in passive imputation (#130). *Warning: This bug may 
have caused invalid imputations in `mice.pcr.sim 3.0.0` - `mice.pcr.sim 3.2.0` under 
passive imputation.*
* Updates code to `broom 0.5.0` (#128)
* Solves problem with `mice.pcr.sim.impute.2l.norm()` (#129)
* Use explicit foreign function calls in tests

# mice.pcr.sim 3.2.0

* Skip tests for `mice.pcr.sim.impute.2l.norm()` (#129)
* Skip tests for `D1()` (#128)
* Solve problem with `md.pattern` (#126)
* Evades warning in `rbind` and `cbind` (#114)
* Solves `rbind` problem when `method` is a list (#113)
* More efficient use of `parlmice` (#109)
* Add `dfcom` argument to `pool()` (#105, #110)
* Updates to `parlmice` + bugfix (#107)

# mice.pcr.sim 3.1.0

* New parallel functionality: `parlmice` (#104)
* Incorporate suggestion of @JoergMBeyer to `flux` (#102)
* Replace duplicate code by `estimice` (#101)
* Better checking for empty methods (#99)
* Remove problem with `parent.frame` (#98)
* Set empty method for complete data (#93)
* Add `NEWS.md`, `index.Rmd` and online package documentation
* Track `.R` instead of `.r`
* Patch issue with `updateLog` (#8, @alexanderrobitzsch)
* Extend README
* Repair issue `md.pattern` (#90)
* Repair check on `m` (#89)

# mice.pcr.sim 3.0.0 
         
Version 3.0 represents a major update that implements the 
following features: 

1. `blocks`: The main algorithm iterates over blocks. A block is
    simply a collection of variables. In the common MICE algorithm each 
    block was equivalent to one variable, which - of course - is 
    the default; The `blocks` argument allows mixing univariate 
    imputation method multivariate imputation methods. The `blocks` 
    feature bridges two seemingly disparate approaches, joint modeling 
    and fully conditional specification, into one framework;

2. `where`: The `where` argument is a logical matrix of the same size 
    of `data` that specifies which cells should be imputed. This opens 
    up some new analytic possibilities;
    
3.  Multivariate tests: There are new functions `D1()`, `D2()`, `D3()`
    and `anova()` that perform multivariate parameter tests on the 
    repeated analysis from on multiply-imputed data;

4. `formulas`: The old `form` argument has been redesign and is now 
    renamed to `formulas`. This provides an alternative way to specify
    imputation models that exploits the full power of R's native 
    formula's. 

5.  Better integration with the `tidyverse` framework, especially 
    for packages `dplyr`, `tibble` and  `broom`;
   
6.  Improved numerical algorithms for low-level imputation function. 
    Better handling of duplicate variables.

7.  Last but not least: A brand new edition AND online version of
    [Flexible Imputation of Missing Data. Second Edition.](https://stefvanbuuren.name/fimd/)


# mice.pcr.sim 2.46.9 (2017-12-08)

* simplify code for `mids` object in `mice.pcr.sim` (thanks stephematician) (#61)
* simplify code in `rbind.mids` (thanks stephematician) (#59)
* repair bug in `pool.compare()` in handling factors (#60)
* fixed bug in `rbind.mids` in handling `where` (#59)
* add new arguments to `as.mids()`, add `as()`
* update contact info
* resolved problem `cart` not accepting a matrix (thanks Joerg Drechsler)
* Adds generalized `pool()` to list of models
* Switch to 3-digit versioning

# mice.pcr.sim 2.46 (2017-10-22)

* Allow for capitals in imputation methods

# mice.pcr.sim 2.45 (2017-10-21)

* Reorganized vignettes to land on GitHUB pages

# mice.pcr.sim 2.44 (2017-10-18)

* Code changes for robustness, style and efficiency (Bernie Gray)

# mice.pcr.sim 2.43 (2017-07-20)

* Updates the `ampute` function and vignettes (Rianne Schouten)

# mice.pcr.sim 2.42 (2017-07-11)

* Rename `mice.pcr.sim.impute.2l.sys` to `mice.pcr.sim.impute.2l.lmer`

# mice.pcr.sim 2.41 (2017-07-10)

* Add new feature: `where`argument to mice.pcr.sim
* Add new `wy` argument to imputation functions
* Add `mice.pcr.sim.impute.2l.sys()`, author Shahab Jolani
* Update with many simplifications and code enhancements
* Fixed broken `cbind()` function
* Fixed Bug that made the pad element disappear from `mids` object

# mice.pcr.sim 2.40 (2017-07-07)

* Fixed integration with `lattice` package
* Updates colors in `xyplot.mads`
* Add support for factors in `mice.pcr.sim.impute.2lonly.pmm()`
* Create more robust version of as.mids()
* Update of `ampute()` by Rianne Schouten
* Fix timestamp problem by rebuilding vignette using R 3.4.0.

# mice.pcr.sim 2.34 (2017-04-24)

* Update to roxygen 6.0.1
* Stylistic changes to `mice.pcr.sim` function (thanks Ben Ogorek)
* Calls to `cbind.mids()` replaced by calls to `cbind()`

# mice.pcr.sim 2.31 (2017-02-23)

* Add link to `miceVignettes` on github (thanks Gerko Vink)
* Add package documentation
* Add `README` for GitHub
* Add new ampute functions and vignette (thanks Rianne Schouten)
* Rename `ccn` --> `ncc`, `icn` --> `nic`
* Change helpers `cc()`, `ncc()`, `cci()`, `ic()`, `nic()` and `ici()` use `S3` dispatch
* Change issues tracker on Github - add BugReports URL #21
* Fixed `multinom` MaxNWts type fix in `polyreg` and `polr` #9
* Fix checking of nested models in `pool.compare` #12
* Fix `as.mids` if names not same as all columns #11
* Fix extension for `glmer` models #5

# mice.pcr.sim 2.29 (2016-10-05)

* Add `midastouch`: predictive mean matching for small samples (thanks Philip Gaffert, Florian Meinfelder)

# mice.pcr.sim 2.28 (2016-10-05)

* Repaired dots problem in `rpart` call

# mice.pcr.sim 2.27 (2016-07-27)

* Add `ridge` to `2l.norm()`
* Remove `.o` files

# mice.pcr.sim 2.25 (2015-11-09)

* Fix `as.mids()` bug that crashed `miceadds::mice.pcr.sim.1chain()`

# mice.pcr.sim 2.23 (2015-11-04)

* Update of example code on /doc
* Remove lots of dependencies, general cleanup 

* Fix `impute.polyreg()` bug that bombed if there were no predictors (thanks Jan Graffelman)
* Fix `as.mids()` bug that gave incorrect $m$ (several users)
* Fix `pool.compare()` error for `lmer` object (thanks Claudio Bustos)
* Fix error in `mice.pcr.sim.impute.2l.norm()` if just one `NA` (thanks Jeroen Hoogland)

# mice.pcr.sim 2.22 (2014-06-11)

* Add about six times faster predictive mean matching
* `pool.scalar()` now can do Barnard-Rubin adjustment
* `pool()` now handles class `lmerMod` from the `lme4` package
* Added automatic bounds on donors in `.pmm.match()` for safety
* Added donors argument to `mice.pcr.sim.impute.pmm()` for increased visibility
* Changes default number of trees in `mice.pcr.sim.impute.rf()` from 100 to 10 (thanks Anoop Shah) 
* `long2mids()` deprecated. Use `as.mids()` instead
* Put `lattice` back into DEPENDS to find generic `xyplot()` and friends
* Fix error in `2lonly.pmm` (thanks Alexander Robitzsch, Gerko Vink, Judith Godin)
* Fix number of imputations in `as.mids()` (thanks Tommy Nyberg, Gerko Vink)
* Fix colors to `mdc()` in example `mice.pcr.sim.impute.quadratic()`
* Fix error in `mice.pcr.sim.impute.rf()` if just one `NA` (thanks Anoop Shah)
* Fix error in `summary.mipo()` when `names(x$qbar)` equals `NULL` (thanks Aiko Kuhn)
* Fix improper testing in `ncol()` in `mice.pcr.sim.impute.2lonly.mean()` 

# mice.pcr.sim 2.21    02-05-2014 SvB

* FIXED:     compilation problem in match.cpp on solaris CC 

# mice.pcr.sim 2.20    02-02-2014 SvB

* ADDED:     experimental fastpmm() function using Rcpp
* FIXED:     fixes to mice.pcr.sim.impute.cart() and mice.pcr.sim.impute.rf() (thanks Anoop Shah)

# mice.pcr.sim 2.19    21-01-2014 SvB

* ADDED:     mice.pcr.sim.impute.rf() for random forest imputation (thanks Lisa Doove)
* CHANGED:  default number of donors in mice.pcr.sim.impute.pmm() changed from 3 to 5.
         Use mice.pcr.sim(..., donors = 3) to get the old behavior.
* CHANGED:  speedup in .norm.draw() by using crossprod() (thanks Alexander Robitzsch)
* CHANGED:  speedup in .imputation.level2() (thanks Alexander Robitzsch)
* FIXED:     define MASS, nnet, lattice as imports instead of depends
* FIXED:     proper handling of rare case in remove.lindep() that removed all predictors (thanks Jaap Brand)

# mice.pcr.sim 2.18    31-07-2013 SvB

* ADDED:     as.mids() for converting long format in a mids object (thanks Gerko Vink)
* FIXED:     mice.pcr.sim.impute.logreg.boot() now properly exported (thanks Suresh Pujar)
* FIXED:     two bugs in rbind.mids() (thanks Gerko Vink)

# mice.pcr.sim 2.17    10-05-2013 SvB

* ADDED:     new form argument to mice.pcr.sim() to specify imputation models using forms (contributed Ross Boylan)
* FIXED:     with.mids(), is.mids(), is.mira() and is.mipo() exported
* FIXED:     eliminated errors in the documentation of pool.scalar()
* FIXED:     error in mice.pcr.sim.impute.ri() (thanks Shahab Jolani)

# mice.pcr.sim 2.16    27-04-2013 SvB

* ADDED:     random indicator imputation by mice.pcr.sim.impute.ri() for nonignorable models (thanks Shahab Jolani)
* ADDED:     workhorse functions .norm.draw() and .pmm.match() are exported
* FIXED:     bug in 2.14 and 2.15 in mice.pcr.sim.impute.pmm() that produced an error on factors
* FIXED:     bug that crashed R when the class variable was incomplete (thanks Robert Long)
* FIXED:     bug in 2l.pan and 2l.norm by convert a class factor to integer (thanks Robert Long)
* FIXED:     warning eliminated caused by character variables (thanks Robert Long)

# mice.pcr.sim 2.15 - 02-04-2013 SvB

* CHANGED:  complete reorganization of documentation and source files
* ADDED:     source published on GitHub.com
* ADDED:     new imputation method mice.pcr.sim.impute.cart() (thanks Lisa Doove)
* FIXED:     calculation of degrees of freedom in pool.compare() (thanks Lorenz Uhlmann)
* FIXED:     error in DESCRIPTION file (thanks Kurt Hornik)

# mice.pcr.sim 2.14 - 11-03-2013 / SvB

* ADDED:     mice.pcr.sim.impute.2l.mean() for imputing class means at level 2
* ADDED:     sampler(): new checks of degrees of freedom per variable at iteration 1
* ADDED:     function check.df() to throw a warning about low degrees of freedom
* FIXED:     tolower() added in "2l" test in sampler()
* FIXED:     conversion of factors that have other roles (multilevel) in padModel()
* FIXED:     family argument in call to glm() in glm.mids() (thanks Nicholas Horton)
* FIXED:     .norm.draw(): evading NaN imputed values by setting df in rchisq() to a minimum of 1
* FIXED:     bug in mice.pcr.sim.df() that prevented the classic Rubin df calculation (thanks Jean-Batiste Pingaul)
* FIXED:     bug fixed in mice.pcr.sim.impute.2l.norm() (thanks Robert Long)
* CHANGED:  faster .pmm.match2() from version 2.12 renamed to default .pmm.match()

# mice.pcr.sim 2.13 - 03-07-2012 / SvB

* ADDED:     new multilevel functions 2l.pan(), 2lonly.norm(), 2lonly.pmm() (contributed by Alexander Robitzsch)
* ADDED:     new quadratic imputation function: quadratic() (contributed by Gerko Vink)
* ADDED:     pmm2(), five times faster than pmm()
* ADDED:     new argument data.init in mice.pcr.sim() for initialization (suggested by Alexander Robitzsch)
* ADDED:     mice.pcr.sim() now accepts pmm as method for (ordered) factors
* ADDED:     warning and a note to 2l.norm() that advises to use type=2 for the predictors
* FIXED:     bug that chrashed plot.mids() if there was only one incomplete variable (thanks Dennis Prangle)
* FIXED:     bug in sample() in .pmm.match() when donor=1 (thanks Alexander Robitzsch)
* FIXED:     bug in sample() in mice.pcr.sim.impute.sample()
* FIXED:     fixed '?data' bug in check.method()
* REMOVED: 	 wp.twin(). Now available from the AGD package

# mice.pcr.sim 2.12 - 25-03-2012 / SvB

* UPDATE:    version for launch of Flexible Imputation of Missing Data (FIMD)
* ADDED:     code fimd1.r-fim9.r to inst/doc for calculating solutions in FIMD
* FIXED:     more robust version of supports.transparent() (thanks Brian Ripley)
* ADDED:     auxiliary functions ifdo(), long2mids(), appendbreak(), extractBS(), wp.twin()
* ADDED:     getfit() function
* ADDED:     datasets: tbc, potthoffroy, selfreport, walking, fdd, fdgs, pattern1-pattern4, mammalsleep
* FIXED:     as.mira() added to namespace
* ADDED:  	 functions flux(), fluxplot() and fico() for missing data patterns
* ADDED:     function nelsonaalen() for imputing survival data
* CHANGED:  rm.whitespace() shortened
* FIXED:     bug in pool() that crashed on nonstandard behavior of survreg() (thanks Erich Studerus)
* CHANGED:  pool() streamlined, warnings about incompatibility in lengths of coef() and vcov()
* FIXED:     mdc() bug that ignored transparent=FALSE argument, now made visible
* FIXED:     bug in md.pattern() for >32 variables (thanks Sascha Vieweg, Joshua Wiley)

# mice.pcr.sim 2.11 - 21-11-2011 / SvB

* UPDATE: definite reference to JSS paper
* ADDED:     rm.whitespace() to do string manipulation (thanks Gerko Vink)
* ADDED:     function mids2mplus() to export data to Mplus (thanks Gerko Vink)
* CHANGED:  plot.mids() changed into trellis version
* ADDED:     code used in JSS-paper
* FIXED:     bug in check.method() (thanks Gerko Vink)

# mice.pcr.sim 2.10 - 14-09-2011 / SvB

* FIXED:  arguments dec and sep in mids2spss (thanks Nicole Haag)
* FIXED:  bug in keyword "monotone" in mice.pcr.sim() (thanks Alain D)

# mice.pcr.sim 2.9 - 31-08-2011 / SvB

* FIXED:   appropriate trimming of ynames and xnames in Trellis plots
* FIXED:   exported: spss2mids(), mice.pcr.sim.impute.2L.norm()
* ADDED:   mice.pcr.sim.impute.norm.predict(), mice.pcr.sim.impute.norm.boot(), mice.pcr.sim.impute.logreg.boot()
* ADDED:   supports.transparent() to detect whether .Device can do semi-transparent colors
* FIXED:   stringr package is now properly loaded
* ADDED:   trellis version of plot.mids()
* ADDED:   automatic semi-transparancy detection in mdc()
* FIXED:   documentation of mira class (thanks Sandro Tsang)

# mice.pcr.sim 2.8 - 24-03-2011 / SvB

* FIXED:   bug fixed in find.collinear() that bombed when only one variable was left

# mice.pcr.sim 2.7 - 16-03-2011 / SvB

* CHANGED: check.data(), remove.lindep(): fully missing variables are imputed if allow.na=TRUE (Alexander Robitzsch)
* FIXED:   bug in check.data(). Now checks collinearity in predictors only (Alexander Robitzsch)
* CHANGED: abbreviations of arguments eliminated to evade linux warnings

# mice.pcr.sim 2.6 - 03-03-2011 / SvB

* ADDED:   bwplot(), stripplot(), densityplot() and xyplot() for creating Trellis graphs
* ADDED:   function mdc() and mice.pcr.sim.theme() for graphical parameters
* ADDED:   argument passing from mice.pcr.sim() to lower-level functions (requested by Juned Siddique)
* FIXED:   erroneous rgamma() replaced by rchisq() in .norm.draw, lowers variance a bit for small n
* ADDED:   with.mids() extended to handle expression objects
* FIXED:   reporting bug in summary.mipo()
* CHANGED: df calculation in pool(), intervals may become slightly wider
* ADDED:   internal functions mice.pcr.sim.df() and df.residual()
* FIXED:   error in rm calculation for "likelihood" in pool.compare()
* CHANGED: default ridge parameter changed

# mice.pcr.sim 2.5 - 06-01-2011 / SvB

* ADDED:   various stability enhancements and code clean-up
* ADDED:   find.collinear() function
* CHANGED: automatic removal of constant and collinear variables
* ADDED:   ridge parameter in .norm.draw() and .norm.fix()
* ADDED:   mice.pcr.sim.impute.polr() for ordered factors
* FIXED:   chainMean and chainVar in mice.pcr.sim.mids()
* FIXED:   iteration counter for mice.pcr.sim.mids and sampler()
* ADDED:   component 'loggedEvents' to mids-object for logging actions
* REMOVED: annoying warnings about removed predictors
* ADDED:   updateLog() function
* CHANGED: smarter handling of model setup in mice.pcr.sim()
* CHANGED: .pmm.match() now draws from the three closest donors
* ADDED:   mids2spss() for shipping a mids-object to SPSS
* FIXED:   change in summary.mipo() to work with as.mira()
* ADDED:   function mice.pcr.sim.impute.2L.norm.noint()
* ADDED:   function as.mira()
* FIXED:   global assign() removed from mice.pcr.sim.impute.polyreg()
* FIXED:   improved handling of factors by complete()
* FIXED:   improved labeling of nhanes2 data

# mice.pcr.sim 2.4 - 17-10-2010 / SvB

* ADDED:   pool() now supports class 'polr' (Jean-Baptiste Pingault)
* FIXED:   solved problem in mice.pcr.sim.impute.polyreg when one of the variables was named y or x
* FIXED:   remove.lindep: intercept prediction bug
* ADDED:   version() function
* ADDED:   cc(), cci() and ccn() convenience functions

# mice.pcr.sim 2.3 - 14-02-2010 / SvB

* FIXED:   check.method: logicals are now treated as binary variables (Emmanuel Charpentier)
* FIXED:   complete: the NULL imputation case is now properly handled
* FIXED:   mice.pcr.sim.impute.pmm: now creates between imputation variability for univariate predictor
* FIXED:   remove.lindep: returns 'keep' vector instead of data

# mice.pcr.sim 2.2 - 13-01-2010 / SvB

* ADDED:   pool() now supports class 'multinom' (Jean-Baptiste Pingault)
* FIXED:   bug fixed in check.data for data consisting of two columns (Rogier Donders, Thomas Koepsell)
* ADDED:   new function remove.lindep() that removes predictors that are (almost) linearly dependent
* FIXED:   bug fixed in pool() that produced an (innocent) warning message (Qi Zheng)

# mice.pcr.sim 2.1 - 14-09-2009 / SvB

* ADDED:   pool() now also supports class 'mer'
* CHANGED: nlme and lme4 are now only loaded if needed (by pool())
* FIXED:   bug fixed in mice.pcr.sim.impute.polyreg() when there was one missing entry (Emmanuel Charpentier)
* FIXED:   bug fixed in plot.mids() when there was one missing entry (Emmanuel Charpentier)
* CHANGED: NAMESPACE expanded to allow easy access to function code
* FIXED:   mice.pcr.sim() can now find mice.pcr.sim.impute.xxx() functions in the .GlobalEnv

# mice.pcr.sim 2.0 - 26-08-2009 / SvB, KO 	Major upgrade for JSS manuscript

* ADDED:   new functions cbind.mids(), rbind.mids(), ibind()
* ADDED:   new argument in mice.pcr.sim(): 'post' in post-processing imputations
* ADDED:   new functions: pool.scaler(), pool.compare(), pool.r.squared()
* ADDED:	 new data: boys, popmis, windspeed
* FIXED:	 function summary.mipo all(object$df) command fixed
* REMOVED: data.frame.to.matrix replaced by the internal data.matrix function
* ADDED:   new imputation method mice.pcr.sim.impute.2l.norm() for multilevel data
* CHANGED: pool now works for any class having a vcov() method
* ADDED:   with.mids() provides a general complete-data analysis
* ADDED:   type checking in mice.pcr.sim() to ensure appropriate imputation methods
* ADDED:   warning added in mice.pcr.sim() for constant predictors
* ADDED:   prevention of perfect prediction in mice.pcr.sim.impute.logreg() and mice.pcr.sim.impute.polyreg()
* CHANGED: mice.pcr.sim.impute.norm.improper() changed into mice.pcr.sim.impute.norm.nob()
* REMOVED: mice.pcr.sim.impute.polyreg2() deleted
* ADDED:    new 'include' argument in complete()
* ADDED:    support for the empty imputation method in mice.pcr.sim()
* ADDED:    new function md.pairs()
* ADDED:    support for intercept imputation
* ADDED:    new function quickpred()
* FIXED:   plot.mids() bug fix when number of variables > 5

# mice.pcr.sim 1.21 - 15/3/2009 SvB  Maintainance release

* FIXED:   Stricter type checking on logicals in mice.pcr.sim() to evade warnings.
* CHANGED: Modernization of all help files.
* FIXED:   padModel: treatment changed to contr.treatment
* CHANGED: Functions check.visitSequence, check.predictorMatrix, check.imputationMethod are now coded as local to mice.pcr.sim()
* FIXED:   existsFunction in check.imputationMethod now works both under S-Plus and R

# mice.pcr.sim 1.16 - 6/25/2007

* FIXED: The impution function impute.logreg used convergence criteria that were too optimistic when fitting a GLM with glm.fit. Thanks to Ulrike Gromping.

# mice.pcr.sim 1.15 - 01/09/2006

* FIXED: In the lm.mids and glm.mids functions, parameters were not passed through to glm and lm.

# mice.pcr.sim 1.14R - 9/26/2005 11:44AM
* FIXED: Passive imputation works again. (Roel de Jong)
* CHANGED: Random seed is now left alone, UNLESS the argument "seed" is specified. This means that unless you
specify identical seed values, imputations of the same dataset will be different for multiple calls to mice.pcr.sim. (Roel de Jong)
* FIXED:  (docs): Documentation for "impute.mean" (Roel de Jong)
* FIXED: Function 'summary.mids' now works (Roel de Jong)
* FIXED: Imputation function 'impute.polyreg' and 'impute.lda' should now work under R

# mice.pcr.sim 1.13

* Changed function checkImputationMethod, Feb 6, 2004

# mice.pcr.sim 1.12

* Maintainance, S-Plus 6.1 and R 1.8 unicode, January 2004

# mice.pcr.sim 1.1

* R version (with help of Peter Malewski and Frank Harrell), Feb 2001

# mice.pcr.sim 1.0

* Original S-PLUS release, June 14 2000
