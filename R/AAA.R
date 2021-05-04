###########################
## container provider
###########################
#' The r-base Foreach Redis container
#'
#' The r-base Foreach Redis container. See `?baseFEDRServerContainer` and
#' `?baseFEDRWorkerContainer`
.baseFEDRContainer <- setRefClass(
    "baseFEDRContainer",
    fields = list(
        sysPackages = "CharOrNULL",
        RPackages = "CharOrNULL"
    ),
    contains = "DockerContainer"
)
