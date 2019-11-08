# govspeakr
**ALPHA**: Please note that this package is the early stages of development.

## What is govspeakr?
govspeakr is an R package that is designed to help users to develop
[Reproproducible Analytical Pipelines (RAP)](https://gss.civilservice.gov.uk/events/introduction-to-reproducible-analytical-pipelines-rap-2/).
Specifically, it enables the user to convert markdown (\*.md) files to [govspeak markdown](http://govspeak-preview.herokuapp.com/guide),
which can be uploaded to the Whitehall publisher ([gov.uk](https://www.gov.uk)).


Chiefly, govspeak markup uses a different notation to reference images within the document:

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


## Usage

Ensure that you title any R markdown code chunks that output images with numbers increasing in sequence according
to order of appearance in the document. For example:

* 1-mortality statistics; (outputs first image)
* 2-AMR statistics; (outputs second image)
* 3-AMR by sex; (outputs third image)

Multiple images produced by a single chunk will be automatically numbered appropriately.

The conversion acts on a markdown (\*.md) file only, so Rmarkdown (\*.Rmd) should first be converted to \*.md.
This can be achieved using the YAML at the top of a \*.Rmd file, either outputing md_document or keeping the *.md produced
when outputting a htlm or pdf document:


```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
---
```

The `govspeakr::convert_md()` function accepts a path to a \*.md file, along with the name of the subdirectory that contains any required images.
This subdirectory should only include the images required for the document. The images_folder parameter defaults to "images/",
so other names must be specified as below:

```
convert_md("C:Users/me/publications/statistical_publication.md", images_folder="figures")
```

The converted \*.md file will be written to the original directory, with the file name suffixed with "_converted".
This file can be interpreted by the whitehall publisher, along with the images contained in the images subdirectory.


## What is converted by govspeakr

Currently the following markdown elements are converted to govspeak:

* Image references
* Single line block quotes/callouts
* R markdown titles

For other elements, please see the [guidance](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/markdown) for preparation of markdown for the Whitehall publisher.
