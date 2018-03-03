#importando o dataset de treino
titanic.train <- read.csv(file = "datasets/train.csv", stringsAsFactors = F, header = T)

#importando o dataset de treino
titanic.test <- read.csv(file = "datasets/test.csv", stringsAsFactors = F, header = T)

#Criando uma flag para os datasets
titanic.train$IsTrain <- T
titanic.test$IsTrain <- F

#criando o campo Survived, que é o target, no datataset de test
titanic.test$Survived <- NA

#Juntando os dois datasets
titanic.full <-rbind(titanic.train, titanic.test)

#Esplorando os dados
str(titanic.full)
table(titanic.full$Embarked)
table(is.na(titanic.full$Age))
table(is.na(titanic.full$Fare))


#filtrando os valores sem registro de embarque e atribuindo "S"
titanic.full[titanic.full$Embarked == "", "Embarked"] <- "S"

#atribuindo a media global para os valores NA
age.median <- median(titanic.full$Age, na.rm = T)
titanic.full[is.na(titanic.full$Age), "Age"] <- age.median

fare.median <- median(titanic.full$Fare, na.rm = T)
titanic.full[is.na(titanic.full$Fare), "Fare"] <- fare.median

#categorizando os campos
titanic.full$Pclass <- as.factor(titanic.full$Pclass)
titanic.full$Sex <- as.factor(titanic.full$Sex)
titanic.full$Embarked <- as.factor(titanic.full$Embarked)

#separando os datasets
titanic.train <- titanic.full[titanic.full$IsTrain == T,]
titanic.test <- titanic.full[titanic.full$IsTrain == F,]

#categorizando o target
titanic.train$Survived <- as.factor(titanic.train$Survived)

#selecionando os campos que vamos usar
campos.relevantes <- "Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"

#preparndo a formula para usar no modelo
titanic.formula <- as.formula(campos.relevantes)

#Instalando e usando o Random Forest
#install.packages("randomForest")
library(randomForest)

#?randomForest

#treinando o modelo
titanic.model <- randomForest(formula = titanic.formula, 
                              data = titanic.train, 
                              ntree = 500, 
                              mtry = 3, 
                              nodesize = 0.01 * nrow(titanic.test))
#prevendo os sobreviventes
Survived <- predict(titanic.model, newdata = titanic.test)

#gerando a saida
PassengerId <- titanic.test$PassengerId
output.df <- as.data.frame(PassengerId)
output.df$Survived <- Survived

write.csv(output.df, file = "kaggle_submission2.csv", row.names = F)

