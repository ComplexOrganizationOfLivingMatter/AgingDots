require(ggplot2)
require(sandwich)
require(msm)
require(R.matlab)
library(readr)
require(gdata)
 
multFactors <- c(1,2,10,5)
numAnimals <- 4
path2read20mc <- "D:/Pedro/AgingDots/resultsByAnimal/NSCs BrdU/clusterDistance/3m/BrdUStemCellsInXThresholdDistanceClusters/statistic/20mc/"
path2read50mc <- "D:/Pedro/AgingDots/resultsByAnimal/NSCs BrdU/clusterDistance/3m/BrdUStemCellsInXThresholdDistanceClusters/statistic/50mc/"
path2write <- "D:/Pedro/AgingDots/resultsByAnimal/NSCs BrdU/clusterDistance/3m/BrdUStemCellsInXThresholdDistanceClusters/statistic/"

pathSample20mc = list.files(path=path2read20mc,pattern="*.csv")
pathSample50mc = list.files(path=path2read50mc,pattern="*.csv")

hwJitter=0.1;

for(i in 1:length(multFactors)){
  
  for(j in 1:numAnimals){
    
    if(i<numAnimals){
      #loading and doing statitic with clustering 20mc
      microns<-20*multFactors[i]
      agingDotsTable20mc <- read_csv(paste(path2read20mc,"animal ",j,"/20mc_X",multFactors[i],".csv",sep = ""))
      agingDotsTable20mc$name[agingDotsTable20mc$name=="random"] <- "1random"
      agingDotsTable20mc$stemCellsInCluster = as.integer(agingDotsTable20mc$stemCellsInCluster)
      dataStatisticPerAnimal <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable20mc))
      out<-capture.output(dataStatisticPerAnimal)
      write.table(out, file =paste(path2write,"animal ",j,"/statisticAnimal_", j,"_clusterDistance",microns,"mc.txt",sep=""))
      
      
      agingDotsTable20mc$phat <- predict(m1, type="response")
      ggplot(agingDotsTable20mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
        geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
        geom_line(size = 1) +
        labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
        scale_x_continuous(breaks = seq(0, 5, by=1)) + scale_y_continuous(breaks = seq(0, 5, by=1)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
      
      ggsave(paste(path2write,"animal ",j,"/statisticAnimal_", j,"_clusterDistance",microns, "mc.tiff",sep=""),
              dpi = 300)
      
      
      
    }
    
    #loading and doing statitic with clustering 50mc
    microns<-50*multFactors[i]
    agingDotsTable50mc <- read_csv(paste(path2read50mc,"animal ",j,"/50mc_X",multFactors[i],".csv",sep = ""))
    agingDotsTable50mc$stemCellsInCluster = as.integer(agingDotsTable50mc$stemCellsInCluster)
    agingDotsTable50mc$name[agingDotsTable50mc$name=="random"] <- "1random"
    dataStatisticPerAnimal <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable50mc))
    out<-capture.output(dataStatisticPerAnimal)
    write.table(out, file =paste(path2write,"animal ",j,"/statisticAnimal_", j,"_clusterDistance",microns, "mc.txt",sep=""))
    
    
    agingDotsTable50mc$phat <- predict(m1, type="response")
    ggplot(agingDotsTable50mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
      geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
      geom_line(size = 1) +
      labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
      scale_x_continuous(breaks = seq(0, 5, by=1)) + scale_y_continuous(breaks = seq(0, 5, by=1)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
    
    ggsave(paste(path2write,"animal ",j,"/statisticAnimal_", j,"_clusterDistance",microns, "mc.tiff",sep=""),
           dpi = 300)
  }
  
  ##anova 20mc
  if(i<4){
    microns<-20*multFactors[i]
    agingDotsTable20mc <- read_csv(paste(path2read20mc,"20mc_X",multFactors[i],".csv",sep = ""))
    agingDotsTable20mc$stemCellsInCluster = as.integer(agingDotsTable20mc$stemCellsInCluster)
    agingDotsTable20mc$name[agingDotsTable20mc$name=="random"] <- "1random"
    dataStatistic20mc <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable20mc))
    out<-capture.output(dataStatistic20mc)
    write.table(out, file =paste(path2write,"clusterDistance",microns,"mc.txt",sep=""))
    
    ##show and save figure
    agingDotsTable20mc$phat <- predict(m1, type="response")
    ggplot(agingDotsTable20mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
      geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
      geom_line(size = 1) +
      labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
      scale_x_continuous(breaks = seq(0, 5, by=1)) + scale_y_continuous(breaks = seq(0, 5, by=1)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
    
    ggsave(paste(path2write,"clusterDistance",microns,"mc.tiff",sep=""),
           dpi = 300)
    
    
    
  }
  
  
  
  
  ##anova 50mc
  microns<-50*multFactors[i]
  agingDotsTable50mc <- read_csv(paste(path2read50mc,"50mc_X",multFactors[i],".csv",sep = ""))
  agingDotsTable50mc$stemCellsInCluster = as.integer(agingDotsTable50mc$stemCellsInCluster)
  agingDotsTable50mc$name[agingDotsTable50mc$name=="random"] <- "1random"
  dataStatistic50mc <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable50mc))
  out<-capture.output(dataStatistic50mc)
  write.table(out, file =paste(path2write,"clusterDistance",microns,"mc.txt",sep=""))
  
  ##show and save figure
  agingDotsTable50mc$phat <- predict(m1, type="response")
  ggplot(agingDotsTable50mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
    geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
    geom_line(size = 1) +
    labs(x = "Total number of stem cells", y = "Expected number of stem cells in clusters", colour = "Classes") + theme_classic() + 
    scale_x_continuous(breaks = seq(0, 5, by=1)) + scale_y_continuous(breaks = seq(0, 5, by=1)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
  
  ggsave(paste(path2write,"clusterDistance",microns,"mc.tiff",sep=""),
         dpi = 300)
  
}