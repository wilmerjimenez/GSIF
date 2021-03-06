\name{afss}
\docType{data}
\encoding{latin1}
\alias{afss}
\alias{afss.spec}
\title{Africa Sentinel Site data}
\description{Africa soil sampled collected at AfSIS sentinel sites. Part of the \href{http://www.africasoils.net/data/ldsf-description}{African Land Degradation Surveillance Framework} (LDSF) Field Database.}
\usage{data(afss)}
\format{
The \code{afss} data set contains two data frames --- sites and horizons. Sites table contains the following columns:
  \describe{
  \item{\code{SOURCEID}}{factor; study soil profile ID (\code{SPID} in the LDSF Field Database)}
  \item{\code{CNTISOC}}{factor; ISO country code (\code{CC} in the LDSF Field Database)}
  \item{\code{LOCNAME}}{factor; sentinel site name referring to the closest populated place (\code{Site} in the LDSF Field Database)}
  \item{\code{LONWGS84}}{numeric; longitude in decimal degrees on the WGS84 datum (\code{Lon} in the LDSF Field Database)}
  \item{\code{LATWGS84}}{numeric; latitude in decimal degrees on the WGS84 datum (\code{Lat} in the LDSF Field Database)}
}
Horizons table contains the following columns:
  \describe{
  \item{\code{SOURCEID}}{factor; study soil profile ID (\code{SPID} in the LDSF Field Database)}
  \item{\code{SAMPLEID}}{factor; soil sample ID (\code{SSID} in the LDSF Field Database)}
  \item{\code{UHDICM}}{numeric; upper sampling depth from the surface in cm}
  \item{\code{LHDICM}}{numeric; lower sampling depth from the surface in cm}
  \item{\code{CLYPPT}}{numeric; weight percentage of the clay particles (<0.0002 mm; \code{Clay} in the LDSF Field Database)}
  \item{\code{SNDPPT}}{numeric; weight percentage of the sand particles (0.0002--0.05 mm; \code{Sand} in the LDSF Field Database)}
  \item{\code{PHIHO5}}{numeric; pH index measured in water solution (\code{pH} in the LDSF Field Database)}
  \item{\code{BST}}{numeric; the exchangeable bases sum of exchangeable Ca, Mg, K \& Na of the sample in cmol/kg (\code{ExBas} in the LDSF Field Database)}
  \item{\code{ORCDRC}}{numeric; soil organic carbon content in permille (\code{SOC} in the LDSF Field Database)}
}
\code{afss.spec} table contains the following columns:
  \describe{
  \item{\code{SAMPLEID}}{factor; soil sample ID (\code{SSID} in the LDSF Field Database)}
  \item{\code{m4003.5}}{numeric; mid-infrared raw absorbance for denoted wavenumbers (Bruker-LTS instrument)}
  \item{\dots}{other raw absorbance values}
}
}
\note{The soil samples from the sentinel site network were collected using three stage sampling scheme: a number of sentinel sites (about 10 by 10 kilometers in size) have been first selected over the whole continent (60 sites in 2012). Each sentinel site is stratied into 16 grid cells (each 1 square kilometer), and sampling cluster centroids are randomly located within the grid cells. Around each centroid, 10 sampling plots are randomly located and soil samples taken (or 160 points per sentinel site). At each sampling plot, soil samples were taken at two depths: 0--20, and 20--50 cm. The block size of each sampling plot is 1000 square meters or 0.1 ha.}
\author{Africa Soil Information Service (\url{http://africasoils.net})}
\references{
\itemize{
\item Vagen, T., Shepherd, K. D., Walsh, M. G., Winowiecki, L., Desta, L. T., & Tondoh, J. E. (2010) \href{http://worldagroforestry.org/sites/default/files/afsisSoilHealthTechSpecs_v1_smaller.pdf}{AfSIS technical specifications: soil health surveillance}. World Agroforestry Centre, Nairobi, Kenya.
}
}
\examples{
\dontrun{
library(sp)
library(rgdal)

data(afss)
xy <- afss$sites
coordinates(xy) <- ~ LONWGS84 + LATWGS84
proj4string(xy) <- "+proj=longlat +datum=WGS84"
xy$PHIHO5_d1 <- merge(xy@data, afss$horizons[afss$horizons$UHDICM==0,], all.x=TRUE)$PHIHO5
library(plotKML)
data(R_pal)
plotKML(xy["PHIHO5_d1"], colour_scale=R_pal[["pH_pal"]])
## obtain country borders:
if(is.na(file.info("admin.af.rda")$size)){
download.file("http://gsif.isric.org/lib/exe/fetch.php?media=admin.af.rda", 
   "admin.af.rda")
}
try(load("admin.af.rda"))
proj4string(admin.af) <- get("ref_CRS", envir = plotKML.opts)
admin.af <- as(admin.af, "SpatialLines") 
## overlay and plot points and maps:
plot(admin.af, col="darkgrey", xlim=xy@bbox[1,], ylim=xy@bbox[2,])
points(xy, pch=21, bg="white", cex=.6, col="black")
## obtain MIR measurements:
if(is.na(file.info("afss.spec.rda")$size)){
download.file("http://gsif.isric.org/lib/exe/fetch.php?media=afss.spec.rda", 
  "afss.spec.rda")
}
try(load("afss.spec.rda"))
}
}
\keyword{datasets}