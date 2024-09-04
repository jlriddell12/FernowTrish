library(sf); library(terra); library(spData); library(ggplot2); library(geodata);library(elevatr); library(tidyterra); library(soilDB); library(rnaturalearth)


# Fernow Property

fernow <- st_read('C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\Fernow')

## Changing CRS
fernow <- st_transform(fernow, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))

# WV geology

geo <- st_read("C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\WV geo 2")

geo <- st_transform(geo, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))

ggplot(geo)+
  geom_sf(aes(fill = MAP_UNIT))


#Cutting out Fernow shape
geo2 <- st_intersection(geo, fernow)

ggplot(geo2)+
  geom_sf(aes(fill = MAP_UNIT))+
  scale_fill_manual("Map Unit", values = c('darkslategray2','lightgoldenrod','plum2','coral1','cornflowerblue','tan1','olivedrab2'))+
  theme_minimal()


# Watersheds

water <- st_read("C:\\Users\\patri\\OneDrive - Chatham University\\Trish_Summer2024\\GIS\\Watersheds")

water <- st_transform(water, crs = st_crs("+proj=utm +zone=17 +datum=WGS84"))


water2 <- st_intersection(water, fernow)

ggplot()+
  geom_sf(data=fernow, fill = 'darkgreen', color = 'darkgreen')+
  geom_sf(data = water2, fill = NA, color = 'lightblue')+
  theme_minimal()
  


