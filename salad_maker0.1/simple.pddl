(define (problem simple)

(:domain overcooked)

(:objects
	chef1 chef2			- chef

	storage_room1		- station
	delivery_station1	- delivery_station
	cutting_station1	- cutting_station
	put_on_plate_station1 - put_on_plate_station 

	salad1 salad2		- salad

	tomato1	tomato2		- tomato
	lettuce1 lettuce2	- lettuce

	order1 order2		- order
)

(:init
	(chef-at chef1 storage_room1)
	(chef-available chef1)

	(chef-at chef2 storage_room1)
	(chef-available chef2)

	(movable_object-at tomato1 storage_room1)
	(movable_object-at tomato2 storage_room1)
	(movable_object-at lettuce1 storage_room1)
	(movable_object-at lettuce2 storage_room1)

	(order-has-dish order1 salad1)
	(order-has-dish order2 salad2)
)

(:goal 
	(and
		(delivered order1)
		(delivered order2)
	)
)

(:metric minimize (total-time)
)

)
