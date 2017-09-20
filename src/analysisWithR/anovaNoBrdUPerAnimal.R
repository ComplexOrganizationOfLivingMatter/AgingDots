require(ggplot2)
require(sandwich)
require(msm)
require(R.matlab)
library(readr)
require(gdata)

numAnimals <- 4
path2read <- "D:/Pedro/AgingDots/resultsByAnimal/NSCs BrdU/clusterDistance/3m/noBrdUStemCellsInCluster/statistic/"

pathSample = list.files(path=path2read,pattern="*.csv")

hwJitter=0.1;

for(j in 1:numAnimals){
  

    #loading and doing statitic with clustering 20mc
    agingDotsTable20mc <- read_csv(paste(path2read,"animal ",j,"/20mc.csv",sep = ""))
    agingDotsTable20mc$stemCellsInCluster = as.integer(agingDotsTable20mc$stemCellsInCluster)
    dataStatisticPerAnimal <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable20mc))
    out<-capture.output(dataStatisticPerAnimal)
    write.table(out, file =paste(path2read,"animal ",j,"/statisticAnimal_", j,"_clusterDistance20mc.txt",sep=""))
    
    
    agingDotsTable20mc$phat <- predict(m1, type="response")
    ggplot(agingDotsTable20mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
      geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
      geom_line(size = 1) +
      labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
      scale_x_continuous(breaks = seq(0, 135, by=10)) + scale_y_continuous(breaks = seq(0, 135, by=10)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
    
    ggsave(paste(path2read,"animal ",j,"/statisticAnimal_", j,"_clusterDistance20mc.tiff",sep=""),
           dpi = 300)
    
    
  #loading and doing statitic with clustering 50mc
  agingDotsTable50mc <- read_csv(paste(path2read,"animal ",j,"/50mc.csv",sep = ""))
  agingDotsTable50mc$stemCellsInCluster = as.integer(agingDotsTable50mc$stemCellsInCluster)
  dataStatisticPerAnimal <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable50mc))
  out<-capture.output(dataStatisticPerAnimal)
  write.table(out, file =paste(path2read,"animal ",j,"/statisticAnimal_", j,"_clusterDistance50mc.txt",sep=""))
  
  
  agingDotsTable50mc$phat <- predict(m1, type="response")
  ggplot(agingDotsTable50mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
    geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
    geom_line(size = 1) +
    labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
    scale_x_continuous(breaks = seq(0, 135, by=10)) + scale_y_continuous(breaks = seq(0, 135, by=10)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
  
  ggsave(paste(path2read,"animal ",j,"/statisticAnimal_", j,"_clusterDistance50mc.tiff",sep=""),
         dpi = 300)
}

    ##anova 20mc

    agingDotsTable20mc <- read_csv(paste(path2read,"20mc.csv",sep = ""))
    agingDotsTable20mc$stemCellsInCluster = as.integer(agingDotsTable20mc$stemCellsInCluster)
    dataStatistic20mc <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable20mc))
    out<-capture.output(dataStatistic20mc)
    write.table(out, file =paste(path2read,"clusterDistance20mc.txt",sep=""))
    
    ##show and save figure
    agingDotsTable20mc$phat <- predict(m1, type="response")
    ggplot(agingDotsTable20mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
      geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
      geom_line(size = 1) +
      labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
      scale_x_continuous(breaks = seq(0, 135, by=10)) + scale_y_continuous(breaks = seq(0, 135, by=10)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
    
    ggsave(paste(path2read,"clusterDistance20mc.tiff",sep=""),
           dpi = 300)
  
      
    ##anova 50mc
    agingDotsTable50mc <- read_csv(paste(path2read,"50mc.csv",sep = ""))
    agingDotsTable50mc$stemCellsInCluster = as.integer(agingDotsTable50mc$stemCellsInCluster)
    dataStatistic50mc <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable50mc))
    out<-capture.output(dataStatistic50mc)
    write.table(out, file =paste(path2read,"clusterDistance50mc.txt",sep=""))
    
    ##show and save figure
    agingDotsTable50mc$phat <- predict(m1, type="response")
    ggplot(agingDotsTable50mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
      geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
      geom_line(size = 1) +
      labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
      scale_x_continuous(breaks = seq(0, 135, by=10)) + scale_y_continuous(breaks = seq(0, 135, by=10)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
    
    ggsave(paste(path2read,"clusterDistance50mc.tiff",sep=""),
           dpi = 300)
      
