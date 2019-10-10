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
	(type_Order_Process     ?o - order  ?p - process);
	(occupied               ?s - station);
	(chef-at                ?c - chef   ?s - station);
	(Process_link           ?m - meal   ?p - process ?pp - process);
	(Pro_in_station         ?s - station ?p - process)
	(start_process          ?m - meal    ?p - process)
    (freetime               ?c - chef)
)

(:durative-action startprocess
	:parameters (?c - chef ?st - station ?m - meal ?p  - process ?o - order)
	:duration (= ?duration 1)
	:condition (and (at start(type_Process ?m ?p))
					  (at start(type_Order ?o ?m))
					  (at start(Pro_in_station ?st ?p))
					  (at start(start_process ?m ?p))
					  (at start(freetime ?c))
				  	  (at start(not (type_Order_Process ?o ?p)))
				      (at start(chef-at ?c ?st)))
	:effect (and (at end (type_Order_Process ?o ?p)))
)

(:durative-action processing
	:parameters (?c - chef ?st - station ?m - meal ?p - process ?pp - process ?o - order)
	:duration (= ?duration 2)
	:condition (and (at start (type_Process 		?m ?p))
	                  (at start (type_Process 		?m ?pp))
					  (at start (type_Order   		?o ?m))
					  (at start (type_Order_Process ?o ?pp))
					  (at start (Process_link ?m ?pp ?p))
					  (at start (Pro_in_station ?st ?p))
					  (at start (freetime ?c))
				  	  (at start (not (type_Order_Process ?o ?p) ))
				      (at start (chef-at ?c ?st)))
	:effect (and (at end (type_Order_Process ?o ?p)))
)

(:durative-action move
	:parameters (?c - chef ?from - station ?to - station)
	:duration (= ?duration 2)
	:condition (and (at start(chef-at ?c ?from))
						(at start (not (occupied ?to)))
						(at start (occupied ?from)))
	:effect (and (at end (not (chef-at ?c ?from)))
					(at end (chef-at ?c ?to))
					(at end (occupied ?to))
				(at end (not (occupied ?from))))
)

)

