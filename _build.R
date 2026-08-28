source("_scripts/run_apsimx.R")

# Run all apsimx files under docs directory

if (Sys.getenv("GITHUB_ACTIONS") == "true") {
    run_apsimx()
}

# Compile the targets pipeline
targets::tar_make()
