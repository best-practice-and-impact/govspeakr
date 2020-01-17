#' Converts image file names to a dataframe, with a field containing the
#' original image name and corresponding govdown reference
#' @param img_filenames character vector of files to be referenced in govdown format
#'   (!!n). The filename must start and end with a number and have text in
#'   between (eg, "1 abcd 1.png")
#' @name generate_image_references
#' @title Generate govdown image references
generate_image_references <- function(img_filenames) {
  image_references <- data.frame(image_file = img_filenames)
  # Strip file ext (not image specific)
  image_references$image_reference <- tools::file_path_sans_ext(image_references$image_file)
  
  # Capture chunk number and image position within chunk
  image_references$pre_dec <- gsub("([0-9]+).*$", "\\1", image_references$image_reference)
  image_references$post_dec <- gsub(".*([0-9])$", "\\1", image_references$image_reference)
  
  # Convert to decimal for ranking
  image_references$combined <- as.numeric(paste0(image_references$pre_dec,
                                                 ".",
                                                 image_references$post_dec))
  image_references$image_reference <- paste0("!!", rank(image_references$combined))
  
  # Keep mapping of image files to govspeak references
  image_references <- image_references[, c("image_file", "image_reference")]
  return(image_references)
}


#' Convert markdown image references to govspeak format (!!n)
#' @param image_references dataframe of image file names and associated govdown
#'   reference.
#' @param md_file string with markdown file text
#' @param images_folder string; folder containing images for *.md file
#' @name convert_image_references
#' @title Convert markdown image references to govdown
convert_image_references <- function(image_references, md_file, images_folder) {
  govspeak_image_reference_file <- as.character(md_file)
  for (i in seq_along(image_references$image_file)) {
    file_name <- image_references$image_file[i]
    
    # Construct markdown reference to image file
    md_image_format <- paste0("!\\[\\]\\(",
                              images_folder,
                              "/",
                              file_name,
                              "\\)<!-- -->")
    
    govspeak_reference <- paste0(as.character(image_references$image_reference[i]),
                                 "\n")
    
    # Replace markdown image reference with govspeak reference
    govspeak_image_reference_file <- gsub(md_image_format,
                                          govspeak_reference,
                                          govspeak_image_reference_file)
  }
  return(govspeak_image_reference_file)
}


#' Convert markdown callout sytax to govspeak
#' @param md_file string; markdown file text
#' @name convert_callouts
#' @title Convert markdown callout syntax to govspeak
convert_callouts <- function(md_file) {
  # Lazy match on lines starting with ">", which are then flanked with "^"
  # Currently only catches single line callouts
  converted_md_file <- gsub("(\\n)>[ ]*(.*?\\n)", "\\1^\\2", md_file)
}


#' Replace R markdown header with title only
#' @param md_file string; markdown file text
#' @name convert_title
#' @title Replace R markdown header with ## title
convert_title <- function(md_file) {
  # Lazy match on header to extract title
  # Remove substitution if titles must be entered manually
  cleaned_md_file <- gsub("---\\n.*?title:.*\"(.*)\".*?---\\n", "# \\1", md_file)
}


#' Remove R markdown multiline block elements (package warnings, but also multiline code blocks)
#' @param md_file string; markdown file text
#' @name remove_rmd_blocks
#' @title Remove R markdown multiline block elements (package warning and code block)
remove_rmd_blocks <- function(md_file) {
  # Lazy match on warnings and code blocks
  cleaned_md_file <- gsub("```\\n.*?```\\n\\n", "", md_file)
}


#' Convert markdown file to Whitehall publisher (gov.uk) govspeak markdown format
#' @param path string; filename (including path) to *.md file for conversion
#' @param images_folder string; folder containing images for *.md file. Defaults
#'   to "images"
#' @param remove_blocks bool; decision to remove block elements from *.md file
#' @export
#' @name convert_md
#' @title Convert standard markdown file to govspeak
convert_md <- function(path, images_folder = "images", remove_blocks=FALSE) {
  md_file <- paste(readLines(path), collapse = "\n")

  img_files <- list.files(paste0(dirname(path),
                                 "/",
                                 images_folder))

  image_references <- generate_image_references(img_files)
  govspeak_file <- convert_image_references(image_references,
                                            md_file,
                                            images_folder)
  
  govspeak_file <- convert_title(govspeak_file)
  
  govspeak_file <- convert_callouts(govspeak_file)
  
  if (remove_blocks) {
    govspeak_file <- remove_rmd_blocks(govspeak_file)
  }
  
  write(govspeak_file, gsub("\\.md", "_converted\\.md", path))
}
