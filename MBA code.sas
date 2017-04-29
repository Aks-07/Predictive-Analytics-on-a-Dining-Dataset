LIBNAME PRJT "C:\Users\Akshay"; run;

data PRJT.MBA;
set PRJT.Clus_mc4;
Alchohol = 0; Appetizer = 0; Beverage = 0; Brunch = 0; Buffet = 0; Burger = 0;
Combo = 0; Dessert = 0; Drink = 0; H_entree = 0; Kids = 0; I_entree = 0; Sides = 0;
Soupsal = 0; Steak = 0;
if fd_cat_alcoh > 0 then Alchohol = 1;
if fd_cat_app > 0 then Appetizer = 1;
if fd_cat_bev > 0 then Beverage = 1;
if fd_cat_brunc > 0 then Brunch = 1;
if fd_cat_buffe > 0 then Buffet = 1;
if fd_cat_burg > 0 then Burger = 1;
if fd_cat_combo > 0 then Combo = 1;
if fd_cat_dess > 0 then Dessert = 1;
if fd_cat_drink > 0 then Drink = 1;
if fd_cat_h_ent > 0 then H_entree = 1;
if fd_cat_kids > 0 then Kids = 1;
if fd_cat_l_ent > 0 then I_entree = 1;
if fd_cat_side > 0 then Sides = 1;
if fd_cat_soupsal > 0 then Soupsal = 1;
if fd_cat_steak > 0 then Steak = 1;
run;

* Performing market basket analysis;
proc logistic descending data = PRJT.MBA;
model Alchohol = Appetizer Beverage Brunch Buffet Burger Combo Dessert Drink H_entree Kids I_entree Sides Soupsal Steak;
where Cluster = 1;run;
