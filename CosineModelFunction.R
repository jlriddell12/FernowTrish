library(ggplot2);library(dplyr);library(readxl);library(tidyverse)

cosinemodel <- function(input_folder, output_folder) {
  
  # Get list of all Excel files in the input folder
  files <- list.files(input_folder, pattern = "\\.xlsx$", full.names = TRUE)
  
  # Define the start and reference dates
  startDate <- as.POSIXct("1900-01-01", tz = "UTC")
  refDate <- as.POSIXct("2023-01-01", tz = "UTC")
  ref <- as.numeric(difftime(refDate, startDate, units = 'days'))
  
  for (file in files) {
    
    # Read and preprocess data
    d <- read_excel(file)
    colnames(d) <- c('obs', 'date', 'temp')
    d <- d[, 1:3]
    d <- na.omit(d)
    d$dateNumeric <- as.numeric(difftime(d$date, startDate, units = "days"))
    d$decimalDate <- (d$dateNumeric - ref) / 365
    avTemp <- mean(d$temp)
    d$meanError <- (d$temp - avTemp)^2
    temp2 <- lm(temp ~ sin(2*pi*decimalDate) + cos(2*pi*decimalDate), data = d)
    d$model <- temp2$fitted.values
    d$modelError <- (d$temp - d$model)^2
    
    # Compute statistics
    Mean <- mean(d$model)
    Amplitude <- max(d$model) - Mean
    
    max_index <- which.max(d$model)
    
    datetime <- d$date[max_index]
    
    Phase <- as.numeric(format(datetime, "%j")) + 
      (as.numeric(format(datetime, "%H")) * 3600 + 
         as.numeric(format(datetime, "%M")) * 60 + 
         as.numeric(format(datetime, "%S"))) / (24 * 3600)
    
    RSSn <- sum(d$meanError)
    RSSc <- sum(d$modelError)
    Fstat <- ((RSSn - RSSc)/2)/(RSSc/(nrow(d)-3))
    pval <- pf(Fstat, 2, (nrow(d)-3), lower.tail = F)
    
    # Extract logger name
    logger_name <- sub(" \\d{4}-\\d{2}-\\d{2}.*", "", basename(file))
    logger_name <- sub("\\.xlsx$", "", logger_name)
    
    # Define the x position for annotation outside the graph
    x_position <- max(d$date) + 30 * 86400  # 30 days offset
    
    # Plot with Annotations Outside the Graph
    p <- ggplot(d, aes(y = temp, x = date)) +
      geom_point() +
      geom_point(aes(y = model, x = date, color = 'red'), show.legend = FALSE) +
      labs(x = 'Date', y = 'Temperature (C°)', color = 'Model', title = logger_name) +
      scale_x_datetime(expand = expansion(mult = c(0, 0.3)), date_breaks = "3 months", date_labels = "%b %Y") +
      theme_classic() +
      theme(plot.margin = unit(c(1, 5, 1, 1), "lines")) +
      annotate("text", x = x_position, y = max(d$temp), label = paste("Mean:", round(Mean, 2)), size = 4, color = "black", hjust = 0) +
      annotate("text", x = x_position, y = max(d$temp) /1.16, label = paste("Amplitude:", round(Amplitude, 2)), size = 4, color = "black", hjust = 0)+
      annotate("text", x = x_position, y= max(d$temp) /1.40, label = paste("Phase:",round(Phase,2)), size = 4, color = 'black', hjust = 0)+
      annotate("text", x = x_position, y = max(d$temp) /4, label = paste("F = ",round(Fstat,2)),size = 4, color = 'black', hjust = 0)+
      annotate("text", x = x_position, y = max(d$temp) /8, label = paste("p << ", pval), size = 4, color = 'black', hjust = 0)
    
    
    # Save the plot
    ggsave(filename = file.path(output_folder, paste0(logger_name, ".jpg")), plot = p, dpi = 500, height = 100, width = 200, units = 'mm')
  }
}

#The following are shared folders, you'll have to just change the 'User', or where it says patri

input_folder <- "C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\FernowTrish\\Compiled2"
output_folder <- "C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\FernowTrish\\Cosine Models"

cosinemodel(input_folder, output_folder)
