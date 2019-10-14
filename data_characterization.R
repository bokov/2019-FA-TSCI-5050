#' ---
#' title: "Dynamic Data Characterization"
#' author: "Alex F. Bokov"
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

#+ characterization, echo=FALSE, message=FALSE
# characterization ----

set.caption('Data Dictionary');
set.alignment(row.names='right');
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[,-1],row.names=dct0$column,split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables
#'
#' Predictors
set.seed(project_seed);
predictorvars <- sample(setdiff(dct0$column,'id'),5);
#' Outcomes
outcomevars <- sample(setdiff(dct0$column,c(predictorvars,'id')),3);
#' All analysis-ready variables
mainvars <- c(outcomevars, predictorvars);
#' Stratifying variable
stratvars <- 'status';
#' A list of numeric variabls that ought to be treated as discrete
ordvars <- dct0[dct0$c_ordinal,'column'];

#' Convert the above to `ordered` variables
for(ii in ordvars) dat00[[ii]] <- ordered(dat00[[ii]]);

set.seed(project_seed);
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];
#' 
#' ### Scatterplot matrix)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot, message=FALSE, warning=FALSE
ggpairs(dat01[,mainvars],mapping=aes(color=stratvars));

#' ### Cohort Characterization
#' 
#' To explore possible covariates
pander(print(CreateTableOne(vars = mainvars, strata = stratvars, data=dat01, includeNA=TRUE), printToggle=FALSE), 
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
#+ echo=FALSE
.wt <- walktrail();
c()
