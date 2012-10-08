# Loading libraries
library(XML)
library(stringr)
library(plyr)
library(reshape2)

doc <- htmlTreeParse('data/compass.cvk2012.org.htm', useInternalNodes = T)
candidcompass <- getNodeSet(doc, "//div[@class='candidate_compass_data']")
candidname <- getNodeSet(doc, "//span[@class='title']")
# .//div[@class='candidates_item']/div[@class='account_candidate_PrintShort']/span[@class='politblock']
compass <- laply(candidcompass, xmlValue )
compass <- str_replace(compass, '\\[(.*)\\]', '\\1')
compass <- read.table(textConnection(compass), sep=',')
name <- laply(candidname, xmlValue)
name <- str_replace_all(name, '\\r\\n(\\t)*', '')
candidates <- cbind(name, compass)
candidatesm <- melt(candidates, id.vars='name')
detectgender <- function(x) {
        str_detect(x, "ич$")
}

# compass <- htmlTreeParse("http://compass.cvk2012.org/compass/",
#                          useInternalNodes = T)
