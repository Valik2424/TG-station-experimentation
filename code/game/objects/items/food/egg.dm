
////////////////////////////////////////////EGGS////////////////////////////////////////////

/obj/item/food/chocolateegg
	name = "шоколадное яйцо"
	desc = "Такая сладкая, жирная еда."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "chocolateegg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("chocolate" = 4, "sweetness" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_2

/// Counter for number of chicks hatched by throwing eggs, minecraft style. Chicks will not emerge from thrown eggs if this value exceeds the MAX_CHICKENS define.
GLOBAL_VAR_INIT(chicks_from_eggs, 0)

/obj/item/food/egg
	name = "яйцо"
	desc = "ЯЙЦО!"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "egg"
	inhand_icon_state = "egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 2, /datum/reagent/consumable/eggwhite = 4)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_TINY
	ant_attracting = FALSE
	decomp_type = /obj/item/food/egg/rotten
	decomp_req_handle = TRUE //so laid eggs can actually become chickens
	/// How likely is it that a chicken will come out of here if we throw it?
	var/chick_throw_prob = 13

/obj/item/food/egg/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/boiledegg, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/egg/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/boiledegg)

/obj/item/food/egg/organic
	name = "органическое яйцо"
	desc = "100% натуральное яйцо."
	starting_reagent_purity = 1

/obj/item/food/egg/rotten
	food_reagents = list(/datum/reagent/consumable/eggrot = 10, /datum/reagent/consumable/mold = 10)
	foodtypes = GROSS
	preserved_food = TRUE

/obj/item/food/egg/rotten/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/boiledegg/rotten, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/egg/rotten/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/boiledegg/rotten)

/obj/item/food/egg/gland
	desc = "ЯЙЦО! Яйцо?"

/obj/item/food/egg/gland/Initialize(mapload)
	. = ..()
	reagents.add_reagent(get_random_reagent_id(), 15)

	var/color = mix_color_from_reagents(reagents.reagent_list)
	add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/obj/item/food/egg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)
	if (prob(chick_throw_prob))
		spawn_impact_chick(hit_turf)
	reagents.expose(hit_atom, TOUCH)
	qdel(src)

/// Spawn a baby chicken from throwing an egg
/obj/item/food/egg/proc/spawn_impact_chick(turf/spawn_turf)
	var/chickens_remaining = MAX_CHICKENS - GLOB.chicks_from_eggs
	if (chickens_remaining < 1)
		return
	var/spawned_chickens = prob(97) ? 1 : min(4, chickens_remaining) // We don't want to go over the limit
	if (spawned_chickens > 1) // Chicken jackpot!
		visible_message(span_notice("[spawned_chickens] chicks come out of the egg! Jackpot!"))
	else
		visible_message(span_notice("A chick comes out of the cracked egg!"))
	for(var/i in 1 to spawned_chickens)
		new /mob/living/basic/chick(spawn_turf)
		GLOB.chicks_from_eggs++

/obj/item/food/egg/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/W = item
		var/clr = W.crayon_color

		if(!(clr in list("blue", "green", "mime", "orange", "purple", "rainbow", "red", "yellow")))
			to_chat(usr, span_notice("[capitalize(src.name)] не хочет принимать новый цвет!"))
			return

		to_chat(usr, span_notice("Крашу [src] используя [W]."))
		icon_state = "egg-[clr]"

	else if(istype(item, /obj/item/stamp/clown))
		var/clowntype = pick("grock", "grimaldi", "rainbow", "chaos", "joker", "sexy", "standard", "bobble",
			"krusty", "bozo", "pennywise", "ronald", "jacobs", "kelly", "popov", "cluwne")
		icon_state = "egg-clown-[clowntype]"
		desc = "Яйцо, украшенное гротескным подобием лица клоуна. "
		to_chat(usr, span_notice("Штампую [src] используя [item], создавая художественное и ничуть не ужасающее подобие клоунского грима."))

	else if(is_reagent_container(item))
		var/obj/item/reagent_containers/dunk_test_container = item
		if (!dunk_test_container.is_drainable() || !dunk_test_container.reagents.has_reagent(/datum/reagent/water))
			return

		to_chat(user, span_notice("You check if [src] is rotten."))
		if(istype(src, /obj/item/food/egg/rotten))
			to_chat(user, span_warning("[src] floats in the [dunk_test_container]!"))
		else
			to_chat(user, span_notice("[src] sinks into the [dunk_test_container]!"))
	else
		..()

/obj/item/food/egg/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!istype(target, /obj/machinery/griddle))
		return SECONDARY_ATTACK_CALL_NORMAL

	var/atom/broken_egg = new /obj/item/food/rawegg(target.loc)
	broken_egg.pixel_x = pixel_x
	broken_egg.pixel_y = pixel_y
	playsound(get_turf(user), 'sound/items/sheath.ogg', 40, TRUE)
	reagents.copy_to(broken_egg,reagents.total_volume)

	var/obj/machinery/griddle/hit_griddle = target
	hit_griddle.AddToGrill(broken_egg, user)
	target.balloon_alert(user, "cracks [src] open")

	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/food/egg/blue
	icon_state = "egg-blue"
	inhand_icon_state = "egg-blue"
/obj/item/food/egg/green
	icon_state = "egg-green"
	inhand_icon_state = "egg-green"
/obj/item/food/egg/mime
	icon_state = "egg-mime"
	inhand_icon_state = "egg-mime"
/obj/item/food/egg/orange
	icon_state = "egg-orange"
	inhand_icon_state = "egg-orange"

/obj/item/food/egg/purple
	icon_state = "egg-purple"
	inhand_icon_state = "egg-purple"

/obj/item/food/egg/rainbow
	icon_state = "egg-rainbow"
	inhand_icon_state = "egg-rainbow"

/obj/item/food/egg/red
	icon_state = "egg-red"
	inhand_icon_state = "egg-red"

/obj/item/food/egg/yellow
	icon_state = "egg-yellow"
	inhand_icon_state = "egg-yellow"

/obj/item/food/egg/penguin_egg
	icon = 'icons/mob/simple/penguins.dmi'
	icon_state = "penguin_egg"

/obj/item/food/egg/fertile
	name = "фертильное яйцо"
	desc = "ЯЙЦО! Оно выглядит оплодотворенным.\nКак вы можете определить это, просто посмотрев на него? Загадка вселенной..."
	chick_throw_prob = 100

/obj/item/food/egg/fertile/Initialize(mapload, loc)
	. = ..()

	AddComponent(/datum/component/fertile_egg,\
		embryo_type = /mob/living/basic/chick,\
		minimum_growth_rate = 1,\
		maximum_growth_rate = 2,\
		total_growth_required = 200,\
		current_growth = 0,\
		location_allowlist = typecacheof(list(/turf)),\
		spoilable = FALSE,\
	)

/obj/item/food/friedegg
	name = "яичница"
	desc = "Жареное яйцо с оттенком соли и перца."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "friedegg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/eggyolk = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	bite_consumption = 1
	tastes = list("яйцо" = 4)
	foodtypes = MEAT | FRIED | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/rawegg
	name = "сырое яйцо"
	desc = "Сырое яйцо. Лучше жареное."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "rawegg"
	food_reagents = list() //Recieves all reagents from its whole egg counterpart
	bite_consumption = 1
	tastes = list("сырое яйцо" = 6)
	eatverbs = list("проглатывает")
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawegg/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/friedegg, rand(20 SECONDS, 35 SECONDS), TRUE, FALSE)

/obj/item/food/boiledegg
	name = "вареное яйцо"
	desc = "Сварено вкрутую."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "egg"
	inhand_icon_state = "egg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("яйцо" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	ant_attracting = FALSE
	decomp_type = /obj/item/food/boiledegg/rotten
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/eggsausage
	name = "яйцо с сосиской"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "eggsausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/nutriment = 4)
	foodtypes = MEAT | FRIED | BREAKFAST
	tastes = list("яйцо" = 4, "мясо" = 4)
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/boiledegg/rotten
	food_reagents = list(/datum/reagent/consumable/eggrot = 10)
	tastes = list("протухшее яйцо" = 1)
	foodtypes = GROSS
	preserved_food = TRUE

/obj/item/food/omelette //FUCK THIS // Че тгшникам омлет не нравится? Французов не любят?
	name = "омлет дю фромаж"
	desc = "Это все, что ты можешь сказать!"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "omelette"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 1
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("яйцо" = 1, "сыр" = 1)
	foodtypes = MEAT | BREAKFAST | DAIRY
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/omelette/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/kitchen/fork))
		var/obj/item/kitchen/fork/fork = item
		if(fork.forkload)
			to_chat(user, span_warning("У меня уже есть омлет на вилке!"))
		else
			fork.icon_state = "forkloaded"
			user.visible_message(span_notice("[user] отрывает кусочек омлета [user.ru_ego()] вилкой!") , \
				span_notice("Беру кусочек омлета вилкой."))

			var/datum/reagent/reagent = pick(reagents.reagent_list)
			reagents.remove_reagent(reagent.type, 1)
			fork.forkload = reagent
			if(reagents.total_volume <= 0)
				qdel(src)
		return
	..()

/obj/item/food/benedict
	name = "яйцо Бенедикт"
	desc = "Здесь всего одно яйцо, как грубо."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "benedict"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment = 3,
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("яйцо" = 1, "бекон" = 1, "булочка" = 1)
	foodtypes = MEAT | BREAKFAST | GRAIN
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/eggwrap
	name = "яичная обертка"
	desc = "Предшественник сосисок в тесте."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "eggwrap"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("яйцо" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/chawanmushi
	name = "тяван-муси"
	desc = "Легендарный яичный крем, который превращает врагов в друзей. Возможно, слишком горячий для кота."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "chawanmushi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("заварной крем" = 1)
	foodtypes = MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3
