; Domain that incorporates a plan metric that approximates minimizing
; the number of orders that are not delivered on time
;
; The domain definition is based on the general object-based domain

(define (domain overcooked_metric)

(:requirements
	:typing
	:durative-actions 
	:numeric-fluents
	:negative-preconditions
	:action-costs
	:conditional-effects)

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

(:functions 
	; Here the functions are defined that are required to implement 
	; modified plan metric

	; Total cost is the number of orders that are not delivered on time
	(total-cost				) - number

	; Every chef has a timer that approximates the total time elapsed in the world.
	; This solution draws on the fact that the plans generated tend to keep
	; the chefs busy almost all the time. I.e. if we just add together the durations
	; of the actions taking by any single chef, that sum will be close to the
	; total time elapsed in the world.
	(timer					?c - chef) - number

	; Every order has a target time when it should be delivered
	(delivery-time-goal		?o - order) - number
)

(:durative-action deliver
	; Even though there is no chef that actually delivers an order, we have to
	; add a chef as a parameter in order to be able to read the value of some
	; chef's timer
	:parameters (?c - chef ?st - delivery_station ?o - order ?m - meal)
	:duration (= ?duration 1)
	:condition (and
				(at start (order-is-meal ?o ?m))
				(at start (item-at ?m ?st))
	)
	:effect (and
				(at start (not (item-at ?m ?st)))
				(at end (delivered ?o))
				; Here the total cost function is updated, through a conditional effect:
				; If the order is NOT delivered on time, the cost function will be increased
				(when
					(at end (< (delivery-time-goal ?o) (timer ?c)))
					(at end (increase (total-cost) 1))
				)
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 1))
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 1))
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 2))
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 2))
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 2))
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

				; Every action that a chef takes increases that chef's timer
				; with the duration of the action
				(at end (increase (timer ?c) 3))
	)
)

)
