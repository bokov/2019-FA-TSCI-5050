#' 
message('
This script will run scripts remotely off the internet and copy files off the 
internet into your current directory,', getwd(),'. If you have any files with 
matching names, they will be overwritten. So, if you are in doubt, you should 
run this script from an empty directory (or one that you have backed up). This 
script will probably also install or update R-packages on your computer, and it 
may take a while.
        
You are running this at your own risk and with no warranty whatsoever.');
.menu01 <- if(!interactive()) 3 else -1;
if(file.exists('.auto.menu01.R')).menu01 <- source('.auto.menu01.R')$value;
if(.menu01 ==  -1){
  .menu01 <- menu(c('This is what I expected, go ahead.'
                    ,'Stop this script without making any changes to my computer.'
                    ))};


if(.menu01 != 1) stop('

No problem, better safe than sorry!

Please read the comments in this script to understand what it does, and make 
sure you have backups of all the files in the directory where you run this 
script (or that you run it in an empty directory). Then, feel free to come back
and try this at a later time.');

gitbootstrap <- function(gitrepos=list(trailR=list(repo='bokov/trailR'
                                                   ,ref='integration')
                                       ,tidbits=list(repo='bokov/tidbits'
                                                     ,ref='integration')
                                       ,rio=list(repo='bokov/rio'
                                                 ,ref='master'))
                         ,instreqs=c()){
  if(!require('devtools')){
    install.packages('devtools',dependencies=TRUE
                     ,repos=getOption('repos','https://cran.rstudio.com'))};
  for(ii in names(gitrepos)){
    do.call(devtools::install_github,gitrepos[[ii]]);
    library(ii,character.only = TRUE)};
  if(exists('instrequire')) instrequire(instreqs);
}

clean_slate <- function(...){gitbootstrap();tidbits:::clean_slate(...)};

.templatepath <- 'https://github.com/bokov/2019-FA-TSCI-5050/archive/ft_simplescript.zip';
.scriptspath <- 'https://github.com/bokov/ut-template/archive/master.zip';
.oldoptions <- options();
options(browser='false'); # to make usethis::use_zip calm down a little bit
.tempenv00 <- new.env();
if(file.exists('autoresponse.R')){
  source('autoresponse.R',local = .tempenv00);
  for(ii in ls(.tempenv())) stack(ii);
};

#' TODO: parse own URL
#' 
#' Install needed libraries
message('Installing needed packages and their dependencies.'
        ,'This may take a while, please be patient.');
gitbootstrap(instreqs = 'usethis');

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
#' Remove the existing scripts directory
unlink(.scriptsinfo$path,recursive = TRUE,force = TRUE);
#' Rename the newly downloaded one to scripts
file.rename(.ztemp1,.scriptsinfo$path);
if(file.exists(.localfns <- file.path(.scriptsinfo$path,'functions.R'))){
  source(.localfns)};
options(browser=.oldoptions$browser); # restore the browser option
#' For setting inputdata
#' 

.inputdata <- smartsetnames(smartfilechoose('data/example_data_pbc.csv'
                                       ,pop('confchfile')));
# TODO: the same within loop, and grow with each cycle
# TODO: print .inputdata as part of extramessage
.confmain <- -1;
# confmainloop ----
while(.confmain<4 || length(.inputdata)==0){
  .confmain <- smartmenu(c( 'Select an additional file.'
                           ,'Change the name of a variable.'
                           ,'Unselect one of the files.'
                           ,'Save selections and continue.'
                           ),batchmode = 4,autoresponse = pop('confchfile')
                         ,title = 'What do you wish to do?'
                         ,extramessage = {
                           ui_line(
'\n\nThese are the files you have chosen and the variable names to which they will
 be assigned after getting imported into R:\n');
                           for(ii in names(.inputdata)){
                             ui_line(
                               '{ui_field(ii)}\t{ui_path(.inputdata[ii])}')}});
  switch(.confmain
         # add a file
         ,.inputdata <- smartsetnames(c(.inputdata
                                        ,smartfilechoose('data/example_data_pbc.csv'
                                                         ,ignorecancel = FALSE
                                                         ,auto=pop('confchfile')
                                                         )))
         ,{ # rename a variable
           .torename <- smartmenu(.inputdata
                                  ,title='Which variable do you wish to rename?'
                                  ,extramessage = {
                                    ui_line(
"After you enter in the name you want it will get modified for uniqueness, 
compatibility with R and ease of typing. Names starting with {ui_code('dat')} 
will be renumbered. Type {ui_code(0)} to cancel and go back to previous menu.")}
                                  ,ignorezero = FALSE,batchmode=0
                                  ,auto=pop('confchfile'));
           if(.torename==0) next;
           message(ui_line(
             "\nIf you want a default name to be auto-assigned, type the 'enter' key"));
           names(.inputdata)[.torename]<-smartreadline(
             sprintf("Type in a new name for '%s': "
                     ,names(.inputdata)[.torename])
             ,auto=pop('confchfile'));
           .inputdata <- smartsetnames(.inputdata);
         }
         ,{ # remove a file
           .toremove <- smartmenu(.inputdata
                                  ,title='Which file do you wish to un-select?'
                                  ,extramessage = {ui_line(
'The file you unselect will not be touched, just its data will not be imported 
into this project. Type {ui_code(0)} to not select any files and return to the 
previous menu.')}
                                  ,ignorezero = FALSE, batchmode = 0
                                  ,auto=pop('confchfile'));
           if(.toremove==0) next;
           .inputdata <- .inputdata[-.toremove];
           if(length(.inputdata)==0){
             message(ui_todo('There must be at least one data file.'));
             .inputdata <- smartsetnames(smartfilechoose('data/example_data_pbc.csv'
                                                         ,pop('confchfile')));
           }
           });
}
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
