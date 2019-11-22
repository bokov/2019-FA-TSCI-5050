#' ---
#' title: "All the Files"
#' ---
#' 
# additional packages to install, if needed. If none needed, should be: ''
.projpackages <- c()
# name of this script
.currentscript <- parent.frame(2)$ofile;
# other scripts which need to run before this one. If none needed, shoule be: ''
.deps <- c( 'dictionary.R','simdata.R'); 
# load project-wide settings, including your personalized config.R
.junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F));
# files not created by this script are in .origfiles
.origfiles <- c();

#' Normally this is where calculations should go, but this script is invoked for
#' its side effects: triggering all the other scripts.

save(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles)
      ,verbose=FALSE);
#+ echo=FALSE
c()
