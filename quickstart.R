#' 
message('
This script will copy files off the internet into your current directory, 
', getwd(),'. If you have any files with matching names, they will be 
overwritten. So, if you are in doubt, you should run it from an empty directory
(or one that you have backed up). This script will probably also install or 
update R-packages on your computer, and it may take a while.
        
You are running this at your own risk and with no warranty whatsoever.');
.menu01 <- menu(c('This is what I expected, go ahead.'
                  ,'Go ahead, but first create an empty directory.'
                  ,'Stop this script without making any changes to my computer.'
                  ));


if(!.menu01 %in% 1:2) stop('

No problem, better safe than sorry!

Please read the comments in this script to understand what it does, and make 
sure you have backups of all the files in the directory where you run this 
script (or that you run it in an empty directory). Then, feel free to come back
and try this at a later time.');
if(.menu01 == 2){
  message("

We will create an empty directory and work in there. Please give it a name. All
spaces and punctuation marks except '_' will be removed. If a directory or file 
by that name already exists, it will be renamed with the '.backup' prefix added 
to it.
")
  .setdir <- readline('Please give a name for the directory to create: ');
  .setdir <- gsub('[^[:alnum:]_]','',.setdir);
  message('Your directory will be named ',.setdir);
  if(file.exists(.setdir)){
    file.rename(.setdir,paste0(.setdir,'.backup'));
    message('An existing directory named ',.setdir,' has been backed up to '
            ,.setdir,'.backup');
    };
  dir.create(.setdir);
  setwd(.setdir);
  message('From now on we are in the ',.setdir
          ,' directory. Continuing installation.');
}

.templatepath <- 'https://github.com/bokov/2019-FA-TSCI-5050/archive/ft_simplescript.zip';
.scriptspath <- 'https://github.com/bokov/ut-template/archive/master.zip';
.checkenv <- new.env();

unzipto <- function(zipfile,to='.',cleanup=getOption('cleanup',TRUE)){
  #' Get file listing
  .checkfiles <- utils::unzip(zipfile,list=TRUE);
  #' Create directories
  .ziproot <- basename(.checkfiles$Name[1]);
  sapply(with(.checkfiles,normalizePath(sub(.ziproot,to,Name[Length==0])
                                        ,mustWork = FALSE))
         ,dir.create,recursive=TRUE);
  #' Unzip the files
  .copiedfiles <- utils::unzip(zipfile);
  file.copy(.copiedfiles,normalizePath(sub(.ziproot,to,.copiedfiles)
                                       ,mustWork = FALSE));
  if(cleanup) unlink(c(zipfile,.ziproot),recursive = TRUE,force = TRUE);
}

getbrsub <- function(file='.gitmodules',section='\\[submodule'
                     ,targetsection='\\[submodule "scripts"'
                     ,params=c('url','branch')){
  # read in the modules file
  .subsraw <- readLines(file);
  # find the places where it switches to a different submodule, or ends
  .subssections <- c(grep(section,.subsraw),length(.subsraw)+1);
  # find the start of the submodule of interest
  .subsscripts <- grep(targetsection,.subsraw);
  # find the start and end of just the body of that submodule section
  .subsextent <- .subssections[match(.subsscripts,.subssections)+0:1] + 
    c(1,-1);
  # find the actual body
  .substarget <- .subsraw[seq(.subsextent[1],.subsextent[2])];
  sapply(params,function(xx) if(any(oo<-grepl(xx,.substarget))){
    gsub(' ','',strsplit(tail(.substarget[oo],1),'=')[[1]][2])} else '');
}

#' 
#' TODO: parse own URL
#' 
#' Copy down the latest version of the specified branch
utils::download.file(.templatepath,'.temp.zip',quiet=TRUE);
unzipto('.temp.zip','.');
#' 
#' Check if a data-file exists
#' 
source('config.R',local=.checkenv);
.inputdataset <- 'inputdata' %in% ls(.checkenv);
.inputdataexists <- file.exists(.checkenv$inputdata);
#' TODO: talk user through setting up a config.R file
#' 
#' Find the submodules urls
#' 
.submodule <- getbrsub();
.submodule <- paste0(.submodule['url'],'/archive/'
                     ,if(.submodule['branch']=='') 'master' else {
                       .submodule['branch']},'.zip');
#' 
#' Download the scripts submodule
#' 
utils::download.file(.submodule,'.scripts.zip');
unzipto('.scripts.zip','scripts');
#' 
#' Prompt the user for the local data file.
#' 
done_fileread <- FALSE;
.inputdata_names <- inputdata <- c();
while(!done_fileread){
  inputdata <- c(inputdata,file.choose());
  .inputdata_names <- c(.inputdata_names,{
    message("Please choose a short name for your data-source, preferably 3 characters or less and lower-case ")
    readline("or type the 'return' key to accept a default name: ")});
  done_fileread <- grepl('done'
                         ,{message("\nType the 'return' key to add one more data file. ");
                           tolower(
                             readline(
                               "If you are finished adding files, type 'DONE' and then the 'return' key. "))
                           })};
.inputdata_names[.inputdata_names==''] <- sprintf('dat%02d'
                                                  ,seq_len(sum(.inputdata_names=='')));
.inputdata_names <- make.names(.inputdata_names,unique=TRUE);
.menu02 <- -1;
while(.menu02 != 0){
  .menu02 <- menu(paste(.inputdata_names,inputdata,sep=' = '),title="Here are the names modified for uniqueness and compatibility with R. Select any that you want to modify further or 0 to accept them and keep going. Please note that names beginning with 'dat' and ending with two digits will always get renumbered consecutively.");
  if(.menu02>0){
    .newname <- readline(paste0('Please type in the new name for '
                                ,.inputdata_names[.menu02]
                                ," or the 'enter' key for a default: "));
    .inputdata_names[.menu02] <- .newname;
    .inputdata_names <- gsub('^dat[[:digit:]]{2}$','',.inputdata_names);
    .inputdata_names[.inputdata_names==''] <- sprintf('dat%02d'
                                                      ,seq_len(sum(
                                                        .inputdata_names=='')));
    .inputdata_names <- make.names(.inputdata_names,unique=TRUE);
  }
}
#' TODO: actually create an updated `config.R` from this data
#' TODO: update the scripts to handle a vector-valued `inputdata`
#' TODO: decide what to do when inputdata doesn't exist in downloaded config.R
#' TODO: decide what to do when inputdata exists but some or all files don't exist
#' TODO: decide what to do when inputdata exists and files do all exist

#' Based on the response, create a `local.config.R` file
#' 
#' 
c()
