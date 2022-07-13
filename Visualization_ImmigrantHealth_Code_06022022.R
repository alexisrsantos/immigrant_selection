install.packages('haven')
install.packages('questionr')  
install.packages('tigerstats')

rm(list = ls()) 

library(haven)
library(ggplot2)
library(questionr)
library(tigerstats)
library(dplyr)

setwd("~/immigrant_selection/")

#To reproduce this code you will need the a_adult file and the d_adult
#Available through https://nis.princeton.edu/

#Read in & merge data (New Immigrant Survey 2001 Section A & D)
nis_a <- read_dta("Data/a_adult.dta")  #Reads Demographic File
nis_a$PU_ID <- as.numeric(nis_a$PU_ID) #Created ID as numeric
nis_d <- read_dta("Data/d_adult.dta")  #Reads Health File
nis <- merge(nis_a, nis_d, by="PU_ID") #Merges the files by ID

#Generating new health vars that collapse fair & poor health
nis$health <- as.factor(ifelse(nis$d1==1, 'Excellent', 
                        ifelse(nis$d1==2, 'Very Good',
                        ifelse(nis$d1==3, 'Good', 
                        ifelse(nis$d1>3,'Fair/Poor', 'Missing')))))

#Comparative health measure - original categories
nis$healthhome_original <- as.factor(ifelse(nis$d112==1, 'Excellent', 
                              ifelse(nis$d112==2, 'Very Good',
                              ifelse(nis$d112==3, 'Good', 
                              ifelse(nis$d112>3,'Fair/Poor', 'Missing')))))

#Comparative health measure - recoded
nis$healthhome <- as.factor(ifelse(nis$d112<3, 'Better',
                            ifelse(nis$d112==3, 'Same', 
                            ifelse(nis$d112>3,'Worse', 'Missing'))))

#Reordering categories
nis$health <- factor(nis$health, levels = c("Excellent", "Very Good", "Good", "Fair/Poor"))
nis$healthhome_original <- factor(nis$healthhome_original, levels = c("Fair/Poor", "Good", "Very Good", "Excellent"))
nis$healthhome <- factor(nis$healthhome, levels = c("Worse", "Same", "Better"))

#Limiting data to top five countries of origin
nis$country <- as.factor(ifelse(nis$A9Amo==44, 'China', 
                         ifelse(nis$A9Amo==65, 'El Salvador',
                         ifelse(nis$A9Amo==98, 'India',
                         ifelse(nis$A9Amo==135,'Mexico',
                         ifelse(nis$A9Amo==164,'Philippines', 'Other'))))))

#Reordering countries of origin by sample size  
nis$country<- factor(nis$country, levels = c("China", "El Salvador", "Philippines", "India", "Mexico"))

#Remove observations with missing values in variables of interest
#Only keeps variables required for the visualization (select)
nis <- subset(nis, health!='Missing' & health!='NA' & 
                   healthhome!='Missing' & healthhome!='NA' &
                   healthhome_original!='Missing' & healthhome_original!='NA' &     
                   country!='Other' & country!='NA', 
                   select=c(health, healthhome, healthhome_original, country, niswgtsamp1))

#Producing a weighted table, used for visualization
nis_weighted <- xtabs(niswgtsamp1 ~  country + healthhome + health, data = nis)

#Turning it into a data frame for ggplot
nis_weighted<-as.data.frame(nis_weighted)

#Creates the Figure and stores it in an object called ggp
ggp <- ggplot (nis_weighted, aes(x=country, y=Freq, fill = healthhome)) +
                 geom_bar(position = "fill", stat = "identity", width = 0.6) +
                 xlab("Home country") +
                 ylab("Proportion") +
                 ggtitle("Among immigrants whose overall self-rated health is...") + 
                 scale_y_continuous(breaks = c(0, .5, 1), labels = c("0", ".5", "1")) +
                 labs(fill="Perception of health compared with those in home country") +
                 coord_flip() +
                 theme_minimal() +
                 scale_fill_manual(values=c("#29AF7FFF", "#FFCC00", "#CC6600"), 
                                   breaks=c('Better', 'Same', 'Worse')) +
                 facet_grid(~health) +
                 theme(panel.spacing = unit(1.5, "lines"), 
                       axis.text=element_text(size=12),
                       strip.text.x = element_text(size = 12), 
                       axis.title.y = element_text(size=12, vjust = +5),
                       axis.title.x = element_text(size=12, vjust = -1),
                       plot.title = element_text(size=13, hjust = +0.5),
                       legend.text=element_text(size=11),
                       legend.title=element_text(size=13),
                       plot.margin = margin(t=2, r=0.9, b=0.75, l=1.2, unit="cm"),
                       legend.position=c(0.45, 1.32),
                       legend.direction = "horizontal")

#Showing the figure
ggp



###### Supplemental figure: showing detailed categories for the comparative health variable #####

#Producing a weighted table, used for visualization
nis_weighted_original <- xtabs(niswgtsamp1 ~  country + healthhome_original + health, data = nis)

#Turning it into a data frame for ggplot
nis_weighted_original <-as.data.frame(nis_weighted_original)

#Creates the Figure and stores it in an object called ggp
ggp_detailed <- ggplot (nis_weighted_original, aes(x=country, y=Freq, fill = healthhome_original)) +
                 geom_bar(position = "fill", stat = "identity", width = 0.6) +
                 xlab("Home country") +
                 ylab("Proportion") +
                 ggtitle("Among immigrants whose overall self-rated health is...") + 
                 scale_y_continuous(breaks = c(0, .5, 1), labels = c("0", ".5", "1")) +
                 labs(fill="Perception of health compared with those in home country") +
                 coord_flip() +
                 theme_minimal() +
                 scale_fill_manual(values=c("darkgreen", "yellowgreen", "#FFCC00", "#CC6600"), 
                                   breaks=c('Excellent', 'Very Good', 'Good', 'Fair/Poor')) +
                 facet_grid(~health) +
                 theme(panel.spacing = unit(1.5, "lines"), 
                       axis.text=element_text(size=12),
                       strip.text.x = element_text(size = 12), 
                       axis.title.y = element_text(size=12, vjust = +5),
                       axis.title.x = element_text(size=12, vjust = -1),
                       plot.title = element_text(size=13, hjust = +0.5),
                       legend.text=element_text(size=11),
                       legend.title=element_text(size=13),
                       plot.margin = margin(t=2, r=0.9, b=0.75, l=1.2, unit="cm"),
                       legend.position=c(0.45, 1.32),
                       legend.direction = "horizontal")

#Shows the figure
ggp_detailed
