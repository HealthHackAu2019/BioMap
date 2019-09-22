shapes <- read.csv('shapes.csv')

# Air Quality
colourScale <- c('#3498DB', '#229954','#9B59B6','#C0392B','#808B96')

areas <- unique(shapes$SA4_NAME16)

shapes$AirQuality <- 0
shapes$AirQuality[shapes$SA4_NAME16 %in% areas[c(15:27, 34:41, 47:50, 75:79, 82)]] <- 70
shapes$AirQuality[shapes$AirQuality == 0] <- sample(30:40, length(shapes$AirQuality[shapes$AirQuality == 0]), replace = TRUE)
shapes$AirQuality[53] <- 120

shapes$AirQualityColour[shapes$AirQuality >= 0 & shapes$AirQuality < 33] <- colourScale[1]
shapes$AirQualityColour[shapes$AirQuality >= 33 & shapes$AirQuality < 66] <- colourScale[2]
shapes$AirQualityColour[shapes$AirQuality >= 66 & shapes$AirQuality < 99] <- colourScale[3]
shapes$AirQualityColour[shapes$AirQuality >= 99 & shapes$AirQuality < 149] <- colourScale[4]
shapes$AirQualityColour[shapes$AirQuality >= 149] <- colourScale[5]


write.csv(shapes, 'dummydata.csv', row.names = FALSE)
