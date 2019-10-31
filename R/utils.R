#' Converts image file names to a dataframe, with a field containing the
#' original image name and one for the Whitehall publishing software
#' @param imgs character vector of png files to be converted to Whitehall format
#'   (!!n). The filename must start and end with a number and have text in
#'   between (eg, "1 abcd 1.png")
#' @title Generate image numbers
generate_image_numbers <- function(imgs) {
  generate_image_numbers <- data.frame(image = imgs)
  generate_image_numbers$img_number <- gsub("\\.png$", "", generate_image_numbers$image)
  generate_image_numbers$pre_dec <- gsub("([0-9]+).*$", "\\1", generate_image_numbers$img_number)
  generate_image_numbers$post_dec <- gsub(".*([0-9])$", "\\1", generate_image_numbers$img_number)
  generate_image_numbers$combined <- as.numeric(paste0(generate_image_numbers$pre_dec,
                                                       ".",
                                                       generate_image_numbers$post_dec))
  generate_image_numbers$img_number <- paste0("!!", rank(generate_image_numbers$combined))


  generate_image_numbers <- generate_image_numbers[, c("image", "img_number")]
  return(generate_image_numbers)

}

#' Convert markdown file to Whitehall (gov.uk) govspeak markdown publishing format
#' @param path string; filename (including path) to *.md file for conversion
#' @param images_folder string; folder containing images for *.md file. Defaults
#'   to "images"
#' @export
#' @name convert_md
#' @title Convert markdown file to Whitehall publishing format
convert_md <- function(path, images_folder = "images") {
  md_file <- readLines(path)

  imgs <- list.files(paste0(dirname(path),
                            "/",
                            images_folder))
  imgs <- generate_image_numbers(imgs)

  for (i in seq_along(imgs$image)) {
    orig <- imgs$image[i]
    md_image_format <- paste0("!\\[\\]\\(",
                              images_folder,
                              "/",
                              orig,
                              "\\)<!-- -->")
    targ <- paste0(as.character(imgs[i, 2]),
                   "\n")

    md_file <- gsub(md_image_format,
                    targ,
                    md_file)
  }

  write(md_file, gsub("\\.md", "_converted\\.md", path))

}
