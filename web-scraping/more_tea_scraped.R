library(rvest)
library(dplyr)
library(tidyverse)
library(tidyr)
library(stringr)

MT_link <- "https://www.machiitea.com/collections/tea"
MT_page <- read_html(MT_link)

Type = MT_page %>% html_nodes(".product-grid--title a") %>% html_text()

MT_links <- MT_page %>% html_nodes(".product-grid--title a") %>%
  html_attr("href") %>% paste("https://www.machiitea.com", ., sep = "")

machi = MT_page %>% html_nodes(".product-grid--title a") %>% html_text()

get_machi_info <- function(MT_link) {
  MT_page = read_html(MT_link)
  MT_info = MT_page %>% html_nodes(".product-details-wrapper") %>%
    html_text() %>% paste(collapse = ",")
  return(MT_info)
}

machis = sapply(MT_links, FUN = get_machi_info)

#test_list <- list(as.list(greens), as.list(blacks), as.list(whites), as.list(oolongs), as.list(puerhs), as.list(fruits), as.list(herbals), as.list(rooibos), as.list(florals))
machi_df <-  data.frame(machis)

View(machi_df)

machi_df$machis

#tidy_machi <- pivot_longer(machi_df, everything())

machi_df_split <- strsplit(machis, split = " ")

machi_df <- machi_df %>% add_column("desc ription", "ingredients", "link", "color", "origin", "time", "flavor", "caffeine", "steeping", "similar", "benefit", "condition", "price", "availability")

machi_df_split <- str_split(machi_df$machis, "\n", simplify = TRUE)

machi_df_trim <- trimws(machi_df$machis, which = c("both"))
machi_trimdf <- as.data.frame(machi_df_trim)

machi_df <- machi_trimdf %>% add_column("description", "ingredients", "link", "color", "origin", "time", "flavor", "caffeine", "steeping", "similar", "benefit", "condition", "price", "availability")

write.csv(machi_df, "machi_tea_df_messy.csv")

#48

TH_link <- "https://theteahaus.com/all-teas/"
TH_page <- read_html(TH_link)

Type = TH_page %>% html_nodes(".flex_child a") %>% html_text()

TH_links <- TH_page %>% html_nodes(".flex_child a") %>%
  html_attr("href")
#261 

A_link <- "https://www.teabox.com/collections/tea"
A_page <- read_html(A_link)

Type = A_page %>% html_nodes(".product-item") %>% html_attr("data-handle")

A_links <- A_page %>% html_nodes(".product-item") %>%
  html_attr("data-handle") %>% paste("https://www.teabox.com/collections/tea/products/", ., sep = "")
#117

Nu_link <- "https://shop.numitea.com/Tea-Bags/c/NumiTeaStore@Teabag"
Nu_page <- read_html(H_link)

Type = Nu_page %>% html_nodes(".product_name") %>% html_text()

Nu_links <- Nu_page %>% html_nodes(".product_name") %>%
  html_attr("href") %>% paste("https://shop.numitea.com/Tea-Bags/c/NumiTeaStore@Teabag", ., sep = "")
#81

Y_link <- "https://yogiproducts.com/teas/all-yogi-teas/"
Y_page <- read_html(Y_link)

Type = Y_page %>% html_nodes(".the-title") %>% html_text()

Y_links <- Y_page %>% html_nodes(".btn-purple") %>%
  html_attr("href")
#45

V_link <- "https://www.vahdam.com/collections/all"
V_page <- read_html(V_link)

Type = V_page %>% html_nodes(".GridItem-title") %>% html_text()

V_links <- V_page %>% html_nodes(".GridItem-link") %>%
  html_attr("href") %>% paste("https://www.vahdam.com/collections/all", ., sep = "")

RI_link <- "https://rishi-tea.com/loose-leaf-tea-and-botanicals/?count=181"
RI_page <- read_html(RI_link)

Type = RI_page %>% html_nodes(".product-title") %>% html_text()

RI_links <- RI_page %>% html_nodes(".product-title") %>%
  html_attr("href") %>% paste("https://rishi-tea.com", ., sep = "")


D_link <- "https://www.davidstea.com/us_en/tea/shop-all/healing-herbals/?sz=all"
D_page <- read_html(D_link)

Type = D_page %>% html_nodes(".name-link") %>% html_text()

D_links <- D_page %>% html_nodes(".name-link") %>%
  html_attr("href") %>% paste("https://www.davidstea.com", ., sep = "")

M_link <- "https://www.davidstea.com/us_en/matcha/davidsmatcha/shop-all/?sz=all"
M_page <- read_html(M_link)

Type = M_page %>% html_nodes(".name-link") %>% html_text()

M_links <- M_page %>% html_nodes(".name-link") %>%
  html_attr("href")

#
tea_list <- list(as.list(greens), as.list(blacks), as.list(whites), as.list(oolongs), as.list(puerhs), as.list(fruits), as.list(herbals), as.list(rooibos), as.list(florals))
tea_df <- data.frame(tea_list)


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
