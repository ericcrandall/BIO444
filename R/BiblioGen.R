# Little function to prepare an up-to-date html version of keywords and lists
# from our bibliogrpahy.  Will generate html that can be opened in browser
# with rendHtml function of TPG

```{r,echo=FALSE}
library(bibtex)
library(knitr)
biblio <-read.bib("../PopGenWithR/Rmd/TPG.bib")
Keys=names(biblio)
Titles <-sapply(biblio,function(x) x[[1]]$title)
Out <-data.frame(Titles)
(kable(Out))
```
