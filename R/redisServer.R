library(mlr)
library(foreach)
library(doRedis)
library(agent)

# Set up redis server password: --------------------------------------------------------------------
# agent::agent_set("redispass", "some_password")


# Set Up Redis:
options('redis:num'=TRUE) # Some weird bug with numeric
setProgress(TRUE)         # Progress bar
registerDoRedis("jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))

# Start some local workers
startLocalWorkers (n = 2, queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))

getDoParWorkers()

# Define the Jobs: ---------------------------------------------------------------------------------
tsks = list(iris.task, pid.task)
lrns = list(makeLearner("classif.rpart"), makeLearner("classif.xgboost"))

ff = foreach(icount(100)) %:%
  foreach(tsk = tsks, .combine = "c") %:%
    foreach(lrn = lrns) %dopar% {
      res = resample(lrn, tsk, cv3, show.info = TRUE)
    }

# Stop the Jobs: -----------------------------------------------------------------------------------
removeQueue("jobs")
