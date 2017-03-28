The screenshot below shows a package I created for a PhD scholar who requested a program. In the Help pane of RStudio, 
the documentation for one of the functions could be seen. This was done by creating a .Rd file using RStudio.

The function is an application of the Accelerated Gauss-Siedel method to solve electric power flow analysis problem.

![r documentation proof](https://github.com/benubah/control-gsoc-test/blob/master/rdoc_screenshot.png "r doc")


### Vignettes

Vignettes can be generated using R Markdown which is a extension of the Markdown language to also include and process R code.
knitr is used to compile an R Markdown document into pure Markdown, converting R codes to their results and plots. From here, it can be converted into a HTML document or pdf as the case may require.

This involves putting the R Markdown document within a subdirectory called 'vignettes', specifying that the Vignetter builder is knitr in the DESCRIPTION file. Also, at the header of the R Markdown file specify these:

```R
---
title: "Control toolbox"
output: pdf_document
vignette: >
  %\VignetteIndexEntry{Control toolbox}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
```
Then build your vignette with the devtools::build_vignettes() function. The built vignette would be located in the inst/doc folder.


