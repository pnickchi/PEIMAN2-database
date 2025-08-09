## Load Library.R contains necessary functions
source('Library.R')

## Set the working directory
setwd("/home/payman/")

## Define the prefix ##
prefix <- 'UniProtReviewed_'

## Get today's date ##
today_date = Sys.Date()

## Write the console to a log file
#sink(file = paste0('Log/', today_date,'_LOGFILE.txt'), append = TRUE, type = c('output', 'message'), split = FALSE)

## Define suffix ##
suffix <- '.dat.gz'

## Generate file name ##
file_name <- paste0('/home/payman/', prefix, today_date, suffix)

## Download the latest version from UniProt ##
print('Downloading file from UniProt ...')
system(command = 'sh download.sh')

## Unzip the file ##
print('Unzip the UniProt file ...')
system( paste0('gzip -d ', '/home/payman/uniprot_sprot.dat.gz') )
system( paste0('mv /home/payman/uniprot_sprot.dat ', '/home/payman/', prefix, today_date, '.dat') )


## Generate INPUT.txt and OUTPUT.txt files for c++ program ##
Ifile <- paste0('/home/payman/',    prefix, today_date, '.dat')
writeLines(text = Ifile, con = 'INPUT.txt')
Ofile <- paste0('/home/payman/6C_', prefix, today_date, '.dat')
writeLines(text = Ofile, con = 'OUTPUT.txt')


## Call c++ program
print('Call cpp program ...')
system(command = 'sh 6columns.sh')



## Call R script to generate PEIMAN database
print('Update PEIMAN database ...')
MakePEIMAN(dt = today_date)


## Update the package with the new data
load(file = paste0('/home/payman/peiman_database_', today_date, '.RData') )
usethis::proj_set(path = '/home/payman/')
usethis::use_data(peiman_database, internal = TRUE, overwrite = TRUE)

# Add and commit changes
# git2r::add(repo = '/home/payman/Projects/PEIMAN2DBUpd/', path = '/home/payman/Projects/PEIMAN2DBUpd/')
# git2r::commit(repo = '/home/payman/Projects/PEIMAN2DBUpd/', all=TRUE, message = paste0('Update Databae on:', today_date))

# Push manually!

# For now push needs to be done manually
# git2r::push(object = '~/Projects/PEIMAN2DBUpd/', refspec = 'main')

# Check and BUild the package if necessary
#devtools::document(pkg = '~/Projects/PEIMAN2DBUpd/')
#devtools::check(pkg = '~/Projects/PEIMAN2DBUpd/', cran = TRUE, remote = TRUE, incoming = TRUE)
#devtools::build(pkg = '~/Projects/PEIMAN2DBUpd/')


## Remove unnecessary files
# print('Remove unnecessary files ...')
# system( paste0('rm ', '/home/payman/Projects/PEIMAN2DBUpd/DBLog/',    prefix, today_date, '.dat') )
# system( paste0('rm ', '/media/payman/DATA/PEIMAN2DBUpd/DBLog/6C_', prefix, today_date, '.dat') )
# system('rm /media/payman/DATA/PEIMAN2DBUpd/INPUT.txt')
# system('rm /media/payman/DATA/PEIMAN2DBUpd/OUTPUT.txt')
