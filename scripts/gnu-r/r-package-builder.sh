#!/bin/bash -e

echo "==> Building & installing R devtools package..."
R -e 'install.packages("devtools", repos="http://cloud.r-project.org")'
# R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/devtools/devtools_2.0.1.tar.gz", repos=NULL, type="source")'

echo "==> Bulilding & installing specified R packages..."
INPUT_FILE=$1
LOG_FILE=$2
CSV_ROWS=$(wc -l ${INPUT_FILE} | awk '{ print $1 }')


cat << 'EOF' > package-build.R
#!/usr/bin/env Rscript

# Use the first arument passed to the script as a path to input file 
args = commandArgs(trailingOnly=TRUE)
inCSVPath<-args[1]
logCSVPath<-args[2]

# Check which packages already installed
installedPackages<-as.data.frame(installed.packages())
#installedPackages$Key<- paste(installedPackages$Package,installedPackages$Version,sep="-")

# Load a list of packages to be installed
wantToInstall <- read.csv(file = inCSVPath)
#wantToInstall$Key <- paste(wantToInstall$package,wantToInstall$version,sep="-")

# Work out which packages are missing
# TODO - need a mechanism for forcing specific version of the package for specific version installs
# At the moment only checking package names. Probably OK for clean installs. 
notAlreadyInstalled<-wantToInstall[!(wantToInstall$package %in% installedPackages$Package),]

# Re-order based on install mode - pushes specific version installs to be the last
# Important as standard installs can override / upgrade these when installing dependencies.
# TODO - Check if this can be avoided by disabling upgrades on install? 
notAlreadyInstalledOrdered <- notAlreadyInstalled[order(notAlreadyInstalled$install_mode),]
notAlreadyInstalledOrdered <- data.frame(lapply(notAlreadyInstalledOrdered, as.character), stringsAsFactors=FALSE)

# Create DF for capturing install performance details
monitorProcessing <- data.frame(package=character(),
                                install_mode=character(), 
                                config=character(),
                                start_time=character(),
                                end_time=character(),
                                install_time=character(), 
                                stringsAsFactors=FALSE)


# Iterate through the not already installed list if it is not empty
if (nrow(notAlreadyInstalledOrdered) > 0 ) {
  for( i in rownames(notAlreadyInstalledOrdered)) {

    start_time <- Sys.time()

    # Get package details
    package<-notAlreadyInstalledOrdered[i,"package"]
    install_mode<-tolower(notAlreadyInstalledOrdered[i,"install_mode"])
    config<-notAlreadyInstalledOrdered[i,"config"] 
    cat("Package:",package,"Install mode:",install_mode,"Config:",config)
    
    # Use the specified install mode
    # https://devtools.r-lib.org/reference/remote-reexports.html
    # TODO - Look at supporting install from private repos
    # TODO - Provide more thorough testing of various install methods
    
    if (install_mode == "bioc") {
        devtools::install_bioc(config)
    } else if (install_mode == "bitbucket") {
        devtools::install_bitbucket(config)
    } else if (install_mode == "cran") {
        install.packages(package, repos="http://cloud.r-project.org")
    } else if (install_mode == "dev") {
        devtools::install_dev(package)
    } else if (install_mode == "git") {
        devtools::install_git(config)
    } else if (install_mode == "github") {
        devtools::install_github(config)
    } else if (install_mode == "gitlab") {
        devtools::install_gitlab(config)
    } else if (install_mode == "local") {
        devtools::install_local(config)
    } else if (install_mode == "svn") {
        devtools::install_svn(config)
    } else if (install_mode == "url") {
        devtools::install_url(config)
    } else if (install_mode == "version") {
        devtools::install_version(package=package,version=config,build=TRUE,repos="https://cloud.r-project.org/")
    } else {
        cat("Unsupported install mode specified:",install_mode,". Please check and try again.")
    }

    end_time <- Sys.time()

    # Capture install performance details for the package and save the log
    monitorProcessing[nrow(monitorProcessing)+1, ] <- c(package, install_mode, config, start_time, end_time, end_time - start_time)
    write.csv(monitorProcessing,logCSVPath, row.names = FALSE)

  }
} else {
  print("All requested pakages already installed. Nothing to do!")
}

EOF

if [[ -f "$INPUT_FILE" && "$CSV_ROWS" > 1 ]]
then
    Rscript package-build.R ${INPUT_FILE} ${LOG_FILE}
else
    echo "R Package Builder: Check your input file. It either does not exist or doesn't have any records."
fi