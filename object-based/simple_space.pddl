(define (problem simplem)

(:domain overcookedm)

(:objects
	chef1				- chef
	chef2				- chef

	; Stations
	pos20 pos21 pos22 - position
	pos30 pos31 pos32 - position
	pos40 pos41 pos42 - position


	; Stations
	storage_room1         storage_room2		    - station
	cutting_station1      cutting_station2      - cutting_station
	cooking_station1      cooking_station2      - cooking_station
	put_on_plate_station1 put_on_plate_station2 - put_on_plate_station 
	delivery_station1	                        - delivery_station
	;fried_station1        fried_station2 		- fried_station

	; Ingredients
	tomato1  tomato2 tomato3 - tomato
	lettuce1 lettuce2  	     - lettuce
	pasta1     			     - pasta
	;fish1               - fish
	sauce1  sauce2 sauce3    - sauce

	; Meals
	salad1 salad2 - salad
	pasta_meal1	  - pasta_meal
	
	; Orders
	order1 order2 order3  - order
)

(:init
	(position-next          pos20 pos21)
	(position-next          pos21 pos20)
	(position-next          pos21 pos22)
	(position-next          pos22 pos21)

	(position-next          pos40 pos41)
	(position-next          pos41 pos40)
	(position-next          pos41 pos42)
	(position-next          pos42 pos41)

	(station-next storage_room1         pos21)
	(station-next storage_room2         pos41)

	(station-next cutting_station1      pos20)
	(station-next cutting_station2      pos40)

	(station-next cooking_station1      pos20)
	(station-next cooking_station2      pos40)
	
	(station-next fried_station1        pos22)
	(station-next fried_station2        pos42)

	(station-next put_on_plate_station1 pos20)
	(station-next put_on_plate_station1 pos40)

	(station-next put_on_plate_station2 pos21)
	(station-next put_on_plate_station2 pos41)
	
	(station-next delivery_station1     pos22)
	(station-next delivery_station1     pos42)

	(is-blocked pos21)
	(chef-at chef1 pos21)
	(chef-available chef1)

	(is-blocked pos41)
	(chef-at chef2 pos41)
	(chef-available chef2)

	; Items in storage room
	(item-at tomato1 storage_room1)
	(item-at sauce1 storage_room1)
	(item-at sauce2 storage_room1)
	;(item-at sauce3 storage_room1)

	;(item-at fish1 storage_room2)
	(item-at tomato2 storage_room2)
	(item-at lettuce1 storage_room2)
	(item-at pasta1 storage_room2)
	;(item-at potato1 storage_room2)

	(order-is-meal order1 salad1)
	(order-is-meal order2 pasta_meal1)
	(order-is-meal order3 salad2)

	;rules
	(can-cut       tomato1)
	(can-cut 	   tomato2)
	(can-cut 	   tomato2)
	(can-cut       lettuce1)
	(can-cut       lettuce2)
	(can-cook      pasta1)

)

(:goal 
	(and
		;(station-used put_on_plate_station1 salad1)
		;(station-used put_on_plate_station2 pasta_meal1)
		(delivered order1)
		(delivered order2)
		;(delivered order3)

	)
)

(:metric minimize (total-time)
)

)
