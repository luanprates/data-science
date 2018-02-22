# Instalação dos pacotes
install.packages("ggmap")
install.packages("ggplot2")
install.packages("downloader")
library(ggmap)
library(ggplot2)
library(downloader)

# Configurando o diretório de trabalho
# Coloque entre aspas o diretório de trabalho que você está usando no seu computador
setwd("~\GitHub\data-science\R")
getwd()

# Criando o dataframe
arquivo <- "http://dados.fortaleza.ce.gov.br/dataset/8e995f96-423c-41f3-ba33-9ffe94aec2a8/resource/de4e876a-ee24-4d6e-9722-db9dc454bbe6/download/policecalls.csv"
df1 <- read.csv(arquivo)
head(df1)
str(df1)
dim(df1)

# Criando o plot
options(warn=-1)
 mapa <- qmap("fortaleza", zoom = 12, source = "stamen", 
              maptype = "toner", darken = c(.3,"#BBBBBB"))

mapa

# Mapeando os dados 
mapa + geom_point(data = df1, aes(x = lng, y = lat))

# Mapeando os dados e ajustando a escala
mapa + geom_point(data = df1, aes(x = lng, y = lat), 
                  color = "dark green", alpha = .03, size = 1.1)

# Mapeando os dados e definindo uma camada de intensidade
mapa +
  stat_density2d(data = df1, aes(x = lng, y = lat, 
                                color = ..density.., 
                                size = ifelse(..density..<= 1,0,..density..), 
                                alpha = ..density..), geom = "point",contour = F) +
  scale_color_continuous(low = "orange", high = "red", guide = "none") +
  scale_size_continuous(range = c(0, 3), guide = "none") +
  scale_alpha(range = c(0,.5), guide = "none") +
  ggtitle("Crimes em Fortaleza") +
  theme(plot.title = element_text(family = "Trebuchet MS", size = 24, face = "bold", hjust = 0, color = "#777777")) 
