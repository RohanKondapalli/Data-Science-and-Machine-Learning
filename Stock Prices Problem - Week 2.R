#STOCK PRICES PROBLEM
#CEO of a company wants review stock prices of here company on a weekly basis 
#She is seeking information on average stock price, which day the stock price was the max, price for last three days etc. 
x<-10
print(x)
x<- mtcars
print(mtcars)
#1Create a vector called stock.prices with the following data points: 25,27,25,21,34.
stock.prices = c(25,27,25,21,34)
#2 Print stock.prices. Ans 25 27 25 21 34
print(stock.prices)
#3 assign names  to the prices with days of the week starting with Mon, Tue, Wed, etc…
names(stock.prices)=c('Mon','Tue','Wed','Thu','Fri')
#4  Print the stock.prices. 
print(stock.prices)
#5 List the stock price for last 3 days of the week
print(stock.prices[3:5])
#6 List the stock prices for Mon and Wednesday
print(stock.prices[c(1,3)])
print(stock.prices[c(1,3,5)])
#7 What was the average (mean) stock price for the week? 
print(mean(stock.prices))
#8 Create a vector called over.25 that corresponds to the days where the stock price was more than $25 
over.25<-stock.prices>25
#9 Use the over.25 vector to return the day and prices where the price was over $25. Yes there is a simpler way to do this, but idea is to use logicals 
over.25<-stock.prices>25
#10 yes, there is another simpler way to do the above too. 
print(stock.prices>25)
#11 Use a built-in function to find the day the price was the highest. Ans Friday 34 
stock.prices[stock.prices == max(stock.prices)]
#Chances are that it did not really show you the day! Only the max price. 
#if yes, then you need to use the comparison operator to filter  all  stock prices other than the max.


