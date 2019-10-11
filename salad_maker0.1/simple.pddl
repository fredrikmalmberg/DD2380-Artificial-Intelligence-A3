(define (problem simple)
	(:domain overcooked)
(:objects
    	chef1                                - chef
    	salad            					- dish
    	storage_room1 - station
    	delivery_station1 - delivery_station
    	cutting_station1 - cutting_station                ;
  		put_on_plate_station1 - put_on_plate_station 
)
(:init  
	(station-occupied storage_room1)
	(chef-available chef1)
	(chef-at chef1 storage_room1)
	(movable_object-at salad cutting_station1)

	

)
(:goal 
	(and (delivered salad)) 

)
(:metric minimize (total-time))
)