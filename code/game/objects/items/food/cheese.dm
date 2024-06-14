/**
 * # Abstract cheese class
 *
 * Everything that is a subclass of this counts as cheese for regal rats.
 */
/obj/item/food/cheese
	name = "the concept of cheese"
	desc = "This probably shouldn't exist."
	tastes = list("сыр" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment/fat = 3)
	foodtypes = DAIRY
	crafting_complexity = FOOD_COMPLEXITY_1
	/// used to determine how much health rats/regal rats recover when they eat it.
	var/rat_heal = 0

/obj/item/food/cheese/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_RAT_INTERACT, PROC_REF(on_rat_eat))

/obj/item/food/cheese/proc/on_rat_eat(datum/source, mob/living/basic/regal_rat/king)
	SIGNAL_HANDLER

	king.cheese_heal(src, rat_heal, span_green("You eat [src], restoring some health."))
	return COMPONENT_RAT_INTERACTED

/obj/item/food/cheese/wedge
	name = "кусок сыра"
	desc = "Кусочек восхитительного Чеддера. Сырная головка, с которой он был срезан, не могла укатиться далеко."
	icon_state = "cheesewedge"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 10
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/cheese/wheel
	name = "головка сыра"
	desc = "Большая головка вкуснейшего чеддера."
	icon_state = "cheesewheel"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/fat = 10,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	) //Hard cheeses contain about 25% protein
	w_class = WEIGHT_CLASS_NORMAL
	rat_heal = 35
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/cheese/wheel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cheese/wheel/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheese/wedge, 5, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/cheese/wheel/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_cheese, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)

/**
 * Whiffs away cheese that was touched by the chaos entity byond the realm. In layman's terms, deletes the cheese and throws sparks.
 * Used in wizard grand rituals' optional cheesy alternative.
 */
/obj/item/food/cheese/wheel/proc/consume_cheese()
	visible_message(span_revenwarning("...and is consumed in a vortex of chaos!"))
	do_sparks(number = 1, cardinal_only = TRUE, source = get_turf(src))
	qdel(src)

/obj/item/food/cheese/royal
	name = "королевский сыр"
	desc = "Взойди на трон. Съешь этот сыр. Почувствуй ВЛАСТЬ."
	icon_state = "royalcheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/fat = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/gold = 20,
		/datum/reagent/toxin/mutagen = 5,
	)
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("сыр" = 4, "власть" = 1)
	rat_heal = 70
	crafting_complexity = FOOD_COMPLEXITY_3

//Curd cheese, a general term which I will now proceed to stretch as thin as the toppings on a supermarket sandwich:
//I'll use it as a substitute for ricotta, cottage cheese and quark, as well as any other non-aged, soft grainy cheese
/obj/item/food/cheese/curd_cheese
	name = "творожный сыр"
	desc = "Известный под многими названиями во всей человеческой кухне, творожный сыр полезен для приготовления самых разнообразных блюд."
	icon_state = "curd_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/cream = 1,
	)
	tastes = list("сливки" = 1, "сыр" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/cheese/curd_cheese/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/cheese/cheese_curds, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/cheese/curd_cheese/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/cheese/cheese_curds)

/obj/item/food/cheese/cheese_curds
	name = "сырники"
	desc = "Не путать с творожным сыром. Вкусней во фритюре."
	icon_state = "cheese_curds"
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/cheese/cheese_curds/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/cheese/firm_cheese)

/obj/item/food/cheese/firm_cheese
	name = "твердый сыр"
	desc = "Твердый выдержанный сыр, по текстуре схожий с твердым тофу. Практически не плавится."
	icon_state = "firm_cheese"
	tastes = list("выдержанный сыр" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cheese/firm_cheese/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheese/firm_cheese_slice, 3, 3 SECONDS, screentip_verb = "Slice")

/obj/item/food/cheese/firm_cheese_slice
	name = "кусок твёрдого сыра"
	desc = "Кусок твердого сыра. Идеально подходит для гриля или приготовления вкусного песто."
	icon_state = "firm_cheese_slice"
	tastes = list("выдержанный сыр" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 10
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cheese/firm_cheese_slice/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese, rand(25 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/food/cheese/mozzarella
	name = "моцарелла"
	desc = "Вкусный, сливочный и сырный, все в одной простой упаковке."
	icon_state = "mozzarella"
	tastes = list("моцарелла" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 10
	crafting_complexity = FOOD_COMPLEXITY_2