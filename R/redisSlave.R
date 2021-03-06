# Install / Load Packages as required
if (!require("devtools"))
  install.packages("devtools"); library("devtools")

if (!require("foreach"))
  install.packages("foreach"); library("foreach")

if (!require("doRedis"))
  devtools::install_github("bwlewis/doRedis"); library("doRedis")

if (!require("processx"))
  devtools::install_github("r-lib/processx"); library(processx)

# if (!require("agent"))
#   devtools::install_github("ropensci/agent")

# Source helper functions
source("https://raw.githubusercontent.com/pfistfl/doRedisSetup/master/R/redisHelpers.R")
