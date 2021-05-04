RPackages <- Sys.getenv("RPackages")
if(RPackages!=""){
    pkgs <- strsplit(RPackages,",")[[1]]
    pkgs <- sapply(pkgs,function(i) URLdecode(i))
    message("Installing the package: ", paste0(pkgs, sep = ", "))
    if (length(pkgs)!=0){
        BiocManager::install(pkgs, update = FALSE, upgrade = "never")
    }
}