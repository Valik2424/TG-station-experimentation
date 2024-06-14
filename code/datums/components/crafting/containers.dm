/datum/crafting_recipe/papersack
	name = "Бумажный мешок"
	result = /obj/item/storage/box/papersack
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 5)
	category = CAT_CONTAINERS

/datum/crafting_recipe/sillycup
	name = "Бумажный стаканчик"
	result =  /obj/item/reagent_containers/cup/glass/sillycup
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 2)
	category = CAT_CONTAINERS

/datum/crafting_recipe/boh
	name = "Блюспейс сумка"
	reqs = list(
		/obj/item/bag_of_holding_inert = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)
	result = /obj/item/storage/backpack/holding
	category = CAT_CONTAINERS

/datum/crafting_recipe/underwater_basket
	name = "Подводная корзина из бамбука"
	reqs = list(
		/obj/item/stack/sheet/mineral/bamboo = 20
	)
	result = /obj/item/storage/basket
	category = CAT_CONTAINERS
	steps = list(
		"изучите искусство подводного плетения корзин",
		"находитесь под водой"
	)

/datum/crafting_recipe/underwater_basket/check_requirements(mob/user, list/collected_requirements)
	. = ..()
	if(!HAS_TRAIT(user,TRAIT_UNDERWATER_BASKETWEAVING_KNOWLEDGE))
		return FALSE
	var/turf/T = get_turf(user)
	if(istype(T, /turf/open/water))
		return TRUE
	var/obj/machinery/shower/S = locate() in T
	if(S?.actually_on)
		return TRUE

//Same but with wheat
/datum/crafting_recipe/underwater_basket/wheat
	name = "Подводная корзина из пшеницы"
	reqs = list(/obj/item/food/grown/wheat = 50)
