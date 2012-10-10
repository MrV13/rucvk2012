# R-script to make some figures

# Count number of "Don't know" answers by questions
quesdk <- dcast(candidatesm, variable ~ ., function(x) sum(x == 0))
names(quesdk) <- c("Вопрос", "Затрудняюсь")

# Make a barchart
fig1 <- ggplot(quesdk, aes(reorder(Вопрос, Затрудняюсь), Затрудняюсь))
fig1 <- fig1 + geom_bar()
fig1 <- fig1 + coord_flip()
print(fig1)
