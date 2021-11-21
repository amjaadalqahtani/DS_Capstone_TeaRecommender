library(rvest)
library(dplyr)
library(tidyverse)
library(tidyr)

green_link <- "https://thefeelgoodtea.co/collections/green-tea"
green_page <- read_html(green_link)

green = green_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

green_links <- green_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_green_info <- function(green_link) {
  green_page = read_html(green_link)
  green_info = green_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(green_info)
}

greens <- sapply(green_links, FUN = get_green_info)

black_link <- "https://thefeelgoodtea.co/collections/black-tea"
black_page <- read_html(black_link)

black = black_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

black_links <- black_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_black_info <- function(black_link) {
  black_page = read_html(black_link)
  black_info = black_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(black_info)
}

blacks <- sapply(black_links, FUN = get_black_info)


white_link <- "https://thefeelgoodtea.co/collections/white-tea"
white_page <- read_html(white_link)

white = white_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

white_links <- white_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_white_info <- function(white_link) {
  white_page = read_html(white_link)
  white_info = white_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(white_info)
}

whites <- sapply(white_links, FUN = get_white_info)


oolong_link <- "https://thefeelgoodtea.co/collections/oolong-tea"
oolong_page <- read_html(oolong_link)

oolong = oolong_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

oolong_links <- oolong_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_oolong_info <- function(oolong_link) {
  oolong_page = read_html(oolong_link)
  oolong_info = oolong_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(oolong_info)
}

oolongs <- sapply(oolong_links, FUN = get_oolong_info)

puerh_link <- "https://thefeelgoodtea.co/collections/pu-erh-tea"
puerh_page <- read_html(puerh_link)

puerh = puerh_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

puerh_links <- puerh_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_puerh_info <- function(puerh_link) {
  puerh_page = read_html(puerh_link)
  puerh_info = puerh_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(puerh_info)
}

puerhs <- sapply(puerh_links, FUN = get_puerh_info)

fruit_link <- "https://thefeelgoodtea.co/collections/fruit-tea"
fruit_page <- read_html(fruit_link)

fruit = fruit_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

fruit_links <- fruit_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_fruit_info <- function(fruit_link) {
  fruit_page = read_html(fruit_link)
  fruit_info = fruit_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(fruit_info)
}

fruits <- sapply(fruit_links, FUN = get_fruit_info)


herbal_link <- "https://thefeelgoodtea.co/collections/herbal-tea"
herbal_page <- read_html(herbal_link)

herbal <- herbal_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

herbal_links <- herbal_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_herbal_info <- function(herbal_link) {
  herbal_page = read_html(herbal_link)
  herbal_info = herbal_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(herbal_info)
}

herbals <- sapply(herbal_links, FUN = get_herbal_info)

rooibos_link <- "https://thefeelgoodtea.co/collections/rooibos-tea"
rooibos_page <- read_html(rooibos_link)

rooibos = rooibos_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

rooibos_links <- rooibos_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_rooibos_info <- function(rooibos_link) {
  rooibos_page = read_html(rooibos_link)
  rooibos_info = rooibos_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(rooibos_info)
}

rooiboses <- sapply(rooibos_links, FUN = get_rooibos_info)

floral_link <- "https://thefeelgoodtea.co/collections/floral-tea"
floral_page <- read_html(floral_link)

floral = floral_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>% html_text()

floral_links <- floral_page %>% html_nodes("#shopify-section-collection-template .Heading a") %>%
  html_attr("href") %>% paste("https://thefeelgoodtea.co", ., sep = "")

get_floral_info <- function(floral_link) {
  floral_page = read_html(floral_link)
  floral_info = floral_page %>% html_nodes("#shopify-section-product-template .Rte") %>%
    html_text() %>% paste(collapse = ",")
  return(floral_info)
}

florals <- sapply(floral_links, FUN = get_floral_info)

tea_list <- list(as.list(greens), as.list(blacks), as.list(whites), as.list(oolongs), as.list(puerhs), as.list(fruits), as.list(herbals), as.list(rooibos), as.list(florals))
tea_df <- data.frame(tea_list)

tidy_tdf <- pivot_longer(tea_df, everything())

tidy_tdf_new_split <- strsplit(tidy_tdf$value, split = "\n")

tidy_tdf_new <- tidy_tdf %>% add_column("description", "ingredients", "link", "color", "origin", "time", "flavor", "caffeine", "steeping", "similar")

tidy_tdf_split <- strsplit(tidy_tdf_new$value, split = "\n")

tdf_by_split <- do.call(rbind.data.frame, tidy_tdf_new_split)

write.csv(tdf_by_split, "tdf_by_split.csv")
