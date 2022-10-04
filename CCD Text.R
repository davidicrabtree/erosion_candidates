library(tidyverse)
library(here)

speeches <- read_csv(here("data", "CCD_text.csv"))

speeches <- speeches %>%
  rename(Speech = X7)

speeches %>%
  group_by(Politician) %>%
  count()

speeches <- speeches %>%
  filter(Politician == "Donald Trump")

speeches$Speech






# install.packages("tm")
# install.packages("SnowballC")
# install.packages("syuzhet")
library(tm)
library(SnowballC)
library(syuzhet)

text <- Corpus(VectorSource(speeches$Speech))

#Replacing "/", "@" and "|" with space
to_space <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
text <- tm_map(text, to_space, "/")
text <- tm_map(text, to_space, "@")
text <- tm_map(text, to_space, "\\|")
text <- tm_map(text, to_space, "<p>")

# Convert the text to lower case
text <- tm_map(text, content_transformer(tolower))
# Remove numbers
text <- tm_map(text, removeNumbers)
# Remove english common stopwords
text <- tm_map(text, removeWords, stopwords("english"))

# Remove your own stop word
# specify your custom stopwords as a character vector
# text <- tm_map(text, removeWords, c("s", "company", "team")) 

# Remove punctuations
text <- tm_map(text, removePunctuation)
# Eliminate extra white spaces
text <- tm_map(text, stripWhitespace)

# Text stemming - which reduces words to their root form
text <- tm_map(text, stemDocument)


# Build a term-document matrix
text_dtm <- TermDocumentMatrix(text)
dtm_m <- as.matrix(text_dtm)
# Sort by decreasing value of frequency
dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
trump_words <- data.frame(word = names(dtm_v),freq=dtm_v)
# Display the top 5 most frequent words
head(trump_words, 5)


findAssocs(text_dtm, terms = c("hillari"), corlimit = 0.25)	

#Wow... Empirical evidence linking Trump's mentions of Hillary to corruption, RIGGING the election . . . do other candidates talk about their opponents this way? 
#STEAL = 0.31



#Emotional Classification

sentiments <- get_nrc_sentiment(speeches$Speech)

speeches_sent <- cbind(speeches, sentiments)

speeches_sent[2, ]










