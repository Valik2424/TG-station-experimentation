/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "бронежалюзи"
	desc = "Механические заслонки для тяжелых условий эксплуатации с атмосферным уплотнением, обеспечивающим их герметичность после закрытия."
	icon = 'icons/obj/doors/shutters.dmi'
	layer = SHUTTER_LAYER
	closingLayer = SHUTTER_LAYER
	damage_deflection = 20
	armor_type = /datum/armor/poddoor_shutters
	max_integrity = 100
	recipe_type = /datum/crafting_recipe/shutters
	animation_sound = 'sound/machines/shutter.ogg'

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/indestructible
	name = "сверхкрепкие жалюзи"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/indestructible/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/radiation
	name = "свинцовые жалюзи"
	desc = "Свинцовые жалюзи с символом радиационной опасности. Хотя это не помешает вам получить облучение, особенно кристаллом суперматерии, оно остановит распространение излучения так далеко."
	icon = 'icons/obj/doors/shutters_radiation.dmi'
	icon_state = "closed"
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE
	rad_insulation = RAD_NO_INSULATION

/datum/armor/poddoor_shutters
	melee = 20
	bullet = 20
	laser = 20
	energy = 75
	bomb = 25
	fire = 100
	acid = 70

/obj/machinery/door/poddoor/shutters/radiation/open()
	. = ..()
	rad_insulation = RAD_NO_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/close()
	. = ..()
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/window
	name = "прозрачные бронежалюзи"
	desc = "жалюзи с толстым прозрачным окном из поликарбоната."
	icon = 'icons/obj/doors/shutters_window.dmi'
	icon_state = "closed"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/poddoor/shutters/window/preopen
	icon_state = "open"
	density = FALSE
