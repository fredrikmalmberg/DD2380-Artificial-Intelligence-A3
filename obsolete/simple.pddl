(define (problem simple)
	(:domain overcooked)
(:objects
		order1 order2 order3 order4 order5 order6 - order
    	chef1 chef2                               - chef
    	salad pasta sandwitch fishchip            - meal
    	st cu co pl de                            - process
    	s1 s2 s3 s4 s5                            - station
)
(:init  
	
	(type_Order order1 salad)
	(type_Order order2 pasta)
	(type_Order order3 sandwitch)
	(type_Order order4 pasta)
	(type_Order order5 fishchip)
	(type_Order order6 salad)
	
	(start_process salad cu)
	(type_Process salad cu)
	(type_Process salad pl)
	(type_Process salad de)
	(Process_link  salad cu pl)
	(Process_link  salad pl de)
	
	(start_process pasta cu)
	(type_Process pasta st)
	(type_Process pasta cu)
	(type_Process pasta pl)
	(type_Process pasta de)
	(type_Process pasta co)
	(Process_link  pasta cu st)
	(Process_link  pasta st co)
	(Process_link  pasta co pl)
	(Process_link  pasta pl de)
	
	(start_process sandwitch st)
	(type_Process sandwitch st)
	(type_Process sandwitch cu)
	(type_Process sandwitch pl)
	(type_Process sandwitch de)
	(Process_link sandwitch st cu)
	(Process_link sandwitch cu pl)
	(Process_link sandwitch pl de)
    
	(start_process fishchip st)
	(type_Process fishchip st)
	(type_Process fishchip co)
	(type_Process fishchip pl)
	(type_Process fishchip de)
	(Process_link fishchip st co)
	(Process_link fishchip co pl)
	(Process_link fishchip pl de)

	(chef-at chef1 s2)
	(chef-at chef2 s5)
	(occupied s2)
	(occupied s5)
	(freetime chef1)
	(freetime chef2)
	
	(Pro_in_station s1 st);
	(Pro_in_station s2 cu);
	(Pro_in_station s3 co);
	(Pro_in_station s4 pl);
	(Pro_in_station s5 de);

)
(:goal 
	(and (type_Order_Process order1 de) 
             (type_Order_Process order1 de) 
             (type_Order_Process order3 de) 
             (type_Order_Process order4 de)
             (type_Order_Process order5 de)
             (type_Order_Process order6 de)
             )
	)
)