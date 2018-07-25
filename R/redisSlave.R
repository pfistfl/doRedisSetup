# Install / Load Packages as required
if (!require("devtools"))
  install.packages("devtools")

if (!require("foreach"))
  install.packages("foreach")

if (!require("bdoRedis"))
  devtools::install_github("bwlewis/doRedis")

if (!require("processx"))
  devtools::install_github("r-lib/processx")

if (!require("agent"))
  devtools::install_github("ropensci/agent")

source("")

# Start n Workers
ps = startLocalWorkers (n = parallel::detectCores() - 2, queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))