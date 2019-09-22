#Updated Rstudio version, updated rtools https://cran.r-project.org/bin/windows/Rtools/
#install.packages("plotly") #https://plot.ly/r/getting-started/
#install.packages("ggplot2", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
library(plotly)
packageVersion('plotly')

# Specify route and attribute to plot
routeNum = 1;

# Load csv data and extract variables of interest
data = read.csv('ALLRoutes.csv',header=TRUE, sep=",");
#head(data,n=2);
routeRows = data$Route.Num==routeNum;
routeRows = data[routeRows,];
HR = routeRows$Heart.Rate..bpm.
long = routeRows$Longitude..Deg.
lat = routeRows$Latitude..Deg.
alt = routeRows$Altitude..m.
speed = routeRows$Speed..km.h.

# Plotting
x <- long
y <- lat
z <- HR
c <- c()

for (i in 1:length(x)) {
  #r <- 20 * cos(i / 20)
  #x <- c(x, r * cos(i))
  #y <- c(y, r * sin(i))
  #z <- c(z, i)
  c <- c(c, i)
}

plotData <- data.frame(x, y, z, c)

p <- plot_ly(plotData, x = ~x, y = ~y, z = ~z, type = 'scatter3d', mode = 'lines+markers',
             line = list(width = 6, color = ~c, colorscale = 'Viridis'),
             marker = list(size = 3.5, color = ~c, colorscale = 'Greens', cmin = -20, cmax = 50))
#plot(HR,long,lat)
#summary(data)
#plot(1:4,2:16)
