r <- getOption('repos')
r['CRAN'] <- 'http://cloud.r-project.org'
options(repos=r)
install.packages('remotes')
install.packages('plotly')
install.packages('tidyverse')
remotes::install_github('plotly/dashR', upgrade=TRUE)
