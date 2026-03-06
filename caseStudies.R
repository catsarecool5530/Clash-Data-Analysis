
players <- read.csv('player_data.csv')
library(ggplot2)
players <- players[players$Trophies < 10000,]
players$WinRate <- players$Wins / (players$Wins + players$Losses)
attach(players)
ggplot(players, aes(x = Trophies, fill = factor(Mega.Knight > 0))) +
    geom_density(aes(y = after_stat(count)), position = "identity", color = "black", alpha = 1) +
    scale_fill_manual(values = c("FALSE" = "#88ef88", "TRUE" = "#ef88ef"),
                                        labels = c("Does not use Mega Knight", "Uses Mega Knight")) +
    labs(title = "Trophy Distribution by Mega Knight Usage",
             x = "Trophies", y = "Count", fill = "Mega Knight Usage")



nrow(subset(players, Mega.Knight > 0 & Trophies >= 6000 & Trophies <= 8000))
nrow(subset(players, Mega.Knight == 0 & Trophies >= 6000 & Trophies <= 8000))

t.test(
    players$WinRate[players$Mega.Knight > 0 & players$Trophies >= 6000 & players$Trophies <= 8000],
    players$WinRate[players$Mega.Knight == 0 & players$Trophies >= 6000 & players$Trophies <= 8000]
)

summary(subset(WinRate, Giant > 0))

ggplot(players, aes(x = Trophies, fill = factor(Giant > 0))) +
    geom_density(aes(y = after_stat(count)), position = "identity", color = "black", alpha = 1) +
    scale_fill_manual(values = c("FALSE" = "#88ef88", "TRUE" = "#ef88ef"),
                                        labels = c("Does not use Giant", "Uses Giant")) +
    labs(title = "Trophy Distribution by Giant Usage",
             x = "Trophies", y = "Count", fill = "Giant Usage")

ggplot(players, aes(x = Trophies, y = WinRate, color = factor(Giant > 0))) +
    geom_point(aes(alpha = factor(Giant > 0))) +
        scale_alpha_manual(values = c("FALSE" = 0.3, "TRUE" = 1), guide = "none") +
    scale_color_manual(values = c("FALSE" = "#88ef88", "TRUE" = "#9486f5"),
                                        labels = c("Does not use Giant", "Uses Giant")) +
    labs(title = "Win Rate vs Trophies by Giant Usage",
             x = "Trophies", y = "Win Rate", color = "Giant Usage")

small_spell_users <- (players$The.Log > 0 | players$Zap > 0 |
                      players$Arrows > 0 |
                      players$Barbarian.Barrel > 0 |
                      players$Tornado > 0 |
                      players$Giant.Snowball > 0) &
                     players$Trophies >= 6000 &
                     players$Trophies <= 8000
no_small_spell <- (The.Log == 0 & Zap == 0 &
                   Arrows == 0 &
                   Barbarian.Barrel == 0 &
                   Tornado == 0 &
                   Giant.Snowball == 0) &
                  Trophies >= 6000 &
                  Trophies <= 8000
t.test(players$WinRate[small_spell_users],
       players$WinRate[no_small_spell])


# players <- players[Trophies >= 5000 & Trophies <= 8000, ]
# most used
mostUsed <- ''
mostUsedCount <- 0
for (card in colnames(players)[11:length(colnames(players))-5]) {
    count <- nrow(subset(players, players[[card]] > 0))
    if (count > mostUsedCount) {
        mostUsed <- card
        mostUsedCount <- count
    }
}
mostUsed
mostUsedCount
nrow(players)
nrow(subset(players, Witch > 0))
summary(subset(players$WinRate, Witch > 0))
plot(players$Trophies[players$Witch > 0], players$WinRate[players$Witch > 0],
     xlab = "Trophies", ylab = "Win Rate",
     main = "Win Rate vs Trophies of Witch Users")


card_columns <- colnames(players)[6:ncol(players)]
formula_string <- paste("WinRate ~", paste(paste0("I(", card_columns, " > 0)"), collapse = " + "))
MultiCardModel <- lm(as.formula(formula_string), data = players)
summary(MultiCardModel)




par(mfrow = c(1, 1))
plot(MultiCardModel)

# get coefficients (same names as in your model)
coefs <- coef(MultiCardModel)

# drop intercept
beta <- coefs[names(coefs) != "(Intercept)"]

# if your indicator names are wrapped like "I(cardname > 0)", keep them as-is
# choose exactly k = 8 largest betas
k <- 20
best_k <- names(sort(beta, decreasing = TRUE))[1:k]
best_k
# predicted value with those 8 on
max_pred_exact8 <- coefs["(Intercept)"] + sum(beta[best_k])
max_pred_exact8



