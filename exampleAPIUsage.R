
library(httr)
library(jsonlite)

res = GET("https://api.clashroyale.com/v1/players/%23JJJUR0YUU/battlelog", 
          add_headers(`Authorization`="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjJiOTAyYjhiLTU0ZTgtNDY4NC04YjY3LWNiZThmYTNkMDNkYyIsImlhdCI6MTc2NDM1Njc5OCwic3ViIjoiZGV2ZWxvcGVyLzE5NTcxOTM2LWZiNTctNjgxMC0wMzEwLWZjYmU2Nzk2MTk3NiIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxNjguOTMuMzIuMTc4Il0sInR5cGUiOiJjbGllbnQifV19.CRPRGflt45hRN50PKD5ds3_hyEHFnBeowgFrnoN1UHQF6RyPUxWDwMd9Y-47NPoJzsLkUTt1sgepdPcLmwp7Pg"))
res
binary_data <- readBin(res$content, what = "raw", n = length(res$content))
text <- rawToChar(binary_data)
data <- jsonlite::fromJSON(text)
names(data)
View(data$opponent[1]["crowns"])
