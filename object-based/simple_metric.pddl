; Problem definition for the the domain that incorporates a plan
; metric that approximates minimizing the number of orders that
; are not delivered on time

(define (problem simple_metric)

(:domain overcooked_metric)

; Standard setup in terms of objects

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

	; Initializing the cost function
	(= (total-cost) 0)

	(chef-at chef1 storage_room1)
	(chef-available chef1)
	; Initialize each chef's associated timer
	(= (timer chef1) 0)

	(chef-at chef2 storage_room1)
	(chef-available chef2)
	(= (timer chef2) 0)

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

	; Setting delivery timing targets for each order
	(= (delivery-time-goal order1) 15)
	(= (delivery-time-goal order2) 20)
	(= (delivery-time-goal order3) 30)
	(= (delivery-time-goal order4) 50)
)

(:goal 
	(and
		(delivered order1)
		(delivered order2)
		(delivered order3)
		(delivered order4)
	)
)

; Specifying that the planner should find a plan that minimizes the
; total cost
(:metric minimize (total-cost)
)

)
