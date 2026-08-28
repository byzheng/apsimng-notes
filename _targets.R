list(
    targets::tar_target(
        qt_files,
        {
            qmd_files <- myworkspace::list_quarto_render_files()
            c(qmd_files, "_quarto.yml")
        },
        format = "file",
        cue = targets::tar_cue(
            mode = "always",
            command = "always"
        )
    ),
    targets::tar_target(
        qt_cnt_hash,
        {
            qt_files
            unname(sort(myworkspace::list_quarto_render_hashes()))
        }
    ),
    targets::tar_target(
        qt_render,
        {
            qt_cnt_hash
            myworkspace::render_modified_quarto(force = FALSE)
        }
    ),
    targets::tar_target(
        merge_site,
        {
            qt_render
            r_sty_lst_pubs
            if (!requireNamespace("myworkspace", quietly = TRUE)) {
                return(invisible(NULL))
            }
            target_dir <- myworkspace::copy_quarto_site()
            target_dir
        },
        format = "file"
    )
)
