# doRedisSetup
Setup / Slave Scripts for doRedis

## Note: The current implementation seems to create zombie processes.


## Make workers available to the server:

```r
source("https://raw.githubusercontent.com/pfistfl/doRedisSetup/master/R/redisSlave.R")
```

## Commands:
```r
# Start workers (n can be set)
# Start (NCPUs - 2) Workers
ps = startLocalWorkers (n = (parallel::detectCores() - 2), queue = "jobs", host = "10.153.53.62") # , password = agent::agent_get("redispass"))
# List workers
listWorkers(ps)

# Kill all workers
killAllWorkers(ps)
```


