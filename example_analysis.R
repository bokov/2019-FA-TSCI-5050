#' ---
#' title: "Example Analysis"
#' ---
#' 
.projpackages <- c()
.deps <- c( 'dictionary.R' ); 
#+ load_deps, echo=FALSE, messages=FALSE, warnings=FALSE
.junk<-capture.output(source('./scripts/global.R',chdir=TRUE,echo=FALSE));
.currentscript <- current_scriptname('example_analysis.R');

#' ### Choosing predictor and response variables
#' 
#' Replace `binary_outcome` and `numeric_outcome` below with vectors 
#' containing one or more column names you actually want to serve as the 
#' outcome variables
binary_outcome <- choose_outcomes(dat01,'c_safetf');
numeric_outcome <- choose_outcomes(dat01,'c_safenumeric');
#' Replace `predictorvars` below with vectors containing one or more column 
#' names you actually want to serve as the predictor variables
predictorvars <- choose_predictors(dat01,'c_safe'
                                   ,exclude=c(binary_outcome,numeric_outcome));
mainvars <- c(predictorvars,binary_outcome,numeric_outcome);



save(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles));
#+ echo=FALSE
c()
