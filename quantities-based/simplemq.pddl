(define (problem simple)

(:domain overcooked)

(:objects
	chef1				- chef
	chef2				- chef

	; Stations
	storage_room1		- station
	cutting_station1	- cutting_station
	;cooking_station1	- cooking_station
	put_on_plate_station1 - put_on_plate_station 
	delivery_station1	  - delivery_station
	fried_station1        - fried_station
	oven1 				- oven
	
	
	; Unprepared ingredients
	;tomato				- tomato_type
	;lettuce				- lettuce_type
	;pasta				- pasta_type
	;dough               - dough_type
	;topping             - topping_type
	fish                 - fish_type
	sauce                - sauce_type
	potato               - potato_type
	; Prepared ingredients
	;cut_tomato			- cut_tomato_type
	;cut_lettuce			- cut_lettuce_type
	;cooked_pasta		- cooked_pasta_type
	;unpizza             - unpizza_type
	cut_fish             - cut_fish_type
	cut_potato           - cut_potato_type

	fried_fish           - fried_fish_type
	fried_potato         - fried_potato_type
	
	; Dishes
	;salad				- salad_type
	;pasta_dish			- pasta_dish_type
	;pizza               - pizza_type
	fishchip             - fishchip_type
	; Orders
	;order1 order2 order3 - order
	order3 - order
)

(:init
	(chef-at chef1 storage_room1)
	(chef-available chef1)

	(chef-at chef2 storage_room1)
	(chef-available chef2)

	; Items in storage room
	;(= (num-items-at tomato storage_room1) 5)
	;(= (num-items-at lettuce storage_room1) 5)
	;(= (num-items-at pasta storage_room1) 5)
	;(= (num-items-at dough storage_room1) 5)
	;(= (num-items-at topping storage_room1) 5)
	(= (num-items-at sauce storage_room1) 5)
	(= (num-items-at fish storage_room1) 5)
	(= (num-items-at potato storage_room1) 5)
	
	
	; Items at cutting station
	;(= (num-items-at tomato cutting_station1) 0)
	;(= (num-items-at lettuce cutting_station1) 0)
	;(= (num-items-at cut_tomato cutting_station1) 0)
	;(= (num-items-at cut_lettuce cutting_station1) 0)
	(= (num-items-at fish cutting_station1) 0)
	(= (num-items-at cut_fish cutting_station1) 0)
	(= (num-items-at potato cutting_station1) 0)
	(= (num-items-at cut_potato cutting_station1) 0)
     



	; Items at cooking station
	;(= (num-items-at pasta cooking_station1) 0)
	;(= (num-items-at cooked_pasta cooking_station1) 0)

	; Items at put on plate station
	;(= (num-items-at cut_tomato put_on_plate_station1) 0)
	;(= (num-items-at cut_lettuce put_on_plate_station1) 0)
	;(= (num-items-at cooked_pasta put_on_plate_station1) 0)
	;(= (num-items-at salad put_on_plate_station1) 0)
	;(= (num-items-at pasta_dish put_on_plate_station1) 0)
    ;(= (num-items-at dough put_on_plate_station1) 0)
	;(= (num-items-at topping put_on_plate_station1) 0)
	;(= (num-items-at pizza put_on_plate_station1) 0)
	;(= (num-items-at pizza oven1) 0)
	;(= (num-items-at sause put_on_plate_station1) 0)
	(= (num-items-at fried_potato put_on_plate_station1) 0)
	(= (num-items-at fried_fish put_on_plate_station1) 0)
	(= (num-items-at sauce put_on_plate_station1) 0)
	(= (num-items-at fishchip put_on_plate_station1) 0)
	
	
	;Items at fried station
	(= (num-items-at cut_fish fried_station1) 0)
	(= (num-items-at fried_fish fried_station1) 0)
	(= (num-items-at cut_potato fried_station1) 0)
	(= (num-items-at fried_potato fried_station1) 0)




	; Items at delivery station
	;(= (num-items-at salad delivery_station1) 0)
	;(= (num-items-at pasta_dish delivery_station1) 0)
	;(= (num-items-at pizza delivery_station1) 0)
	(= (num-items-at fishchip delivery_station1) 0)
	
	
	; Orders
	;(order-has-dish order1 salad)
	;(order-has-dish order2 pasta_dish)
	;(order-has-dish order3 pasta_dish)
	(order-has-dish order3 fishchip)
	
	; rules 
	;(cutting-type           cut_tomato tomato)
	;(cutting-type           cut_lettuce lettuce)
	(cutting-type           cut_fish fish)
	(cutting-type           cut_potato potato)
	
	(fried-type             fried_potato cut_potato)
	(fried-type             fried_fish cut_fish)
)

(:goal 
	(and
		;(= (num-items-at fried_fish fried_station1) 1)
		;(= (num-items-at fried_potato fried_station1) 1)
		;(= (num-items-at fishchip put_on_plate_station1) 1)
		(delivered order3)
		;(delivered order2)
		;(delivered order3)
	)
)

(:metric minimize (total-time)
)

)
