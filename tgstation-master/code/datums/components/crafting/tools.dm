/datum/crafting_recipe/gold_horn
	name = "Золотой гудок"
	result = /obj/item/bikehorn/golden
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/bananium = 5,
		/obj/item/bikehorn = 1,
	)
	category = CAT_TOOLS

/datum/crafting_recipe/boneshovel
	name = "Зубчатая костяная лопата"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_TOOLS

/datum/crafting_recipe/lasso
	name = "Костяное лассо"
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 5,
	)
	result = /obj/item/key/lasso
	category = CAT_TOOLS

/datum/crafting_recipe/ipickaxe
	name = "Импровизированная кирка"
	reqs = list(
		/obj/item/crowbar = 1,
		/obj/item/knife = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/pickaxe/improvised
	category = CAT_TOOLS

/datum/crafting_recipe/bandage
	name = "Импровизированный бинт"
	reqs = list(
		/obj/item/stack/sheet/cloth = 3,
		/datum/reagent/medicine/c2/libital = 10,
	)
	result = /obj/item/stack/medical/bandage/makeshift
	category = CAT_TOOLS
