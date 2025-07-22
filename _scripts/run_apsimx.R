# Run apsimx files 
run_apsimx <- function() {
    # Check the Models executable 
    Models <- if (.Platform["OS.type"] == "windows") {
        "Models.exe"
    } else if (.Platform["OS.type"] == "unix"){
        "Models"
    } else {
        stop("Unsupported OS type")
    }
    if (nzchar(Sys.which(Models)) == 0) {    
        return(invisible())
    }
    # Remove all db files
    apsimx_files <- list.files("docs", "*.apsimx$", recursive = TRUE, full.names = TRUE)
    db_files <- gsub("\\.apsimx$", ".db", apsimx_files)
    db_files <- db_files[file.exists(db_files)] |> 
        lapply(file.remove)
    Sys.sleep(1)  # Wait for file removal to complete
    # Run simulations
    cmd <- paste(Models, "--recursive docs/*.apsimx")
    system(cmd, ignore.stdout = TRUE, ignore.stderr = TRUE)
    Sys.sleep(1)  # Wait for simulations to complete
}



# Run all apsimx files under docs directory
run_apsimx()
