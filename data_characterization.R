#' ---
#' title: "Fertility survey"
#' author: "Jennifer Knudtson"
#' date: "09/08/2019"
#' ---
#' 
#+ message=F,echo=F
# init -----
if(interactive()){
  try(source('https://raw.githubusercontent.com/bokov/UT-Template/master/git_setup.R'));
};

# set to > 0 for verbose initialization
debug <- 0;

# vector of additional packages to install, if needed. If none needed, should be
# an empty string
packages <- c( 'GGally','tableone','pander' );

# name of this script
.currentscript <- "data_characterization.R"; 

# vector of other scripts which need to run before this one. If none needed, 
# should be an empty string
.deps <- c( 'dictionary.R' ); 

# load stuff ----
# load project-wide settings, including your personalized config.R
if(debug>0) source('./scripts/global.R',chdir=T) else {
  .junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F))};
# load any additional packages needed by just this script
if(length(packages) > 1 || !identical(packages,'')) instrequire(packages);
# start logging
tself(scriptname=.currentscript);

# Use the workdir
.workdir <- getwd();
# run scripts on which this one depends, if any that have not been cached yet
.loadedobjects <- load_deps(.deps,cachedir = .workdir);

# which files are here before anything new is created by this script
.origfiles <- ls(all=T);

#+ echo=F
#############################################################
# Your code goes below, content provided only as an example #
#############################################################

#' ### Data Dictionary
#' 
#' Quality control, descriptive statistics, etc.

#next three lines are temporary fix
load("36902-0001-Data.rda")
dat00 <- da36902.0001;
if(pn %in% names(dat00)) dat00[[pn]] <- as.character(dat00[[pn]]);
dct0 <- tblinfo(dat00);

#+ echo=F
# characterization ----
map0 <- autoread('varmap.csv')
dct0$column <- make.unique(unlist(submulti(dct0$column,map0,method = 'startsends')))
names(dat00) <- dct0$column
set.seed(project_seed)

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
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];


message('\nDid variable rename and set seed\n\n')

set.caption('Data Dictionary');
set.alignment(row.names='right')
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table

pander(dct0[1:200,-1],row.names=dct0$column[1:200],split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables (step 8)
#' 
#' Predictors
# Uncomment the below line after putting in the actual predictor column names
# from your dat00
predictorvars <- c('SCR2','SCR3');
#' Outcomes
# Uncomment the below line after putting in the actual outcome column names
# from your dat00
outcomevars <- c('Q1A','Q1C');
#' All analysis-ready variables
#Uncomment the below line after predictorvars and outcomevars already exist
mainvars <- c(outcomevars, predictorvars);
#' ### Scatterplot matrix (step 10)
#' 
#' To explore pairwise relationships between all variables of interest.
#ggpairs_plot
# Uncomment the below after mainvars already exists and you have chosen a 
# discrete variable to take the place of VAR1 (note that you don't quote that
# one)

ggpairs(dat01[,mainvars]);

#' ### Cohort Characterization (step 10)
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
# Uncomment the below code after mainvars exists and you have chosen a discrete
# variable to take the place of VAR1 (this time you do quote it)
#
pander(print(CreateTableOne(vars = mainvars, data=dat01, includeNA=TRUE), printToggle=FALSE), 
                            caption='Cohort Characterization');

#' ### Data Analysis
#' 
#' Fitting the actual statistical models.
#+ echo=F
# analysis ----

#+ echo=F
#############################################################
# End of your code, start of boilerplate code               #
#############################################################

# save out with audit trail ----
# Saving original file-list so we don't keep exporting functions and 
# environment variables to other scripts. Could also replace .origfiles
# with the expression c(.origfiles,.loadedobjects) and then, nothing
# get inherited from previous files, only the stuff created in this 
# script gets saved. If this doesn't make sense, don't worry about it.
message('About to tsave');
tsave(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles)
      ,verbose=F);
message('Done tsaving');

#' ### Audit Trail
#+ echo=F
.wt <- walktrail();
#pander(.wt[order(.wt$sequence),-5],split.tables=Inf,justify='left',missing=''
#       ,row.names=F);
#+ echo=F,eval=F


