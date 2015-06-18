library("httr")
library("XML")

## before the loop create the list to store all entries:
AllEntries <- list()

## it is important that there is an object with the list of all links in memory before running this loop and it is called links

############ here the loop starts ###########
for (i in 1: length(links))
	{
	url <- links [i] ##replace with links[i]
	raw <- GET (url)
	contentSubpage <- content(raw, as= "text")
	parsedSubpage <- htmlParse(contentSubpage, asText=T)

	## name of the organisation
	OrgName <- xpathSApply(parsedSubpage, "//article/div/header/div/h1" , xmlValue)

	## list of available fields; e.g. address, phone, www etc.
	fieldNames <- xpathSApply(parsedSubpage, "//article/div[@class='article']/form/div[@class='twoColumnData']/h3" , xmlValue)

	## values of those fields
	details <- xpathSApply(parsedSubpage, "//article/div[@class='article']/form/div[@class='twoColumnData']/p" , xmlValue)

	## make vector representing first entry
	entry <- c(OrgName, details)
	names(entry) <- c("Organisation", fieldNames)

	## add this vector to the list of all entries
	AllEntries [[i]] <- entry
}
########### here the loop ends ###########	LOOKS OK SO FAR

## What are column names in the final table? 
tableNames <- c()
for (i in 1: length(AllEntries))
	{ tableNames <- c(tableNames, names(AllEntries[[i]]))	## THIS LOOP WORKS
}
## were there any missing names?
missingNames <- length(tableNames) - sum(is.na(tableNames))
## remove NAs from tableNames
tableNames <- tableNames [!is.na(tableNames)]
tableNames <- unique(tableNames)
## time to make and populate the FINAL TABLE

FinalTable <- matrix(ncol= length(tableNames), nrow= length(AllEntries))
FinalTable <- as.data.frame (FinalTable)
names (FinalTable) <- tableNames

################ loop to fill the data frame ################


for (i in 1: length(AllEntries))
	{
	FinalTable [i, tableNames] <- AllEntries [[i]] [tableNames]
}

## Export to CSV

WD <- getwd()
setwd("/media/k/Data/WestwayCT/")
write.table(FinalTable, file="Contacts.csv", sep=",", na="", row.names=FALSE, col.names=TRUE, fileEncoding="UTF-8")
setwd(WD)

paste("there was ", missingNames, " of missing names")

### END OF STORY ###