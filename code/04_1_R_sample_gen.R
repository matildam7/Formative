#set working directory as formative/code
datadir <- '../data'
accel_ids <- read.table(paste0(datadir,'/derived/accel_ids.txt'), header=FALSE, col.names='SEQN')
bmx_data <- read.csv(paste0(datadir, '/original/BMX_D.csv' ), header = TRUE)

accel_ids$hasaccel <- TRUE
merged <- merge(bmx_data, accel_ids, by = 'SEQN', all = TRUE )

merged$insample <- 0

merged$insample [!is.na(merged$BMXBMI) & !is.na(merged$hasaccel)] <- 1 

print(table(merged$insample))

write.csv(merged[, c('SEQN', 'insample')], paste0(datadir, '/derived/sample.csv'), row.names = FALSE)