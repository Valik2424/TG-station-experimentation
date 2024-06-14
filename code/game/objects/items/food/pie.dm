/obj/item/food/pie
	icon = 'icons/obj/food/piecake.dmi'
	inhand_icon_state = "pie"
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 80
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_2
	/// type is spawned 5 at a time and replaces this pie when processed by cutting tool
	var/obj/item/food/pieslice/slice_type
	/// so that the yield can change if it isnt 5
	var/yield = 5

/obj/item/food/pie/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, yield, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/pieslice
	name = "кусок пирога"
	icon = 'icons/obj/food/piecake.dmi'
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("пирог" = 1, "uncertainty" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/pie/plain
	name = "пирог"
	desc = "Обычный вкусный пирог."
	icon_state = "pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/pie/cream
	name = "банановый пирог со сливками"
	desc = "По рецепту ХонкоМамы! ХОНК!"
	icon_state = "pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	var/stunning = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/cream/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/food/pie/cream/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/hit_turf = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(hit_turf)
	if(reagents?.total_volume)
		reagents.expose(hit_atom, TOUCH)
	var/is_creamable = TRUE
	if(isliving(hit_atom))
		var/mob/living/living_target_getting_hit = hit_atom
		if(stunning)
			living_target_getting_hit.Paralyze(2 SECONDS) //splat!
		if(iscarbon(living_target_getting_hit))
			is_creamable = !!(living_target_getting_hit.get_bodypart(BODY_ZONE_HEAD))
		if(is_creamable)
			living_target_getting_hit.adjust_eye_blur(2 SECONDS)
		living_target_getting_hit.visible_message(span_warning("[living_target_getting_hit] is creamed by [src]!"), span_userdanger("You've been creamed by [src]!"))
		playsound(living_target_getting_hit, SFX_DESECRATION, 50, TRUE)
	if(is_creamable && is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/food/pie/cream/nostun
	stunning = FALSE

/obj/item/food/pie/berryclafoutis
	name = "ягодный клафути"
	desc = "Почувствуй вкус древней Франции."
	icon_state = "berryclafoutis"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "ежевика" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/bearypie
	name = "медвежий пирог"
	desc = "Где повар смог найти медведя..."
	icon_state = "bearypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("пирог" = 1, "мясо" = 1, "лосось" = 1)
	foodtypes = GRAIN | SUGAR | MEAT | FRUIT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/pie/meatpie
	name = "мясной пирог"
	icon_state = "meatpie"
	desc = "Старый земной рецепт, очень вкусно!"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("пирог" = 1, "мясо" = 1)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_NORMAL
	slice_type = /obj/item/food/pieslice/meatpie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/meatpie
	name = "кусок мясного пирога"
	icon_state = "meatpie_slice"
	tastes = list("пирог" = 1, "мясо" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/tofupie
	name = "пирог с тофу"
	icon_state = "meatpie"
	desc = "Вкусный пирог с тофу."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("пирог" = 1, "тофу" = 1)
	foodtypes = GRAIN | VEGETABLES
	slice_type = /obj/item/food/pieslice/tofupie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/tofupie
	name = "кусок пирога с тофу"
	desc = "О да, мясной пирог- ПОДОЖДИ МИНУТКУ!!"
	icon_state = "meatpie_slice"
	tastes = list("пирог" = 1, "disappointment" = 1, "tofu" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/amanita_pie
	name = "пирог с мухоморами"
	desc = "Сладкий и вкусный ядовитый пирог."
	icon_state = "amanita_pie"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/toxin/amatoxin = 3,
		/datum/reagent/drug/mushroomhallucinogen = 1,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "грибы" = 1)
	foodtypes = GRAIN | VEGETABLES | TOXIC | GROSS
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/plump_pie
	name = "пирог с толстошлемником"
	desc = "Держу пари, тебе понравится вкус толстошлемника!"
	icon_state = "plump_pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "грибы" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/plump_pie/Initialize(mapload)
	var/fey = prob(10)
	if(fey)
		name = "исключительный пирог с толстошлемником"
		desc = "Микроволновку захватывает феерическое настроение! Ведь в ней приготовили пирог с толстошлемником!"
		food_reagents = list(
			/datum/reagent/consumable/nutriment = 11,
			/datum/reagent/medicine/omnizine = 5,
			/datum/reagent/consumable/nutriment/vitamin = 4,
		)
	. = ..()

/obj/item/food/pie/xemeatpie
	name = "ксено пирог"
	icon_state = "xenomeatpie"
	desc = "Вкуснейший мясной пирог. Почему-то пахнет кислотой."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("пирог" = 1, "мясо" = 1, "кислота" = 1)
	foodtypes = GRAIN | MEAT
	slice_type = /obj/item/food/pieslice/xemeatpie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/xemeatpie
	name = "кусок ксено-пирога"
	desc = "Боже... Оно ещё двигается..."
	icon_state = "xenopie_slice"
	tastes = list("пирог" = 1, "мясо" = 1, "кислота" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/applepie
	name = "яблочный пирог"
	desc = "Пирог, приготовленный с добавлением любви повара... ну... или яблок."
	icon_state = "applepie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("пирог" = 1, "яблоко" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	slice_type = /obj/item/food/pieslice/apple
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/apple
	name = "кусок яблочного пирога"
	desc = "Пирог с яблоками, приготовленный с добавлением любви повара... ну... или яблок."
	icon_state = "applepie_slice"
	tastes = list("пирог" = 1, "яблоко" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3


/obj/item/food/pie/cherrypie
	name = "вишневый пирог"
	desc = "Вкус настолько хорош, что заставит плакать даже твоего отца."
	icon_state = "cherrypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("пирог" = 7, "Nicole Paige Brooks" = 2)
	foodtypes = GRAIN | FRUIT | SUGAR
	slice_type = /obj/item/food/pieslice/cherry
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/cherry
	name = "кусок вишневого пирога"
	icon_state = "cherrypie_slice"
	tastes = list("пирог" = 1, "apples" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/pumpkinpie
	name = "тыквенный пирог"
	desc = "Вкусное осеннее угощение."
	icon_state = "pumpkinpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("пирог" = 1, "тыква" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	slice_type = /obj/item/food/pieslice/pumpkin
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/pumpkin
	name = "кусок тыквенного пирога"
	icon_state = "pumpkinpieslice"
	tastes = list("пирог" = 1, "тыква" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/appletart
	name = "тарт со стружкой из золотого яблока"
	desc = "Вкусный десерт. Не пытайся пройти с ним через металлоискатель."
	icon_state = "gappletart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/gold = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "яблоко" = 1, "дорогой металл" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/pie/grapetart
	name = "виноградный тарт"
	desc = "Вкусный десерт, который напомнит вам о вине, который вы могли сделать вместо этого."
	icon_state = "grapetart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "виноград" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/pie/mimetart
	name = "мимовый тарт"
	desc = "..."
	icon_state = "mimetart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nothing = 10,
	)
	tastes = list("nothing" = 3)
	foodtypes = GRAIN

/obj/item/food/pie/berrytart
	name = "ягодный тарт"
	desc = "Вкусный десерт из множества различных мелких ягод на тонком корже."
	icon_state = "berrytart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("пирог" = 1, "berries" = 2)
	foodtypes = GRAIN | FRUIT

/obj/item/food/pie/cocolavatart
	name = "шоколадный лавовый тарт"
	desc = "Вкусный десерт из шоколада с жидкой сердцевиной." //But it doesn't even contain chocolate...
	icon_state = "cocolavatart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "тёмный шоколад" = 3)
	foodtypes = GRAIN | SUGAR

/obj/item/food/pie/blumpkinpie
	name = "синетыквенный пирог"
	desc = "Странный синий пирог, приготовленный из синетыквенника."
	icon_state = "blumpkinpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 13,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("пирог" = 1, "глоток воды из бассейна" = 1)
	foodtypes = GRAIN | VEGETABLES
	slice_type = /obj/item/food/pieslice/blumpkin
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/blumpkin
	name = "кусок синетыквенного пирога"
	desc = "Кусочек синетыквенного пирога со взбитыми сливками сверху. Он точно съедобен?"
	icon_state = "blumpkinpieslice"
	tastes = list("пирог" = 1, "a mouthful of pool water" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/dulcedebatata
	name = "дульсе де батата"
	desc = "Вкусное желе, приготовленное из сладкого картофеля."
	icon_state = "dulcedebatata"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("желе" = 1, "сладкая картошка" = 1)
	foodtypes = VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_EXOTIC
	slice_type = /obj/item/food/pieslice/dulcedebatata
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/dulcedebatata
	name = "кусок дульсе да батата"
	desc = "Кусочек сладкого желе дульсе де батата."
	icon_state = "dulcedebatataslice"
	tastes = list("желе" = 1, "сладкая картошка" = 1)
	foodtypes = VEGETABLES | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/frostypie
	name = "ледяной пирог"
	desc = "Ты узнаешь каков синий цвет на вкус."
	icon_state = "frostypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("мята" = 1, "пирог" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	slice_type = /obj/item/food/pieslice/frostypie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/frostypie
	name = "кусок ледяного пирога"
	icon_state = "frostypie_slice"
	tastes = list("мята" = 1, "пирог" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/baklava
	name = "пахлава"
	desc = "Восхитительная закуска из ореховых слоев между тонкими хлебными прослойками."
	icon_state = "baklava"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("орехи" = 1, "пирог" = 1)
	foodtypes = NUTS | SUGAR
	slice_type = /obj/item/food/pieslice/baklava
	yield = 6
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/pieslice/baklava
	name = "порция пахлавы"
	desc = "Порция восхитительной закуски из ореховых слоев с тонким хлебом."
	icon_state = "baklavaslice"
	tastes = list("орехи" = 1, "пирог" = 1)
	foodtypes = NUTS | SUGAR

/obj/item/food/pie/frenchsilkpie
	name = "french silk pie"
	desc = "A decadent pie made of a creamy chocolate mousse filling topped with a layer of whipped cream and chocolate shavings. Sliceable."
	icon_state = "frenchsilkpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("пирог" = 1, "smooth chocolate" = 1, "whipped cream" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	slice_type = /obj/item/food/pieslice/frenchsilk
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/frenchsilk
	name = "french silk pie slice"
	desc = "A slice of french silk pie, filled with a chocolate mousse and topped with a layer of whipped cream and chocolate shavings. Delicious enough to make you cry."
	icon_state = "frenchsilkpieslice"
	tastes = list("пирог" = 1, "smooth chocolate" = 1, "whipped cream" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/shepherds_pie
	name = "shepherds pie"
	desc = "A dish of minced meat and mixed vegetables baked under a layer of creamy mashed potatoes. Sliceable."
	icon_state = "shepherds_pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 40,
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment/protein = 20,
	)
	tastes = list("juicy meat" = 2, "mashed potatoes" = 2, "baked veggies" = 2)
	foodtypes = MEAT | DAIRY | VEGETABLES
	slice_type = /obj/item/food/pieslice/shepherds_pie
	yield = 4
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/pieslice/shepherds_pie
	name = "shepherds pie slice"
	desc = "A messy slice of shepherds pie, made of minced meat and mixed vegetables baked under a layer of creamy mashed potatoes. Dangerously tasty."
	icon_state = "shepherds_pie_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
	)
	tastes = list("juicy meat" = 1, "mashed potatoes" = 1, "baked veggies" = 1)
	foodtypes = MEAT | DAIRY | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/pie/asdfpie
	name = "pie-flavored pie"
	desc = "I baked you a pie!"
	icon_state = "asdfpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 16,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("пирог" = 1, "the far off year of 2010" = 1)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2