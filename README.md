# SoilErosionMap
### An open-source and open-access resource for the soil erosion community.

The interactive web application can be viewed at [SoilErosionMap] or ran locally using the instructions below.

This work sits alongside a peer-reviewed [Geoderma] publication [Benaud et al. (In review)] *National-scale geodata describe widespread accelerated soil erosion.* 

This work was undertaken as part of Defra-funded Project [SP1311]: *Piloting a cost-effective for monitoring soil erosion in England and Wales*.

Further information about the geodatabase can be found at <WEBLINK>.

---

To run the app locally, please run the following in your R console: 
```R
library(shiny)
runGitHub( "SoilErosionMap", "piabenaud")
```
To do this you will need the following packages, which can be installed by running this code in your R console:
 ```R
 install.packages(c("shiny", "leaflet", "ggplot", "dplyr", "readr", "rgdal", "scales", "lubridate", "DT", "htmltools"))
 ```
 R can be downloaded from <https://www.r-project.org/> and I use the Rstudio IDE, available from <https://rstudio.com/products/rstudio/download/>
 
---

To cite this resource please use <DOI:TBD> (Journal article) and [![DOI](https://zenodo.org/badge/DOI/http://10.5281/zenodo.3670112.svg)](https://doi.org/http://10.5281/zenodo.3670112) (GitHub code). 

For future collaborations or to suggest improvements to the Shiny app please contact [Pia Benaud] at the University of Exeter, UK. 

--- 

This code has been developed using some of the code from the Shiny [SuperZip] example by [jcheng5] and the [DT Editor] made by [jienagu]



[SoilErosionMap]: https://piabenaud.shinyapps.io/SoilErosionMap
[Geoderma]: https://www.journals.elsevier.com/geoderma
[Benaud et al. (In review)]: DOI
[Pia Benaud]: http://geography.exeter.ac.uk/staff/index.php?web_id=Pia_Benaud
[Superzip]: https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
[jcheng5]: https://github.com/jcheng5
[SP1311]: http://randd.defra.gov.uk/Default.aspx?Module=More&Location=None&ProjectID=18369
[DT Editor]: https://github.com/jienagu/DT-Editor
[jienagu]: https://github.com/jienagu