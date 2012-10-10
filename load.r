# Convert original html-file in data.frame with candidates' names and compass data

# Loading libraries
library(XML)
library(stringr)
library(plyr)
library(reshape2)

# Covert raw html-file in R HTML-tree
doc <- htmlTreeParse('data/compass.cvk2012.org.htm', useInternalNodes = T)

# Extract compass data in XML-pieces
candidcompass <- getNodeSet(doc, "//div[@class='candidate_compass_data']")

# Extract candidate names in XML-pieces
candidname <- getNodeSet(doc, "//span[@class='title']")

# Get political blocks of candidates. Doesn't work yet.
# .//div[@class='candidates_item']/div[@class='account_candidate_PrintShort']/span[@class='politblock']

# Convert list of XML-pieces in vector of strings
compass <- laply(candidcompass, xmlValue )

# Remove bracketes
compass <- str_replace(compass, '\\[(.*)\\]', '\\1')

# Convert strings in numeric values
compass <- read.table(textConnection(compass), sep=',')

# Extract strings with names from XML-pieces
name <- laply(candidname, xmlValue)

# Remove some garbage
name <- str_replace_all(name, '\\r\\n(\\t)*', '')

# Construct united data.frame
candidates <- cbind(name, compass)

# Declare function to detect gender from russian-style middle name
detectgender <- function(x) {
        str_detect(x, "ич$")
}

# Trying to get compass data labels
# compass <- htmlTreeParse("http://compass.cvk2012.org/compass/",
#                          useInternalNodes = T)

# Short labels for compass questions
varlabs <- c("Парл.респуб", "Защит.пошлины", "Огранич.миграц.", "Госучр.из Мск", "Оппозиц.на выборы", "Беспл.мед. и обр", "ЭксСССР", "Бюдж.в рег", "Проф.армия", "Плоск.налог", "Интегр.с ЕС", "Оружие", "ЕГЭ", "Тит.нация", "Нет ЕР", "Выборн.МСУ", "Деньги Кавказу", "Пересм.приватиз", "Госкорпорац", "Накопит.пенс", "Религ.в УК", "Альтер.парлам", "Присяжн.УК", "Либерал.экон", "Компромисс с власт")

names(candidates)[2:26] <- varlabs     

# Convert to long-form (for ggplot graphics)
candidatesm <- melt(candidates, id.vars='name')
