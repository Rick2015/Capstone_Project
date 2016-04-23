library(data.table)
library(ggplot2)

DT1 <- readRDS("./data/dt1.rds")
DT2 <- readRDS("./data/dt2.rds")
DT3 <- readRDS("./data/dt3.rds")

shinyServer(
  function(input, output) {

    dataOut <- reactive({ 

      myinput <- tolower(unlist(strsplit(input$id1,"[^A-Za-z'0-9#.]+")))
      myinput <- append("<b>", myinput, after= 1)
      ilength <- length(myinput)
      
      if (ilength > 1){
      for (i in 1:ilength){ myinput[i] <- gsub("[0-9]", "<n>", myinput[i]) }
      for (i in 1:ilength){
        if (length(DT1[ugram1 %in% myinput[i]][,ugram1]) == 0) myinput[i] <- "<u>" }
      i <- 1
      
      while(i <= ilength){
        phrase <- paste(myinput[i:ilength], collapse=' ')
        query <- paste("^", phrase, " ", sep="")
        if (length(myinput[i:ilength]) == 2) out3 <- (head(DT3[grep(query,tgram3, perl = TRUE)],10))
        if (length(myinput[i:ilength]) == 1) out2 <- (head(DT2[grep(query,bgram2, perl = TRUE)],10))
        i <- i + 1
      }
      ## Remove token of <u>, <b>, <e>, <n>
      
      out3 <- out3[!grep(">$", tgram3)] 
      out2 <- out2[!grep(">$", bgram2)]
      out3 <- out3[!grep(">$", tgram3, perl=TRUE)] 
      out2 <- out2[!grep(">$", bgram2, perl=TRUE)]
      
      ## SHORTEN TO FIVE ENTRIES ##
      out3 <- head(out3,5)
      out2 <- head(out2,5)
      out1 <- head(DT1[!grep(">$",ugram1)],5) 
      
      ## FILTER OPTION - www.FrontGateMedia.com ##
      blocked_words <- gsub(",", "", read.csv("./data/Terms-to-Block.csv", sep = ",", skip = 3, colClasses=c("NULL",NA))[,1], fixed = TRUE);
      wordFilter <- function(word){
        if (word %in% blocked_words) return("<FilterON!>")
        return(word)
      }
      
      pfilter <- input$cb1

      if(pfilter == 1 && nrow(out3) > 0) {
        for (i in 1:nrow(out3)){
          newWord3<-wordFilter(strsplit(out3[i,tgram3],"\\s")[[1]][3])
          out3[i,tgram3:=paste(strsplit(out3[i,tgram3],"\\s")[[1]][1], strsplit(out3[i,tgram3],"\\s")[[1]][2], newWord3,sep=" ")]
        }
      }
     

      if(pfilter == 1 && nrow(out2) > 0) {
        for (i in 1:nrow(out2)){
          newWord2<-wordFilter(strsplit(out2[i,bgram2],"\\s")[[1]][2])
          out2[i,bgram2:=paste(strsplit(out2[i,bgram2],"\\s")[[1]][1], newWord2,sep=" ")]
        }
      }
      ####### END OF FILTER ########
      
      w3 <- vector()
      w2 <- vector()
      w1 <- out1[,ugram1]
      
      if (nrow(out3) > 0 ) {
        for (i in 1:nrow(out3)){
          w3[[i]] <- strsplit(out3[i,tgram3],"\\s")[[1]][3]
        }
      }
      if (nrow(out2) > 0 ) {
        for (i in 1:nrow(out2)){
          w2[[i]] <- strsplit(out2[i,bgram2],"\\s")[[1]][2]
        }
      }

      out <- head(unique(c(w3,w2,w1)),5)

      }
      ### Handle No Input ###
      if(!exists("out")) out=c("Please type input above ^")
      if(!exists("out2")) out2 <- data.table(bgram2=character(0), bFreq2=integer(0), gli2=numeric(0))
      if(!exists("out3")) out3 <- data.table(tgram3=character(0), tFreq3=integer(0), gli3=numeric(0))
      list(out=out, out2=out2, out3=out3)
      
 
      })

    output$od1 <- renderPrint({ dataOut()$out })
    
    output$newPlot3 <- renderPlot({
      trdfp <- ggplot(dataOut()$out3, aes( reorder(tgram3, tFreq3), tFreq3))
      trdfp <- trdfp + geom_bar(stat = "identity", aes(fill=tFreq3),alpha=.7, width=.5) + ylab("Frequency") + xlab("3-gram") + ggtitle("Top Trigrams") +theme(axis.text.y=element_text(size=13)) + coord_flip()
      trdfp
    })  
    output$newPlot2 <- renderPlot({
      bidfp <- ggplot(dataOut()$out2, aes( reorder(bgram2, bFreq2), bFreq2))
      bidfp <- bidfp + geom_bar(stat = "identity", aes(fill=bFreq2), alpha=.7, width=.5) + ylab("Frequency") + xlab("2-gram") + ggtitle("Top Bigrams") +theme(axis.text.y=element_text(size=13)) + coord_flip()
      bidfp
    })
    
  } ) 