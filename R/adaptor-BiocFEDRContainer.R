#' Configure the server container environment,
#'
#' Configure the server container environment, only the environment
#' `serverPort`, `serverPassword` and `sshPubKey` will be set in this method
#'
#' @inheritParams DockerParallel::configServerContainerEnv
#' @return A `BiocFEDRContainer` object
#' @export
setMethod("configServerContainerEnv", "BiocFEDRContainer",
          function(container, cluster, verbose = FALSE){
              if(length(container$RPackages)!=0){
                  warning("The server containder does not support installing R packages")
              }
              if(length(container$sysPackages)!=0){
                  warning("The server containder does not support installing system packages")
              }
              container <- container$copy()

              serverPort <- .getServerPort(cluster)
              serverPassword <- .getServerPassword(cluster)
              sshPubKey <- getSSHPubKeyValue()

              stopifnot(!is.null(serverPort))
              if(is.null(serverPassword)){
                    stop("The server must be password protected!")
              }
              container$environment <- combineList(
                  container$environment,
                  list(
                      serverPort = serverPort,
                      serverPassword = serverPassword,
                      sshPubKey = sshPubKey
                  )
              )
              container
          })

#' Configure the worker container
#'
#' Configure the worker container
#'
#' @inheritParams DockerParallel::configWorkerContainerEnv
#' @return A `BiocFEDRContainer` object
#' @export
setMethod("configWorkerContainerEnv", "BiocFEDRContainer",
          function(container, cluster, workerNumber, verbose = FALSE){
              container <- container$copy()

              queueName <- .getJobQueueName(cluster)
              serverPort <- .getServerPort(cluster)
              serverPassword <- .getServerPassword(cluster)
              sshPubKey <- getSSHPubKeyValue()
              RPackages <- packPackages(container$RPackages)
              sysPackages <- paste0(container$sysPackages,collapse = ",")
              if(.getServerWorkerSameLAN(cluster)){
                  serverIp <- .getServerPrivateIp(cluster)
              }else{
                  serverIp <- .getServerPublicIp(cluster)
              }

              if(is.null(serverIp)){
                  stop("Fail to find the server Ip")
              }
              stopifnot(!is.null(serverPort))

              container$environment <- combineList(
                  container$environment,
                  list(
                      queueName = queueName,
                      serverIp = serverIp,
                      serverPort = serverPort,
                      serverPassword = serverPassword,
                      sshPubKey = sshPubKey,
                      workerNum = workerNumber,
                      RPackages = RPackages,
                      sysPackages = sysPackages
                  )
              )
              container
          })


#' Register the foreach doRedis backend
#'
#' Register the foreach doRedis backend. The registration will be done via
#' `doRedis::registerDoRedis`
#'
#' @inheritParams DockerParallel::registerParallelBackend
#' @param ... The additional parameter that will be passed to `doRedis::registerDoRedis`
#' @return No return value
#' @export
setMethod("registerParallelBackend", "BiocFEDRContainer",
          function(container, cluster, verbose = FALSE, ...){
              queue <- .getJobQueueName(cluster)
              password <- .getServerPassword(cluster)
              serverPort <- .getServerPort(cluster)
              if(.getServerClientSameLAN(cluster)){
                  serverClientIP <- .getServerPrivateIp(cluster)
              }else{
                  serverClientIP <- .getServerPublicIp(cluster)
              }

              if(is.null(serverClientIP)){
                  stop("Fail to find the server Ip")
              }
              stopifnot(!is.null(serverPort))

              doRedis::registerDoRedis(queue=queue,
                                       host = serverClientIP,
                                       password = password,
                                       port = serverPort, ...)
              invisible(NULL)
          })

#' Get the Bioconductor foreach Redis container
#'
#' Get the Bioconductor foreach Redis container from the worker container
#'
#' @inheritParams DockerParallel::getServerContainer
#' @return A `BiocFEDRContainer` server container
#' @export
setMethod("getServerContainer", "BiocFEDRContainer",function(workerContainer){
    BiocFEDRServerContainer()
})




containerExportedMethods <- c("getSysPackages", "setSysPackages", "addSysPackages",
                              "getRPackages", "setRPackages", "addRPackages")


#' Get the exported object
#'
#' Get the exported object. The objects are 'getSysPackages', 'setSysPackages',
#' 'addSysPackages', 'getRPackages', 'setRPackages' and 'addRPackages'. see details
#'
#' @details
#' The function `XSysPackages` can be used to install the system package for the
#' worker container before running the R worker. The package will be installed by
#' `apt-get install`.
#'
#' The function `XRPackages` will install the R packages for the container. The
#' package is installed via `AnVIL::install`. It will first try the fast binary installation,
#' then fallback to `BiocManager::install`. Therefore, you can also provide the GitHub package
#' to this function.
#'
#' Note that these function must be called before deploying the container.
#' Setting the packages will have no effect on the running container.
#'
#'
#' @inheritParams DockerParallel::getExportedObject
#' @inheritParams DockerParallel::getExportedNames
#' @return For the exported function: The current package vector
#' @rdname BiocFEDRPackages
#' @export
setMethod("getExportedNames", "BiocFEDRContainer",
          function(x){
              if(x$name == "redisRWorkerContainer")
                  containerExportedMethods
              else
                  character()
          }
)

#' @rdname BiocFEDRPackages
#' @export
setMethod("getExportedObject", "BiocFEDRContainer",
          function(x, name){
              if(x$name != "redisRWorkerContainer"){
                return(NULL)
              }
              if(!name%in%containerExportedMethods)
                  return(NULL)
              get(name)
          }
)





