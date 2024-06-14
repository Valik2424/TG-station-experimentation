
/turf/open/floor/engine/hull
	name = "внешняя обшивка корпуса"
	desc = "Прочная внешняя обшивка корпуса, которая отделяет нас от безразличного вакуума космоса."
	icon_state = "regular_hull"
	initial_gas_mix = AIRLESS_ATMOS
	temperature = TCMB

/turf/open/floor/engine/hull/nonairless
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	temperature = 255.37

/turf/open/floor/engine/hull/ceiling
	name = "shuttle ceiling plating"
	var/old_turf_type

/turf/open/floor/engine/hull/ceiling/AfterChange(flags, oldType)
	. = ..()
	old_turf_type = oldType

/turf/open/floor/engine/hull/reinforced
	name = "внешняя укрепленная обшивка корпуса"
	desc = "Чрезвычайно прочная внешняя обшивка корпуса, отделяющая нас от безразличного вакуума космоса."
	icon_state = "reinforced_hull"
	heat_capacity = INFINITY
