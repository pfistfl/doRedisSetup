# doRedisSetup
Setup / Slave Scripts for doRedis

## Make workers available to the server:
```r
source("https://raw.githubusercontent.com/pfistfl/doRedisSetup/master/R/redisSlave.R")
```

## Commands:
```r
# Start workers (n can be set)
# Sourcing the Script automatically starts NCPUs - 2 Workers
ps = startLocalWorkers (n = (parallel::detectCores() - 2), queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))
# Start NCPUs - 2 Workers
ps = startLocalWorkers (n = (parallel::detectCores() - 2), queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))

# List workers
listWorkers(ps)

# Kill all workers
killAllWorkers(ps)
```


