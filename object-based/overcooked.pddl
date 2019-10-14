(define (domain overcooked)

(:requirements
	:typing
	:durative-actions 
	:numeric-fluents
	:object-fluents
	:negative-preconditions)

(:types
	; Chef
	chef - object

	; Stations
	station - object
	cutting_station - station
	cooking_station - station
	delivery_station - station
	put_on_plate_station - station

	; Items
	movable_item - object

	; Ingredients
	ingredient - movable_item

	; Ingredients
	tomato - ingredient
	lettuce - ingredient
	pasta - ingredient

	; Plates
	plate - movable_item

	; Dishes
	dish - object

	; Orders
	order - object
)

(:constants
	salad - dish
	pasta-dish - dish
)

(:predicates
	(chef-at				?c - chef   ?s - station);
	(chef-available			?c - chef)

	(station-occupied		?s - station); There is a chef WORKING at the station

	(item-at				?mi - movable_item ?s - station) ; A certain MOVABLE item is present at a certain station

	(is-cut					?i - ingredient)
	(is-cooked				?i - ingredient)

	(plate-is-occupied		?p)
	(plate-is-dish			?p - plate ?d - dish)

	(delivered				?o - order)

	(order-is				?o - order ?d - dish)
)

(:durative-action deliver
	:parameters (?st - delivery_station ?o - order ?p - plate ?d - dish)
	:duration (= ?duration 1)
	:condition (and
				(at start (order-is ?o ?d))
				(at start (plate-is-dish ?p ?d))
				(at start (item-at ?p ?st))
	)
	:effect (and
				(at start (not (item-at ?p ?st)))
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
	:parameters (?c - chef ?s - put_on_plate_station ?t - tomato ?l - lettuce ?p - plate)
	:duration (= ?duration 2)
	:condition (and
				(at start(chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (item-at ?t ?s))
				(at start (item-at ?l ?s))
				(at start (item-at ?p ?s))

				(at start (is-cut ?t))
				(at start (is-cut ?l))

				(at start (not (plate-is-occupied ?p)))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?t ?s)))
				(at start (not (item-at ?l ?s)))

				(at end (plate-is-dish ?p salad))
				(at start (plate-is-occupied ?p))
	)
)

(:durative-action prepare-pasta
	:parameters (?c - chef ?s - put_on_plate_station ?pa - pasta ?pl - plate)
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

				(at start (item-at ?pa ?s))
				(at start (item-at ?pl ?s))

				(at start (is-cooked ?pa))

				(at start (not (plate-is-occupied ?pl)))
	)
	:effect (and
	    		(at start (not (chef-available ?c)))
				(at end (chef-available ?c))

				(at start (station-occupied ?s))
				(at end (not (station-occupied ?s)))

				(at start (not (item-at ?pa ?s)))

				(at end (plate-is-dish ?pl pasta-dish))
				(at start (plate-is-occupied ?pl))
	)
)

(:durative-action cut
	:parameters (?c - chef ?s - cutting_station ?i - ingredient)
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

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
