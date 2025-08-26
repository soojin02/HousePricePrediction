rm(list = ls())
library(data.table)

df1 <- fread('./project/volume/data/raw/Stat_380_housedata.csv')
df2 <- fread('./project/volume/data/raw/Stat_380_QC_table.csv')

common_column <- 'qc_code'

merged_df <- merge(df1, df2, by = common_column, all = FALSE)

housedata <- fread("./project/volume/data/interim/merged_df.csv")

housedata[, NumericId := as.integer(gsub("\\D", "", Id))]
housedata <- housedata[order(NumericId)]

train <- housedata[grepl("^train_", Id)]
test <- housedata[grepl("^test", Id)]

fwrite(train, './project/volume/data/interim/Stat_380_train.csv')
fwrite(test, './project/volume/data/interim/Stat_380_test.csv')


test_sub <- housedata[grepl("^test", Id),]

train_subset <- train[, .(Id, SalePrice)]
test_subset <- test_sub[, .(Id, SalePrice)]

average_sale_price <- mean(train_subset$SalePrice)
test_subset$SalePrice <- average_sale_price

print(test_subset)
fwrite(test_subset, './project/volume/data/processed/Submit_1.csv')


