(define (domain overcooked)
(:requirements
        :typing
        :durative-actions 
        :numeric-fluents)

(:types
  chef - object               	  ;
  movable_object - object
  dish - movable_object                   ;
  station - object
  cutting_station - station                ;
  delivery_station - station                ;
  put_on_plate_station - station                ;
  ingredient - movable_object
  tomato - ingredient
  lettuce - ingredient
)

(:predicates
	(station-occupied       ?s - station); There is a chef at the station
	;(station-has            ?s - station ?i - ingredient);if this station is occupied by FOOD (process of the meal in the order)
	(chef-at                ?c - chef   ?s - station);
    (chef-available         ?c - chef)
    (movable_object-at		?mo - movable_object ?s - station)
    (delivered				?d - dish)

)

(:durative-action deliver
	:parameters (?st - delivery_station ?d - dish)
	:duration (= ?duration 1)
	:condition (and (at start(movable_object-at ?d ?st)))
	:effect (and (at end(not (movable_object-at ?d ?st)))
					(at end (delivered ?d))
	)
)

(:durative-action move_item
    :parameters (?c - chef ?here - station ?there - station ?o - movable_object )
	:duration (= ?duration 2)
    :condition (and (at start (chef-at ?c ?here))
    				(at start (chef-available ?c ))
    				(at start (not (station-occupied ?there))); This actually should be at end...
    				(at start (movable_object-at ?o ?here )))

    :effect (and (at start (not(chef-at ?c ?here)))
    				(at start (not (chef-available ?c )))
            		(at end (chef-at ?c ?there))
                (at end (chef-available ?c ))
            		(at start (not (movable_object-at ?o ?here)))
            		(at start (not (station-occupied ?here)))
            		(at end (station-occupied ?there))
            		(at end (movable_object-at ?o ?there))
            		)
	)

(:durative-action move
	:parameters (?c - chef ?from - station ?to - station)
	:duration (= ?duration 2)
	:condition (and (at start(chef-at ?c ?from))
					(at start (chef-available ?c ))
					(at start (not (station-occupied ?to))))
	:effect (and (at start (not (chef-at ?c ?from)))
		    		(at start (not (chef-available ?c )))
					(at start (not (station-occupied ?from)))
					(at end (chef-at ?c ?to))
          (at end (chef-available ?c ))
					(at end (station-occupied ?to)))
	)
)

