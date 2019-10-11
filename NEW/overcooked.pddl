(define (domain overcooked)
(:requirements
        ;:strips
        :typing
        ;:equality
        ;:fluents
        ;:conditional-effects
        :durative-actions 
        :numeric-fluents)

(:types
  chef - object               	  ;
  meal - object                   ;
  station - object                ;
  process - object                ;
  order - object                  ;
)

(:predicates
	(type_Process           ?m - meal   ?p - process);
	(type_Order             ?o - order  ?m - meal);
	(Process_link           ?m - meal   ?p - process ?pp - process);
	(Pro_in_station         ?s - station ?p - process)
	(start_process          ?m - meal    ?p - process)
	(type_Order_Process     ?o - order  ?p - process);
	(occupied               ?s - station);
	(foodoccupied           ?s - station);if this station is occupied by FOOD (process of the meal in the order)
	(chef-at                ?c - chef   ?s - station);
    (freetime               ?c - chef)
    (where_process          ?p - process ?o - order ?s - station);where is the order with the process done; where we place the order in current time
)

(:durative-action move
	:parameters (?c - chef ?from - station ?to - station)
	:duration (= ?duration 2)
	:condition (and (at start(chef-at ?c ?from))
						(at start (not (occupied ?to))))
	:effect (and (at start (not (chef-at ?c ?from)))
				(at start (not (occupied ?from)))
					(at end (chef-at ?c ?to))
					(at end (occupied ?to)))
)

(:durative-action movedish
    :parameters (?o - order ?p - process ?c - chef ?here - station ?there - station )
	:duration (= ?duration 2)
    :condition (and (at start (chef-at ?c ?here))
                      (at start (freetime ?c))
                      (at start (foodoccupied ?here))
                      (at start (not (foodoccupied ?there)))
                      (at start (where_process ?p ?o ?here)))
    :effect (and (at start (not(chef-at ?c ?here)))
            	(at end (chef-at ?c ?there))
                 (at start (not(foodoccupied ?here)))
                      (at end (foodoccupied ?there))
                      (at end (not(foodoccupied ?here)))
                      (at start (where_process ?p ?o ?there))
                 (at end (not (where_process ?p ?o ?here))))
                 
)

(:durative-action startprocess
	:parameters (?o - order ?m - meal ?p  - process ?c - chef ?st - station)
	:duration (= ?duration 1)
	:condition (and (at start(type_Order ?o ?m))
					(at start(type_Process ?m ?p))
					(at start(start_process ?m ?p))					  
					(at start(Pro_in_station ?st ?p))
					(at start(not (type_Order_Process ?o ?p)))
					(at start(freetime ?c))
				    (at start(chef-at ?c ?st))
					(at start(not (foodoccupied ?st))))
	:effect (and (at end (type_Order_Process ?o ?p))
				(at start (foodoccupied ?st))
				(at end (where_process ?p ?o ?st)))
)

(:durative-action processing
	:parameters (?o - order ?m - meal ?p - process ?pp - process ?c - chef ?st - station)
	:duration (= ?duration 2)
	:condition (and	(at start (type_Order   		?o ?m))
					  (at start (type_Process 		?m ?p))
	                  (at start (type_Process 		?m ?pp))
					  (at start (Process_link ?m ?pp ?p))
					  (at start (type_Order_Process ?o ?pp))
				  	  (at start (not (type_Order_Process ?o ?p) ))
					  (at start (Pro_in_station ?st ?p))
					  (at start (freetime ?c))
				      (at start (chef-at ?c ?st))
					  (at start (where_process ?pp ?o ?st))
					  (at start (foodoccupied ?st)))
	:effect (and (at end (type_Order_Process ?o ?p))
				(at end (where_process ?p ?o ?st))
				(at end (not (where_process ?pp ?o ?st)))))
)

