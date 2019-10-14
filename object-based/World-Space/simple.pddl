(define (problem simplem)

(:domain overcookedm)

(:objects
	chef1				- chef
	chef2				- chef

	; Stations
		  pos11 pos12 pos13 pos14 pos15 - position
	pos20 pos21 pos22 pos23 pos24 pos25 - position
	pos30 pos31 pos32 pos33 pos34 pos35 - position
		  pos41 pos42 pos43 pos44 pos45 - position



	storage_room1		- station
	cutting_station1	- cutting_station
	cutting_station2	- cutting_station
	cooking_station1	- cooking_station
	put_on_plate_station1 - put_on_plate_station 
	put_on_plate_station2 - put_on_plate_station 
	delivery_station1	- delivery_station
	fried_station1      - fried_station
	oven1               - oven
	; Ingredients
	tomato1 tomato2		- tomato
	lettuce1 lettuce2	- lettuce
	pasta1     			- pasta
	fish1  - fish
	potato1 - potato
	sauce1  - sauce
	dough1 - dough
	topping1 - bag_topping
	unpizza1 - unbakedpizza
	; Meals
	salad1 salad2		- salad
	pasta_meal1			- pasta_meal
	fNc1  - fishchip
	pizza1 - pizza
	
	; Orders
	order1 order2 order3 order4 order5  - order
)

(:init
	(position-next          pos21 pos22)
	(position-next          pos21 pos31)

	(position-next          pos22 pos21)
	(position-next          pos22 pos23)
	(position-next          pos22 pos23)

	(position-next          pos23 pos22)
	(position-next          pos23 pos24)
	(position-next          pos23 pos33)

	(position-next          pos24 pos23)
	(position-next          pos24 pos34)
	(position-next          pos24 pos25)

	(position-next          pos25 pos24)
	(position-next          pos25 pos35)

	(position-next          pos31 pos21)
	(position-next          pos31 pos32)

	(position-next          pos32 pos31)
	(position-next          pos32 pos22)
	(position-next          pos32 pos33)

	(position-next          pos33 pos32)
	(position-next          pos33 pos23)
	(position-next          pos33 pos34)

	(position-next          pos34 pos33)
	(position-next          pos34 pos24)
	(position-next          pos34 pos35)

	(position-next          pos35 pos34)
	(position-next          pos35 pos25)

	(chef-at chef1 pos31);storage_room1
	(chef-available chef1)

	(chef-at chef2 pos23);put_on_plate_station1
	(chef-available chef2)

	(station-next cutting_station1      pos21);pos11)
	(station-next cutting_station2      pos22);pos12)
	(station-next put_on_plate_station1 pos23);pos13)
	(station-next put_on_plate_station2 pos24);pos14)
	(station-next delivery_station1     pos25);pos15)
	(station-next cooking_station1      pos21);pos20)
	(station-next storage_room1         pos31);pos30)
	(station-next fried_station1        pos31);pos41)

	; Items in storage room
	
	(item-at tomato1 storage_room1)
	(item-at tomato2 storage_room1)
	(item-at lettuce1 storage_room1)
	(item-at lettuce2 storage_room1)
	(item-at pasta1 storage_room1)
	(item-at pasta2 storage_room1)
	;
	(item-at sauce1 storage_room1)
	;(item-at sauce2 storage_room1)
	;(item-at sauce3 storage_room1)
	;(item-at sauce4 storage_room1)

	;(item-at fish1 storage_room1)
	;(item-at fish2 storage_room1)
	;(item-at fish3 storage_room1)
	;(item-at fish4 storage_room1)

	(item-at potato1 storage_room1)
	;(item-at potato2 storage_room1)
	;(item-at potato3 storage_room1)
	;(item-at potato4 storage_room1)

	;(item-at topping1 put_on_plate_station1)
	;(item-at dough1 put_on_plate_station1) 	
	; Orders
	(order-is-meal order1 salad1)
	(order-is-meal order2 salad2)
	(order-is-meal order3 pasta_meal1)
	(order-is-meal order4 fNc1)
	(order-is-meal order5 pizza1)	
	;(order-is-meal order2 fNc2)	
	;(order-is-meal order3 fNc3)	
	;(order-is-meal order4 fNc4)	

	;rules
	(can-cut       tomato1)
	(can-cut 	   tomato2)
	(can-cut       lettuce1)
	(can-cut       lettuce2)
	(can-cook      pasta1)
	(can-cook      pasta2)

	;(can-cut       fish1)
	;(can-cut       fish2)
	;(can-cut       fish3)
	;(can-cut       fish4)

	(can-cut       potato1)
	;(can-cut       potato2)
	;(can-cut       potato3)
	;(can-cut       potato4)

	(can-fried      potato1)
	;(can-fried      potato2)
	;(can-fried      potato3)
	;(can-fried      potato4)

	(can-fried      fish1)
	;(can-fried      fish2)
	;(can-fried      fish3)
	;(can-fried      fish4)

	;(is-cut  fish1)
	;(is-cut potato1)
)

(:goal 
	(and
		;(delivered order1)
		;(delivered order2)
		(delivered order3)
		;(delivered order4)
		;(delivered order5)

	)
)

(:metric minimize (total-time)
)

)
