
/// Abstract parent object for bread items. Should not be made obtainable in game.
/obj/item/food/bread
	name = "хлеб?"
	desc = "Не ешь меня."
	icon = 'icons/obj/food/burgerbread.dmi'
	max_volume = 80
	tastes = list("хлеб" = 10)
	foodtypes = GRAIN
	eat_time = 3 SECONDS
	crafting_complexity = FOOD_COMPLEXITY_2
	/// type is spawned 5 at a time and replaces this bread loaf when processed by cutting tool
	var/obj/item/food/breadslice/slice_type
	/// so that the yield can change if it isnt 5
	var/yield = 5

/obj/item/food/bread/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)
	AddComponent(/datum/component/food_storage)

/obj/item/food/bread/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, yield, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")
		AddElement(/datum/element/processable, TOOL_SAW, slice_type, yield, 4 SECONDS, table_required = TRUE, screentip_verb = "Slice")

// Abstract parent object for sliced bread items. Should not be made obtainable in game.
/obj/item/food/breadslice
	name = "ломтик хлеба?"
	desc = "не ешь меня."
	icon = 'icons/obj/food/burgerbread.dmi'
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	eat_time = 0.5 SECONDS
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/breadslice/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/bread/plain
	name = "хлеб"
	desc = "Обычный хлеб по старому земному рецепту."
	icon_state = "bread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("хлеб" = 10)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/breadslice/plain
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/bread/plain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/bread/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

/obj/item/food/breadslice/plain
	name = "ломтик хлеба"
	desc = "Напоминание о доме."
	icon_state = "breadslice"
	foodtypes = GRAIN
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	venue_value = FOOD_PRICE_TRASH
	decomp_type = /obj/item/food/breadslice/moldy
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/breadslice/plain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_STACK)

/obj/item/food/breadslice/plain/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/griddle_toast, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/breadslice/moldy
	name = "заплесневелый хлеб"
	desc = "Плесень отвратительна на вкус, но очень вкусна, если у вас девиантные вкусы!"
	icon_state = "moldybreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/mold = 10,
	)
	tastes = list("гниющая плесень" = 1)
	foodtypes = GROSS
	preserved_food = TRUE
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/breadslice/moldy/bacteria
	name = "заплесневелый хлеб с бактериями"
	desc = "Кажется, что он двигается, когда никто не смотрит. Надо позвать священника! Или принести огнемёт!"
/obj/item/food/breadslice/moldy/bacteria/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2, 4), 25)

/obj/item/food/bread/meat
	name = "мясной рулет"
	desc = "Основное блюда для уважающего себя гурмана."
	icon_state = "meatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("хлеб" = 10, "мясо" = 10)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/breadslice/meat
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/meat
	name = "ломтик мясного рулета"
	desc = "Ломтик вкуснейшего мясного хлеба."
	icon_state = "meatbreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2.4,
	)
	tastes = list("хлеб" = 1, "мясо" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/sausage
	name = "булка хлеба с сосиской"
	desc = "Не думай об этом слишком много."
	icon_state = "sausagebread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("хлеб" = 10, "мясо" = 10)
	foodtypes = GRAIN | MEAT
	slice_type = /obj/item/food/breadslice/sausage
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/sausage
	name = "ломтик сосисочного хлеба"
	desc = "Ломтик вкуснейшего сосисочного хлеба."
	icon_state = "sausagebreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2.4,
	)
	tastes = list("хлеб" = 10, "мясо" = 10)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/xenomeat
	name = "хлеб с мясом чужого"
	desc = "Основное блюда для уважающего себя гурмана. Сверхъеретический."
	icon_state = "xenomeatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 15,
	)
	tastes = list("хлеб" = 10, "кислота" = 10)
	foodtypes = GRAIN | MEAT
	slice_type = /obj/item/food/breadslice/xenomeat
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/xenomeat
	name = "ломтик хлеба с мясом чужого"
	desc = "Ломтик вкуснейшего мясного хлеба. Сверхъеретический."
	icon_state = "xenobreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("хлеб" = 10, "кислота" = 10)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/spidermeat
	name = "хлеб с паучьим мясом"
	desc = "Обнадёживающе зеленый мясной рулет из мяса паука."
	icon_state = "spidermeatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/toxin = 15,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("хлеб" = 10, "паутинки" = 5)
	foodtypes = GRAIN | MEAT | TOXIC
	slice_type = /obj/item/food/breadslice/spidermeat
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/spidermeat
	name = "ломтик хлеба с паучиьм мясом"
	desc = "Ломтик мясного рулета с мясом паука. Похоже, этот паук, ещё жаждет твоей смерти."
	icon_state = "spidermeatslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/toxin = 3,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("хлеб" = 10, "паутинки" = 5)
	foodtypes = GRAIN | MEAT | TOXIC
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/banana
	name = "банановый хлеб"
	desc = "Божественно сытное угощение."
	icon_state = "bananabread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/banana = 20,
	)
	tastes = list("хлеб" = 10) // bananjuice will also flavour
	foodtypes = GRAIN | FRUIT
	slice_type = /obj/item/food/breadslice/banana
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/banana
	name = "ломтик бананового хлеба"
	desc = "Ломтик вкуснейшего бананового хлеба."
	icon_state = "bananabreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/banana = 4,
	)
	tastes = list("хлеб" = 10)
	foodtypes = GRAIN | FRUIT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/tofu
	name = "хлеб с тофу"
	desc = "Как мясной рулет, но для вегетарианцев. Не гарантированно дает сверхспособности."
	icon_state = "tofubread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 10,
	)
	tastes = list("хлеб" = 10, "тофу" = 10)
	foodtypes = GRAIN | VEGETABLES
	venue_value = FOOD_PRICE_TRASH
	slice_type = /obj/item/food/breadslice/tofu
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/tofu
	name = "ломтик хлеба тофу"
	desc = "Ломтик вкуснейшего хлеба тофу."
	icon_state = "tofubreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("хлеб" = 10, "тофу" = 10)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/creamcheese
	name = "хлеб со сливочным сыром"
	desc = "Вкуснятина!"
	icon_state = "creamcheesebread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("хлеб" = 10, "сыр" = 10)
	foodtypes = GRAIN | DAIRY
	slice_type = /obj/item/food/breadslice/creamcheese

/obj/item/food/breadslice/creamcheese
	name = "ломтик хлеба со сливочным сыром"
	desc = "Кусочек вкусняшки."
	icon_state = "creamcheesebreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("хлеб" = 10, "сыр" = 10)
	foodtypes = GRAIN | DAIRY

/obj/item/food/bread/mimana
	name = "мимановский хлеб"
	desc = "Лучше всего есть в тишине."
	icon_state = "mimanabread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/toxin/mutetoxin = 5,
		/datum/reagent/consumable/nothing = 5,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("хлеб" = 10, "тишина" = 10)
	foodtypes = GRAIN | FRUIT
	slice_type = /obj/item/food/breadslice/mimana
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/breadslice/mimana
	name = "ломтик мимановского хлеба"
	desc = "Тихо!"
	icon_state = "mimanabreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/toxin/mutetoxin = 1,
		/datum/reagent/consumable/nothing = 1,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("хлеб" = 10, "тишина" = 10)
	foodtypes = GRAIN | FRUIT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bread/empty
	name = "хлеб"
	icon_state = "tofubread"
	desc = "Хлеб, приготовленный в соответствии с вашими самыми смелыми мечтами."
	slice_type = /obj/item/food/breadslice/empty

// What you get from cutting a custom bread. Different from custom sliced bread.
/obj/item/food/breadslice/empty
	name = "ломтик хлеба"
	icon_state = "tofubreadslice"
	foodtypes = GRAIN
	desc = "Ломтик хлеба, приготовленного в соответствии с вашими самыми смелыми мечтами."

/obj/item/food/breadslice/empty/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

/obj/item/food/baguette
	name = "багет"
	desc = "Бон аппети!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "baguette"
	inhand_icon_state = null
	worn_icon_state = "baguette"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	attack_verb_continuous = list("трогает")
	attack_verb_simple = list("трогает")
	tastes = list("хлеб" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2
	/// whether this is in fake swordplay mode or not
	var/fake_swordplay = FALSE

/obj/item/food/baguette/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/food/baguette/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(HAS_MIND_TRAIT(user, TRAIT_MIMING) && held_item == src)
		context[SCREENTIP_CONTEXT_LMB] = "Toggle Swordplay"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/food/baguette/examine(mob/user)
	. = ..()
	if(HAS_MIND_TRAIT(user, TRAIT_MIMING))
		. += span_notice("You can wield this like a sword by using it in your hand.")

/obj/item/food/baguette/attack_self(mob/user, modifiers)
	. = ..()
	if(!HAS_MIND_TRAIT(user, TRAIT_MIMING))
		return
	if(fake_swordplay)
		end_swordplay(user)
	else
		begin_swordplay(user)

/obj/item/food/baguette/proc/begin_swordplay(mob/user)
	visible_message(
		span_notice("[user] begins wielding [src] like a sword!"),
		span_notice("You begin wielding [src] like a sword, with a firm grip on the bottom as an imaginary handle.")
	)
	ADD_TRAIT(src, TRAIT_CUSTOM_TAP_SOUND, SWORDPLAY_TRAIT)
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	fake_swordplay = TRUE

	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_sword_equipped))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_sword_dropped))

/obj/item/food/baguette/proc/end_swordplay(mob/user)
	UnregisterSignal(src, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	REMOVE_TRAIT(src, TRAIT_CUSTOM_TAP_SOUND, SWORDPLAY_TRAIT)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	hitsound = initial(hitsound)
	fake_swordplay = FALSE

	if(user)
		visible_message(
			span_notice("[user] no longer holds [src] like a sword!"),
			span_notice("You go back to holding [src] normally.")
		)

/obj/item/food/baguette/proc/on_sword_dropped(datum/source, mob/user)
	SIGNAL_HANDLER

	end_swordplay()

/obj/item/food/baguette/proc/on_sword_equipped(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_HANDS))
		end_swordplay()

/// Deadly bread used by a mime
/obj/item/food/baguette/combat
	block_sound = 'sound/weapons/parry.ogg'
	sharpness = SHARP_EDGED
	/// Force when wielded as a sword by a mime
	var/active_force = 20
	/// Block chance when wielded as a sword by a mime
	var/active_block = 50

/obj/item/food/baguette/combat/begin_swordplay(mob/user)
	. = ..()
	force = active_force
	block_chance = active_block

/obj/item/food/baguette/combat/end_swordplay(mob/user)
	. = ..()
	force = initial(force)
	block_chance = initial(block_chance)

/obj/item/food/garlicbread
	name = "чесночный хлеб"
	desc = "Увы, рано или поздно он заканчивается."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "garlicbread"
	inhand_icon_state = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/garlic = 2,
	)
	bite_consumption = 3
	tastes = list("хлеб" = 1, "чеснок" = 1, "масло" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/butterbiscuit
	name = "бисквит с маслом"
	desc = "Намажь мне бисквит маслом!"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterbiscuit"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("масло" = 1, "бисквит" = 1)
	foodtypes = GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/butterdog
	name = "масло-дог"
	desc = "Изготовлено с использованием экзотических масел."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterdog"
	bite_consumption = 1
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("масло" = 1, "экзотическое масло" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/butterdog/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 8 SECONDS)

/obj/item/food/raw_frenchtoast
	name = "неприготовленный французский тост"
	desc = "Ломтик хлеба, замоченный в яичной смеси. Положите его на сковороду, чтобы начать готовить!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_frenchtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("сырые яйца" = 2, "вымоченный хлеб" = 1)
	foodtypes = GRAIN | RAW | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_frenchtoast/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/frenchtoast, rand(20 SECONDS, 30 SECONDS), TRUE)

/obj/item/food/frenchtoast
	name = "французский тост"
	desc = "Ломтик хлеба, замоченный в яичной смеси и обжаренный до золотистого цвета. Положите его на сковороду, чтобы начать готовить!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "frenchtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("французский тост" = 1, "сироп" = 1)
	foodtypes = GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_breadstick
	name = "неприготовленная гриссини"
	desc = "Полоска сырого теста в форме хлебной палочки."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_breadstick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("сырое тесто" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/raw_breadstick/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/breadstick, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/breadstick
	name = "гриссини"
	desc = "Вкусные хлебные палочки с маслом. Быстро привыкаешь, но оно того стоит!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "breadstick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("хлеб" = 1, "масло" = 2)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_croissant
	name = "неприготовленный круассан"
	desc = "Складывается из теста, готово к запеканию."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_croissant"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("сырое тесто" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/raw_croissant/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/croissant, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/croissant
	name = "круассан"
	desc = "Вкусный, маслянистый круассан. Идеальное начало дня."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "croissant"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("пышный хлеб" = 1, "масло" = 2)
	foodtypes = GRAIN | DAIRY | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

// Enhanced weaponised bread
/obj/item/food/croissant/throwing
	throwforce = 20
	tastes = list("пышный хлеб" = 1, "масло" = 2, "железо" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/iron = 1)

/obj/item/food/croissant/throwing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/boomerang, throw_range, TRUE)
