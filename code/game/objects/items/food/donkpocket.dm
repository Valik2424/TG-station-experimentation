////////////////////////////////////////////DONK POCKETS////////////////////////////////////////////

/obj/item/food/donkpocket
	name = "донк-покет"
	desc = "Пища для опытного предателя."
	icon_state = "donkpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "лень" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

	/// What type of donk pocket we're warmed into via baking or microwaving.
	var/warm_type = /obj/item/food/donkpocket/warm
	/// The lower end for how long it takes to bake
	var/baking_time_short = 25 SECONDS
	/// The upper end for how long it takes to bake
	var/baking_time_long = 30 SECONDS
	/// The reagents added when microwaved. Needed since microwaving ignores food_reagents
	var/static/list/added_reagents = list(/datum/reagent/medicine/omnizine = 6)
	/// The reagents that most child types add when microwaved. Needed because you can't override static lists.
	var/static/list/child_added_reagents = list(/datum/reagent/medicine/omnizine = 2)

/obj/item/food/donkpocket/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, added_reagents)

/obj/item/food/donkpocket/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, added_reagents)

/obj/item/food/donkpocket/warm
	name = "теплый Донк-покет"
	desc = "Разогретая пища для опытного предателя."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 6,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "лень" = 1)
	foodtypes = GRAIN

	// Warmed donk pockets will burn if you leave them in the oven or microwave.
	warm_type = /obj/item/food/badrecipe
	baking_time_short = 10 SECONDS
	baking_time_long = 15 SECONDS

/obj/item/food/dankpocket
	name = "данк-покет"
	desc = "Пища для опытного ботаника."
	icon_state = "dankpocket"
	food_reagents = list(
		/datum/reagent/toxin/lipolicide = 3,
		/datum/reagent/drug/space_drugs = 3,
		/datum/reagent/consumable/nutriment = 4,
	)
	tastes = list("мясо" = 2, "тесто" = 2)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/donkpocket/spicy
	name = "острый-покет"
	desc = "Классическая закуска, теперь с острым вкусом."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "пряности" = 1)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/spicy

/obj/item/food/donkpocket/spicy/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/spicy/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/spicy
	name = "теплый острый-покет"
	desc = "Классическая закуска, теперь, возможно, слишком острая."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/capsaicin = 5,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "странные специи" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/teriyaki
	name = "терияки-покет"
	desc = "Восточно-азиатский вариант классической привокзальной закуски."
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "соевый соус" = 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/teriyaki

/obj/item/food/donkpocket/teriyaki/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/teriyaki/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/teriyaki
	name = "теплый терияки-покет"
	desc = "Восточно-азиатский вариант классической привокзальной закуски, теперь мягкий и теплый"
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "соевый соус" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/pizza
	name = "пицца-покет"
	desc = "Вкусный, сырный и удивительно сытный."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "сыр"= 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/pizza

/obj/item/food/donkpocket/pizza/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/pizza/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/pizza
	name = "теплый пицца-покет"
	desc = "Вкусный, сырный, а теперь еще вкуснее."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "плавленый сыр"= 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/honk
	name = "хонк-покет"
	desc = "Отмеченный наградами донк-покет, который завоевал сердца как клоунов, так и людей."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/banana = 4,
	)
	tastes = list("банан" = 2, "тесто" = 2, "детские антибиотики" = 1)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/honk
	crafting_complexity = FOOD_COMPLEXITY_3
	var/static/list/honk_added_reagents = list(
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/laughter = 6,
	)

/obj/item/food/donkpocket/honk/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, honk_added_reagents)

/obj/item/food/donkpocket/honk/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, honk_added_reagents)

/obj/item/food/donkpocket/warm/honk
	name = "теплый хонк-покет"
	desc = "Отмеченный наградами донк-покет, теперь теплый и вкусный."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/banana = 4,
		/datum/reagent/consumable/laughter = 6,
	)
	tastes = list("тесто" = 2, "детские антибиотики" = 1)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donkpocket/berry
	name = "ягод-покет"
	desc = "Безжалостно сладкий донк-покет, впервые созданный для использования в операции \"Буря в пустыне\"."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("тесто" = 2, "джем" = 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/berry

/obj/item/food/donkpocket/berry/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/berry/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/berry
	name = "теплый ягод-покет"
	desc = "Безжалостно сладкий донк-покет, теперь теплый и вкусный."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("тесто" = 2, "тёплый джем" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/gondola
	name = "гондола-покет"
	desc = "Выбор в пользу использования в рецепте настоящего мяса гондолы, мягко говоря, спорный." //Only a monster would craft this.
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/gondola_mutation_toxin = 5,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "внутренний мир" = 1)
	foodtypes = GRAIN

	warm_type = /obj/item/food/donkpocket/warm/gondola
	var/static/list/gondola_added_reagents = list(
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/gondola_mutation_toxin = 5,
	)

/obj/item/food/donkpocket/gondola/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, gondola_added_reagents)

/obj/item/food/donkpocket/gondola/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, gondola_added_reagents)

/obj/item/food/donkpocket/warm/gondola
	name = "теплый Гондола-pocket"
	desc = "Выбор в пользу использования в рецепте настоящего мяса гондолы, мягко говоря, спорный"
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/gondola_mutation_toxin = 10,
	)
	tastes = list("мясо" = 2, "тесто" = 2, "внутренний мир" = 1)
	foodtypes = GRAIN
