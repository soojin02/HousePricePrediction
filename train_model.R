library(data.table)

set.seed(77)
test$SalePrice <- 0


train <- fread('./project/volume/data/interim/Stat_380_train.csv')
test <- fread('./project/volume/data/interim/Stat_380_test.csv')


lm_model <- lm(SalePrice ~ qc_code + Heating + LotArea + BldgType + 
                 Qual + Cond + FullBath + HalfBath + YearBuilt + 
                 TotalBsmtSF + BedroomAbvGr + CentralAir + GrLivArea + 
                 YrSold, data = train)
summary(lm_model)

test$pred <- predict(lm_model,newdata = test)


submit <- test[,.(Id, pred)]
names(submit)[names(submit) == "pred"] = "SalePrice"

fwrite(submit,"./project/volume/data/processed/submit_4.csv")
