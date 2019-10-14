if(!exists('.url')) .url <- 'https://raw.githubusercontent.com/bokov/2019-FA-TSCI-5050/update_00';
if(!exists('.thisfile')) .thisfile <- 'patch_191014.R';
if(!exists('.attempt')) .attempt <- 1;
system(paste0('wget -N ',file.path(.url,'.gitignore')));
system('git rm *.rdata');
try(message('\n******\n.attempt = ',.attempt,'\n\n'));

c()
