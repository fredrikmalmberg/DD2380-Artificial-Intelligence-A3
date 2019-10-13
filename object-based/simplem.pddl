(define (problem simple)

(:domain overcooked)

(:objects
	chef1				- chef
	chef2				- chef

	; Stations
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
	sause1  - sause
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
	(chef-at chef1 storage_room1)
	(chef-available chef1)

	(chef-at chef2 put_on_plate_station1)
	(chef-available chef2)

	; Items in storage room
	
	(item-at tomato1 storage_room1)
	(item-at tomato2 storage_room1)
	(item-at lettuce1 storage_room1)
	(item-at lettuce2 storage_room1)
	(item-at pasta1 storage_room1)
	;(item-at pasta2 storage_room1)
	;
	(item-at sause1 storage_room1)
	;(item-at sause2 storage_room1)
	;(item-at sause3 storage_room1)
	;(item-at sause4 storage_room1)

	(item-at fish1 storage_room1)
	;(item-at fish2 storage_room1)
	;(item-at fish3 storage_room1)
	;(item-at fish4 storage_room1)

	(item-at potato1 storage_room1)
	;(item-at potato2 storage_room1)
	;(item-at potato3 storage_room1)
	;(item-at potato4 storage_room1)

	(item-at topping1 put_on_plate_station1)
	(item-at dough1 put_on_plate_station1) 	
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

	(can-cut       fish1)
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
		(delivered order4)
		(delivered order5)

	)
)

(:metric minimize (total-time)
)

)
