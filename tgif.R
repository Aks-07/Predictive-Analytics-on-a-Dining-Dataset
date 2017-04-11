install.packages(sas7bdat)
library(sas7bdat)
x<-read.sas7bdat(C:\\Users\\Akshay\\Documents\\tgif.sas7bdat, debug=TRUE)
x  

summary(x)
#points_ratio, email_Send, email_open_rate, time_dinner, time_lunch, disc_pct_tot, disc_chan_value, disc_pct_trans,
#items_tot_distinct, items_tot, net_amt_p_item, checks_tot, net_sales_p_chck, net_sales_tot 
#days_between_trans, tenure_day, age, guests_last_12mo, customer_number
#fd_cat_alcoh, fd_cat_app, fd_cat_bev, fd_cat_bev, fd_cat_h_ent, 


#keeping only what i think are important variables 
tgif = subset(x, select = c(points_ratio, email_send, email_open_rate, time_dinner, time_lunch, disc_pct_tot, 
                          disc_chan_value, disc_pct_trans, items_tot_distinct, items_tot, net_amt_p_item, checks_tot,
                          net_sales_p_chck, net_sales_tot, days_between_trans, tenure_day, age, guests_last_12mo, 
                          customer_number, fd_cat_alcoh, fd_cat_app, fd_cat_bev, fd_cat_bev, fd_cat_h_ent))


#running linear regression on tgif to check for significant variables?

reg <- lm(net_sales_tot ~ points_ratio + email_send + email_open_rate + time_dinner + time_lunch + disc_pct_tot + 
   disc_chan_value + disc_pct_trans + items_tot_distinct + items_tot + net_amt_p_item + checks_tot +
   net_sales_p_chck + days_between_trans + tenure_day + age + guests_last_12mo + customer_number 
   + fd_cat_alcoh + fd_cat_app + fd_cat_bev + fd_cat_bev + fd_cat_h_ent, data = tgif )

summary(reg)


#creating subset of significant variables alone for clustering

tgif_reg= subset(x, select = c(points_ratio,  time_dinner, time_lunch,disc_chan_value,  items_tot_distinct, items_tot, 
                      net_amt_p_item, net_sales_p_chck, net_sales_tot, days_between_trans, tenure_day, age,
                      guests_last_12mo, customer_number, fd_cat_alcoh, fd_cat_bev))

#standardizing
tgif_std = apply(tgif_reg,2,function(r)
{  if (sd(r) != 0) 
  res = (r - mean(r))/sd(r) else res = 0 * r
  res}
)



# Initialize total within sum of squares error: wss
wss <- 0

# For 1 to 15 cluster centers
for (i in 1:15) {
  km.out <- kmeans(tgif_std, centers = i, nstart = 20)
  # Save total within sum of squares to wss variable
  wss[i] <- km.out$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")
