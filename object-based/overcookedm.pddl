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
	station - object
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
	sause - ingredient
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
	(chef-at				?c - chef   ?s - station);
	(chef-available			?c - chef)

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

(:durative-action move-item
	:parameters (?c - chef ?here - station ?there - station ?mi - movable_item)
	:duration (= ?duration 1)
	:condition (and
				(at start (chef-at ?c ?here))
				(at start (chef-available ?c ))

				(at start (item-at ?mi ?here))
	)

	:effect (and
				(at start (not (chef-at ?c ?here)))
				(at start (not (chef-available ?c )))
				(at end (chef-at ?c ?there))
				(at end (chef-available ?c ))

				(at start (not (item-at ?mi ?here)))
				(at end (item-at ?mi ?there))
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
	:parameters (?c - chef ?s - put_on_plate_station ?t - tomato ?l - lettuce ?salad - salad)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?s))
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
	:parameters (?c - chef ?s - put_on_plate_station ?p - pasta ?pd - pasta_meal)
	:duration (= ?duration 3)
	:condition (and
				(at start (chef-at ?c ?s))
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
	:parameters (?c - chef ?s - fried_station ?i - ingredient)
	:duration(= ?duration 2)
	:condition (and (at start (chef-at ?c   ?s))
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
	:parameters (?c - chef ?s - put_on_plate_station ?ss - sause ?f - fish ?p - potato ?fc - fishchip)
	:duration (= ?duration 2)
	:condition (and (at start (chef-at				?c   ?s))
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
	:parameters(?c - chef ?s - put_on_plate_station ?t - bag_topping ?d - dough ?up - unbakedpizza)
	:duration (= ?duration 3)
	:condition (and (at start (chef-at	 ?c   ?s))
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
	:parameters(?c - chef ?o - oven ?up - unbakedpizza ?p - pizza)
	:duration(= ?duration 2)
	:condition(and (at start (chef-at   ?c   ?o))
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
	:parameters (?c - chef ?s - cutting_station ?i - ingredient)
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
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
	:parameters (?c - chef ?s - cooking_station ?i - ingredient)
	:duration (= ?duration 3)
	:condition (and
				(at start (chef-at ?c ?s))
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
