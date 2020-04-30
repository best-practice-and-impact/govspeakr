#' Convert a Markdown file to the Whitehall Publisher (GOV.UK) govspeak
#'   markup format
#' @param path string; filename (including path) to *.md file for conversion
#' @param images_folder string; folder containing images for *.md file. Defaults
#'   to "images"
#' @param remove_blocks bool; decision to remove block elements from *.md file.
#'   This includes code blocks and warnings
#' @export
#' @name convert_md
#' @title Convert standard markdown file to govspeak
convert_md <- function(path,
                       images_folder = "images",
                       remove_blocks=FALSE
                       ) {
  md_file <- paste(readLines(path), collapse = "\n")

  img_files <- list.files(paste0(dirname(path),
                                 "/",
                                 images_folder))

  image_references <- generate_image_references(img_files)
  govspeak_file <- convert_image_references(image_references,
                                            md_file,
                                            images_folder)

  govspeak_file <- remove_header(govspeak_file)

  govspeak_file <- convert_callouts(govspeak_file)

  if (remove_blocks) {
    govspeak_file <- remove_rmd_blocks(govspeak_file)
  }

  write(govspeak_file, gsub("\\.md", "_converted\\.md", path))
}
