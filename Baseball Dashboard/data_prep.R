library(Lahman)
library(dplyr)
library(tidyr)

# Step 1: Build season-level batting stats with key metrics


# Calculate total bases, OBP, SLG, and OPS
batting_data <- Batting |>
  filter(AB > 0) |>
  mutate(
    singles = H - X2B - X3B - HR,
    TB = singles + 2 * X2B + 3 * X3B + 4 * HR,
    OBP = (H + BB + HBP) / (AB + BB + HBP + SF),
    SLG = TB / AB,
    OPS = OBP + SLG
  ) |>
  # Add player names
  left_join(
    People |> select(playerID, nameFirst, nameLast),
    by = "playerID"
  ) |>
  mutate(Name = paste(nameFirst, nameLast)) |>
  # Add franchise/team info
  left_join(
    Teams |> select(yearID, teamID, franchID),
    by = c("yearID", "teamID")
  ) |>
  # Keep only relevant columns
  select(
    playerID, Name, yearID, franchID, teamID,
    G, AB, H, HR, BB, SO, OPS, OBP, SLG
  ) |>
  # Clean up NA and extreme OPS values
  filter(!is.na(OPS), OPS < 2)


# Step 2: Create a career summary for each player


career_stats <- batting_data |>
  group_by(playerID, Name) |>
  summarise(
    Years       = n_distinct(yearID),
    Total_HR    = sum(HR, na.rm = TRUE),
    Total_H     = sum(H, na.rm = TRUE),
    Total_AB    = sum(AB, na.rm = TRUE),
    Career_OPS  = round(mean(OPS, na.rm = TRUE), 3),
    Career_OBP  = round(mean(OBP, na.rm = TRUE), 3),
    Career_SLG  = round(mean(SLG, na.rm = TRUE), 3),
    .groups = "drop"
  ) |>
  mutate(
    Career_AVG = round(Total_H / Total_AB, 3)
  ) |>
  filter(Total_AB >= 1000)  # Filter for players with enough at-bats

# Step 3: Save the cleaned datasets for use in Shiny app

saveRDS(batting_data, "batting_data.rds")
saveRDS(career_stats, "career_stats.rds")
