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
    apsimx_files <- list.files("docs", "\\.apsimx$", recursive = TRUE, full.names = TRUE)
    if (length(apsimx_files) == 0) {
        return(invisible())
    }
    db_files <- gsub("\\.apsimx$", ".db", apsimx_files)

    to_run <- mapply(function(apsimx, db) {
        !file.exists(db) || file.mtime(apsimx) > file.mtime(db)
    }, apsimx_files, db_files)

    apsimx_files <- apsimx_files[to_run]
    db_files <- db_files[to_run]
    if (length(apsimx_files) == 0) {
        return(invisible())
    }
    aa <- db_files |> lapply(file.remove)
    Sys.sleep(1)  # Wait for file removal to complete
    # Run simulations
    message("Re-running ", length(apsimx_files), " simulation(s)...")
    cmd <- paste(Models, "--recursive docs/*.apsimx")
    system(cmd, ignore.stdout = TRUE, ignore.stderr = TRUE)
    Sys.sleep(1)  # Wait for simulations to complete
}



# Run all apsimx files under docs directory
run_apsimx()
