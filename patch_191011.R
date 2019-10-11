system('wget -N https://raw.githubusercontent.com/bokov/2019-FA-TSCI-5050/update_00/.gitmodules');
devtools::install_github('bokov/tidbits',ref='integration');
devtools::install_github('bokov/rio',ref='master');
file.rename('data_characterization.R','.data_characterization.backup');
clean_slate('library(tidbits)');
c()