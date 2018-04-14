library(shiny)
library(ggplot2)


shinyServer(function(input, output) {
    
    # Generate the requested distribution
    data <- reactive({
        if (input$dist=='norm'){
            mns=NULL
            for (i in 1:input$n) mns=c(mns,mean(rnorm(input$size,input$mean,input$sd)))
            mns
        }
        else if (input$dist=='unif'){
            mns=NULL
            for (i in 1:input$n) mns=c(mns,mean(runif(input$size,input$range[1],input$range[2])))
            mns
        }
        else if (input$dist=='lnorm'){
            mns=NULL
            for (i in 1:input$n) mns=c(mns,mean(rlnorm(input$size,input$meanlog,input$sdlog)))
            mns
        }
        else if (input$dist=='exp'){
            mns=NULL
            for (i in 1:input$n) mns=c(mns,mean(rexp(input$size,input$rate)))
            mns
        }
    })
    
    thsd<-reactive({
        if (input$dist=='norm'){
            (input$sd/sqrt(input$size))
        }
        else if (input$dist=='unif'){
            sqrt(1/12*(input$range[2]-input$range[1])^2/input$size)
        }
        else if (input$dist=='lnorm'){
            sqrt((exp(input$sdlog^2)-1)*exp(2*input$meanlog+input$sdlog^2)/input$size)
        }
        else if (input$dist=='exp'){
            (1/input$rate/sqrt(input$size))
        }
    })
        
    thmean<-reactive({
        if (input$dist=='norm'){
            input$mean
        }
        else if (input$dist=='unif'){
            (mean(input$range))
        }
        else if (input$dist=='lnorm'){
            exp(input$meanlog+input$sdlog^2/2)
        }
        else if (input$dist=='exp'){
            (1/input$rate)
        }
    })
        

    # Generate a plot of the data
    
    output$plot <- renderPlot({
        g<-ggplot(data.frame(x=data()), aes(x = x)) + 
            geom_histogram(bins=15, color='black', fill='red', aes(y = ..density..)) +
            labs(x='sample mean', title='Histogram of Sample Distribution')
        if (input$normdist) g<- g + stat_function(fun = dnorm,args=list(mean=thmean(),sd=thsd()))
        if (input$smean) g<- g + geom_vline(xintercept=mean(data()),color='blue')
        g
        })
    
    output$statMean <- renderText({
        paste("Expected Mean:", round(thmean(),3),
               "| Sample Mean:", round(mean(data()),3))
    })
    
    output$statSD <- renderText({
        paste("Expected SD:", round(thsd(),3),
              "| Sample SD:", round(sd(data()),3))
    })
})