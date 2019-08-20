#' ---
#' title: "Dynamic Data Characterization"
#' author: "Alex F. Bokov"
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
.packages <- c( 'GGally' );

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
if(length(.packages) > 1 || .packages != '') instrequire(.packages);
# start logging
tself(scriptname=.currentscript);

# Use the workdir ----
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

#+ echo=F
# characterization ----
set.caption('Data Dictionary');
set.alignment(row.names='right')
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[,-1],row.names=dct0$column,split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables (step 8)
#' 
#' Predictors
# Uncomment the below line after putting in the actual predictor column names
# from your dat00
predictorvars <- c('age','sex','status');
#' Outcomes
# Uncomment the below line after putting in the actual outcome column names
# from your dat00
outcomevars <- c('bili','albumin','alk.phos','stage','protime','platelet');
#' All analysis-ready variables
# Uncomment the below line after predictorvars and outcomevars already exist
mainvars <- c(outcomevars, predictorvars);
#' ### Scatterplot matrix (step 10)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot,message=F,warning=F
# Uncomment the below after mainvars already exists and you have chosen a 
# discrete variable to take the place of VAR1 (note that you don't quote that
# one)

# ggpairs() plots a grid of scatterplots, one for each pair of variables. 
ggpairs(dat00[,mainvars]
        # The 'mapping' argument sets global values for size and transparency 
        # (alpha) of the dots in this plot
        ,mapping=aes(size=I(0.5),alpha=I(0.1))
        # the 'upper' argument tells the function what to do just in the upper 
        # right half of the grid for various combinations of of variables that 
        # it might encounter-- continuous/discrete/combo/na
        # ...there are similarly structured 'lower' and 'diag' arguments but
        # we are leaving those at their default values for now.
        ,upper = list(continuous = wrap("cor",size=3,alpha=1)
                      ,discrete = "facetbar"
                      # i.e. one variable is continuous, the other discrete
                      ,combo = "box_no_facet"
                      # i.e. what to do when a cell is simply missing.
                      ,na = "na"));

# This one is like 'ggpairs()' but plots one set of variables against another,
# so more focused on the comparisons of interest and less redundancy
ggduo(dat00,predictorvars,outcomevars,mapping=aes(alpha=I(0.1),size=I(0.5)));

# We may return to this one after talking about statistical models
# ggnostic(step(lm(formula(paste(predictorvars[1],'~.')),data=dat00[,mainvars])
#               ,trace=F)
#          ,columnsY = c('.resid','.hat','.sigma','.cooksd','.fitted'
#                        ,'.se.fit','.std.resid')
#          ,mapping=aes(alpha=0.1));
# For more examples, see https://ggobi.github.io/ggally/
#' ### Cohort Characterization
#' 
#' To explore possible covariates
# Uncomment the below code after mainvars exists and you have chosen a discrete
# variable to take the place of VAR1 (this time you do quote it)
#
#pander(print(CreateTableOne(
#  vars = setdiff(mainvars,'VAR1'),strata='VAR1',data = dat00
#  , includeNA = T), printToggle=F), caption='Group Characterization');

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
pander(.wt[order(.wt$sequence),-5],split.tables=Inf,justify='left',missing=''
       ,row.names=F);
#+ echo=F,eval=F
c()
