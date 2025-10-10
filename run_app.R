# Create the log file
sink( paste0('log_runtime_at_', Sys.Date(), '.txt'), append = TRUE ) 

# Prints out the run time
cat( paste0('--- Run at ', Sys.Date(), ' ---') )

# Run the main pipeline
source('main.R')

#
system('git add .')
system( paste0('git commit -m Monthly data update: ', Sys.Date()) )
system('git push origin main')

# Close log file
sink()
