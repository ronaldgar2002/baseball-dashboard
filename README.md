⚾ Baseball Sabermetrics Dashboard (R + Shiny)
This interactive dashboard lets you explore MLB player statistics using the Lahman Baseball Database. It's built entirely in R using Shiny, dplyr, and ggplot2.

You can filter by season, team, and plate appearances, view stat leaderboards (like OPS, HR, OBP), and dive into individual player performance trends.

📸 Preview
![image](https://github.com/user-attachments/assets/990b76a6-cc03-44bd-9d42-0ffc8f08e8e6)
![image](https://github.com/user-attachments/assets/d5286830-d15c-4f29-b060-fa8a8bc0fb12)




🚀 Features
📅 Filter by year and team

⚾ View top players by:

OPS (On-base + Slugging)

OBP, SLG, HR

📈 Visualize OPS distribution by season

👤 Search individual players to:

View career summary

See OPS over time

🗂️ Files in this Repo
File	Description
app.R	Shiny app dashboard
data_prep.R	Script to process and clean the Lahman data
batting_data.rds	Cleaned season-level dataset
career_stats.rds	Career-level player summaries
install_packages.R	Installs required R packages
README.md	This documentation

🧰 Install Required Packages
Before running the app, open R or RStudio and run:

r
Copy code
source("install_packages.R")
This will install the required R packages:

shiny

dplyr

ggplot2

plotly

Lahman

readr

▶️ How to Run the App
Clone or download this repository.

Open the project folder in RStudio.

If needed, run:

r
Copy code
source("data_prep.R")
Launch the app:

r
Copy code
shiny::runApp("app.R")
📦 Tech Stack
Language: R

Dashboard: Shiny

Data Viz: ggplot2 + plotly

Data Source: Lahman MLB Database (CRAN)

📊 Data Source
This project uses the Lahman package, which includes historical MLB player and team stats.

We calculate key sabermetrics like OPS, OBP, SLG, and estimate career summaries directly from the dataset.

✍️ Author
Ronald Garcia
GitHub: @ronaldgar2002
