require(OpenSth)
require(rSL)
require(projectX)

#### EXEMPEL: Beräkna BLKI(tm) för olika adresser ####
jag <- sthAddr("Erkenskroken",24)
a1 <- sthAddr("Sveavägen",10)
a2 <- sthAddr("fiskmåsvägen",20)

blki(jag) # Indexvärde för en adress i närförord
blki(a1) # Indexvärde för en adress i innerstan
blki(a2) # Indexvärde för en adressi ytterförort


#### EXEMPEL: Datamining i Stockholms enhets-API ####
## Skapa ett adressobjekt
jag <- sthAddr("Fiskmåsvägen", 20)

## Hämta data om närmaste enheter ur Stockholms Enhets-API
# Enheter i enhets-API:t kan hämtas ut på många sätt. Nedan söker vi ut enheter baserat på ett av följande kriterier:
# 1. Enhetstypgrupp ("Skola", "Fritid" etc.)
# 2. Enhetstyp ("Grundskola", "Bibliotek" etc.)

## 1. Enhetstypgrupp
# Info om vilka typgrupper som kan skickas till GetNearestServiceUnit se här:
# http://api.stockholm.se/ServiceGuideService/ServiceUnitTypeGroups?apiKey=0eb1055a722f4b65986f545cb67bd44e
closestSchools <- GetNearestServiceUnit(7, jag$RT90, n=10)
closestCulture <- GetNearestServiceUnit(8, jag$RT90, n=50)
closestLeisure <- GetNearestServiceUnit(2, jag$RT90)

## 2. Enhetstyp
# Hämta enhetsdata för specifika enhetstyper, t.ex. "Grundskola".
# Info om vilka typer som finns i API:t finns här:
# http://api.stockholm.se/ServiceGuideService/ServiceUnitTypes?apiKey=0eb1055a722f4b65986f545cb67bd44e
closestPrimarySchools <- GetNearestServiceUnit("61c1cc6e-99bf-409a-85ca-4e3d0c137d5f", jag$RT90, n=10, groups=FALSE)
closestPrimarySchools <- GetNearestServiceUnit("61c1cc6e-99bf-409a-85ca-4e3d0c137d5f", jag$RT90, n=10, groups=FALSE)

closestLibraries <- GetNearestServiceUnit("9ff1c3b5-f2e9-45b4-a478-caa09d923417", jag$RT90, n=10, groups=FALSE)
closestMuseums <- GetNearestServiceUnit("ad53d167-dba4-4000-b9b0-89380b89e831", jag$RT90, n=10, groups=FALSE)
closestArtGalleries <- GetNearestServiceUnit("fd27590d-11ad-4811-9327-13e5a9fe9794", jag$RT90, n=10, groups=FALSE)

# Mät avståndet (i meter) från min adress till nåon enhet i datasetet
i <- 2; GetRTDistance(jag$RT90, c(closestLibraries[i,"GeographicalPosition.Y"], closestLibraries[i,"GeographicalPosition.X"]))



#### EXEMPEL: Restider från en gatuadress till T-Centralen ####
jag <- sthAddr("Fiskmåsvägen", 20)

# Hitta snittrestid till T-Centralen, kl. 12:00, idag
travelTimeFromPos(jag$WGS84)

# Hitta snittrestider för T-Centralen, Slussen, Odenplan
snittrestid <- travelTimeFromPos(jag$WGS84, destinations = c(9001, 9192, 9117), Time = "18:00", Date = "09.01.2014")


#### TESTKOD ####

# Hämta data för närmaste skolan
school1 <- list_to_table(closestPrimarySchools[[1]]$Attributes)
addr <- as.character(school1[school1$Id == "StreetAddress","Value"])
addr <- str_split(addr, " ", n=2)[[1]]
street <- addr[1]
number  <- addr[2]
if (str_detect(number, "[[:digit:]][[:blank:]|\\-]+")) {
  number <- str_split(number, "[[:blank:]|\\-]")[[1]][1]
}
number <- as.integer(number)
addrObj1 <- sthAddr(street, number)

school5 <- list_to_table(closestPrimarySchools[[5]]$Attributes)
addr <- as.character(school5[school5$Id == "StreetAddress","Value"])
addr <- str_split(addr, " ", n=2)[[1]]
street <- addr[1]
number  <- addr[2]
if (str_detect(number, "[[:digit:]][[:blank:]|\\-]+")) {
  number <- str_split(number, "[[:blank:]|\\-]")[[1]][1]
}
number <- as.integer(number)
addrObj5 <- sthAddr(street, number)


school10 <- list_to_table(closestPrimarySchools[[10]]$Attributes)
addr <- as.character(school10[school10$Id == "StreetAddress","Value"])
addr <- str_split(addr, " ", n=2)[[1]]
street <- addr[1]
number  <- addr[2]
if (str_detect(number, "[[:digit:]][[:blank:]|\\-]+")) {
  number <- str_split(number, "[[:blank:]|\\-]")[[1]][1]
}
number <- as.integer(number)
addrObj10 <- sthAddr(street, number)

# Mät avståndet från min adress till skolorna
GetRTDistance(jag$RT90, addrObj1$RT90)
GetRTDistance(jag$RT90, addrObj5$RT90)
