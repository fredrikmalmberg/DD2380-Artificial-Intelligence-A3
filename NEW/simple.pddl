(define (problem simple)
	(:domain overcooked)
(:objects
		order1                                     - order
;		order1 order2 order3 order4 order5 order6  - order
    	chef1                                      - chef
;    	chef1 chef2                                - chef
    	salad pasta sandwitch fishchip             - meal
    	storing cutting cooking place_on_plate delivering - process
    	storage_room cutting_station cooking_station plate_station delivery_station - station
)
(:init  
	
	(type_Order order1 salad)
;	(type_Order order2 pasta)
;	(type_Order order3 sandwitch)
;	(type_Order order4 pasta)
;	(type_Order order5 fishchip)
;	(type_Order order6 salad)
	
	(type_Process salad cutting)
	(type_Process salad place_on_plate)
	(type_Process salad delivering)
	(start_process salad cutting)
	(Process_link  salad cutting place_on_plate)
	(Process_link  salad place_on_plate delivering)
	
	(type_Process pasta cutting)
	(type_Process pasta storing)
	(type_Process pasta cooking)
	(type_Process pasta place_on_plate)
	(type_Process pasta delivering)
	(start_process pasta cutting)
	(Process_link  pasta cuttingtting st)
	(Process_link  pasta storing cooking)
	(Process_link  pasta cooking place_on_plate)
	(Process_link  pasta place_on_plate delivering)
	
	(type_Process sandwitch storing)
	(type_Process sandwitch cutting)
	(type_Process sandwitch place_on_plate)
	(type_Process sandwitch delivering)
	(start_process sandwitch storgin)
	(Process_link sandwitch storing cutting)
	(Process_link sandwitch cuttingtting place_on_plate)
	(Process_link sandwitch place_on_plate delivering)
    
	(type_Process fishchip st)
	(type_Process fishchip cooking)
	(type_Process fishchip place_on_plate)
	(type_Process fishchip delivering)
	(start_process fishchip storing)
	(Process_link fishchip storing cooking)
	(Process_link fishchip cooking place_on_plate)
	(Process_link fishchip place_on_plate delivering)

	(Pro_in_station storage_room storing);
	(Pro_in_station cutting_station cutting);
	(Pro_in_station cooking_station cooking);
	(Pro_in_station plate_station place_on_plate);
	(Pro_in_station delivery_station delivering);

	(chef-at chef1 delivery_station)
;	(chef-at chef1 cutting_station)
;	(chef-at chef2 delivery_station)
;	(occupied s2)
	(occupied delivering)
	(freetime chef1)
;	(freetime chef2)
	

)
(:goal 
	(and (type_Order_Process order1 delivering) 
;             (type_Order_Process order1 delivering) 
 ;            (type_Order_Process order3 delivering) 
  ;           (type_Order_Process order4 delivering)
   ;          (type_Order_Process order5 delivering)
    ;         (type_Order_Process order6 delivering)
             )
	)
)