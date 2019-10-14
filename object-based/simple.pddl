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

	; Plates

	plate1 plate2 plate3 plate4	- plate

	; Orders
	order1 order4 - order
;	order1 order2 order3 order4 - order
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

	; Items at put on plate station
	(item-at plate1 put_on_plate_station1)
	(item-at plate2 put_on_plate_station1)
	(item-at plate3 put_on_plate_station1)
	(item-at plate4 put_on_plate_station1)

	; Orders
	(order-is order1 salad)
;	(order-is order2 salad)
;	(order-is order3 pasta-dish)
	(order-is order4 pasta-dish)
)

(:goal 
	(and
		(delivered order1)
;		(delivered order2)
;		(delivered order3)
		(delivered order4)
	)
)

(:metric minimize (total-time)
)

)
