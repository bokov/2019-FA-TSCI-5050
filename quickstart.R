#' 
message('
This script will run scripts remotely off the internet and copy files off the 
internet into your current directory,', getwd(),'. If you have any files with 
matching names, they will be overwritten. So, if you are in doubt, you should 
run this script from an empty directory (or one that you have backed up). This 
script will probably also install or update R-packages on your computer, and it 
may take a while.
        
You are running this at your own risk and with no warranty whatsoever.');
if(file.exists('.auto.menu01.R')){
  .menu01 <- source('.auto.menu01.R')$value } else {
    .menu01 <- menu(c('This is what I expected, go ahead.'
                      ,'Go ahead, but first create an empty directory.'
                      ,'Stop this script without making any changes to my computer.'
                      ))};


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
#' TODO: parse own URL
#' 
#' Install needed libraries
message('Installing needed packages and their dependencies');
if(!require('devtools')){
  install.packages('devtools',dependencies=TRUE
                   ,repos=getOption('repos','https://cran.rstudio.com'))};
devtools::install_github('bokov/trailR',ref='integration'); library(trailR);
devtools::install_github('bokov/tidbits',ref='integration'); library(tidbits);
devtools::install_github('bokov/rio',ref='master'); library(rio);
instrequire('usethis');

#' 
#' Copy down the latest version of the specified branch
.ztemp0 <- usethis::use_zip(.templatepath,'.',cleanup = TRUE);
#' Merge into current directory, with backups
mergedirs(.ztemp0);
#' Get info about the scripts submodule
.scriptsinfo <- getkeyval(
  filesections('.gitmodules',sectionrxp = '\\[.*submodule'
               ,targetrxp = '\\[.*submodule .*scripts.*\\]')[[1]]
  ,c('path','url','branch'));
#' Download the appropriate version of the submodule
.ztemp1 <- usethis::use_zip(
  with(.scriptsinfo,paste0(url,'/archive/',c(branch,'master')[1],'.zip'))
  ,'.',cleanup = TRUE);
#' Rename it to its standard local name
unlink(.scriptsinfo$path,recursive = TRUE,force = TRUE);
file.rename(.ztemp1,.scriptsinfo$path);
#' For setting inputdata
#' 
.userconfigdone <- FALSE;
#' While !.userconfigdone
#' Select a data file to include
#' These are the data-files you selected so far and the variables into which
#' they will be read. What do you wish to do next?
#' [0. Re-display this menu]
#' 1. Start over (remove all the files in this list)
#' 2. Add more files
#' 3. Edit one of the variable names
#' 4. Done
#' 
#' If edit: 
#' Which variable do you wish to rename 
#' (hit 0 or XX to go back to previous menu)
#' 
#' If selected a variable:
#' Please note that your variable names might get modified for compatibility 
#' with R and uniqueness. Hit 'enter' if you no longer wish to rename the 
#' variable XXXXX
#' What would you like to rename XXXXX to?
#' 
#' (redisplay main menu until done)

#' The result:
#sprintf('inputdata <- c(\n %s\n);',paste0(c('dat01','dat02','dat03'),' = ',replicate(3,'"/tmp/2019-FA-TSCI-5050/data/example_data_pbc.csv"'),collapse='\n,'))

#' 
#' Check if a data-file exists
#' 
#source('config.R',local=.checkenv);
#.inputdataset <- 'inputdata' %in% ls(.checkenv);
#.inputdataexists <- file.exists(.checkenv$inputdata);
#' TODO: talk user through setting up a config.R file
#' 
#' Prompt the user for the local data file.
#' 
# done_fileread <- FALSE;
# .inputdata_names <- inputdata <- c();
# while(!done_fileread){
#   .filechosen <- try(file.choose());
#   if(!is(.filechosen,'try-error')){
#     inputdata <- c(inputdata,.filechosen);
#     .inputdata_names <- c(.inputdata_names,{
#       message("Please choose a short name for your data-source, preferably 3 characters or less and lower-case ")
#       readline("or type the 'return' key to accept a default name: ")});
#   };
#   done_fileread <- grepl('done'
#                          ,{message("\nType the 'return' key to add one more data file. ");
#                            tolower(
#                              readline(
#                                "If you are finished adding files, type 'DONE' and then the 'return' key. "))
#                            })};
# .inputdata_names <- gsub('^dat[[:digit:]]{0,2}$','',.inputdata_names);
# .inputdata_names <- gsub('^inputdata','',.inputdata_names);
# .inputdata_names[.inputdata_names==''] <- sprintf('dat%02d'
#                                                   ,seq_len(sum(.inputdata_names=='')));
# .inputdata_names <- make.names(.inputdata_names,unique=TRUE);
# .menu02 <- -1;
# while(.menu02 != 0){
#   .menu02 <- menu(paste(.inputdata_names,inputdata,sep=' = '),title="Here are the names modified for uniqueness and compatibility with R. Select any that you want to modify further or 0 to accept them and keep going. Please note that names beginning with 'dat' and ending with two digits will always get renumbered consecutively. Certain names that are known to interfere with these scripts will also get replaced with default values.");
#   if(.menu02>0){
#     .newname <- readline(paste0('Please type in the new name for '
#                                 ,.inputdata_names[.menu02]
#                                 ," or the 'enter' key for a default: "));
#     .inputdata_names[.menu02] <- .newname;
#     .inputdata_names <- gsub('^dat[[:digit:]]{0,2}$','',.inputdata_names);
#     .inputdata_names <- gsub('^inputdata','',.inputdata_names);
#     .inputdata_names[.inputdata_names==''] <- sprintf('dat%02d'
#                                                       ,seq_len(sum(
#                                                         .inputdata_names=='')));
#     .inputdata_names <- make.names(.inputdata_names,unique=TRUE);
#   }
# }

#' Update hooks.
if(file.exists('scripts/quickstart_patch.R')) source('scripts/quickstart_patch.R');

#' TODO: actually create an updated `config.R` from this data
#' TODO: update the scripts to handle a vector-valued `inputdata`
#' TODO: decide what to do when inputdata doesn't exist in downloaded config.R
#' TODO: decide what to do when inputdata exists but some or all files don't exist
#' TODO: decide what to do when inputdata exists and files do all exist
#' TODO: recommend chocolatey and git install for Windows users
#' TODO: recommend git install for MacOS and Linux users if missing

#' Based on the response, create a `local.config.R` file
#' 
#' 
c()
