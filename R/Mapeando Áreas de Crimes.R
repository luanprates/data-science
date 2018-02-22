# Instalação dos pacotes
install.packages("ggmap")
install.packages("ggplot2")
install.packages("downloader")
library(ggmap)
library(ggplot2)
library(downloader)

# Criando o dataframe
df <- read.csv("datasets/crimes.txt")
head(df)
str(df)
dim(df)

# Criando o plot
options(warn=-1)
mapa <- qmap("seattle", zoom = 11, source = "stamen", 
             maptype = "toner", darken = c(.3,"#BBBBBB"))
mapa

# Mapeando os dados 
mapa + geom_point(data = df, aes(x = Longitude, y = Latitude))

# Mapeando os dados e ajustando a escala
mapa + geom_point(data = df, aes(x = Longitude, y = Latitude), 
                  color = "dark green", alpha = .03, size = 1.1)

# Mapeando os dados e definindo uma camada de intensidade
mapa +
  stat_density2d(data = df, aes(x = Longitude, y = Latitude, 
                                color = ..density.., 
                                size = ifelse(..density..<= 1,0,..density..), 
                                alpha = ..density..), geom = "tile",contour = F) +
  scale_color_continuous(low = "orange", high = "red", guide = "none") +
  scale_size_continuous(range = c(0, 3), guide = "none") +
  scale_alpha(range = c(0,.5), guide = "none") +
  ggtitle("Crimes em Seattle") +
  theme(plot.title = element_text(family = "Trebuchet MS", size = 36, face = "bold", hjust = 0, color = "#777777")) 


# Big Data na Prática - Mapeando Áreas de Bikes
library(ggmap)
library(ggplot2)
 
# Gerando o dataframe
df2 <- read.csv("paris.txt", sep = ",", header = T) 
str(df)
dim(df)

# Criando o mapa
map.paris <- qmap("paris", source = "stamen", zoom = 12, maptype = "toner", darken = c(.3, "#BBBBBB")) 

# Unindo mapa e camada de dados
map.paris +
  geom_point(data = df2, aes(x = longitude, y = latitude, 
                             size = available_bike_stands, 
                             color = available_bike_stands), 
                             alpha = .9, na.rm = T) +
  scale_color_gradient(low = "#33CC33", high = "#003300", name = "Número de Bikes Disponíveis") +
  scale_size(range=c(1,11) , guide = "none") + 
  ggtitle("Número de Bikes Disponíveis em Paris") +
  theme(text = element_text(family = "Trebuchet MS", color = "#666666")) +
  theme(plot.title = element_text( size = 32, face = "bold", hjust = 0, vjust = .5))
