if(!exists('.url')) .url <- 'https://raw.githubusercontent.com/bokov/2019-FA-TSCI-5050/update_00';
if(!exists('.thisfile')) .thisfile <- 'patch_191011.R';
if(!exists('.attempt')) .attempt <- 1;
system(paste0('wget -N ',file.path(.url,'.gitmodules')));
try(devtools::install_github('bokov/tidbits',ref='integration'));
try(devtools::install_github('bokov/rio',ref='master'));
try(file.rename('data_characterization.R','.data_characterization.backup'));

if(file.exists('scripts/bootstrap.Rprofile')){
  source('scripts/bootstrap.Rprofile');
  .onrestart <- sprintf('.attempt <- %d;
                         if(!require(tidbits) && .attempt < 3) source("%s/%s")'
                        ,.attempt+1,.url,.thisfile);
  clean_slate(.onrestart);
}
c()