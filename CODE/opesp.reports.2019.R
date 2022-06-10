library(readxl)
library(dplyr)
library(openxlsx)

file.list <- list.files(pattern='*.xlsx', recursive = TRUE)

df.list <- lapply(file.list, read_excel, skip = 10)

merged <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = c("Κωδικός", "Ενότητα", "Τίτλος", "Υποενότητα"), all.x = TRUE, all.y = TRUE),
       df.list)

colnames(merged) <- c(c("Κωδικός", "Ενότητα", "Τίτλος", "Υποενότητα"), gsub(" 2022.xlsx","",file.list))

colnames(merged)

merged <- merged[ -c(2,4) ]

write.xlsx(merged, file = "OPESP_21_PPS.xlsx", overwrite = TRUE)

##

indices <- as.data.frame(t(merged[-2]))
names(indices) <- c(merged[,1])
indices <- indices[-1,]                         

sapply(indices, class)

wb <- loadWorkbook("OPESP_21_PPS.xlsx")
addWorksheet(wb,"indices")
writeData(wb,"indices",indices, rowNames = TRUE, colNames = TRUE)
saveWorkbook(wb,"OPESP_21_PPS.xlsx",overwrite = TRUE)
