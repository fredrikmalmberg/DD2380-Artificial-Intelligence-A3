(define (problem simple)

(:domain overcooked)

(:objects
	chef1				- chef
;	chef2				- chef

	storage_room1		- station
	cutting_station1	- cutting_station
	put_on_plate_station1 - put_on_plate_station 
	delivery_station1	- delivery_station

	tomato				- tomato_type
	lettuce				- lettuce_type

	cut_tomato			- cut_tomato_type
	cut_lettuce			- cut_lettuce_type

	salad				- salad_type

	order1 order2		- order
)

(:init
	(chef-at chef1 storage_room1)
	(chef-available chef1)

;	(chef-at chef2 storage_room1)
;	(chef-available chef2)

	(= (num-items-at tomato storage_room1) 5)
	(= (num-items-at lettuce storage_room1) 5)

	(= (num-items-at tomato cutting_station1) 0)
	(= (num-items-at lettuce cutting_station1) 0)

	(= (num-items-at cut_tomato cutting_station1) 0)
	(= (num-items-at cut_lettuce cutting_station1) 0)

	(= (num-items-at cut_tomato put_on_plate_station1) 0)
	(= (num-items-at cut_lettuce put_on_plate_station1) 0)

	(= (num-items-at salad put_on_plate_station1) 0)
	(= (num-items-at salad delivery_station1) 0)

	(order-has-dish order1 salad)
	(order-has-dish order2 salad)
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
