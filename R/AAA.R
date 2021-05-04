###########################
## container provider
###########################
#' The Bioconductor Foreach Redis container
#'
#' The Bioconductor Foreach Redis container. See `?BiocFEDRServerContainer` and
#' `?BiocFEDRWorkerContainer`
.BiocFEDRContainer <- setRefClass(
    "BiocFEDRContainer",
    fields = list(
        sysPackages = "CharOrNULL",
        RPackages = "CharOrNULL"
    ),
    contains = "DockerContainer"
)
