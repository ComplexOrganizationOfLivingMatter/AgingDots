require(ggplot2)
require(sandwich)
require(msm)
require(R.matlab)
library(readr)
require(gdata)

path2read <- "D:/Pedro/AgingDots/resultsByAnimal/Total NSCs/clusterDistance/"

pathSample = list.files(path=path2read,pattern="*.csv")

hwJitter=0.1;

for(j in 1:length(pathSample)){
  
  #loading and doing statitic with clustering 20mc
  agingDotsTable20mc <- read_csv(paste(path2read,pathSample[j],sep = ""))
  agingDotsTable20mc$stemCellsInCluster = as.integer(agingDotsTable20mc$stemCellsInCluster)
  name2save<-substring(pathSample[j], 1,14)
  
  
  
  dataStatisticPerAnimal <- summary(m1 <- glm(stemCellsInCluster ~ name + numberOfStemCells, family="poisson", data=agingDotsTable20mc))
  out<-capture.output(dataStatisticPerAnimal)
  write.table(out, file =paste(path2read,"statistic_", name2save,".txt",sep=""))
  
  
  agingDotsTable20mc$phat <- predict(m1, type="response")
  ggplot(agingDotsTable20mc, aes(x = numberOfStemCells, y = phat, colour = name)) +
    geom_point(aes(y = stemCellsInCluster), alpha=.5, position=position_jitter(w=hwJitter, h=hwJitter)) +
    geom_line(size = 1) +
    labs(x = "Total number of stem cells", y = "Number of stem cells in clusters", colour = "Classes") + theme_classic() + 
    scale_x_continuous(breaks = seq(0, 135, by=2)) + scale_y_continuous(breaks = seq(0, 135, by=2)) + theme(panel.grid.major.y = element_line(size = 0.05, colour = "grey80"), axis.text=element_text(size=13), axis.title=element_text(size=13,face="bold"))
  
  ggsave(paste(path2read,"/statistic_",name2save,".tiff",sep=""),
         dpi = 300)
}



