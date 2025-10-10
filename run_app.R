# Create the log file
sink( paste0('log/log_runtime_at_', Sys.Date(), '.txt'), append = TRUE ) 

# Prints out the run time
cat( paste0('--- Run at ', Sys.Date(), ' ---') )

# Run the main pipeline
source('main.R')

# Close log file
sink()
