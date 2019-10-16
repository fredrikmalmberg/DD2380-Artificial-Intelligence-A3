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
	cutting_station cooking_station fried_station delivery_station put_on_plate_station - station

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

	(position-next          ?pos1 ?pos2 - position)
	(station-next 			?s - station ?p - position)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(item-at				?mi - movable_item ?s - station) ; A certain MOVABLE item is present at a certain station

	(station-used   		?s - station ?m - meal)
	
	(is-blocked 			?pos - position)
	(is-cut					?i - ingredient)
	(is-cooked				?i - ingredient)
	(is-fried               ?i - ingredient)
	(delivered				?o - order)
	(can-cut                ?i - ingredient)
	(can-cook               ?i - ingredient)
	(can-fried              ?i - ingredient)
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
	:parameters (?c - chef ?pos - position ?mi - movable_item ?s - station)
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
	:parameters (?c - chef ?pos - position ?mi - movable_item ?s - station)
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
				(at start (not(is-blocked ?to)))
				(at start (position-next ?from ?to))
	)
	:effect (and
				(at start (not (chef-at ?c ?from)))
				(at start (not (chef-available ?c )))

				(at end (not (is-blocked ?from)))
				(at end (is-blocked ?to))

				(at end (chef-at ?c ?to))
				(at end (chef-available ?c ))
	)
)

(:durative-action prepare-salad
	:parameters (?c - chef ?pos - position ?s - put_on_plate_station ?t - tomato ?l - lettuce ?sau - sauce ?salad - salad)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?pos))
				(at start (station-next ?s ?pos))
			
				(at start (chef-available ?c))
				(at start (not (station-occupied ?s)))

				(at start (item-at ?t   ?s))
				(at start (item-at ?l   ?s))
				(at start (item-at ?sau ?s))

				(at start (is-cut ?t))
				(at start (is-cut ?l))
				(at start (not (station-used ?s ?salad)))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?t ?s)))
				(at start (not (item-at ?l ?s)))
				(at start (not (item-at ?sau ?s)))
				(at end (item-at ?salad ?s))
				(at end (station-used  ?s ?salad))
	)
)

(:durative-action prepare-pasta
	:parameters (?c - chef ?pos - position ?s - put_on_plate_station ?p - pasta ?t - tomato ?sau - sauce ?pd - pasta_meal)
	:duration (= ?duration 3)
	:condition (and
				(at start(chef-at ?c ?pos))
				(at start (station-next ?s ?pos))

				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))
				(at start (item-at ?t ?s))
				(at start (item-at ?sau ?s))
				(at start (item-at ?p ?s))
				(at start (is-cut ?t))
				(at start (is-cooked ?p))
				(at start (not (station-used ?s ?pd)))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?t ?s)))
				(at start (not (item-at ?sau ?s)))
				(at start (not (item-at ?p ?s)))
				(at end (item-at ?pd ?s))
				(at end (station-used  ?s ?pd))
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

					   (at start(item-at			 ?f ?s))
					   (at start(item-at			 ?p ?s))
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
