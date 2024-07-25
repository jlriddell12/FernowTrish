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
    
    # Compute statistics
    Mean <- mean(d$model)
    Amplitude <- max(d$model) - Mean
    
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
      annotate("text", x = x_position, y = max(d$temp) - 1.5, label = paste("Amplitude:", round(Amplitude, 2)), size = 4, color = "black", hjust = 0) +
      annotate("text", x = x_position, y = max(d$temp) - 3, label = paste("Phase:",""), size = 4, color = 'black', hjust = 0)
    
    # Save the plot
    ggsave(filename = file.path(output_folder, paste0(logger_name, ".jpg")), plot = p, dpi = 500, height = 100, width = 200, units = 'mm')
  }
}


input_folder <- "C:\\Users\\patri\\OneDrive - Chatham University\\2024 Summer\\Compiled2"
output_folder <- "C:\\Users\\patri\\OneDrive - Chatham University\\2024 Summer\\Cosine Models"

cosinemodel(input_folder, output_folder)
