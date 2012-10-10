# R-script to make some figures

# Count number of "Don't know" answers by questions
quesdk <- dcast(candidatesm, variable ~ ., function(x) sum(x == 0))
names(quesdk) <- c("Вопрос", "Затрудняюсь")

# Make a barchart
fig1 <- ggplot(quesdk, aes(reorder(Вопрос, Затрудняюсь), Затрудняюсь))
fig1 <- fig1 + geom_bar()
fig1 <- fig1 + coord_flip()
fig1 <- fig1 + xlab('Вопрос компаса') 
fig1 <- fig1 + ylab('Количество неопределившихся кандидатов')
fig1 <- fig1 + ggtitle('На какие вопросы компаса кандидаты не стали отвечать')

# Count number of "Don't know" answers by candidates
candsdk <- dcast(candidatesm, name ~ ., function(x) sum(x == 0))
names(candsdk) <- c("Кандидат", "Затрудняюсь")
candsdk15 <- head(candsdk[order(candsdk$Затрудняюсь, decreasing = T),], 15)
fig2 <- ggplot(candsdk15, aes(reorder(Кандидат, Затрудняюсь), as.factor(Затрудняюсь)))
fig2 <- fig2 + geom_bar()
fig2 <- fig2 + coord_flip()
fig2 <- fig2 + xlab('') 
fig2 <- fig2 + ylab('Количество ответов "Не знаю"')
fig2 <- fig2 + ggtitle('Кандидаты с наибольшим количеством неответов')

# Distribution of answers by questions
# Remove DK-answers
candidatesm <- candidatesm[candidatesm$value != 0,]
queskew <- ddply(candidatesm, .(variable), function(x) skew(x$value))
names(queskew)[2] <- 'qskew'
candidatesm <- join(candidatesm, queskew)

fig3 <- ggplot(candidatesm, aes(as.factor(value))) +
               geom_bar() + facet_wrap(~ variable)
fig3 <- fig3 + xlab('') + ylab('Количество ответов') +
  ggtitle('Распределение ответов на вопросы компаса') 
#   guides(fill = F) + scale_fill_gradient(high = 'black', low='white')
  print(fig3)
