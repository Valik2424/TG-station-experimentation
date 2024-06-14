/datum/crafting_recipe/naturalpaper
	name = "Спрессованная руками бумага"
	time = 3 SECONDS
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	category = CAT_MISC

/datum/crafting_recipe/skeleton_key
	name = "Скелетный ключ"
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 5)
	result = /obj/item/skeleton_key
	always_available = FALSE
	category = CAT_MISC

/datum/crafting_recipe/coffee_cartridge
	name = "Картридж Бутлег-кофе"
	result = /obj/item/coffee_cartridge/bootleg
	time = 2 SECONDS
	reqs = list(
		/obj/item/blank_coffee_cartridge = 1,
		/datum/reagent/toxin/coffeepowder = 10,
	)
	category = CAT_MISC

/datum/crafting_recipe/corporate_paper_slip
	name = "Корпоративный нож для бумаги"
	result = /obj/item/paper/paperslip/corporate
	time = 3 SECONDS
	reqs = list(
		/obj/item/paper/paperslip = 1,
		/obj/item/stack/sheet/plastic = 3,
	)
	tool_paths = list(/obj/item/stamp/head/captain)
	category = CAT_MISC

/datum/crafting_recipe/cardboard_id
	name = "Картонная ID карта"
	tool_behaviors = list(TOOL_WIRECUTTER)
	result = /obj/item/card/cardboard
	time = 4 SECONDS
	reqs = list(
		/obj/item/stack/sheet/cardboard = 1,
	)
	category = CAT_MISC
