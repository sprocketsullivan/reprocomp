# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.5.3

# required
MAINTAINER Ulf <toelch@gmail.com>

COPY . /reprocomp

# go into the repo directory
RUN . /etc/environment \

  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  && sudo apt-get install pandoc \
  && sudo apt-get install pandoc-citeproc\

  # build this compendium package
  && R -e "devtools::install('/reprocomp', dep=TRUE)" \
  && R -e "install.packages(c('readxl', 'rio','dataverse'),dep=TRUE,repos='http://cran.rstudio.com/')" \

 # render the manuscript into a docx, you'll need to edit this if you've
 # customised the location and name of your main Rmd file
  && R -e "rmarkdown::render('/reprocomp/analysis/paper/paper.Rmd','bookdown::pdf_document2')"
