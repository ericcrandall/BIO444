rendHtml <-function(file){
  f.name <-paste("./Rmd/",file,".Rmd",sep="")
  rmarkdown::render(f.name,output_dir="../html")
}