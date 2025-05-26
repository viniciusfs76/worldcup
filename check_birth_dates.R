# Load the data
load("data-raw/Wikipedia-data/wikipedia_squads.RData") # This loads the 'wikipedia_squads' dataframe

# Check for player_ids with multiple unique birth_dates
library(dplyr)

inconsistent_birth_dates <- wikipedia_squads |>
  group_by(player_id) |>
  summarize(
    unique_birth_dates_count = n_distinct(birth_date),
    birth_dates_list = paste(unique(birth_date), collapse = "; ")
  ) |>
  filter(unique_birth_dates_count > 1) |>
  arrange(desc(unique_birth_dates_count))

# Print the results
if (nrow(inconsistent_birth_dates) > 0) {
  print("Players with inconsistent birth dates found:")
  print(inconsistent_birth_dates)
} else {
  print("No players found with inconsistent birth dates (i.e., each player_id has only one unique birth_date).")
}

# As an additional check, let's see if any player_id is NA,
# as that could also cause issues in the group_by in build-database.R
na_player_ids <- wikipedia_squads |>
  filter(is.na(player_id)) |>
  summarize(count = n())

if (na_player_ids$count > 0) {
  print(paste("Found", na_player_ids$count, "rows with NA player_id."))
} else {
  print("No rows with NA player_id found.")
}
