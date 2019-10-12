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

	; Meals
	meal - movable_item
	salad - meal
	pasta_meal - meal

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

	(delivered				?o - order)

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
	:duration (= ?duration 2)
	:condition (and
				(at start (chef-at ?c ?s))
				(at start (chef-available ?c))

				(at start (not (station-occupied ?s)))

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
