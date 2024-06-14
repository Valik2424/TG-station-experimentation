#define PANCAKE_MAX_STACK 10

/obj/item/food/pancakes
	name = "блинчик"
	desc = "Пышный блинчик. Более мягкий, близкий родственник вафли."
	icon_state = "pancakes_1"
	inhand_icon_state = null
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("блинчики" = 1)
	foodtypes = GRAIN | SUGAR | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	///Used as a base name while generating the icon states when stacked
	var/stack_name = "pancakes"
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/pancakes/raw
	name = "сырой блинчик"
	desc = "Едва приготовленное месиво, которое некоторые могут принять за блин. Его стоит положить на сковородку."
	icon_state = "rawpancakes_1"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("milky batter" = 1)
	stack_name = "rawpancakes"
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/pancakes/raw/make_grillable()
	AddComponent(/datum/component/grillable,\
				cook_result = /obj/item/food/pancakes,\
				required_cook_time = rand(30 SECONDS, 40 SECONDS),\
				positive_result = TRUE,\
				use_large_steam_sprite = TRUE)

/obj/item/food/pancakes/raw/attackby(obj/item/garnish, mob/living/user, params)
	var/newresult
	if(istype(garnish, /obj/item/food/grown/berries))
		newresult = /obj/item/food/pancakes/blueberry
		name = "сырой блинчик с черникой"
		icon_state = "rawbbpancakes_1"
		stack_name = "rawbbpancakes"
	else if(istype(garnish, /obj/item/food/chocolatebar))
		newresult = /obj/item/food/pancakes/chocolatechip
		name = "сырой блинчик с шоколадной крошкой"
		icon_state = "rawccpancakes_1"
		stack_name = "rawccpancakes"
	else
		return ..()
	if(newresult)
		qdel(garnish)
		to_chat(user, span_notice("Добавляю [garnish] к [src]."))
		AddComponent(/datum/component/grillable, cook_result = newresult)

/obj/item/food/pancakes/raw/examine(mob/user)
	. = ..()
	if(name == initial(name))
		. += "<span class='notice'>\nВы можете изменить форму блинчика, добавив <b>чернику</b> или <b>шоколад</b> перед приготовлением на сковороде."

/obj/item/food/pancakes/blueberry
	name = "блинчик с черникой"
	desc = "Пышный и вкусный блинчик с черникой."
	icon_state = "bbpancakes_1"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("блинчики" = 1, "черника" = 1)
	stack_name = "bbpancakes"
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pancakes/chocolatechip
	name = "блинчик с шоколадной крошкой"
	desc = "Пышный и вкусный блинчик с шоколадной крошкой."
	icon_state = "ccpancakes_1"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("блинчики" = 1, "шоколад" = 1)
	stack_name = "ccpancakes"
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pancakes/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/food/pancakes/update_name()
	name = contents.len ? "стопка блинчиков" : initial(name)
	return ..()

/obj/item/food/pancakes/update_icon(updates = ALL)
	if(!(updates & UPDATE_OVERLAYS))
		return ..()

	updates &= ~UPDATE_OVERLAYS
	. = ..() // Don't update overlays. We're doing that here

	if(contents.len < LAZYLEN(overlays))
		overlays -= overlays[overlays.len]
	. |= UPDATE_OVERLAYS

/obj/item/food/pancakes/examine(mob/user)
	var/ingredients_listed = ""
	var/pancakeCount = contents.len
	switch(pancakeCount)
		if(0)
			desc = initial(desc)
		if(1 to 2)
			desc = "Стопка пышных блинчиков."
		if(3 to 6)
			desc = "Большая стопка пышных, вкусных блинчиков!"
		if(7 to 9)
			desc = "Грандиозная башня из пышных, вкусных блинов!"
		if(PANCAKE_MAX_STACK to INFINITY)
			desc = "Массивный возвышающийся шпиль из пышных, вкусных блинчиков. Похоже, он может перевернуться!"
	. = ..()
	if (pancakeCount)
		for(var/obj/item/food/pancakes/ING in contents)
			ingredients_listed += "[ING.name], "
		. += "It contains [contents.len?"[ingredients_listed]":"no ingredient, "]on top of a [initial(name)]."

/obj/item/food/pancakes/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/food/pancakes))
		var/obj/item/food/pancakes/pancake = item
		if((contents.len >= PANCAKE_MAX_STACK) || ((pancake.contents.len + contents.len) > PANCAKE_MAX_STACK))
			to_chat(user, span_warning("Не могу добавить больше блинов!"))
		else
			if(!user.transferItemToLoc(pancake, src))
				return
			to_chat(user, span_notice("Я добавил блинчик к стопке блинов."))
			pancake.name = initial(pancake.name)
			contents += pancake
			update_snack_overlays(pancake)
			if (pancake.contents.len)
				for(var/pancake_content in pancake.contents)
					pancake = pancake_content
					pancake.name = initial(pancake.name)
					contents += pancake
					update_snack_overlays(pancake)
			pancake = item
			pancake.contents.Cut()
		return
	else if(contents.len)
		var/obj/O = contents[contents.len]
		return O.attackby(item, user, params)
	..()

/obj/item/food/pancakes/proc/update_snack_overlays(obj/item/food/pancakes/pancake)
	var/mutable_appearance/pancake_visual = mutable_appearance(icon, "[pancake.stack_name]_[rand(1, 3)]")
	pancake_visual.pixel_x = rand(-1, 1)
	pancake_visual.pixel_y = 3 * contents.len - 1
	pancake_visual.layer = layer + (contents.len * 0.01)
	add_overlay(pancake_visual)
	update_appearance()

/obj/item/food/pancakes/attack(mob/target, mob/living/user, params, stacked = TRUE)
	if(user.combat_mode || !contents.len || !stacked)
		return ..()
	var/obj/item/item = contents[contents.len]
	. = item.attack(target, user, params, FALSE)
	update_appearance()

#undef PANCAKE_MAX_STACK
