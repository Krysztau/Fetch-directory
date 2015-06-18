library("httr")
library("XML")
url <- "https://brent.gov.uk/your-community/community-directory/"
raw <- GET (url)
contentMain <- content(raw, as= "text")
parsedMain <- htmlParse(contentMain, asText=T)
links <- xpathSApply(parsedMain, "//li/h2/a[@href]" , xmlGetAttr, "href")
links <- paste("https://brent.gov.uk", links, sep="")

## here is a bit of code that returned link descriptions - may be useful in the next step :)
##		xpathSApply(parsedMain, "//li/h2/a" , xmlValue)

##	next step - create a loop 

for (i in 2:27) {
	url <- paste("https://brent.gov.uk/your-community/community-directory/?page=", i, sep="")
	raw <- GET (url)
	contentMain <- content(raw, as= "text")
	parsedMain <- htmlParse(contentMain, asText=T)
	linkstemp <- xpathSApply(parsedMain, "//li/h2/a[@href]" , xmlGetAttr, "href")
	linkstemp <- paste("https://brent.gov.uk", linkstemp, sep="")
	links <- c(links, linkstemp)
}