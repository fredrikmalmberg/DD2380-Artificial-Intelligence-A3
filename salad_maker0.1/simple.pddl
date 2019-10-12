(define (problem simple)

(:domain overcooked)

(:objects
	chef1				- chef
;	chef2				- chef

	; Stations
	storage_room1		- station
	cutting_station1	- cutting_station
	cooking_station1	- cooking_station
	put_on_plate_station1 - put_on_plate_station 
	delivery_station1	- delivery_station

	; Unprepared ingredients
	tomato				- tomato_type
	lettuce				- lettuce_type
	pasta				- pasta_type

	; Prepared ingredients
	cut_tomato			- cut_tomato_type
	cut_lettuce			- cut_lettuce_type
	cooked_pasta		- cooked_pasta_type

	; Dishes
	salad				- salad_type
	pasta_dish			- pasta_dish_type

	; Orders
	order1 order2 order3 - order
)

(:init
	(chef-at chef1 storage_room1)
	(chef-available chef1)

;	(chef-at chef2 storage_room1)
;	(chef-available chef2)

	; Items in storage room
	(= (num-items-at tomato storage_room1) 5)
	(= (num-items-at lettuce storage_room1) 5)
	(= (num-items-at pasta storage_room1) 5)

	; Items at cutting station
	(= (num-items-at tomato cutting_station1) 0)
	(= (num-items-at lettuce cutting_station1) 0)
	(= (num-items-at cut_tomato cutting_station1) 0)
	(= (num-items-at cut_lettuce cutting_station1) 0)

	; Items at cooking station
	(= (num-items-at pasta cooking_station1) 0)
	(= (num-items-at cooked_pasta cooking_station1) 0)

	; Items at put on plate station
	(= (num-items-at cut_tomato put_on_plate_station1) 0)
	(= (num-items-at cut_lettuce put_on_plate_station1) 0)
	(= (num-items-at cooked_pasta put_on_plate_station1) 0)
	(= (num-items-at salad put_on_plate_station1) 0)
	(= (num-items-at pasta_dish put_on_plate_station1) 0)

	; Items at delivery station
	(= (num-items-at salad delivery_station1) 0)
	(= (num-items-at pasta_dish delivery_station1) 0)

	; Orders
	(order-has-dish order1 salad)
	(order-has-dish order2 pasta_dish)
	(order-has-dish order3 pasta_dish)
)

(:goal 
	(and
		(delivered order1)
		(delivered order2)
		(delivered order3)
	)
)

(:metric minimize (total-time)
)

)
