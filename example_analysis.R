#' ---
#' title: "Example Analysis"
#' ---
#' 
#' ### Settings 
#' 
#' In the below two lines are the minimum script-level settings you need. 
#' The `.projpackages` object has the names of the packages you need installed 
#' if necessary and then loaded for this scriport. The `.deps` object contains
#' other scriports on which this one _directly_ depends (you don't need to worry
#' about the indirect ones-- each scriport manages its own dependencies for 
#' packages and scriports). The recommended value to start with is the one shown 
#' here. You can add more if the need arises later. For more information, please
#' see the [overview](overview.html) scriport.
.projpackages <- c()
.deps <- c( 'dictionary.R' ); 
#+ load_deps, echo=FALSE, message=FALSE, warning=FALSE,results='hide'
# do not edit the next two lines
.junk<-capture.output(source('./scripts/global.R',chdir=TRUE,echo=FALSE));
.currentscript <- current_scriptname('example_analysis.R');
#' 
#' 
#' ### Choosing predictor and response variables
#' 
#' The values below are variables arbitrarily selected for demonstration
#' purposes. To do your actual analysis, replace `binary_outcome` and 
#' `numeric_outcome` below with vectors containing one or more column names you 
#' want to serve as the outcome variables. If you have no binary outcomes, set
#' the value to an empty vector, `c()`. Likewise if you have no numeric 
#' outcomes.
binary_outcome <- choose_outcomes(dat01,'c_safetf');
numeric_outcome <- choose_outcomes(dat01,'c_safenumeric');
#' Again, replace `predictorvars` below with vectors containing one or more 
#' column names you actually want to serve as the predictor variables
predictorvars <- choose_predictors(dat01,'c_safe'
                                   ,exclude=c(binary_outcome,numeric_outcome));
#' If you are satisfied with your choice of `binary_outcome`, `numeric_outcome`,
#' and `predictorvars` you don't need to change the following line. It simply
#' combines the above.
mainvars <- c(predictorvars,binary_outcome,numeric_outcome);


#' ### Save results
#' 
#' Now the results are saved and available for use by other scriports if you
#' place `r ``'.currentscript'``` among the values in their `.deps` variables.
save(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles));
#+ echo=FALSE
c()
