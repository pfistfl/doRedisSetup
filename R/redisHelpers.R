# Set Up Redis:
options('redis:num'=TRUE) # Some weird bug with numeric
setProgress(TRUE)         # Progress bar

# Set up redis server password: --------------------------------------------------------------------
# agent::agent_set("redispass", "some_password")

#' Taken and adapted from doRedis Github (bwlewis/doRedis):
#' This substitutes the call to system() with a call to process$new, which
#' allows control of the processes.
#'
#' Start one or more background R worker processes on the local system.
#'
#' Use \code{startLocalWorkers} to start one or more doRedis R worker processes
#' in the background. The worker processes are started on the local system using
#' the \code{redisWorker} function.
#'
#' Running workers self-terminate after a \code{linger} period when their work queues are deleted with the
#' \code{removeQueue} function or when network activity with Redis remains
#' inactive for longer than the \code{timeout} period set in the \code{redisConnect}
#' function. That value defaults internally to 3600 (one hour) in \code{startLocalWorkers}.
#' You can increase it by including a {timeout=n} argument value.
#'
#' @param n number of workers to start
#' @param queue work queue name
#' @param host Redis database host name or IP address
#' @param port Redis database port number
#' @param iter maximum number of tasks to process before exiting the worker loop
#' @param linger timeout in seconds after which the work queue is deleted that the worker terminates
#' @param log print messages to the specified file connection
#' @param Rbin full path to the command-line R program
#' @param password optional Redis database password
#' @param ... optional additional parameters passed to the \code{\link{redisWorker}} function
#'
#' @return NULL is invisibly returned.
#'
#' @seealso \code{\link{registerDoRedis}}, \code{\link{redisWorker}}
#'
#' @examples
#' \dontrun{
#' require('doRedis')
#' registerDoRedis('jobs')
#' startLocalWorkers(n=2, queue='jobs', linger=5)
#' print(getDoParWorkers())
#' foreach(j=1:10,.combine=sum,.multicombine=TRUE) \%dopar\%
#'           4*sum((runif(1000000)^2 + runif(1000000)^2)<1)/10000000
#' removeQueue('jobs')
#' }
#'
#' @export
startLocalWorkers <- function(n, queue, host="localhost", port=6379,
  iter=Inf, linger=30, log=stdout(),
  Rbin=paste(R.home(component="bin"),"R",sep="/"), password, ...) {
  m <- match.call()
  f <- formals()
  l <- m$log
  if(is.null(l)) l <- f$log
  conargs <- list(...)
  if(is.null(conargs$timeout)) conargs$timeout <- 3600
  conargs <- paste(paste(names(conargs), conargs, sep="="), collapse=",")

  # ensure that we pass multiple queues, if applicable, to each worker
  queue <- sprintf("c(%s)", paste("'", queue, "'", collapse=", ", sep=""))

  cmd <- paste("require(doRedis);redisWorker(queue=",
    queue, ", host='", host,"', port=", port,", iter=", iter,", linger=",
    linger, ", log=", deparse(l), sep="")
  if(nchar(conargs) > 0) cm <- sprintf("%s, %s", cmd, conargs)
  if(!missing(password)) cmd <- sprintf("%s, password='%s'", cmd, password)
  dots <- list(...)
  if(length(dots) > 0)
  {
    dots <- paste(paste(names(dots),dots,sep="="),collapse=",")
    cmd <- sprintf("%s,%s",cmd,dots)
  }
  cmd <- sprintf("%s)",cmd)
  cmd <- gsub("\"", "'", cmd)

  j <- 0
  args <- c(" --slave","-e", cmd)
  p = vector("list", n)
  while(j < n)
  {
    p[[j + 1]] = process$new(command = Rbin, args = args)
    j <- j + 1
  }
  return(p)
}

#' Kills all worker processes
killAllWorkers = function(ps) {
  n = length(ps)
  killNWorkers(ps, n)
}

#' Kills 'n' first worker processes
killNWorkers = function(ps, n = 2) {
  sapply(ps[seq_len(n)], function(x){x$kill()})

  # Check if all workers are terminated
  if (all(!sapply(ps[seq_len(n)], function(x){x$is_alive()})))
    cat(sprintf("Killed %i workers \n", n))

  ps = ps[-seq_len(n)]
  return(ps)
}

# List worker status
listWorkers = function(ps) {
  status = sapply(ps, function(x){x$is_alive()})
  cat(sprintf("Total workers:  %i \n", length(status)))
  cat(sprintf("Active workers: %i \n", sum(status)))
  cat(sprintf("Killed workers: %i \n", sum(!status)))
}
