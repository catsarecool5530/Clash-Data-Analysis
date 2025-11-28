library(readr)
library(ggplot2)

curData <- read.csv("battle_data.csv")
attach(curData)
curData$Difference = Blue_Elixir_Leaked - Red_Elixir_Leaked 
# Create paired histograms
ggplot(curData, aes(x = Difference, fill = factor(Win))) +
    geom_density(alpha = 0.3) +
    scale_fill_manual(values = c("0" = "red", "1" = "blue"),
                      labels = c("Loss (Red)", "Win (Blue)")) +
    xlim(-20, 20) +
    labs(x = "Difference in Elixir Leaked", y = "Density", fill = "Result")



library(dplyr)

winners <- curData$Difference[curData$Win == 1]
losers <- curData$Difference[curData$Win == 0]
summary(winners)
summary(losers)
t.test(winners, losers)
wilcox.test(winners, losers, paired = FALSE)
