/datum/crafting_recipe/paperframes
	name = "Бумажные рамки"
	time = 1 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 5,
		/obj/item/paper = 20,
	)
	result = /obj/item/stack/sheet/paperframes
	result_amount = 5
	category = CAT_STRUCTURE

/datum/crafting_recipe/rib
	name = "Ребро Колосса"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/rib
	category = CAT_STRUCTURE

/datum/crafting_recipe/skull
	name = "Вырезать череп"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 6,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull
	category = CAT_STRUCTURE

/datum/crafting_recipe/halfskull
	name = "Вырезать половину черепа"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 3,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_STRUCTURE

/datum/crafting_recipe/firecabinet
	name = "Шкаф для пожарного топора"
	result = /obj/item/wallframe/fireaxecabinet
	time = 8 SECONDS
	reqs = list(
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stack/sheet/glass = 5,
		/obj/item/stack/cable_coil = 10,
	)
	category = CAT_STRUCTURE

/datum/crafting_recipe/mechcabinet
	name = "Шкаф для лома против мехов"
	result = /obj/item/wallframe/fireaxecabinet/mechremoval
	time = 8 SECONDS
	reqs = list(
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stack/sheet/glass = 5,
		/obj/item/stack/cable_coil = 10,
	)
	category = CAT_STRUCTURE

/datum/crafting_recipe/syndicate_uplink_beacon
	name = "Маяк аплинка Синдиката"
	result = /obj/structure/syndicate_uplink_beacon
	tool_behaviors = list(TOOL_SCREWDRIVER)
	always_available = FALSE
	time = 6 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
		/obj/item/beacon = 1,
		/obj/item/stack/ore/bluespace_crystal = 1,
	)
	category = CAT_STRUCTURE

/datum/crafting_recipe/bonfire
	name = "Костёр"
	time = 6 SECONDS
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_STRUCTURE
