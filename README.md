# govspeakr
**WARNING**: Please note that this package is currently under development. To be updated when this package is ready for use, or to contribute, please get in touch.

## What is govspeakr?
govspeakr is an R package that is designed to help users to develop
[Reproproducible Analytical Pipelines (RAP)](https://gss.civilservice.gov.uk/events/introduction-to-reproducible-analytical-pipelines-rap-2/).
Specifically, it enables the user to convert markdown files to [govspeak markdown](http://govspeak-preview.herokuapp.com/guide),
which can be directly uploaded to the Whitehall publisher ([gov.uk](https://www.gov.uk)).

Govspeak markup uses a different notation for image location within the text:
```
Figure 1
!!1

Figure 2
!!2
```

The `govspeakr::convert_md()` function converts the usual markdown format (below), to that shown above:

```
Figure 1
![](images/image1.png)<!-- -->!

Figure 2
![](images/image2.png)<!-- -->! 
```


## Usage

The conversion acts on a markdown (*.md) file only, so Rmarkdown (*.Rmd) should first be converted to *.md.
This can be achieved using the YAML at the top of a *.Rmd file, either outputing md_document or keeping the *.md produced
when outputting a htlm or pdf document:


```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
---


```

The `govspeakr::convert_md()` function accepts a path to a *.md file, along with the name of the subdirectory that contains any required images.
This subdirectory should only include the images required for the document. The images_folder parameter defaults to "images/",
so other names must be specified as below:


```
convert_md("C:Users/me/publications/statistical_publication.md", images_folder="figures")
```

The converted *.md file will be written to the original directory, with the file name suffixed with "_converted".
This file can be interpreted by the whitehall publisher, along with the images contained in the images subdirectory.