(define (domain overcooked)

(:requirements
	:typing
	:durative-actions 
	:numeric-fluents
	:negative-preconditions)

(:types
	chef - object

	station - object
	cutting_station - station
	delivery_station - station
	put_on_plate_station - station

	movable_item_type - object

	ingredient_type - movable_item_type

	tomato_type - ingredient_type
	lettuce_type - ingredient_type

	cut_ingredient_type - ingredient_type

	cut_tomato_type - cut_ingredient_type
	cut_lettuce_type - cut_ingredient_type

	dish - movable_item_type
	salad_type - dish

	order - object
)

(:predicates
	(chef-at				?c - chef   ?s - station);
	(chef-available			?c - chef)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(delivered				?o - order)

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
	:duration (= ?duration 2)
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
	:duration (= ?duration 2)
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

(:durative-action cut
	:parameters (?c - chef ?s - cutting_station ?i - ingredient_type ?ci - cut_ingredient_type)
	:duration (= ?duration 2)
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
