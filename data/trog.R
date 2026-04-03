install.packages("tidyverse")
library(tidyverse)

# Load data directly from R package
library(mokken)
data(trog)

# Add id column (none in original data)
trog$id <- seq_len(nrow(trog))

# Melt to IRW long format
long_df <- trog %>%
  pivot_longer(cols = -id, names_to = "item", values_to = "resp") %>%
  drop_na(resp) %>%
  mutate(
    resp = as.integer(resp),
    item_letter = str_extract(item, "[a-z]+"),
    item_num = as.integer(str_extract(item, "[0-9]+")),
    item_family = as.integer(factor(item_letter, levels = sort(unique(item_letter))))
  ) %>%
  arrange(id, item_letter, item_num) %>%
  select(id, item, resp, item_family)

write.csv(long_df, "trog_brinchmann_2019.csv", row.names = FALSE)
cat("Saved: trog_brinchmann_2019.csv —", nrow(long_df), "rows,", ncol(long_df), "cols\n")
