### Description In Class Demo: Some Crazy Ken Stuff
### Date: 10/18/2016

# Import CO2 Data
str(CO2)
fit <- lm(uptake ~ conc, data = CO2)
summary(fit)
str(fit)
fitted(fit)
residuals(fit)
