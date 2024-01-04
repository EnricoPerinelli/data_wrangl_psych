
# Load libraries and dataset -----------------------------------------------


library(tidyverse)
library(magrittr)
library(psych)

my_bfi <- bfi  # used for longer way
my_bfi2 <- bfi # used for reduced way


# Reverse items -----------------------------------------------------------


## Longer way -------------------------------------------------------------


my_bfi %<>%
  mutate(A1_rev = 7 - A1,
         C4_rev = 7 - C4,
         C5_rev = 7 - C5,
         E1_rev = 7 - E1,
         E2_rev = 7 - E2,
         O2_rev = 7 - O2,
         O5_rev = 7 - O5)


## Reduced way ------------------------------------------------------------


rev_item <- c("A1", "C4", "C5", "E1", "E2", "O2", "O5")

for (i in seq_along(rev_item)) {
  my_bfi2 %<>%
    mutate(
      !!sym(paste0(rev_item[i], "_rev")) := 7 - !!sym(rev_item[i])
      )
}



# Compute Composite scores ------------------------------------------------

## Longer way -------------------------------------------------------------

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


## Reduced way -------------------------------------------------------------

# Store in a list (a) the name of the composite scores to be created (b) their corresponding items 

composite_scores <- list(
  Agreeableness     = c("A1_rev", "A2", "A3", "A4", "A5"),
  Conscientiousness = c("C1", "C2", "C3", "C4_rev", "C5_rev"),
  Extraversion      = c("E1_rev", "E2_rev", "E3", "E4", "E5"),
  Neuroticism       = c("N1", "N2", "N3", "N4", "N5"),
  Openness          = c("O1", "O2_rev", "O3", "O4", "O5_rev")
)

# Create a function to calculate composite scores

calculate_composite <- function(data, list) {
  for (compositeScore in names(list)) {
    data <- data %>% 
      mutate({{compositeScore}} := rowMeans(select(., list[[compositeScore]]), na.rm = TRUE))
  }
  return(data)
}


# Use the above function

my_bfi2 <- calculate_composite(
  data = my_bfi2,
  list = composite_scores
  )


# Below, the same procedure but using only a for-loop instead of creating a customized function

for (new_comp_scores in names(composite_scores)) {
  
  my_bfi2 <- my_bfi2 %>% 
    mutate({{new_comp_scores}} := rowMeans(select(., composite_scores[[new_comp_scores]]), na.rm = TRUE))
  
}



# Compute Composite scores with objects

my_bfi2 %<>%
  mutate(agr = rowMeans(.[c(!!composite_scores$Agreeableness)]),
         con = rowMeans(.[c(!!composite_scores$Conscientiousness)]),
         ex = rowMeans(.[c(!!composite_scores$Extraversion)]),
         neu = rowMeans(.[c(!!composite_scores$Neuroticism)]),
         op = rowMeans(.[c(!!composite_scores$Openness)])
  )


# Compute alpha -----------------------------------------------------------


my_bfi %>% select(A1_rev, A2, A3, A4, A5)     %>% psych::alpha(.) # alpha for Agreeableness
my_bfi %>% select(C1, C2, C3, C4_rev, C5_rev) %>% psych::alpha(.) # alpha for Conscientiousness
my_bfi %>% select(E1_rev, E2_rev, E3, E4, E5) %>% psych::alpha(.) # alpha for Extraversion
my_bfi %>% select(N1, N2, N3, N4, N5)         %>% psych::alpha(.) # alpha for Neuroticism
my_bfi %>% select(O1, O2_rev, O3, O4, O5_rev) %>% psych::alpha(.) # alpha for Openness


# Compute alpha by means of object ----------------------------------------


my_bfi %>% select(!!composite_scores$Agreeableness)     %>% psych::alpha(.) # alpha for Agreeableness
my_bfi %>% select(!!composite_scores$Conscientiousness) %>% psych::alpha(.) # alpha for Conscientiousness
my_bfi %>% select(!!composite_scores$Extraversion)      %>% psych::alpha(.) # alpha for Extraversion
my_bfi %>% select(!!composite_scores$Neuroticism)       %>% psych::alpha(.) # alpha for Neuroticism
my_bfi %>% select(!!composite_scores$Openness)          %>% psych::alpha(.) # alpha for Openness



# Function to extract alpha -----------------------------------------------

my_alpha <- function(data, items) {
  data %>% 
    select(all_of(items)) %>% 
    psych::alpha() %>% 
    pluck(., "total", "raw_alpha") %>%
    round(., 2) %>% 
    print()
}

# Example with Neuroticism

my_alpha(data = my_bfi, items = c("N1", "N2", "N3", "N4", "N5"))  # Way 1
my_alpha(data = my_bfi, items = composite_scores$Neuroticism)     # Way 2

# Iterate

purrr::map(composite_scores, ~ my_alpha(my_bfi2, .))


# Save workspace --------------------------------------------------------


save.image("./data_wra.RData")
