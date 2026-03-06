
players <- read.csv('player_data.csv')
ncol(players)
hist(players$Trophies)
library(ggplot2)
players <- players[Trophies < 10000,]
players$WinRate <- players$Wins / (players$Wins + players$Losses)
attach(players)

ggplot(players, aes(x = Trophies)) +
    geom_histogram(binwidth = 200, fill = '#8f88ef', color = 'black') +
    labs(title = 'Distribution of Player Trophies', x = 'Trophies', y = 'Number of Players')


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
                      labels = c('Does not use Mega Knight', 'Uses Mega Knight')) +
    labs(title = 'Trophy Distribution by Mega Knight Usage',
         x = 'Trophies', y = 'Number of Players', fill = 'Mega Knight Ownership')
ggplot(playersMid, aes(x = WinRate, fill = factor(I(Mega.Knight == 0)))) + 
    geom_density(position = 'dodge', color = 'black', alpha = 0.3) +
    scale_fill_manual(values = c('TRUE' = '#88ef88', 'FALSE' = '#ef88ef'),
                      labels = c('No Mega Knight', 'Mega Knight')) +
    labs(title = 'Win Rate Distribution by Mega Knight Usage',
         x = 'Win Rate', y = 'Number of Players', fill = 'Mega Knight Usage')


playersMid <- players[players$Trophies >= 6000 & players$Trophies <= 8000, ]
ggplot(players, aes(x = Trophies, y = WinRate)) +
    geom_point(alpha = 0.2) +
    labs(title = 'Win Rate vs Trophies', x = 'Trophies', y = 'Win Rate')

ggplot(playersMid, aes(sample = WinRate)) +
    stat_qq(color = '#8f88ef') +
    stat_qq_line(color = 'black') +
    labs(title = 'Q-Q Plot of Player Win Rates', x = 'Theoretical Quantiles', y = 'Sample Quantiles')

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
plot(WinRate ~ Trophies)
abline(OneLinModel, col = 'red')

MegaKnightModel <- lm(WinRate ~ I(Mega.Knight > 0))
summary(MegaKnightModel)


best_k
max_pred_exact8
plot(MultiCardModel)
library(plotly)
plot_ly(players, x = ~Trophies, y = ~TotalGames, z = ~WinRate, 
    type = 'scatter3d', mode = 'markers',
    marker = list(size = 2, color = ~WinRate, colorscale = 'Viridis')) %>%
  layout(scene = list(xaxis = list(title = 'Trophies'),
              yaxis = list(title = 'Total Games'),
              zaxis = list(title = 'Win Rate')),
     title = '3D Plot: Win Rate vs Trophies and Total Games')


activerPlayers <- players[players$TotalGames > 100, ]
ggplot(activerPlayers, aes(x = Trophies, y = WinRate)) +
    geom_point(alpha = 0.3)

ggplot(players, aes(x = TotalGames)) +
    geom_density(fill = '#88ccee', color = 'black', alpha = 0.7)
summary(players$TotalGames)
# crashes my computer
# formula_string <- paste("WinRate ~ (", paste(paste0("I(", card_columns, " > 0)"), collapse = " + "), ")^2")
# MultiCardWithInteractionsModel <- lm(as.formula(formula_string), data = players)
# plot(MultiCardWithInteractionsModel)

level_formula_string <- paste("WinRate ~", paste(paste0(card_columns), collapse = " + "))
LevelCardModel <- lm(as.formula(level_formula_string), data = players)
summary(LevelCardModel)

hist(residuals(MultiCardModel))
shapiro.test(residuals(MultiCardModel)[1:5000])
attach(players)
unique(PlayerID)
length(unique(PlayerID))
length(PlayerID)
predict(MultiCardModel, newdata = data.frame(players[1, ]))
