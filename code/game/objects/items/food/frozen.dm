/obj/item/food/icecreamsandwich
	name = "мороженое-сэндвич"
	desc = "Причудливая комбинация завтрака с десертом."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "icecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/ice = 4,
	)
	tastes = list("мороженка" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/strawberryicecreamsandwich
	name = "клубничное мороженое-сэндвич"
	desc = "Продукт заигрывания завтрака с десертом."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "strawberryicecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/ice = 4,
	)
	tastes = list("мороженка" = 2, "ягоды" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD
	crafting_complexity = FOOD_COMPLEXITY_3


/obj/item/food/spacefreezy
	name = "космическая Замерзайка"
	desc = "Лучшее мороженое в космосе!"
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "spacefreezy"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("синяя вишня" = 2, "мороженка" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/spacefreezy/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder)

/obj/item/food/sundae
	name = "сандей"
	desc = "Классический десерт."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "sundae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("мороженка" = 1, "банан" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/sundae/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2, sweetener = /datum/reagent/consumable/caramel)

/obj/item/food/honkdae
	name = "хонкдей"
	desc = "Любимый десерт клоунов."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "honkdae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/banana = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("мороженка" = 1, "банан" = 1, "плохая шутка" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/honkdae/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2) //The sugar will react with the banana forming laughter. Honk!

/////////////
//SNOWCONES//
/////////////

/obj/item/food/snowcones //We use this as a base for all other snowcones
	name = "безвкусное гранисадо"
	desc = "Это просто тертый лед. Но все равно интересно погрызть."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "flavorless_sc"
	w_class = WEIGHT_CLASS_SMALL
	trash_type = /obj/item/reagent_containers/cup/glass/sillycup //We dont eat paper cups
	food_reagents = list(
		/datum/reagent/water = 11,
	) // We dont get food for water/juices
	tastes = list("лёд" = 1, "вода" = 1)
	foodtypes = SUGAR //We use SUGAR as a base line to act in as junkfood, other wise we use fruit
	food_flags = FOOD_FINGER_FOOD
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/snowcones/lime
	name = "лаймовое гранисадо"
	desc = "Лаймовый сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "lime_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "лаймы" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/lemon
	name = "лимонное гранисадо"
	desc = "Лимонный сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "lemon_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/lemonjuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "лимоны" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/apple
	name = "яблочное гранисадо"
	desc = "Яблочный сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "amber_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/applejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "яблоки" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/grape
	name = "виноградное гранисадо"
	desc = "Виноградный сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "grape_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/grapejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "виноград" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/orange
	name = "апельсиновое гранисадо"
	desc = "Апельсиновый сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "orange_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "апельсины" = 5)
	foodtypes = FRUIT | ORANGES

/obj/item/food/snowcones/blue
	name = "синевишневое гранисадо"
	desc = "Синевишневый сироп, политый на снежок в бумажном стаканчике, какая редкость!"
	icon_state = "blue_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "синева" = 5, "вишня" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/red
	name = "вишневое гранисадо"
	desc = "Вишневый сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "red_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "краснота" = 5, "вишня" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/berry
	name = "ягодное гранисадо"
	desc = "Ягодный сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "berry_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "ягоды" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/fruitsalad
	name = "мультифруктовое гранисадо"
	desc = "Восхитительная смесь цитрусовых сиропов, вылитая на снежок в бумажном стаканчике."
	icon_state = "fruitsalad_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/lemonjuice = 5,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "апельсины" = 5, "лаймы" = 5, "лимоны" = 5, "цитрусы" = 5, "salad" = 5)
	foodtypes = FRUIT | ORANGES

/obj/item/food/snowcones/pineapple
	name = "ананасовое гранисадо"
	desc = "Ананасовый сироп, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "pineapple_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/pineapplejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "ананасы" = 5)
	foodtypes = PINEAPPLE //Pineapple to allow all that like pineapple to enjoy

/obj/item/food/snowcones/mime
	name = "гранисадо мима"
	desc = "..."
	icon_state = "mime_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nothing = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "ничего" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/clown
	name = "клоунское гранисадо"
	desc = "Хохотач, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "clown_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/laughter = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "шутки" = 5, "заморозка мозгов" = 5, "радость" = 5)
	foodtypes = SUGAR | FRUIT

/obj/item/food/snowcones/soda
	name = "космокольное гранисадо"
	desc = "Космо-кола, брызнутая на ледяной снежок в бумажном стаканчике."
	icon_state = "soda_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/space_cola = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "кола" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/spacemountainwind
	name = "солнечно-ветрянное гранисадо"
	desc = "Солнечный ветер, теперь с заморозкой мозга!"
	icon_state = "mountainwind_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/spacemountainwind = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "mountain wind" = 5)
	foodtypes = SUGAR


/obj/item/food/snowcones/pwrgame
	name = "PWR Game гранисадо"
	desc = "Газировка PWRGame, брызнутая на ледяной снежок в бумажном стаканчике."
	icon_state = "pwrgame_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/pwr_game = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "валид" = 5, "соль" = 5, "ваты" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/honey
	name = "медовое гранисадо"
	desc = "Мёд, брызнутый на ледяной снежок в бумажном стаканчике."
	icon_state = "amber_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/honey = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "цветы" = 5, "сладость" = 5, "воск" = 1)
	foodtypes = SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/snowcones/rainbow
	name = "радужное гранисадо"
	desc = "Очень цветастый снежок в бумажном стаканчике."
	icon_state = "rainbow_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/laughter = 25,
		/datum/reagent/water = 11,
	)
	tastes = list("лёд" = 1, "вода" = 1, "солнечный свет" = 5, "свет" = 5, "слаймы" = 5, "краска" = 3, "облака" = 3)
	foodtypes = SUGAR

/obj/item/food/popsicle
	name = "фруктовый лед из жуков"
	desc = "Мммм, это не должно существовать."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick_s"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	tastes = list("сок жука")
	trash_type = /obj/item/popsicle_stick
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD
	crafting_complexity = FOOD_COMPLEXITY_3

	var/overlay_state = "creamsicle_o" //This is the edible part of the popsicle.
	var/bite_states = 4 //This value value is used for correctly setting the bite_consumption to ensure every bite changes the sprite. Do not set to zero.
	var/bitecount = 0


/obj/item/food/popsicle/Initialize(mapload)
	. = ..()
	bite_consumption = reagents.total_volume / bite_states
	update_icon() // make sure the popsicle overlay is primed so it's not just a stick until you start eating it

/obj/item/food/popsicle/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, after_eat = CALLBACK(src, PROC_REF(after_bite)))

/obj/item/food/popsicle/update_overlays()
	. = ..()
	if(!bitecount)
		. += initial(overlay_state)
		return
	. += "[initial(overlay_state)]_[min(bitecount, 3)]"

/obj/item/food/popsicle/proc/after_bite(mob/living/eater, mob/living/feeder, bitecount)
	src.bitecount = bitecount
	update_appearance()

/obj/item/popsicle_stick
	name = "палочка для мороженного"
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick"
	desc = "На этой скромной маленькой палочке обычно лежит замороженное угощение."
	custom_materials = list(/datum/material/wood = SMALL_MATERIAL_AMOUNT * 0.20)
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	force = 0

/obj/item/food/popsicle/creamsicle_orange
	name = "апельсиновцы фруктовый лед"
	desc = "Классическая апельсиновая сладость."
	food_reagents = list(
		/datum/reagent/consumable/orangejuice = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	foodtypes = FRUIT | DAIRY | SUGAR | ORANGES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/popsicle/creamsicle_berry
	name = "ягодный фруктовый лед"
	desc = "Ягодное вкусное замороженное лакомство."
	food_reagents = list(
		/datum/reagent/consumable/berryjuice = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	overlay_state = "creamsicle_m"
	foodtypes = FRUIT | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/popsicle/jumbo
	name = "мороженое Джамбо"
	desc = "Роскошное мороженое, покрытое насыщенным шоколадом. Оно кажется меньше, чем вы его помните."
	food_reagents = list(
		/datum/reagent/consumable/hot_coco = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 3,
		/datum/reagent/consumable/sugar = 2,
	)
	overlay_state = "jumbo"
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/popsicle/licorice_creamsicle
	name = "Void Bar™"
	desc = "Солёное лакричное мороженое. Солёное замороженное лакомство."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 1,
		/datum/reagent/consumable/sugar = 4,
	)
	tastes = list("солёная лакрица")
	overlay_state = "licorice_creamsicle"
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/cornuto
	name = "рожок"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "cornuto"
	desc = "Неаполитанский рожок с ванилью и шоколадным мороженым. Посыпается орехами в карамели."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/hot_coco = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 4,
		/datum/reagent/consumable/sugar = 2,
	)
	tastes = list("нарезанный фундук", "вафли")
	foodtypes = DAIRY | SUGAR
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3
