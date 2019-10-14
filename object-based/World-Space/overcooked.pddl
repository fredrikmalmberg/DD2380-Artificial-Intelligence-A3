(define (domain overcookedm)

(:requirements
	:typing
	:durative-actions 
	:numeric-fluents
	:negative-preconditions)

(:types
	; Chef
	chef - object

	; Stations
	station position - object
	cutting_station - station
	cooking_station - station
	fried_station - station
	delivery_station - station
	put_on_plate_station - station
	oven - station

	; Items
	movable_item - object

	;  
	ingredient - movable_item

	; Ingredients
	tomato - ingredient
	lettuce - ingredient
	pasta - ingredient
	sauce - ingredient
	fish  - ingredient
	potato - ingredient
	bag_topping - ingredient
	dough - ingredient
	unbakedpizza - ingredient
	; Meals
	meal - movable_item
	salad - meal
	pasta_meal - meal
	fishchip - meal
	pizza - meal

	; Orders
	order - object
)

(:predicates
	(chef-at				?c - chef   ?p - position);
	(chef-available			?c - chef)
	(chef-has-item          ?c - chef ?mi - movable_item)

	(position-next          ?pos ?pos - position)
	(station-next 			?s - station ?p - position)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(item-at				?mi - movable_item ?s - station) ; A certain MOVABLE item is present at a certain station

	(is-cut					?i - ingredient)
	(is-cooked				?i - ingredient)
	(is-fried               ?i - ingredient)
	(is-baked               ?p - pizza)
	(delivered				?o - order)
	(can-cut                ?i - ingredient)
	(can-cook               ?i - ingredient)
	(can-fried              ?i - ingredient)
	(can-baked              ?i - ingredient)
	(order-is-meal			?o - order ?m - meal)
)

(:durative-action deliver
	:parameters (?st - delivery_station ?o - order ?m - meal)
	:duration (= ?duration 1)
	:condition (and
				(at start (order-is-meal ?o ?m))
				(at start (item-at ?m ?st))
	)
	:effect (and
				(at start (not (item-at ?m ?st)))
				(at end (delivered ?o))
	)
)
(:durative-action take-item
	:parameters (?c - chef ?mi - movable_item ?pos - position ?s - station)
	:duration (= ?duration 1)
	:condition (and 
		(at start (chef-at ?c ?pos))
		(at start (chef-available ?c))

		(at start (not (chef-has-item ?c ?mi)))

		(at start (station-next ?s ?pos))
		(at start (not (station-occupied ?s)))

		(at start (item-at ?mi ?s))
	)
	:effect (and 
				(at start (not (chef-available ?c )))
				(at start (station-occupied ?s))

				(at end (not (station-occupied ?s)))
				(at end (not (item-at ?mi ?s)))

				(at end (chef-has-item ?c ?mi))
				(at end (chef-available ?c))
	)
)

(:durative-action leave-item
	:parameters (?c - chef ?mi - movable_item ?pos - position ?s - station)
	:duration (= ?duration 1)
	:condition (and
				(at start (chef-at ?c ?pos))
				(at start (chef-available ?c ))
				
				(at start (chef-has-item ?c ?mi))
				
				(at start (station-next ?s ?pos))
				(at start (not (station-occupied ?s)))
				;(at start (item-at ?mi ?s))
	)

	:effect (and
				(at start (station-occupied ?s))
				(at start (not (chef-available ?c)))

				(at end (not (station-occupied ?s)))
				(at end (not(chef-has-item ?c ?mi)))

				(at end (chef-available ?c))
				(at end (item-at ?mi ?s))
	)
)

(:durative-action move-chef
	:parameters (?c - chef ?from - position ?to - position)
	:duration (= ?duration 1)
	:condition (and
				(at start(chef-at ?c ?from))
				(at start (chef-available ?c ))
				(at start (position-next ?from ?to))
	)
	:effect (and
				(at start (not (chef-at ?c ?from)))
				(at start (not (chef-available ?c )))
				(at end (chef-at ?c ?to))
				(at end (chef-available ?c ))
	)
)

(:durative-action prepare-salad
	:parameters (?c - chef ?s - put_on_plate_station ?pos - position ?t - tomato ?l - lettuce ?salad - salad)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?pos))
				(at start (station-next ?s ?pos))

				(at start (chef-available ?c))
				(at start (not (station-occupied ?s)))

				(at start (item-at ?t ?s))
				(at start (item-at ?l ?s))

				(at start (is-cut ?t))
				(at start (is-cut ?l))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?t ?s)))
				(at start (not (item-at ?l ?s)))
				(at end (item-at ?salad ?s))
	)
)

(:durative-action prepare-pasta
	:parameters (?c - chef ?s - put_on_plate_station ?pos - position ?p - pasta ?pd - pasta_meal)
	:duration (= ?duration 3)
	:condition (and
				(at start(chef-at ?c ?pos))
				(at start (station-next ?s ?pos))

				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))
				(at start (can-cook               ?p))
				(at start (item-at ?p ?s))
				(at start (is-cooked ?p))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?p ?s)))
				(at end (item-at ?pd ?s))
	)
)

(:durative-action fried
	:parameters (?c - chef ?s - fried_station ?pos - position ?i - ingredient)
	:duration(= ?duration 2)
	:condition (and 
					(at start(chef-at ?c ?pos))
					(at start (station-next ?s ?pos))
				    (at start (chef-available ?c))
				    (at start (not (station-occupied ?s)))

				    (at start (can-fried             ?i))
				    (at start (not (is-fried         ?i)))
				    (at start (item-at			?i ?s))
				    (at start (is-cut             ?i))
			)
	:effect (and (at start(not (chef-available			?c)))
				 (at end (chef-available ?c))
				
				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))
				(at end (is-fried         ?i))	
	)
)
(:durative-action prepare-fishchip
	:parameters (?c - chef ?pos - position ?s - put_on_plate_station ?ss - sauce ?f - fish ?p - potato ?fc - fishchip)
	:duration (= ?duration 2)
	:condition (and   
					   (at start(chef-at ?c ?pos))
					   (at start (station-next ?s ?pos))
					   (at start (chef-available ?c))
					   (at start (not (station-occupied ?s)))

					   (at start(item-at				?f ?s))
					   (at start(item-at				?p ?s))
					   (at start(item-at             ?ss ?s))
					   (at start(is-fried            ?f))
					   (at start(is-fried            ?p))
	)
	:effect (and (at start(not (chef-available			?c)))
				 (at end (chef-available ?c))

				 (at start (station-occupied ?s))
				 (at end (not (station-occupied ?s)))

				 (at end(item-at				?fc ?s))
				 (at start(not(item-at		    ?ss ?s)))
				 (at start(not(item-at		    ?f ?s)))
				 (at start(not(item-at			?p ?s)))
	)

)
; make pizza before baking
(:durative-action make_pizza 
	:parameters(?c - chef ?pos - position ?s - put_on_plate_station ?t - bag_topping ?d - dough ?up - unbakedpizza)
	:duration (= ?duration 3)
	:condition (and 
					(at start(chef-at ?c ?pos))
					(at start (station-next ?s ?pos))
					(at start (chef-available ?c))
					(at start (not (station-occupied ?s)))

					(at start(item-at				?t ?s))
					(at start(item-at				?d ?s))
	)
	:effect( and (at start(not (chef-available			?c)))
				 (at end (chef-available ?c))

				 (at start (station-occupied ?s))
				 (at end (not (station-occupied ?s)))

				 (at end(item-at				?up ?s))
				 (at start(not(item-at		    ?d ?s)))
				 (at start(not(item-at		    ?t ?s)))
	)
)

(:durative-action baking_pizza
	:parameters(?c - chef ?pos - position ?o - oven ?up - unbakedpizza ?p - pizza)
	:duration(= ?duration 2)
	:condition(and 
				   (at start(chef-at ?c ?pos))
				   (at start (station-next ?s ?pos))
				   (at start (chef-available ?c))
				   (at start (not (station-occupied ?o)))

				   (at start (item-at ?up ?o))
	)
	:effect(and (at start(not (chef-available			?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?o))
				(at end (not (station-occupied ?o)))

				(at end (not(item-at   ?up ?o)))	
				(at end (item-at   ?p ?o))
	)

)

(:durative-action cut
	:parameters (?c - chef ?pos - position ?s - cutting_station ?i - ingredient)
	:duration (= ?duration 2)
	:condition (and
					(at start(chef-at ?c ?pos))
					(at start (station-next ?s ?pos))
					(at start (chef-available ?c))
					(at start (can-cut        ?i))
					(at start (not (station-occupied ?s)))

					(at start (item-at ?i ?s))
					(at start (not (is-cut ?i)))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))
				
				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))
				
				(at end (is-cut ?i))
	)
)

(:durative-action cook
	:parameters (?c - chef ?pos - position ?s - cooking_station ?i - ingredient)
	:duration (= ?duration 3)
	:condition (and
					(at start(chef-at ?c ?pos))
					(at start (station-next ?s ?pos))
					(at start (chef-available ?c))

					(at start (not (station-occupied ?s)))
					(at start (can-cook              ?i))
					(at start (item-at ?i ?s))
					(at start (not (is-cooked ?i)))
	)
	:effect (and
	    			(at start (not (chef-available ?c)))
					(at end (chef-available ?c))

					(at start (station-occupied ?s))
					(at end (not (station-occupied ?s)))
				
					(at end (is-cooked ?i))
	)
)

)
