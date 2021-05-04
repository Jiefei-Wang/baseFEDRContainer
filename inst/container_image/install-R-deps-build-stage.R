pkgs <- c("foreach", "redux", "doRedis", "BiocManager", "remotes")
install.packages(pkgs)
if (!requireNamespace("doRedis", quietly = TRUE)){
    BiocManager::install("bwlewis/doRedis", update=FALSE, upgrade = "never")
}