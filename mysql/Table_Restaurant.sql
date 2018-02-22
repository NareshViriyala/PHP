USE dbo;
DROP TABLE IF EXISTS dbo.tbl_mstr_RestaurantMenu;

CREATE TABLE dbo.tbl_mstr_RestaurantMenu(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , EntityID INT 
	 , ItemType BIT /*veg/nonveg*/
	 , ItemGroup NVARCHAR(100)
	 , ItemName NVARCHAR(100)
	 , ItemPrice INT
	 , ItemDesc NVARCHAR(500)
	 , SpiceIndex INT DEFAULT 0
	 , ChefRecommended BIT
	 , OrderID INT
	 , UpdateDate TIMESTAMP DEFAULT NOW());
ALTER TABLE dbo.tbl_mstr_RestaurantMenu ADD CONSTRAINT UK_tbl_mstr_RestaurantMenu UNIQUE (ItemType, ItemGroup, ItemName, ItemPrice); 

INSERT INTO dbo.tbl_mstr_RestaurantMenu(EntityID, ItemType, ItemGroup, ItemName, ItemPrice, ItemDesc, SpiceIndex, ChefRecommended, OrderID)
SELECT 5, 1, 'Kids Concepts','Candy Land',112,'A delightful combination of vanilla and strawberry ice cream with choco chips, jujube & choco stick and gems',0,0,1 UNION ALL
SELECT 5, 1, 'Kids Concepts','Magic Pop',99,'Ice cream sprinkled with sizzling  & crackling top-pings that pop in the mouth for a fun & flavourful experience',0,0,2 UNION ALL
SELECT 5, 1, 'Kids Concepts','Bubble Gum',83,'One Scoops of bubble gum ilce cream mixed with jelly cubes & jujube',0,0,3 UNION ALL
SELECT 5, 1, 'Diet Concepts','Fruit Fast',141,'A delightful combination of in season fruits ,with 95% fat free and no added sugar ice cream, indulge without guilt for weight watchers or other dietary restrictions',0,0,4 UNION ALL
SELECT 5, 1, 'Frozen Sundae','Hot Chocolate Fudge',125,'Ice cream with lots of hot chocolate Fudge with roasted cashews',0,0,5 UNION ALL
SELECT 5, 1, 'Frozen Sundae','Death By Chocolate',150,'Two scoops of ice cream topped with hot chocolate Pastry with lots of hot chocolate fudge',0,0,6 UNION ALL
SELECT 5, 1, 'Mini Concepts','Creamy Red  Velvet',100,'White chocolate ice cream mixed with Red velvet cake & choco chip & topped with choco stick',0,0,7 UNION ALL
SELECT 5, 1, 'Mini Concepts','Devils Brownie',100,'Delicious Dark chocolate ice cream mixed with brownie & topped with choco stick Plain & Simple flavours',0,0,8 UNION ALL
SELECT 5, 1, 'Simple Flavours','French Vanilla',62,'',0,0,9 UNION ALL
SELECT 5, 1, 'Simple Flavours','Nutty Crunch',62,'',0,0,10 UNION ALL
SELECT 5, 1, 'Simple Flavours','Fresh Strawberry',62,'',0,0,11 UNION ALL
SELECT 5, 1, 'Simple Flavours','Choco Fudge',66,'',0,0,12 UNION ALL
SELECT 5, 1, 'Simple Flavours','Rich Chocolate',66,'',0,0,13 UNION ALL
SELECT 5, 1, 'Simple Flavours','Caramel Nuts',66,'',0,0,14 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Willy Wonka',150,'Chocolate Ice Cream mixed with choco-chips chocolate Pastry, dark choco-fudge and Choco-Stick',0,0,15 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Oreo Shot',125,'Ice Cream with crunchy Oreo cookies & dripping fudge sauce',0,0,16 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Chocoholics',137,'Dark chocolate ice cream mixed with Perk, Oreo, Choco-chips, hot fudge topped withhot lava cake & choco-Stick',0,0,17 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Chocolava',187,'Chocolate Ice Cream mixed with crunchy Oreos, choco-chips, hot fudge topped with hot lava cake & choco-stick',0,0,18 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Ferrero Rocher',195,'Chocolate ice cream blended with ferrero rocher, hot fudge & chocolate stick topped with Ferrero Rocher',0,0,19 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Brownie Break ',133,'Ice cream with chocolate walnut brownie & dripping fudge sauce',0,0,20 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Nuttella Brownie',162,'Delicious ice cream mixed with crunchy oreo & choco chips, garnished with tiramisu powder & choco stick',0,0,21 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Tiramasu',166,'delicious tiramisu ice cream mixed with crunchy oreo & choco ships, garnished with tiramisu powder & choco stick',0,0,22 UNION ALL
SELECT 5, 1, 'Chocolate Concepts','Chocolate Overdose',150,'Two scoops of delicious ice cream mixed with Chocolate cake & topped with melting walnut brownie',0,0,23 UNION ALL
SELECT 5, 1, 'Fruit Concepts','Fruit Exotica',141,'Multi-flavour ice cream with exotic fruits toppings',0,0,24 UNION ALL
SELECT 5, 1, 'Fruit Concepts','Lichee Lake',141,'French vanilla ice cream mixed with lichee fruit and topped with a strawberry stick',0,0,25 UNION ALL
SELECT 5, 1, 'Fruit Concepts','Fresh Fruit & Nuts',150,'Strawberry ice cream crushed with fig, apple, pineapple & roasted cashews',0,0,26 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Dry Fruit Delight',141,'Our classic Dry Fruit Delight ice cream blended with fig & cashew nuts',0,0,27 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Nuts Overload',150,'A combination of Caramel & Butter Scotch Ice Cream mixed with roasted almonds, Cashews, & choco-stick',0,0,28 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Arabian Nights',150,'Scoops of delicious ice cream mlixed with dates, figs & mixed nuts',0,0,29 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Karamel Sutra',170,'Mouth watering ice cream mixed with roasted almond & brownie with hot choco fudge',0,0,30 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Twisted Karamel',160,'Buttery salted caramel ice cream mixed with Perk, topped with crunchy roasted almonds & choco-stick',0,0,31 UNION ALL
SELECT 5, 1, 'Nutty Concepts','Coffee Craze',137,'Coffee  + chocolate ice cream mixed with brownies, almond and fudge',0,0,32;




INSERT INTO dbo.tbl_mstr_RestaurantMenu(EntityID, ItemType, ItemGroup, ItemName, ItemPrice, ItemDesc, SpiceIndex, ChefRecommended, OrderID)
SELECT 2,1, 'Soups','Manchow Soup',125,'',0,0,1 UNION ALL
SELECT 2,1, 'Soups','Creame of Tomato Soup',125,'',0,0,2 UNION ALL
SELECT 2,1, 'Soups','Sweet Corn Vegetable Soup',125,'',0,0,3 UNION ALL
SELECT 2,1, 'Soups','Hot-N-Sour Vegetable Soup',125,'',0,0,4 UNION ALL
SELECT 2,0, 'Soups','Chicken Manchow Soup',134,'',0,0,5 UNION ALL
SELECT 2,0, 'Soups','Hot-N-Sour Chicken Soup',134,'',0,0,6 UNION ALL
SELECT 2,0, 'Soups','Clear Cicken Noodles Soup',134,'',0,0,7 UNION ALL
SELECT 2,0, 'Soups','Cream of Chicken Soup',134,'',0,0,8 UNION ALL
SELECT 2,0, 'Soups','Sweet Corn Chicken Soup',134,'',0,0,9 UNION ALL
SELECT 2,1, 'Starters','Baby Corn Hot-N-Pepper',229,'',0,0,10 UNION ALL
SELECT 2,1, 'Starters','Chilli Paneer',229,'',0,0,11 UNION ALL
SELECT 2,1, 'Starters','Gobi Manchirian',221,'',0,0,12 UNION ALL
SELECT 2,1, 'Starters','Crispy Corn Chilli Peppar',221,'',0,0,13 UNION ALL
SELECT 2,1, 'Starters','Baby Corn Manchurian',229,'',0,0,14 UNION ALL
SELECT 2,1, 'Starters','Paneer 65',229,'',0,0,15 UNION ALL
SELECT 2,1, 'Starters','Vegetable Manchurian',221,'',0,0,16 UNION ALL
SELECT 2,0, 'Starters','Chilli Prawns',378,'',0,0,17 UNION ALL
SELECT 2,0, 'Starters','Loose Prawns',378,'',0,0,18 UNION ALL
SELECT 2,0, 'Starters','Schezwan Fish',358,'',0,0,19 UNION ALL
SELECT 2,0, 'Starters','Chicken Drum Sticks',309,'',0,0,20 UNION ALL
SELECT 2,0, 'Starters','Chicken Manchurian',309,'',0,0,21 UNION ALL
SELECT 2,0, 'Starters','Chilli Chicken',309,'',0,0,22 UNION ALL
SELECT 2,0, 'Starters','Peppar Chicken',309,'',0,0,23 UNION ALL
SELECT 2,0, 'Starters','Fried Fish',309,'',0,0,24 UNION ALL
SELECT 2,0, 'Starters','Spring Roll -Veg/Egg/Chicken',175,'',0,0,25 UNION ALL
SELECT 2,0, 'Starters','Golden Fried Prawns',378,'',0,0,26 UNION ALL
SELECT 2,0, 'Starters','Apollo Fish',358,'',0,0,27 UNION ALL
SELECT 2,0, 'Starters','Chilli Fish',358,'',0,0,28 UNION ALL
SELECT 2,0, 'Starters','Chicken 65',309,'',0,0,29 UNION ALL
SELECT 2,1, 'Biryanis','Aloo Biryani',200,'',0,0,30 UNION ALL
SELECT 2,1, 'Biryanis','Vegetable Biryani',200,'',0,0,31 UNION ALL
SELECT 2,0, 'Biryanis','Paradise Special Biryani',860,'',0,0,32 UNION ALL
SELECT 2,0, 'Biryanis','Paradise Special Supreme Biryani Chicken',916,'',0,0,33 UNION ALL
SELECT 2,0, 'Biryanis','Paradise Special Supreme Biryani Mutton',956,'',0,0,34 UNION ALL
SELECT 2,0, 'Biryanis','Mutton Biryani',254,'',0,0,35 UNION ALL
SELECT 2,0, 'Biryanis','Chicken Biryani',244,'',0,0,36 UNION ALL
SELECT 2,0, 'Biryanis','Egg Biryani',200,'',0,0,37 UNION ALL
SELECT 2,0, 'Kebabs','Special Kebab Platter',460,'',0,0,38 UNION ALL
SELECT 2,0, 'Kebabs','Tandoori Chicken (Full)',443,'',0,0,39 UNION ALL
SELECT 2,0, 'Kebabs','Fish Tikka Kebab/ Fish Malai Kebab',309,'',0,0,40 UNION ALL
SELECT 2,0, 'Kebabs','Mutton Peppar Kebab',299,'',0,0,41 UNION ALL
SELECT 2,0, 'Kebabs','Mutton Tikka Kebab',299,'',0,0,42 UNION ALL
SELECT 2,0, 'Kebabs','Mutton Malai Kebab',299,'',0,0,43 UNION ALL
SELECT 2,0, 'Kebabs','Mutton Sheek Kebab',299,'',0,0,44 UNION ALL
SELECT 2,0, 'Kebabs','Chicken Garlic Kebab',284,'',0,0,45 UNION ALL
SELECT 2,0, 'Kebabs','Chicken Hara Bhara Kebab',284,'',0,0,46 UNION ALL
SELECT 2,0, 'Kebabs','Chicken Sheek Kebab/ Reshmi Kebab',284,'',0,0,47 UNION ALL
SELECT 2,0, 'Kebabs','Tandoori Chicken (Half)',284,'',0,0,48 UNION ALL
SELECT 2,1, 'Kebabs','Paneer Tikka Kebab',210,'',0,0,49 UNION ALL
SELECT 2,1, 'Kebabs','Veg Sheek Kebab',200,'',0,0,50 UNION ALL
SELECT 2,0, 'Kebabs','Chicken Tikka Kebab/Kalmi Kebab',284,'',0,0,51 UNION ALL
SELECT 2,1, 'Kebabs','Paneer Achari Kebab',210,'',0,0,52 UNION ALL
SELECT 2,1, 'Veg Curries','Palak Paneer',210,'',0,0,53 UNION ALL
SELECT 2,1, 'Veg Curries','Dal Fry',200,'',0,0,54 UNION ALL
SELECT 2,1, 'Veg Curries','Dal Makhani',200,'',0,0,55 UNION ALL
SELECT 2,1, 'Veg Curries','Vegetable-Do-Pyaza',200,'',0,0,56 UNION ALL
SELECT 2,1, 'Veg Curries','Methi Chamen',200,'',0,0,57 UNION ALL
SELECT 2,1, 'Veg Curries','Kadai Vegetables',200,'',0,0,58 UNION ALL
SELECT 2,1, 'Veg Curries','Kadai Paneer',210,'',0,0,59 UNION ALL
SELECT 2,1, 'Veg Curries','Malai Koftha',210,'',0,0,60 UNION ALL
SELECT 2,1, 'Veg Curries','Paneer Butter Masala',210,'',0,0,61 UNION ALL
SELECT 2,1, 'Veg Curries','Mixed Vegetable Curry',200,'',0,0,62 UNION ALL
SELECT 2,0, 'Curries','Mutton Tikka Masala/Mutton Masala',309,'',0,0,63 UNION ALL
SELECT 2,0, 'Curries','Mutton Rogan Josh/Kadai Gosht',309,'',0,0,64 UNION ALL
SELECT 2,0, 'Curries','Butter Chicken Boneless',288,'',0,0,65 UNION ALL
SELECT 2,0, 'Curries','Chicken Tikka Masala/Kadai Chicken',288,'',0,0,66 UNION ALL
SELECT 2,0, 'Curries','Chicken Chilli Masala',278,'',0,0,67 UNION ALL
SELECT 2,0, 'Curries','Chicken Masala/Chicken Curry',278,'',0,0,68 UNION ALL
SELECT 2,0, 'Curries','Prawns Masala',309,'',0,0,69 UNION ALL
SELECT 2,0, 'Curries','Fish Masala',288,'',0,0,70 UNION ALL
SELECT 2,0, 'Curries','Egg Masala',200,'',0,0,71 UNION ALL
SELECT 2,0, 'Curries','Paradise Special Mutton ',329,'',0,0,72 UNION ALL
SELECT 2,0, 'Curries','Mutton Shahi Korma/Kheema Masala',309,'',0,0,73 UNION ALL
SELECT 2,0, 'Curries','Tandoori Chicken Masala/ Murg Musallam',288,'',0,0,74 UNION ALL
SELECT 2,0, 'Curries','Chicken Nawabi/ Chicken Kandhari',288,'',0,0,75 UNION ALL
SELECT 2,0, 'Curries','Paradise Special Chicken Curry',288,'',0,0,76 UNION ALL
SELECT 2,0, 'Breads','Kheema Naan/ Paneer Kulcha',75,'',0,0,77 UNION ALL
SELECT 2,1, 'Breads','Pudina Paratha/ Aloo Paratha',67,'',0,0,78 UNION ALL
SELECT 2,1, 'Breads','Masala Kulcha/Onion Kulcha',67,'',0,0,79 UNION ALL
SELECT 2,1, 'Breads','Butter Naan/ Garlic Naan',67,'',0,0,80 UNION ALL
SELECT 2,1, 'Breads','Butter Roti/Naan',59,'',0,0,81 UNION ALL
SELECT 2,1, 'Breads','Tandoori Roti/Rumali Roti',46,'',0,0,82 UNION ALL
SELECT 2,1, 'Raitas','Pineapple Raita/Mixed Raita',84,'',0,0,83 UNION ALL
SELECT 2,1, 'Raitas','Cucumber Raita/ Plain Raita',84,'',0,0,84 UNION ALL
SELECT 2,1, 'Papad','Roasted/Fried/Masala',38,'',0,0,85 UNION ALL
SELECT 2,1, 'Salads','Fruit Chat Salad/Pineapple Chaat Salad',75,'',0,0,86 UNION ALL
SELECT 2,1, 'Salads','Russian Salad',75,'',0,0,87 UNION ALL
SELECT 2,1, 'Salads','Green Salad/Onion Salad',50,'',0,0,88 UNION ALL
SELECT 2,1, 'Salads','Cucumber Salad',50,'',0,0,89 UNION ALL
SELECT 2,0, 'Main Course','Ginger Prawns',378,'',0,0,90 UNION ALL
SELECT 2,0, 'Main Course','Garlic Prawns',350,'',0,0,91 UNION ALL
SELECT 2,0, 'Main Course','Sweet-N-Sour Prawns',378,'',0,0,92 UNION ALL
SELECT 2,0, 'Main Course','Ginger Fish',350,'',0,0,93 UNION ALL
SELECT 2,0, 'Main Course','Garlic Fish',350,'',0,0,94 UNION ALL
SELECT 2,0, 'Noodles','Chicken Soft Noodles',184,'',0,0,95 UNION ALL
SELECT 2,0, 'Noodles','Chicken Hakka Noodles',184,'',0,0,96 UNION ALL
SELECT 2,0, 'Rice','Chicken Fried Rice',184,'',0,0,97 UNION ALL
SELECT 2,0, 'Rice','Schezwan Chicken Fried Rice',184,'',0,0,98 UNION ALL
SELECT 2,0, 'Rice','Egg Fried Rice',184,'',0,0,99 UNION ALL
SELECT 2,1, 'Noodles','Veg Soft Noodles',184,'',0,0,100 UNION ALL
SELECT 2,1, 'Noodles','Veg Hakka Noodles',184,'',0,0,101 UNION ALL
SELECT 2,1, 'Rice','Vegetable Fried Rice',184,'',0,0,102 UNION ALL
SELECT 2,1, 'Rice','Schezwan Vegetable Fried Rice',184,'',0,0,103 UNION ALL
SELECT 2,1, 'Desserts','Qubani ka Meetha',125,'',0,0,104 UNION ALL
SELECT 2,1, 'Desserts','Chocolate Brownie/ Pot Kulfi',100,'',0,0,105 UNION ALL
SELECT 2,1, 'Desserts','Gajar Ka Halwa',84,'',0,0,106 UNION ALL
SELECT 2,1, 'Desserts','Gulab Jamoon',84,'',0,0,107 UNION ALL
SELECT 2,1, 'Desserts','Double Ka Meetha',84,'',0,0,108 UNION ALL
SELECT 2,1, 'Desserts','Caramel Custard',84,'',0,0,109 UNION ALL
SELECT 2,1, 'Ice Creams','Banana Split',150,'',0,0,110 UNION ALL
SELECT 2,1, 'Ice Creams','Paradise Lovers Delight',150,'',0,0,111 UNION ALL
SELECT 2,1, 'Ice Creams','Chocolate Sundae',150,'',0,0,112 UNION ALL
SELECT 2,1, 'Ice Creams','Lychee with Vanilla /Strawberry',150,'',0,0,113 UNION ALL
SELECT 2,1, 'Ice Creams','Pineapple with Vanilla',150,'',0,0,114 UNION ALL
SELECT 2,1, 'Ice Creams','Vanilla with Hot Chocloate Sauce',150,'',0,0,115 UNION ALL
SELECT 2,1, 'Ice Creams','Triple Sundae',150,'',0,0,116 UNION ALL
SELECT 2,1, 'Ice Creams','Special Tutti Frutti/Honey Moon Spl',150,'',0,0,117 UNION ALL
SELECT 2,1, 'Ice Creams','Black Forest Gateau/ Vanilla',125,'',0,0,118 UNION ALL
SELECT 2,1, 'Ice Creams','Strawberry/Chocloate/Mango',125,'',0,0,119 UNION ALL
SELECT 2,1, 'Ice Creams','Tutti Frutti/Butterscotch/Pista',125,'',0,0,120 UNION ALL
SELECT 2,1, 'Ice Creams','Kaju Kishmis/Casatta/Fruit Salad',125,'',0,0,121 UNION ALL
SELECT 2,1, 'Fresh Fruit Juices','Pineapple/Apple/Orange/Mango',84,'',0,0,122 UNION ALL
SELECT 2,1, 'Fresh Fruit Juices','Grape/Sweet Lime/Cocktail',84,'',0,0,123 UNION ALL
SELECT 2,1, 'Milkshakes','Apple/ Banana/Chocolate',84,'',0,0,124 UNION ALL
SELECT 2,1, 'Milkshakes','Strawberry/Vanilla/Mango',84,'',0,0,125 UNION ALL
SELECT 2,1, 'Milkshakes','Butterscotch/Pista',84,'',0,0,126 UNION ALL
SELECT 2,1, 'Milkshakes','Lassi/Falooda/Fruit Punch',84,'',0,0,127 UNION ALL
SELECT 2,1, 'Milkshakes','Cold Coffee/Cold Coffee with Ice Cream',84,'',0,0,128 UNION ALL
SELECT 2,1, 'Cold Beverages','Diet Coke',63,'',0,0,129 UNION ALL
SELECT 2,1, 'Cold Beverages','Fresh Lemon Water/Ice Cream Soda',50,'',0,0,130 UNION ALL
SELECT 2,1, 'Cold Beverages','Coca Cola /Thums Up/ Sprite/Limca',42,'',0,0,131 UNION ALL
SELECT 2,1, 'Cold Beverages','Fanta/Maaza',42,'',0,0,132 UNION ALL
SELECT 2,1, 'Cold Beverages','Kinley Club Soda /Kinley Water',42,'',0,0,133;

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/

DROP TABLE IF EXISTS dbo.tbl_rest_PlacedOrderMaster;

CREATE TABLE dbo.tbl_rest_PlacedOrderMaster(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , DeviceID INT 
	 , SubjectID INT
	 , PlacedTime TIMESTAMP DEFAULT NOW()
	 , AckTime DATETIME
	 , AckBit BIT DEFAULT 0
	 , CallWaiter BIT DEFAULT 0
	 , Person NVARCHAR(100));
     
/*
INSERT INTO dbo.tbl_rest_PlacedOrderMaster
SELECT 4,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 21,1,2,NOW(),NOW(),1,1,'Naresh';
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_rest_PlacedOrderMasterArchive;

CREATE TABLE dbo.tbl_rest_PlacedOrderMasterArchive(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , MasterID INT
	 , DeviceID INT 
	 , SubjectID INT
	 , PlacedTime DATETIME
	 , AckTime DATETIME
	 , AckBit BIT
	 , CallWaiter BIT
	 , Person NVARCHAR(100));
     
/*     
INSERT INTO dbo.tbl_rest_PlacedOrderMasterArchive(MasterID, DeviceID, SubjectID, PlacedTime, AckTime, AckBit, CallWaiter, Person)
SELECT 119,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 120,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 113,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 123,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 124,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 125,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 126,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 127,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 128,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 129,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 130,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 131,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 133,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 132,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 134,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 135,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 136,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 137,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 122,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 138,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 139,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 140,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 141,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 143,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 144,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 145,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 146,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 147,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 148,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 149,-1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 150,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 151,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 1,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 2,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 3,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 5,2,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 6,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 7,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 8,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 9,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 10,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 11,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 12,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 13,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 14,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 15,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 16,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 17,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 18,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 19,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 20,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 23,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 24,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 25,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 26,3,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 22,1,2,NOW(),NOW(),1,1,'Naresh' UNION
SELECT 27,3,2,NOW(),NOW(),1,1,'Naresh'; 
*/    
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_rest_PlacedOrderSlave;

CREATE TABLE dbo.tbl_rest_PlacedOrderSlave(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , MasterID INT
	 , TID INT
	 , Quantity INT);

/*
INSERT INTO dbo.tbl_rest_PlacedOrderSlave
SELECT 23,4,35,4 UNION
SELECT 57,21,35,1;
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_rest_PlacedOrderSlaveArchive;

CREATE TABLE dbo.tbl_rest_PlacedOrderSlaveArchive(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , SlaveID INT
	 , MasterID INT
	 , TID INT
	 , Quantity INT);

/*
INSERT INTO dbo.tbl_rest_PlacedOrderSlaveArchive
SELECT 1,661,119,33,1 UNION
SELECT 2,662,119,36,1 UNION
SELECT 3,663,119,39,1 UNION
SELECT 4,664,120,33,1 UNION
SELECT 5,675,113,35,1 UNION
SELECT 6,676,113,37,1 UNION
SELECT 7,677,113,39,1 UNION
SELECT 8,687,123,34,1 UNION
SELECT 9,688,123,36,1 UNION
SELECT 10,689,124,34,1 UNION
SELECT 11,690,124,36,1 UNION
SELECT 12,691,125,33,1 UNION
SELECT 13,692,125,41,1 UNION
SELECT 14,693,126,36,2 UNION
SELECT 15,694,127,33,1 UNION
SELECT 16,695,127,41,1 UNION
SELECT 17,696,128,33,1 UNION
SELECT 18,697,128,41,1 UNION
SELECT 19,698,129,33,1 UNION
SELECT 20,699,129,41,1 UNION
SELECT 21,700,130,35,1 UNION
SELECT 22,701,130,37,1 UNION
SELECT 23,702,131,35,1 UNION
SELECT 24,703,131,38,1 UNION
SELECT 25,706,133,52,1 UNION
SELECT 26,704,132,36,1 UNION
SELECT 27,705,132,38,1 UNION
SELECT 28,707,134,52,1 UNION
SELECT 29,708,135,36,1 UNION
SELECT 30,709,135,40,1 UNION
SELECT 31,712,137,36,1 UNION
SELECT 32,729,136,37,2 UNION
SELECT 33,730,136,45,1 UNION
SELECT 34,727,138,33,3 UNION
SELECT 35,728,138,38,2 UNION
SELECT 36,682,122,33,1 UNION
SELECT 37,683,122,37,1 UNION
SELECT 38,684,122,39,1 UNION
SELECT 39,731,139,52,1 UNION
SELECT 40,732,139,62,1 UNION
SELECT 41,733,140,49,1 UNION
SELECT 42,735,141,37,2 UNION
SELECT 43,736,141,85,1 UNION
SELECT 44,770,143,59,1 UNION
SELECT 45,771,143,136,1 UNION
SELECT 46,774,144,33,2 UNION
SELECT 47,775,144,36,1 UNION
SELECT 48,776,145,33,1 UNION
SELECT 49,777,145,36,1 UNION
SELECT 50,778,146,37,1 UNION
SELECT 51,779,146,39,1 UNION
SELECT 52,780,147,37,1 UNION
SELECT 53,781,147,39,1 UNION
SELECT 54,782,148,34,1 UNION
SELECT 55,783,148,38,1 UNION
SELECT 56,784,149,35,1 UNION
SELECT 57,785,149,38,1 UNION
SELECT 58,786,150,34,1 UNION
SELECT 59,787,150,37,1 UNION
SELECT 60,788,151,35,1 UNION
SELECT 61,3,1,33,2 UNION
SELECT 62,4,1,39,5 UNION
SELECT 63,15,2,33,1 UNION
SELECT 64,16,2,39,1 UNION
SELECT 65,17,2,48,1 UNION
SELECT 66,18,2,50,1 UNION
SELECT 67,19,2,61,1 UNION
SELECT 68,20,3,33,1 UNION
SELECT 69,21,3,49,1 UNION
SELECT 70,22,3,51,1 UNION
SELECT 71,24,5,38,1 UNION
SELECT 72,25,5,40,1 UNION
SELECT 73,26,5,62,1 UNION
SELECT 74,27,6,33,1 UNION
SELECT 75,28,6,49,1 UNION
SELECT 76,29,6,51,1 UNION
SELECT 77,30,7,33,1 UNION
SELECT 78,31,7,49,1 UNION
SELECT 79,32,7,51,1 UNION
SELECT 80,33,8,33,1 UNION
SELECT 81,34,8,36,1 UNION
SELECT 82,35,8,37,1 UNION
SELECT 83,36,9,34,1 UNION
SELECT 84,37,9,38,1 UNION
SELECT 85,38,10,34,1 UNION
SELECT 86,39,10,38,1 UNION
SELECT 87,40,11,36,1 UNION
SELECT 88,41,11,38,1 UNION
SELECT 89,42,12,34,1 UNION
SELECT 90,43,12,38,1 UNION
SELECT 91,44,13,34,1 UNION
SELECT 92,45,13,38,1 UNION
SELECT 93,46,14,34,1 UNION
SELECT 94,47,14,38,1 UNION
SELECT 95,48,15,34,1 UNION
SELECT 96,49,15,36,1 UNION
SELECT 97,50,16,34,1 UNION
SELECT 98,51,16,37,1 UNION
SELECT 99,52,17,34,1 UNION
SELECT 100,53,17,37,1 UNION
SELECT 101,54,18,33,1 UNION
SELECT 102,55,19,34,1 UNION
SELECT 103,56,20,34,1 UNION
SELECT 104,61,23,58,1 UNION
SELECT 105,62,23,62,1 UNION
SELECT 106,63,24,33,1 UNION
SELECT 107,64,24,37,1 UNION
SELECT 108,65,25,35,1 UNION
SELECT 109,66,25,38,1 UNION
SELECT 110,67,26,34,1 UNION
SELECT 111,68,26,36,1 UNION
SELECT 112,58,22,3,1 UNION
SELECT 113,70,27,18,1;
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
/*
IF TYPE_ID('utt_tbl_OrderItem') IS NOT NULL 
DROP TYPE utt_tbl_OrderItem

CREATE TYPE utt_tbl_OrderItem AS TABLE(
	   TID INT
	 , Quantity INT)
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
