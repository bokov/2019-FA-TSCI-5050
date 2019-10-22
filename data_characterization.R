#' ---
#' title: "Fertility survey"
#' author: "Jennifer Knudtson"
#' date: "09/08/2019"
#' ---
#' 
#+ init, message=FALSE,echo=FALSE
# init -----
if(interactive()){
  try(source('https://raw.githubusercontent.com/bokov/UT-Template/master/git_setup.R'));
};

# set to > 0 for verbose initialization
.debug <- 0;
# additional packages to install, if needed. If none needed, should be: ''
.projpackages <- c('GGally','tableone','pander')
# name of this script
.currentscript <- "data_characterization.R"; 
# other scripts which need to run before this one. If none needed, shoule be: ''
.deps <- c( 'dictionary.R' ); 

# load stuff ----
# load project-wide settings, including your personalized config.R
if(.debug>0) source('./scripts/global.R',chdir=T) else {
  .junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F))};

#+ startcode, echo=F, message=FALSE
#===========================================================#
# Your code goes below, content provided only as an example #
#===========================================================#
#' ### Data Dictionary
#' 
#' Quality control, descriptive statistics, etc.

#+ characterization, echo=F, message=FALSE
# characterization ----

dat00 <- droplevels(dat00)
#' 
#' * Q: What does the command `nrow()` do?
#'     * A: return the number of rows or columns in (x) in a specified data set
#'          
#'          
#' * Q: What does the command `sample()` do? What are its first and second
#'      arguments for?
#'     * A: Sample takes a sample of the specificed size from the elements of x using either 
#'      or without replacement. (x, size, replace = FALSE, prob = NULL) 1st argument is x (data set) and    
#'      2nd argument is size.    
#' * Q: If `foo` were a data frame, what might the expression `foo[bar,baz]` do,
#'      what are the roles of `bar` and `baz` in that expression, and what would
#'      it mean if you left either of them out of the expression?
#'     * A: foo is the function and bar and baz are the arguments. If you left it out, it wouldn't be able to run.
#'          
#'          
#' 
set.seed(project_seed)
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];


set.caption('Data Dictionary');
set.alignment(row.names='right');
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[1:200,-1],row.names=dct0$column[1:200],split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables
#' 
#' Predictors
predictorvars <- c('SCR2','SCR3');
#' Outcomes
outcomevars <- c('Q1A','Q1C');
#' All analysis-ready variables
mainvars <- c(outcomevars, predictorvars);
#' ### Scatterplot matrix)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot, message=FALSE, warning=FALSE
ggpairs(dat01[,mainvars]);

#' ### Cohort Characterization
#' #' * Q: Which function 'owns' the argument `caption`? What value does that 
#'      argument pass to that function?
#'     * A: pander, it tells it what to incorporate
#'          
#'          
#' * Q: Which function 'owns' the argument `printToggle`? What value does that 
#'      argument pass to that function?
#'     * A: print, where to create the table
#'          
#'          
#' * Q: Which function 'owns' the argument `vars`? We can see that the value
#'      this argument passes comes from the variable `mainvars`... so what is
#'      the actual value that ends up getting passed to the function?
#'     * A: CreateTableOne, mainvars becomes vars
#'          
#'          
#' * Q: What is the _very first_ argument of `print()` in the expression below?
#'      (copy-paste only that argument into your answer without including 
#'      anything extra)
#'     * A: CreateTableOne
#'          
#' To explore possible covariates
pander(print(CreateTableOne(vars = mainvars, strata = 'SCR3', data=dat01, includeNA=TRUE), printToggle=FALSE), 
                            caption='Cohort Characterization');

#' ### Data Analysis
#' 
#' Fitting the actual statistical models.
#+ echo=FALSE, message=FALSE
# analysis ----

#+ echo=FALSE,warning=FALSE,message=FALSE
#===========================================================#
##### End of your code, start of boilerplate code ###########
#===========================================================#
knitr::opts_chunk$set(echo = FALSE,warning = FALSE,message=FALSE);

# save out with audit trail 
message('About to tsave');
tsave(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles)
      ,verbose=FALSE);
message('Done tsaving');

#' ### Audit Trail
.wt <- walktrail();
c()
