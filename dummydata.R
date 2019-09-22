shapes <- read.csv('shapes.csv')

library('sn')
# Air Quality
#colourScale <- c('#3498DB', '#229954','#9B59B6','#C0392B','#808B96')

areas <- unique(shapes$SA4_NAME16)

shapes$AirQuality <- 0
shapes$AirQuality[shapes$SA4_NAME16 %in% areas[c(15:27, 34:41, 47:50, 75:79, 82)]] <- 70
shapes$AirQuality[shapes$AirQuality == 0] <- sample(30:40, length(shapes$AirQuality[shapes$AirQuality == 0]), replace = TRUE)
shapes$AirQuality[53] <- 120

#shapes$AirQualityColour[shapes$AirQuality >= 0 & shapes$AirQuality < 33] <- colourScale[1]
#shapes$AirQualityColour[shapes$AirQuality >= 33 & shapes$AirQuality < 66] <- colourScale[2]
#shapes$AirQualityColour[shapes$AirQuality >= 66 & shapes$AirQuality < 99] <- colourScale[3]
#shapes$AirQualityColour[shapes$AirQuality >= 99 & shapes$AirQuality < 149] <- colourScale[4]
#shapes$AirQualityColour[shapes$AirQuality >= 149] <- colourScale[5]

# Temperature in degrees celcius
shapes$Temperature <- 0
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(1:10)]] <- 40
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(11:91)]] <- 10
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(93:161)]] <- 40
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(162:187)]] <- 40
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(188:203)]] <- 60
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(204:250)]] <- 30
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(251:300)]] <- 70
shapes$Temperature[shapes$SA4_NAME16 %in% areas[c(301:340)]] <- 40


#Humidity in %
shapes$Humidity <- 0
shapes$Humidity <- floor(rnorm(340, mean=100, sd=30))


#Wind in km/h
shapes$Wind <-0
shapes$Wind <- floor(rnorm(340, mean=50, sd=30))

#UV Index
shapes$UV <-0
shapes$UV <- floor(rnorm(340, mean=50, sd=10))

#Rainfall Scale in mm
shapes$Rain <-0
shapes$Rain <- floor(rnorm(340, mean=50, sd=10))

write.csv(shapes, 'dummydata.csv', row.names = FALSE)
