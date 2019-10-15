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
.projpackages <- c('GGally','tableone','pander','dplyr');
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
.oldopt00 <- panderOptions();
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[,-1],row.names=dct0$column,split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00$table.continues);

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
#' A list of numeric variables that ought to be treated as discrete
ordvars <- v(c_ordinal);

#' Convert the above to `ordered` variables
#+ ordvars
for(ii in ordvars) dat00[[ii]] <- ordered(dat00[[ii]]);

#+ devsample
set.seed(project_seed);
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];
#' 
#' ### Scatterplot matrix)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot, message=FALSE, warning=FALSE
ggpairs(dat01[,mainvars],mapping=aes_string(colour=stratvars,alpha=0.4)
        ,size=0.25);

#' ### Cohort Characterization
#' 
#' To explore possible covariates
set.alignment(default='right',row.names='right');
pander(print(CreateTableOne(vars = setdiff(mainvars,stratvars)
                            , strata = stratvars, data=dat01, includeNA=TRUE)
             , printToggle=FALSE),split.tables=Inf
       ,caption='Cohort Characterization');

#' ### Data Analysis
#' 
#' Fitting the actual statistical models.
#+ univar_prep, echo=TRUE, message=TRUE
# univariate analysis ----
univar <- list(); 
for(yy in outcomevars){
  univar[[yy]] <- sapply(predictorvars,function(xx){
    lm(paste(yy,'~',xx),data=dat01) %>% glance
    },simplify=F) %>% bind_rows(.id='predictor') %>% 
    arrange(AIC)};

.oldopt01 <- panderOptions();
# Make pander print things from inside the for loop
panderOptions('knitr.auto.asis', FALSE);
# Don't split the tables
panderOptions('table.split.table', Inf);
#+ univar_tables, results='asis'
for(ii in names(univar)){
  pander(univar[[ii]],caption=paste('Univariate predictors of',ii))};
#+ cleanup, echo = FALSE
panderOptions('knitr.auto.asis',.oldopt01$knitr.auto.asis);
panderOptions('table.split.table',.oldopt01$table.split.table);

#+ univar_plots, warning=FALSE
ggduo(dat01,aes(alpha=0.1),columnsX = predictorvars,columnsY = outcomevars);

#+ wrapup, echo=FALSE,warning=FALSE,message=FALSE
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
