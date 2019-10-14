(define (domain overcooked)

(:requirements
	:typing
	:durative-actions 
	:numeric-fluents
	:negative-preconditions)

(:types
	; Chef
	chef - object

	; Stations
	station                - object
	cutting_station        - station
	cooking_station        - station
	delivery_station       - station
	put_on_plate_station   - station
	oven				   - station
	fried_station          - station
	; Items
	movable_item_type      - object

	; Ingredient types
	ingredient_type        - movable_item_type

	; Unprepared ingredient types
	tomato_type            - ingredient_type
	lettuce_type           - ingredient_type
	
	pasta_type             - ingredient_type
	
	dough_type             - ingredient_type
	topping_type           - ingredient_type
	
	fish_type              - ingredient_type
	potato_type            - ingredient_type
	sauce_type             - ingredient_type
	; Prepared ingredients
	cut_ingredient_type    - ingredient_type
	cut_tomato_type        - cut_ingredient_type
	cut_lettuce_type       - cut_ingredient_type
	cut_fish_type          - cut_ingredient_type
	cut_potato_type        - cut_ingredient_type
	
	fried_ingredient_type  - ingredient_type
	fried_fish_type        - fried_ingredient_type
	fried_potato_type      - fried_ingredient_type
	
	bake_ingredient_type   - ingredient_type
	unpizza_type           - bake_ingredient_type
	
	cooked_ingredient_type - ingredient_type
	cooked_pasta_type      - cooked_ingredient_type
	; Dishes
	dish                   - movable_item_type
	salad_type             - dish
	pasta_dish_type        - dish
	pizza_type             - dish
	fishchip_type          - dish
	; Orders
	order                  - object
)

(:predicates
	(chef-at				?c - chef   ?s - station);
	(chef-available			?c - chef)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(delivered				?o - order)
	(cutting-type           ?ci - cut_ingredient_type ?i - ingredient_type)
	(fried-type             ?f - fried_ingredient_type ?ci - cut_ingredient_type)
	(order-has-dish			?o - order ?d - dish)
)

(:functions 
	(num-items-at	?mit - movable_item_type ?s - station) ; Number of MOVABLE items of a certain type that are present at a certain station
)

(:durative-action deliver
	:parameters (?st - delivery_station ?o - order ?d - dish)
	:duration (= ?duration 1)
	:condition (and
				(at start (order-has-dish ?o ?d))
				(at start (> (num-items-at ?d ?st) 0))
	)
	:effect (and
				(at start (decrease (num-items-at ?d ?st) 1))
				(at end (delivered ?o))
	)
)

(:durative-action move-item
	:parameters (?c - chef ?here - station ?there - station ?mit - movable_item_type)
	:duration (= ?duration 1)
	:condition (and
				(at start (chef-at ?c ?here))
				(at start (chef-available ?c ))
				(at start (> (num-items-at ?mit ?here ) 0))
	)

	:effect (and
				(at start (not (chef-at ?c ?here)))
				(at start (not (chef-available ?c )))
				(at end (chef-at ?c ?there))
				(at end (chef-available ?c ))
				(at start (decrease (num-items-at ?mit ?here ) 1))
				(at end (increase (num-items-at ?mit ?there ) 1))
	)
)

(:durative-action move-chef
	:parameters (?c - chef ?from - station ?to - station)
	:duration (= ?duration 1)
	:condition (and
				(at start(chef-at ?c ?from))
				(at start (chef-available ?c ))
	)
	:effect (and
				(at start (not (chef-at ?c ?from)))
				(at start (not (chef-available ?c )))
				(at end (chef-at ?c ?to))
				(at end (chef-available ?c ))
	)
)


(:durative-action prepare-salad
	:parameters (?c - chef ?s - put_on_plate_station ?t - cut_tomato_type ?l - cut_lettuce_type ?salad - salad_type)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (> (num-items-at ?t ?s) 0))
				(at start (> (num-items-at ?l ?s) 0))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (decrease (num-items-at ?t ?s) 1))
				(at start (decrease (num-items-at ?l ?s) 1))
				(at end (increase (num-items-at ?salad ?s) 1))
	)
)

(:durative-action prepare-pasta
	:parameters (?c - chef ?s - put_on_plate_station ?cpt - cooked_pasta_type ?pasta_dish - pasta_dish_type)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (> (num-items-at ?cpt ?s) 0))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (decrease (num-items-at ?cpt ?s) 1))
				(at end (increase (num-items-at ?pasta_dish ?s) 1))
	)
)
(:durative-action make_pizza
	:parameters (?c - chef ?s - put_on_plate_station ?t - topping_type ?d - dough_type ?up - unpizza_type)
	:duration (= ?duration 3)
	:condition (and
	            (at start(chef-at  ?c   ?s))
				(at start(chef-available ?c))
				(at start(not (station-occupied  ?s)))

				(at start (> (num-items-at ?t ?s) 0))
				(at start (> (num-items-at ?d ?s) 0))

	)
	:effect (and 
		(at start (not (chef-available  ?c )))
		(at end  (chef-available ?c ))

		(at start (station-occupied		?s))
		(at end (not (station-occupied	?s)))

		(at start (decrease (num-items-at	?d ?s)  1))
		(at start (decrease (num-items-at	?t ?s)  1))
		(at end   (increase (num-items-at	?up ?s) 1))
	)
)
(:durative-action baking_pizza
	:parameters (?c - chef ?o - oven ?up - unpizza_type ?p - pizza_type)
	:duration (= ?duration 2)
	:condition (and 
		(at start (chef-at ?c ?o))
		(at start (chef-available  ?c))
		(at start(not (station-occupied  ?o)))

		(at start (> (num-items-at ?up ?o) 0))

	)
	:effect (and 
		(at start (not (chef-available  ?c )))
		(at end  (chef-available ?c ))

		(at start (station-occupied		?o))
		(at end (not (station-occupied	?o)))

		(at start (decrease (num-items-at	?up ?o) 1))
		(at end   (increase (num-items-at	?p ?o)  1))
	)
)
(:durative-action fried
	:parameters (?c - chef ?s - fried_station ?ci - cut_ingredient_type 
				?fi - fried_ingredient_type)
	:duration (= ?duration 2)
	:condition (and 
		(at start (chef-at ?c ?s))
		(at start (chef-available  ?c))
		(at start(not (station-occupied  ?s)))

		(at start (fried-type       ?fi ?ci))
		(at start (> (num-items-at	?ci ?s) 0))
		
	)
	:effect (and 
		(at start (not (chef-available  ?c)))
		(at end  (chef-available ?c ))

		(at start (station-occupied		?s))
		(at end (not (station-occupied	?s)))

		(at start (decrease (num-items-at	?ci ?s) 1))
		(at end   (increase (num-items-at	?fi ?s)  1))
	)
)

(:durative-action prepare-fishchip
	:parameters (?c - chef ?s - put_on_plate_station ?ff - fried_fish_type 
				?fp - fried_potato_type ?fm - fishchip_type ?sauce - sauce_type)
	:duration (= ?duration 2)
	:condition (and 
		(at start (chef-at ?c ?s))
		(at start (chef-available  ?c))
		(at start(not (station-occupied  ?s)))
		
		(at start (> (num-items-at	?ff ?s) 0))
		(at start (> (num-items-at	?fp ?s) 0))
		(at start (> (num-items-at	?sauce ?s) 0))
	)
	:effect (and 
		(at start (not (chef-available  ?c)))
		(at end  (chef-available ?c))

		(at start (station-occupied		?s))
		(at end (not (station-occupied	?s)))

		(at start (decrease (num-items-at	?sauce ?s) 1))	
		(at start (decrease (num-items-at	?ff ?s) 1))
		(at start (decrease (num-items-at	?fp ?s) 1))
		(at end   (increase (num-items-at	?fm ?s) 1))
	)
)


(:durative-action cut
	:parameters (?c - chef ?s - cutting_station ?i - ingredient_type ?ci - cut_ingredient_type)
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))
				(at start (cutting-type    ?ci ?i))
				(at start (> (num-items-at ?i ?s) 0))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))
				
				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))
				
				(at start (decrease (num-items-at ?i ?s) 1))
				(at end (increase (num-items-at ?ci ?s) 1))
	)
)

(:durative-action cook
	:parameters (?c - chef ?s - cooking_station ?i - ingredient_type ?ci - cooked_ingredient_type)
	:duration (= ?duration 3)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (> (num-items-at ?i ?s) 0))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))
				
				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))
				
				(at start (decrease (num-items-at ?i ?s) 1))
				(at end (increase (num-items-at ?ci ?s) 1))
	)
)

)
