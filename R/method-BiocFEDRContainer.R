baseFEDRContainer <- function(image = "", name = NULL,  environment = list(),
                             maxWorkerNum = 4L,
                             RPackages = NULL,
                             sysPackages = NULL){
  .baseFEDRContainer$new(
    name=name, image = image,
    environment = environment,
    maxWorkerNum = as.integer(maxWorkerNum),
    RPackages=RPackages,
    sysPackages=sysPackages)
}

#' Common baseFEDRContainer parameter
#'
#' Common baseFEDRContainer parameter
#'
#' @param image Character, the container image
#' @param name Character, the optional name of the container
#' @param environment List, the environment variables in the container
#' @rdname baseFEDRContainer-commom-parameters
#' @name baseFEDRContainer-commom-parameters
NULL



#' Get the r-base Foreach Redis server container
#'
#' Get the r-base Foreach Redis server container.
#'
#' @inheritParams baseFEDRContainer-commom-parameters
#' @examples baseFEDRServerContainer()
#' @return a `baseFEDRContainer` object
#' @export
baseFEDRServerContainer <- function(environment = list(),tag = "latest"){
  name <- "redisRServerContainer"
  image <- paste0("dockerparallel/redis-r-server:",tag)
  baseFEDRContainer(image = image, name=name,
                   environment=environment,
                   maxWorkerNum=1L)
}
#' Get the r-base Foreach Redis worker container
#'
#' Get the r-base Foreach Redis worker container.
#'
#' @inheritParams baseFEDRContainer-commom-parameters
#' @param RPackages Character, a vector of R packages that will be installed
#' by `AnVIL::install` before connecting with the server
#' @param sysPackages Character, a vector of system packages that will be installed
#' by `apt-get install` before running the R worker
#' @param maxWorkerNum Integer, the maximum worker number in a container
#'
#' @examples baseFEDRWorkerContainer()
#' @return a `baseFEDRContainer` object
#' @export
baseFEDRWorkerContainer <- function(RPackages = NULL,
                                   sysPackages = NULL,
                                   environment = list(),
                                   maxWorkerNum = 4L,
                                   tag = "latest"){
  name <- "redisRWorkerContainer"
  image <- paste0("dockerparallel/bioc-foreach-doredis-worker:",tag)
  baseFEDRContainer(image = image, name=name, RPackages=RPackages, sysPackages=sysPackages,
                   environment=environment,
                   maxWorkerNum=maxWorkerNum)
}

.baseFEDRContainer$methods(
  show = function(){
    cat("r-base foreach redis container reference object\n")
    cat("  Image:     ", .self$image, "\n")
    cat("  maxWorkers:", .self$maxWorkerNum, "\n")
    if(!is.null(.self$RPackages)){
      cat("  R packages:", paste0(.self$RPackages, collapse = ", "), "\n")
    }
    if(!is.null(.self$sysPackages)){
      cat("  system packages:", paste0(.self$sysPackages, collapse = ", "), "\n")
    }
    cat("  Environment variables:\n")
    for(i in names(.self$environment)){
      cat("    ",i,": ", .self$environment[[i]], "\n",sep="")
    }
    invisible(NULL)
  }
)


