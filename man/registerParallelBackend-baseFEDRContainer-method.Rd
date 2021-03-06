% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adaptor-BiocFEDRContainer.R
\name{registerParallelBackend,baseFEDRContainer-method}
\alias{registerParallelBackend,baseFEDRContainer-method}
\title{Register the foreach doRedis backend}
\usage{
\S4method{registerParallelBackend}{baseFEDRContainer}(container, cluster, verbose = FALSE, ...)
}
\arguments{
\item{container}{The worker container.}

\item{cluster}{S4 \code{DockerCluster} object.}

\item{verbose}{Integer. The verbose level, default 1.}

\item{...}{The additional parameter that will be passed to \code{doRedis::registerDoRedis}}
}
\value{
No return value
}
\description{
Register the foreach doRedis backend. The registration will be done via
\code{doRedis::registerDoRedis}
}
