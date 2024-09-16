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

