library(sf); library(terra); library(spData); library(ggplot2); library(geodata);library(elevatr); library(tidyterra); library(soilDB); library(rnaturalearth)


# Fernow Property

fernow <- st_read('C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\Fernow')

## Changing CRS
fernow <- st_transform(fernow, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))

# WV geology

geo <- st_read("C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\WV geo")

geo <- st_transform(geo, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))

ggplot(geo, fill = NAME)+
  geom_sf()

## something is definitely not right there

# Watersheds

water <- st_read("C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\Watersheds")

water <- st_transform(water, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))


both <- st_intersection(water, fernow)

ggplot()+
  geom_sf(data=fernow, fill = 'darkgreen', color = 'darkgreen')+
  geom_sf(data = both, fill = NA, color = 'lightblue')+
  theme_minimal()
  


