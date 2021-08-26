library(tidyverse)
library(magrittr)
library(psych)

my_bfi <- bfi

################################### Reverse items

my_bfi %<>% 
  mutate(A1_rev = 7 - A1,
         C4_rev = 7 - C4,
         C5_rev = 7 - C5,
         E1_rev = 7 - E1,
         E2_rev = 7 - E2,
         O2_rev = 7 - O2,
         O5_rev = 7 - O5)


################################### Object for each composite score

Agreeableness     <- c("A1_rev", "A2", "A3", "A4", "A5")
Conscientiousness <- c("C1", "C2", "C3", "C4_rev", "C5_rev")
Extraversion      <- c("E1_rev", "E2_rev", "E3", "E4", "E5")
Neuroticism       <- c("N1", "N2", "N3", "N4", "N5")
Openness          <- c("O1", "O2_rev", "O3", "O4", "O5_rev")


################################### Compute Composite scores

my_bfi %<>%
  rowwise() %>%
  mutate(
    Agreeableness     = mean(c(A1_rev, A2, A3, A4, A5),     na.rm = T),
    Conscientiousness = mean(c(C1, C2, C3, C4_rev, C5_rev), na.rm = T),
    Extraversion      = mean(c(E1_rev, E2_rev, E3, E4, E5), na.rm = T),
    Neuroticism       = mean(c(N1, N2, N3, N4, N5),         na.rm = T),
    Openness          = mean(c(O1, O2_rev, O3, O4, O5_rev), na.rm = T)
          ) %>%
  ungroup()


################################### Compute Composite scores with objects

my_bfi %<>% mutate(agr = rowMeans(.[c(!!Agreeableness)]),
                   con = rowMeans(.[c(!!Conscientiousness)]),
                   ex = rowMeans(.[c(!!Extraversion)]),
                   neu = rowMeans(.[c(!!Neuroticism)]),
                   op = rowMeans(.[c(!!Openness)])
                   )


################################### Compute alpha

my_bfi %>% select(A1_rev, A2, A3, A4, A5)     %>% psych::alpha(.) # alpha for Agreeableness
my_bfi %>% select(C1, C2, C3, C4_rev, C5_rev) %>% psych::alpha(.) # alpha for Conscientiousness
my_bfi %>% select(E1_rev, E2_rev, E3, E4, E5) %>% psych::alpha(.) # alpha for Extraversion
my_bfi %>% select(N1, N2, N3, N4, N5)         %>% psych::alpha(.) # alpha for Neuroticism
my_bfi %>% select(O1, O2_rev, O3, O4, O5_rev) %>% psych::alpha(.) # alpha for Openness


################################### Compute alpha by means of object

my_bfi %>% select(!!Agreeableness)     %>% psych::alpha(.) # alpha for Agreeableness
my_bfi %>% select(!!Conscientiousness) %>% psych::alpha(.) # alpha for Conscientiousness
my_bfi %>% select(!!Extraversion)      %>% psych::alpha(.) # alpha for Extraversion
my_bfi %>% select(!!Neuroticism)       %>% psych::alpha(.) # alpha for Neuroticism
my_bfi %>% select(!!Openness)          %>% psych::alpha(.) # alpha for Openness


################################# Extract alpha

my_bfi %>% select(!!Agreeableness)     %>% psych::alpha(.) %>% pluck(., "total", "raw_alpha") %>% round(., 3)
my_bfi %>% select(!!Conscientiousness) %>% psych::alpha(.) %>% pluck(., "total", "raw_alpha") %>% round(., 3)
my_bfi %>% select(!!Extraversion)      %>% psych::alpha(.) %>% pluck(., "total", "raw_alpha") %>% round(., 3)
my_bfi %>% select(!!Neuroticism)       %>% psych::alpha(.) %>% pluck(., "total", "raw_alpha") %>% round(., 3)
my_bfi %>% select(!!Openness)          %>% psych::alpha(.) %>% pluck(., "total", "raw_alpha") %>% round(., 3)










## QUI SOTTO INVECE QUELLO CHE VORREI FARE IDEALMENTE PER COMPOSITE SCORES E ALPHA

# 1) creare oggetti con nomi item per ogni composite scores

Agreeableness     <- c("A1_rev", "A2", "A3", "A4", "A5")
Conscientiousness <- c("C1", "C2", "C3", "C4_rev", "C5_rev")
Extraversion      <- c("E1_rev", "E2_rev", "E3", "E4", "E5")
Neuroticism       <- c("N1", "N2", "N3", "N4", "N5")
Openness          <- c("O1", "O2_rev", "O3", "O4", "O5_rev")
                       
# 2) creare un oggetto con tutti gli oggetti dei composite scores

my_comp_scores <- c("Agreeableness", "Conscientiousness", "Extraversion", "Neuroticism", "Openness")

# 3) "ciclizzare" la fase "Compute Composite scores"

for(i in 1:length(my_comp_scores)) {
  my_bfi %<>%
      rowwise() %>%
      mutate(
        paste0(my_comp_scores[i]) = mean(my_comp_scores[i], na.rm = T)
      ) %>%
      ungroup()
    }


# 4) "ciclizzare" la fase "Compute alpha"
  
  for(i in 1:length(my_comp_scores)) {
    my_bfi %>% select(my_comp_scores[i]) %>% psych::alpha(.)
  }


# esempio di apply per frequenze
apply(my_bfi[c("O1", "O2")], 2, table)


save.image("./data_wra.RData")
