#
sink( paste0('log_runtime_at_', Sys.Date(), '.txt'), append = TRUE ) 

#
cat('\n--- Run at', Sys.Date(), '---\n')

#
# Run the main pipeline
#
source('main.R')


#
#
#
system('git add .')
system('git commit -m "Monthly data update: (date)"')
system('git push origin main')


sink()