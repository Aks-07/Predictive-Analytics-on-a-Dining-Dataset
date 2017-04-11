LIBNAME PRJT "C:\Users\mouni\Documents\Courses - Spring 2017\Marketing Predictive Analytics with SAS\Project"; run;

*To decide on variables for clustering; 
proc varclus  data=PRJT.tgif maxc=15; var points_ratio--customer_number; run;

*Finalizing variables that have most explanatory power using a regression model, done through multiple steps of regression;
proc reg data = PRJT.tgif; 
model net_sales_tot = items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot / VIF;
output out = resid  p = predicted student = student;run;*Obtained a fit of 93.37% Adj-R2 through this model

*Deleting the outliers;
data PRJT.tgif_smooth;
set resid;
if student > 3.00 then delete;
if student < -3.00 then delete;
run;

*Standardizing data to run k-means;
proc standard data = PRJT.tgif_smooth mean = 0 std = 1 
out = PRJT.tgif_std;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Running K-means with different clusters starting from 2 to 10; 
proc fastclus data = PRJT.tgif_std maxclusters = 2
out = PRJT.clus_2;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc fastclus data = PRJT.tgif_std maxclusters = 3
out = PRJT.clus_3;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc fastclus data = PRJT.tgif_std maxclusters = 4
out = PRJT.clus_4;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Since a drop in CCC was found between n=3 to n=4,sorting by another parameter to see if it can improve clustering;
*Choosing net_sales_tot;

PROC SORT data = PRJT.tgif_std; by net_sales_tot;run;

*Running K-means with different clusters starting from 2 to 10 andwith a random seed; 
proc fastclus data = PRJT.tgif_std maxc=2 random = 200 replace = random
out = PRJT.clus2_2;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Sort the clusters w.r.t customer id so as to associate customers to a cluster;
proc sort data = PRJT.clus2_2; by customer_number; run;

*Sort the merge data w.r.t customer id so as to associate customers to a cluster;
proc sort data = PRJT.tgif_smooth; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_2;
merge PRJT.clus2_2 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=3 random = 200 replace = random
out = PRJT.clus2_3;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Sort cluster by customer number;
proc sort data = PRJT.clus2_3; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_3;
merge PRJT.clus2_3 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=4 random = 200 replace = random
out = PRJT.clus2_4;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus2_4; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_4;
merge PRJT.clus2_4 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=5 random = 200 replace = random
out = PRJT.clus2_5;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Sort cluster by customer number;
proc sort data = PRJT.clus2_5; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_5;
merge PRJT.clus2_5 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=6 random = 200 replace = random
out = PRJT.clus2_6;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus2_6; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_6;
merge PRJT.clus2_6 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=7 random = 200 replace = random
out = PRJT.clus2_7;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*Sort cluster by customer number;
proc sort data = PRJT.clus2_7; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_7;
merge PRJT.clus2_7 PRJT.tgif_smooth; by customer_number ; run;

proc fastclus data = PRJT.tgif_std maxc=8 random = 200 replace = random
out = PRJT.clus2_8;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus2_8; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_8;
merge PRJT.clus2_8 PRJT.tgif_smooth; by customer_number ; run;

*Using PROC DISCRIM to select the best clustering criterion;
proc discrim data= PRJT.Cluster2_2 out= output2 scores = x2 method=normal short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_3 out= output3 scores = x3 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_4 out= output4 scores = x4 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_5 out= output5 scores = x5 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_6 out= output6 scores = x6 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_7 out= output7 scores = x7 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc discrim data= PRJT.Cluster2_8 out= output8 scores = x8 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Ward's method to determine ideal number of clusters; 
ods graphics on;
proc cluster data=PRJT.tgif_std method=ward ccc pseudo k=110 print=25;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
id customer_number;
run;
*ods graphics off;
* Says it could be 8, 10, 12, 15, 17, 19;
*Trying out 10, 12 & 15, 17, 19;
proc fastclus data = PRJT.tgif_std maxc=10 random = 200 replace = random
out = PRJT.clus2_10;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus2_10; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_10;
merge PRJT.clus2_10 PRJT.tgif_smooth; by customer_number ; run;

proc discrim data= PRJT.Cluster2_10 out= output10 scores = x10 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*10 is lower than 8;
proc fastclus data = PRJT.tgif_std maxc=12 random = 200 replace = random
out = PRJT.clus2_12;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus2_12; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster2_12;
merge PRJT.clus2_12 PRJT.tgif_smooth; by customer_number ; run;

proc discrim data= PRJT.Cluster2_12 out= output12 scores = x12 method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;
*12 is higher than 10;

*Trying out other seeds for 8 and 10;

proc fastclus data = PRJT.tgif_std maxc=6
out = PRJT.clus_final;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Sort cluster by customer number;
proc sort data = PRJT.clus_final; by customer_number; run;

* Merge cluster -customer id data with merge dataset;
data PRJT.cluster_final;
merge PRJT.clus_final PRJT.tgif_smooth; by customer_number ; run;

proc discrim data= PRJT.Cluster_final out= output scores = x method=normal anova short;
class cluster ;priors prop;id customer_number;
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

proc sort data = PRJT.Cluster_final; by cluster; run;

*Print output for k-means after the discrim has chosen the best cluster method;
* Gives output of what are the parameters for each cluster;
proc means data = PRJT.Cluster_final; by cluster; 
output out = means; 
var	net_sales_tot items_tot	disc_pct_tot	rest_loc_bar	fd_cat_steak
disc_ribs	time_breakfast	tenure_day disc_chan_gmms fd_cat_side	fd_cat_h_ent
age	email_click_rate	fd_cat_brunc	days_between_trans	disc_chan_gps	
fd_cat_bev	fd_cat_kids	guests_last_12mo	items_tot_distinct	checks_tot;
run;

*Extract only means from the cluster data for further analysis;
data means2;
set means;
where _stat_ = 'MEAN';
