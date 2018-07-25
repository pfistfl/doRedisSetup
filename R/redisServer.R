library(mlr)
library(foreach)
library(doRedis)
library(agent)
library(processx)

# Set up redis server password: --------------------------------------------------------------------
# agent::agent_set("redispass", "some_password")

# Source helper functions
source("https://raw.githubusercontent.com/pfistfl/doRedisSetup/master/R/redisHelpers.R")

# Set Up Redis:
registerDoRedis("jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))

# Start some local workers
ps = startLocalWorkers (n = 2, queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))


# Define the Jobs: ---------------------------------------------------------------------------------
tsks = list(iris.task, pid.task)
lrns = list(makeLearner("classif.rpart"), makeLearner("classif.lda"))

ff = foreach(icount(100)) %:%
  foreach(tsk = tsks, .combine = "c") %:%
    foreach(lrn = lrns, .packages = "mlr") %dopar% {
      res = resample(lrn, tsk, cv3, show.info = TRUE)
    }

# Stop the Jobs: -----------------------------------------------------------------------------------
killAllWorkers(ps)
removeQueue("jobs")

