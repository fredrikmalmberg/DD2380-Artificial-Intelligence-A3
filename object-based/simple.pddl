(define (problem simple)

(:domain overcooked)

(:objects
	chef1				- chef
	chef2				- chef

	; Stations
	storage_room1		- station
	cutting_station1	- cutting_station
	cooking_station1	- cooking_station
	put_on_plate_station1 - put_on_plate_station 
	delivery_station1	- delivery_station

	; Ingredients
	tomato1 tomato2		- tomato
	lettuce1 lettuce2	- lettuce
	pasta1 pasta2		- pasta

	; Meals
	salad1 salad2		- salad
	pasta_meal1			- pasta_meal
	pasta_meal2			- pasta_meal

	; Orders
	order1 order2 order3 order4 - order
)

(:init
	(chef-at chef1 storage_room1)
	(chef-available chef1)

	(chef-at chef2 storage_room1)
	(chef-available chef2)

	; Items in storage room
	(item-at tomato1 storage_room1)
	(item-at tomato2 storage_room1)
	(item-at lettuce1 storage_room1)
	(item-at lettuce2 storage_room1)
	(item-at pasta1 storage_room1)
	(item-at pasta2 storage_room1)

	; Orders
	(order-is-meal order1 salad1)
	(order-is-meal order2 salad2)
	(order-is-meal order3 pasta_meal1)
	(order-is-meal order4 pasta_meal2)
)

(:goal 
	(and
		(delivered order1)
		(delivered order2)
		(delivered order3)
		(delivered order4)
	)
)

(:metric minimize (total-time)
)

)