# J. Tabor
# 14 October 2019
# Project: Invasive Bees Hawaii
# R script: crops and masks bioclimatic variables to convex hull of target species
# target species: Apis mellifera native range

# load libraries
library(rgbif)
library(biomod2)
library(ggplot2)
library(gridExtra)
# library(sf) #doesn't load in with R on the HPC...need to either update R language.
library(ade4)
library(rgdal)
library(raster)
library(maptools)
library(rasterVis)
library(latticeExtra)
library(lattice)
library(sp)
library(geometry)
library(maps)

print("loaded libraries")

# setwd
setwd("/home/kochj/hilo_koch_lts/biomod_inR/Tabor-thesis")

#load X. sonorina occurences
df <- read.table("nat_range/nat_imbrex_convhull.csv",
                 header=TRUE, 
                 sep=",",
                 row.names=NULL)
print("loaded dataframe")

#create convex hull to surround the occurence points
ch <- chull(df)
coords <- df[c(ch, ch[1]), ]  # closed polygon
plot(df, pch=19)
lines(coords, col="red")

print("created convex hull")

#create a polygon for use in Arcmap
env <- SpatialPolygons(list(Polygons(list(Polygon(coords)), ID=1)),
                       proj4string = CRS("+proj=longlat +datum=WGS84"))

env <- SpatialPolygonsDataFrame(env, data=data.frame(ID=1))

print("env polygon made")

# only create this directory/folder once
dir.create("imbrex_env")

#set working directory to new folder
setwd("/home/kochj/hilo_koch_lts/biomod_inR/Tabor-thesis/imbrex_env/")

# create directory for the bioclimatic variables
dir.create("bioclim")

#save env conex hull polygon in env folder
writeOGR(env, "imbrex_env", layer="imbrex_env", driver="ESRI Shapefile")

print("saved env convex hull polygon to env folder")

#set working directory back to main
setwd("/home/kochj/hilo_koch_lts/biomod_inR/Tabor-thesis")

#stack all 19 bioclimatic variables
bio <- stack(list.files("bio",pattern = "bio",full.names = T),RAT = FALSE)

print("stacked 19 bioclimatic variables")

#mask and crop all 19 bioclimatic variables indavidually

bio_1 <- bio[[c(1)]]
bio_1 <- mask(bio_1,env)
bio_1 <-crop(bio_1,env)

print("bio1")

bio_10 <- bio[[c(2)]]
bio_10 <- mask(bio_10,env)
bio_10 <-crop(bio_10,env)

print("bio10")

bio_11 <- bio[[c(3)]]
bio_11 <- mask(bio_11,env)
bio_11 <-crop(bio_11,env)

print("bio11")

bio_12 <- bio[[c(4)]]
bio_12 <- mask(bio_12,env)
bio_12 <-crop(bio_12,env)

print("bio12")

bio_13 <- bio[[c(5)]]
bio_13 <- mask(bio_13,env)
bio_13 <-crop(bio_13,env)

print("bio13")

bio_14 <- bio[[c(6)]]
bio_14 <- mask(bio_14,env)
bio_14 <-crop(bio_14,env)

print("bio14")

bio_15 <- bio[[c(7)]]
bio_15 <- mask(bio_15,env)
bio_15 <-crop(bio_15,env)

print("bio15")

bio_16 <- bio[[c(8)]]
bio_16 <- mask(bio_16,env)
bio_16 <-crop(bio_16,env)

print("bio16")

bio_17 <- bio[[c(9)]]
bio_17 <- mask(bio_17,env)
bio_17 <-crop(bio_17,env)

print("bio17")

bio_18 <- bio[[c(10)]]
bio_18 <- mask(bio_18,env)
bio_18 <-crop(bio_18,env)

print("bio18")

bio_19 <- bio[[c(11)]]
bio_19 <- mask(bio_19,env)
bio_19 <-crop(bio_19,env)

print("bio19")

bio_2 <- bio[[c(12)]]
bio_2 <- mask(bio_2,env)
bio_2 <-crop(bio_2,env)

print("bio2")

bio_3 <- bio[[c(13)]]
bio_3 <- mask(bio_3,env)
bio_3 <-crop(bio_3,env)

print("bio3")

bio_4 <- bio[[c(14)]]
bio_4 <- mask(bio_4,env)
bio_4 <-crop(bio_4,env)

print("bio4")

bio_5 <- bio[[c(15)]]
bio_5 <- mask(bio_5,env)
bio_5 <-crop(bio_5,env)

print("bio5")

bio_6 <- bio[[c(16)]]
bio_6 <- mask(bio_6,env)
bio_6 <-crop(bio_6,env)

print("bio6")

bio_7 <- bio[[c(17)]]
bio_7 <- mask(bio_7,env)
bio_7 <-crop(bio_7,env)

print("bio7")

bio_8 <- bio[[c(18)]]
bio_8 <- mask(bio_8,env)
bio_8 <-crop(bio_8,env)

print("bio8")

bio_9 <- bio[[c(19)]]
bio_9 <- mask(bio_9,env)
bio_9 <-crop(bio_9,env)

print("bio9")

print("cropped bioclimatic variables")

#stack bioclim variables to save easily
bioclim <- stack(c(bio_1, bio_10, bio_11,
                   bio_12, bio_13, bio_14,
                   bio_15, bio_16, bio_17,
                   bio_18, bio_2,
                   bio_3, bio_4, bio_5,
                   bio_6, bio_7, bio_8,
                   bio_9))

print("stacked bioclimatic variables")

# setwd() to hold clipped and masked bioclim variables

setwd("/home/kochj/hilo_koch_lts/biomod_inR/Tabor-thesis/imbrex_env/bioclim/")

# WRITE the RASTERS
writeRaster(bioclim, filename=names(bioclim), bylayer=TRUE, format="raster", overwrite = TRUE)

print("wrote bioclimatic raster")