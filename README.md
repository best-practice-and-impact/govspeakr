# govspeakr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build status](https://travis-ci.org/best-practice-and-impact/govspeakr.svg?branch=master)](https://travis-ci.org/best-practice-and-impact/govspeakr)
<!-- badges: end -->

## Overview
{govspeakr} is an R package that is designed to help users to develop
[Reproproducible Analytical Pipelines (RAP)](https://dataingovernment.blog.gov.uk/2017/03/27/reproducible-analytical-pipeline/).
Specifically, it enables the user to convert Markdown (\*.md) files to [govspeak markup](http://govspeak-preview.herokuapp.com/guide),
which can be uploaded to the Whitehall publisher ([GOV.UK](https://www.gov.uk)).

Please also ensure that you follow the [GOV.UK guidance for publishing content](https://www.gov.uk/guidance/how-to-publish-on-gov-uk).

govspeak markup uses a specific notation to reference images within the document:

```
Figure 1
!!1

Figure 2
!!2
```

The `govspeakr::convert_md()` function converts the standard Markdown image reference format (below), to govspeak (above):

```
Figure 1
![](images/image1.png)<!-- -->

Figure 2
![](images/image2.png)<!-- -->
```
> Note: an empty comment is used to indicate references for conversion.


### What's the difference between govspeakr and [govdown](https://github.com/ukgovdatascience/govdown)?
* {govdown} translates ordinary Markdown into HTML, styled to look like GOV.UK. However, this HTML can't currently be submitted for publication on GOV.UK.
* {govspeakr} translates ordinary Markdown into a slightly different markup language (called 'govspeak') that can be pasted into Whitehall Publisher for publication on GOV.UK.


## Usage

For the image reference conversion to work, you should ensure that any R markdown
code chunks that output images are labelled with numbers increasing in sequence
according to order of appearance in the document. For example:

* 1-mortality statistics; (chunk that outputs first image)
* 2-AMR statistics; (outputs second image)
* 3-AMR by sex; (outputs third image)

Multiple images produced by a single chunk will be automatically numbered
appropriately, to preserve their order.

The conversion acts on a markdown (\*.md) file only, so R markdown (\*.Rmd) should first be converted/knitted to \*.md.
This can be achieved using the YAML header at the top of a \*.Rmd file, either outputing a `md_document` or keeping the *.md produced
when outputting a htlm or pdf document (i.e. using `keep_md: true`):

```
---
title: "My Rmarkdown File"
output: 
  md_document
---
```



or

```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
---
```


The `govspeakr::convert_md()` function accepts a path to a \*.md file, along with the name of the subdirectory that contains the
images required to produce the document. The images_folder parameter defaults to "images/", so other directory names must be specified
as below:

```
govspeakr::convert_md("C:Users/me/publications/statistical_publication.md", images_folder="figures")
```

The converted \*.md file will be written to the original directory, with the file name suffixed with "_converted".
This file, when supplied with the images contained in the specified images subdirectory, can be parsed by the Whitehall Publisher to produce HTML on GOV.UK.

### Rmarkdown configuration

A number of settings should be configured in your Rmarkdown file, to simplify
generation of Markdown for conversion.
The following example code chunk can be used at the start of your Rmarkdown file to configure:

- hiding R warnings and package messages from the output
- image size and resolution, to conform with [GOV.UK requirements](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/images-and-videos).
- the image output directory, so that `govspeakr::convert_md()` can be directed to the `images_folder`.
- table output format to Markdown, so that tables can be parsed by the Whitehall Publisher.


    ```{r knitr_init, echo=FALSE, cache=FALSE, message=FALSE, warning=FALSE}
    knitr::opts_chunk$set(
      # Prevent creation of warning or other message blocks - should be used only
      # when publishing output, so that you remain aware of warnings when developing a document
      # Alternatively, gpovspeakr::convert_md(..., remove_blocks=TRUE) can be used to strip blocks from the markdown output
      echo=FALSE,
      cache=FALSE,
      warning = FALSE,
      message = FALSE,
      
      # Image size rules for GOV.uk
      # https://www.gov.uk/guidance/how-to-publish-on-gov-uk/images-and-videos
      fig.width=960 / 72,
      fig.height=640 / 72,
      dpi=72,
      
      # The default path for govspeakr::convert_md() to search for images is ./images
      fig.path = "images/"
      )
    
    # Ensure that tables are output as markdown - can be achieved using knitr::kable (see example below)
    options(knitr.table.format = "markdown")
    ```

Please refer to the `rmd_examples` directory within the package, to see examples
that contain images and tables.

## What is currently converted by govspeakr?

Currently the following markdown elements are converted to govspeak using `govspeak::convert_md()`:

* Image references
* Single line block quotes/callouts
* (optional) removes remaining multiline blocks (i.e. within three backticks), including package warnings

Please raise an issue if you would like to request additional features.
