require(ggplot2)
require(sandwich)
require(msm)
require(R.matlab)
library(readr)

agingDotsTable <- read_csv("D:/Pedro/AgingDots/resultsByAnimal/NSCs BrdU/clusterDistance/3m/agingDotsTable.txt")
agingDotsTable$meanOfDots = as.integer(agingDotsTable$meanOfDots)

summary(m1 <- glm(meanOfDots ~ name + numberOfStemCells, family="poisson", data=agingDotsTable))

cov.m1 <- vcovHC(m1, type="HC0")
std.err <- sqrt(diag(cov.m1))
r.est <- cbind(Estimate= coef(m1), "Robust SE" = std.err,
               "Pr(>|z|)" = 2 * pnorm(abs(coef(m1)/std.err), lower.tail=FALSE),
               LL = coef(m1) - 1.96 * std.err,
               UL = coef(m1) + 1.96 * std.err)

r.est

with(m1, cbind(res.deviance = deviance, df = df.residual,
               p = pchisq(deviance, df.residual, lower.tail=FALSE)))

m2 <- update(m1, . ~ . - name)
## test model differences with chi square test
anova(m2, m1, test="Chisq")

s <- deltamethod(list(~ exp(x1), ~ exp(x2), ~ exp(x3), ~ exp(x4)), 
                 coef(m1), cov.m1)

## exponentiate old estimates dropping the p values
rexp.est <- exp(r.est[, -3])
## replace SEs with estimates for exponentiated coefficients
rexp.est[, "Robust SE"] <- s

rexp.est

(s1 <- data.frame(numberOfStemCells = mean(agingDotsTable$numberOfStemCells),
                  name = factor(c("nodesClusterRandom", "nodesClusterRaw12Month", "nodesClusterRaw18Month"), levels =  c("nodesClusterRandom", "nodesClusterRaw12Month", "nodesClusterRaw18Month"))))

predict(m1, s1, type="response", se.fit=TRUE)

## calculate and store predicted values
agingDotsTable$phat <- predict(m1, type="response")

## order by program and then by math
agingDotsTable <- agingDotsTable[with(agingDotsTable, order(name, numberOfStemCells)), ]


agingDotsTable$name <- substr(agingDotsTable$name, 13, 30)
## create the plot
ggplot(agingDotsTable, aes(x = numberOfStemCells, y = phat, colour = name)) +
  geom_point(aes(y = meanOfDots), alpha=.5, position=position_jitter(h=.2)) +
  geom_line(size = 1) +
  labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
  scale_x_continuous(breaks = seq(17, 50, by=1)) + scale_y_continuous(breaks = seq(5, 50, by=5)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))

##What we really wanted! See if the classes are different

summary(m2 <- glm(meanOfDots ~ name + numberOfStemCells, family="poisson", data=agingDotsTable[agingDotsTable$name != "Random", ]))
m3 <- m3(numberOfStemCells, family="poisson", data=agingDotsTable)
## test model differences with chi square test
anova(m3, m1, test="Chisq")
