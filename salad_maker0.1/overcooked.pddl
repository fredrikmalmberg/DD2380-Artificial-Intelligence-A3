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

	movable_object - object

	dish - movable_object
	salad - dish

	ingredient - movable_object
	tomato - ingredient
	lettuce - ingredient

	order - object
)

(:predicates
	(chef-at				?c - chef   ?s - station);
	(chef-available			?c - chef)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(movable_object-at		?mo - movable_object ?s - station)

	(delivered				?o - order)

	(is-cut					?i - ingredient)

	(order-has-dish			?o - order ?d - dish)
)

(:durative-action deliver
	:parameters (?st - delivery_station ?o - order ?d - dish)
	:duration (= ?duration 1)
	:condition (and
				(at start (order-has-dish ?o ?d))
				(at start (movable_object-at ?d ?st))
	)
	:effect (and
				(at start (not (movable_object-at ?d ?st)))
				(at end (delivered ?o))
	)
)

(:durative-action move_item
	:parameters (?c - chef ?here - station ?there - station ?o - movable_object )
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?here))
				(at start (chef-available ?c ))

				(at start (movable_object-at ?o ?here ))
	)

	:effect (and
				(at start (not (chef-at ?c ?here)))
				(at start (not (chef-available ?c )))
				(at end (chef-at ?c ?there))
				(at end (chef-available ?c ))

				(at start (not (movable_object-at ?o ?here)))
				(at end (movable_object-at ?o ?there))
	)
)

(:durative-action move
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
	:parameters (?c - chef ?s - put_on_plate_station ?t - tomato ?l - lettuce ?salad - salad)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (movable_object-at ?t ?s))
				(at start (movable_object-at ?l ?s))

				(at start (is-cut ?t))
				(at start (is-cut ?l))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (movable_object-at ?t ?s )))
				(at start (not (movable_object-at ?l ?s )))
				(at end (movable_object-at ?salad ?s ))
	)
)

(:durative-action cut
	:parameters (?c - chef ?s - cutting_station ?i - ingredient)
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (movable_object-at ?i ?s))
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

)
