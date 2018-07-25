# Install / Load Packages
if (!require("foreach"))
  install.packages("foreach")

if (!require("doRedis"))
  install.packages("doRedis")

if (!require("agent"))
  install.packages("agent")

# Set Up Redis:
options('redis:num'=TRUE) # Some weird bug with numeric
setProgress(TRUE)         # Progress bar

# Set up redis server password: --------------------------------------------------------------------
# agent::agent_set("redispass", "some_password")

# Start some local workers
startLocalWorkers (n = 2, queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))
