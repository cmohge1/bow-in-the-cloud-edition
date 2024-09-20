# Syuzhet calculations
install.packages("syuzhet")
library(syuzhet)
library(ggplot2)
library(tidytext)
library(dplyr)
library(zoo)
bow_v <- get_text_as_string(path_to_file = "~/Desktop/GitHub/bow-in-the-cloud-edition/edition/bow-in-the-cloud-plain-text.txt")
get_sentiment(bow_v)
bow_sentences_v <- get_sentences(bow_v)
bow_sentiments_v <- get_sentiment(bow_sentences_v)

plot(
  bow_sentiments_v,
  type = "l",
  xlab = "Book Time",
  ylab = "Sentiment",
  main = "Raw Sentiment Values in the Bow in the Cloud (published text, 1834)"
)

bow_window <- round(length(bow_sentiments_v)*.1) 
bow_rolled <- rollmean(bow_sentiments_v, k = bow_window)
bow_scaled <- rescale_x_2(bow_rolled)

plot(bow_scaled$x,
     bow_scaled$z,
     type="l",
     col="blue",
     xlab="Narrative Time",
     ylab="Emotional Valence",
     main = "Sentiment Values in the Bow in the Cloud (published text, 1834), with Rolling Means"
)

write.csv(bow_sentences_v, "~/Desktop/GitHub/bow-in-the-cloud-edition/edition/text-analysis/bow-sentences.csv")
write.csv(bow_sentiments_v, "~/Desktop/GitHub/bow-in-the-cloud-edition/edition/text-analysis/bow-sentiments.csv")

# comparing to other C19 narratives
prince_v <- get_text_as_string(path_to_file = "~/Desktop/GitHub/bow-in-the-cloud-edition/edition/text-analysis/")
get_sentiment(prince_v)
prince_sentences_v <- get_sentences(prince_v)
prince_sentiments_v <- get_sentiment(prince_sentences_v)

equiano_v <- get_text_as_string(path_to_file = "~/Desktop/GitHub/bow-in-the-cloud-edition/edition/text-analysis/equiano.txt")
get_sentiment(equiano_v)
equiano_sentences_v <- get_sentences(equiano_v)
equiano_sentiments_v <- get_sentiment(equiano_sentences_v)

prince_window <- round(length(prince_sentiments_v)*.1) 
prince_rolled <- rollmean(prince_sentiments_v, k = prince_window)
prince_scaled <- rescale_x_2(prince_rolled)

equiano_window <- round(length(equiano_sentiments_v)*.1) 
equiano_rolled <- rollmean(equiano_sentiments_v, k = equiano_window)
equiano_scaled <- rescale_x_2(equiano_rolled)

# comparative graph
plot(bow_scaled$x,
     bow_scaled$z,
     type="l",
     col="blue",
     xlab="Narrative Time",
     ylab="Emotional Valence",
     main = "The Bow in the Cloud (blue) compared to Mary Prince (red) and Ouladah Equiano (purple) with Rolling Means"
)
lines(prince_scaled$x, prince_scaled$z, col="red")
lines(equiano_scaled$x, equiano_scaled$z, col="purple")
