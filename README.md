# govspeakr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build status](https://travis-ci.org/best-practice-and-impact/govspeakr.svg?branch=master)](https://travis-ci.org/best-practice-and-impact/govspeakr)
<!-- badges: end -->

## What is govspeakr?
govspeakr is an R package that is designed to help users to develop
[Reproproducible Analytical Pipelines (RAP)](https://dataingovernment.blog.gov.uk/2017/03/27/reproducible-analytical-pipeline/).
Specifically, it enables the user to convert markdown (\*.md) files to [govspeak markup](http://govspeak-preview.herokuapp.com/guide),
which can be uploaded to the Whitehall publisher ([GOV.UK](https://www.gov.uk)).

govspeak markup uses a different notation to reference images within the document:

```
Figure 1
!!1

Figure 2
!!2
```

The `govspeakr::convert_md()` function converts the standard markdown image reference format (below), to govspeak (above):

```
Figure 1
![](images/image1.png)<!-- -->!

Figure 2
![](images/image2.png)<!-- -->! 
```

### What's the difference between govspeakr and [govdown](https://github.com/ukgovdatascience/govdown)?
* {govdown} translates ordinary markdown into HTML, styled to look like GOV.UK. However, this HTML can't currently be submitted for publication on GOV.UK.
* {govspeakr} translates ordinary markdown into a slightly different version of markdown (called 'govspeak') that can be pasted into   Whitehall Publisher for publication on GOV.UK.


## Usage

Ensure that you title any R markdown code chunks that output images with numbers increasing in sequence according
to order of appearance in the document. For example:

* 1-mortality statistics; (outputs first image)
* 2-AMR statistics; (outputs second image)
* 3-AMR by sex; (outputs third image)

Multiple images produced by a single chunk will be automatically numbered appropriately.

The conversion acts on a markdown (\*.md) file only, so R markdown (\*.Rmd) should first be converted to \*.md.
This can be achieved using the YAML at the top of a \*.Rmd file, either outputing md_document or keeping the *.md produced
when outputting a htlm or pdf document (i.e. using `keep_md: true`):

```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
---
```

The `govspeakr::convert_md()` function accepts a path to a \*.md file, along with the name of the subdirectory that contains the
images required to produce the document.The images_folder parameter defaults to "images/", so other directory names must be specified
as below:

```
convert_md("C:Users/me/publications/statistical_publication.md", images_folder="figures")
```

The converted \*.md file will be written to the original directory, with the file name suffixed with "_converted".
This file, along with the images contained in the images subdirectory, can be parsed by the Whitehall Publisher to produce HTML on GOV.UK.


## What is converted by govspeakr?

Currently the following markdown elements are converted to govspeak using `govspeak::convert_md()`:

* Image references
* Single line block quotes/callouts
* (optional) removes remaining multiline blocks (i.e. within three backticks), including package warnings

For other elements, please see the [guidance](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/markdown) for preparation of markdown for the Whitehall publisher.
