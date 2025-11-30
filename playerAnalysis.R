
players <- read.csv('player_data.csv')
View(players)
ncol(players)
players$Goblin.Giant
ncol(players)
hist(players$Trophies)
library(ggplot2)
attach(players)
ggplot(players, aes(x = Trophies)) +
    geom_histogram(binwidth = 100, fill = '#8f88ef', color = 'black') +
    labs(title = 'Distribution of Player Trophies', x = 'Trophies', y = 'Number of Players')

players$WinRate <- players$Wins / (players$Wins + players$Losses)
ggplot(players, aes(x = WinRate)) +
    geom_histogram(binwidth = 0.03, fill = '#ef8888', color = 'black') +
    labs(title = 'Distribution of Player Win Rates', x = 'Win Rate', y = 'Number of Players')
summary(players$WinRate)
qqnorm(players$WinRate)
qqline(players$WinRate)
shapiro.test(players$WinRate[1:5000])
nrow(subset(players, Mega.Knight > 0))
summary(players$Trophies)
attach(players)
min(WinRate)
ggplot(players, aes(x = Trophies, fill = factor(I(Mega.Knight == 0)))) + 
    geom_density(position = 'dodge', color = 'black', alpha = 0.3) +
    scale_fill_manual(values = c('TRUE' = '#88ef88', 'FALSE' = '#ef88ef'),
                      labels = c('No Mega Knight', 'Has Mega Knight')) +
    labs(title = 'Trophy Distribution by Mega Knight Ownership',
         x = 'Trophies', y = 'Number of Players', fill = 'Mega Knight Ownership')

highest_average_card <- ''
highest_average_trophies <- 0
for (column in colnames(players)[6:ncol(players)]) {
    average_trophies <- mean(players$Trophies[players[[column]] > 0])
    if (nrow(subset(players, players[[column]] > 0)) <= 100) {
        next
    }
    if (average_trophies > highest_average_trophies) {
        highest_average_trophies <- average_trophies
        highest_average_card <- column
    }
}
cat('Card with highest average trophies:', highest_average_card, 
    'with average trophies of', highest_average_trophies, '\n')

highest_winrate_card <- ''
highest_winrate <- 0
for (column in colnames(players)[6:ncol(players)]) {
    card_players <- subset(players, players[[column]] > 0)
    if (nrow(card_players) <= 10) {
        next
    }
    winrate <- sum(card_players$Wins) / (sum(card_players$Wins) + sum(card_players$Losses))
    if (winrate > highest_winrate) {
        highest_winrate <- winrate
        highest_winrate_card <- column
    }
}
cat('Card with highest win rate:', highest_winrate_card, 
    'with win rate of', highest_winrate, '\n')


lowest_winrate_card <- ''
lowest_winrate <- 1
for (column in colnames(players)[6:ncol(players)]) {
    card_players <- subset(players, players[[column]] > 0)
    if (nrow(card_players) <= 10) {
        next
    }
    winrate <- sum(card_players$Wins) / (sum(card_players$Wins) + sum(card_players$Losses))
    if (winrate < lowest_winrate) {
        lowest_winrate <- winrate
        lowest_winrate_card <- column
    }
}
cat('Card with lowest win rate:', lowest_winrate_card, 
    'with win rate of', lowest_winrate, '\n')



OneLinModel <- lm(WinRate ~ Trophies)
summary(OneLinModel)
plot(OneLinModel)
plot(WinRate ~ Trophies)
abline(OneLinModel, col = 'red')

MegaKnightModel <- lm(WinRate ~ I(Mega.Knight > 0))
summary(MegaKnightModel)

card_columns <- colnames(players)[6:ncol(players)]
formula_string <- paste("WinRate ~", paste(paste0("I(", card_columns, " > 0)"), collapse = " + "))
MultiCardModel <- lm(as.formula(formula_string), data = players)
summary(MultiCardModel)

level_formula_string <- paste("WinRate ~", paste(paste0(card_columns), collapse = " + "))
LevelCardModel <- lm(as.formula(level_formula_string), data = players)
summary(LevelCardModel)

hist(residuals(MultiCardModel))
shapiro.test(residuals(MultiCardModel)[1:5000])
plot(MultiCardModel)
predict(MultiCardModel, newdata = players[1:5, ])
