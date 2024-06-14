//Not only meat, actually, but also snacks that are almost meat, such as fish meat or tofu


////////////////////////////////////////////FISH////////////////////////////////////////////

/obj/item/food/cubancarp
	name = "кубинский карп"
	desc = "Вкусный сэндвич, который обжигает язык!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "cubancarp"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("рыба" = 4, "кляр" = 1, "перцы" = 1)
	foodtypes = SEAFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/fishmeat
	name = "рыбное филе"
	desc = "Филе из мяса рыбы."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfillet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	bite_consumption = 6
	tastes = list("рыба" = 1)
	foodtypes = SEAFOOD
	eatverbs = list("кусает", "жует", "грызет", "глотает", "пожирает")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat/carp
	name = "филе карпа"
	desc = "Филе космчисекого карпа."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/carpotoxin = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	/// Cytology category you can swab the meat for.
	var/cell_line = CELL_LINE_TABLE_CARP

/obj/item/food/fishmeat/carp/Initialize(mapload)
	. = ..()
	if(cell_line)
		AddElement(/datum/element/swabable, cell_line, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/fishmeat/carp/imitation
	name = "имитация филе карпа"
	desc = "Почти как настоящее, вроде как."
	cell_line = null
	starting_reagent_purity = 0.3

/obj/item/food/fishmeat/moonfish
	name = "филе рыбы-луны"
	desc = "Филе рыбы-луны."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_fillet"

/obj/item/food/fishmeat/moonfish/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_moonfish, rand(40 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/fishmeat/gunner_jellyfish
	name = "филе медузы"
	desc = "Филе медузы с удаленными щупальцами. Вызывает галлюцинации."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "jellyfish_fillet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/mindbreaker = 2,
	)

/obj/item/food/fishmeat/armorfish
	name = "филе панцирника"
	desc = "Панцирник с удаленными внутренностями и панцирем, готов к приготовлению."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "armorfish_fillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)

///donkfish fillets. The yuck reagent is now added by the fish trait of the same name.
/obj/item/food/fishmeat/donkfish
	name = "филе донк-рыбы"
	desc = "Ужасное филе донк-рыбы. Ни один здравомыслящий космонавт не станет есть это, и оно не становится лучше после приготовления."
	icon_state = "donkfillet"

/obj/item/food/fishmeat/octopus
	name = "осьминожье филе"
	desc = "Филе осьминога."
	icon = 'icons/obj/food/martian.dmi'
	icon_state = "octopus_fillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)

/obj/item/food/fishmeat/octopus/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_octopus, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/fishfingers
	name = "рыбные палочки"
	desc = "Филе рыбы в панировке."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfingers"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	bite_consumption = 1
	tastes = list("рыба" = 1, "breadcrumbs" = 1)
	foodtypes = SEAFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/fishandchips
	name = "рыба и картофель фри"
	desc = "Любимая еда британцев."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishandchips"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("рыба" = 1, "chips" = 1)
	foodtypes = SEAFOOD | VEGETABLES | FRIED
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/fishfry
	name = "жаркое из рыбы"
	desc = "И все это без картошки фри......"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfry"
	food_reagents = list (
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("рыба" = 1, "pan seared vegtables" = 1)
	foodtypes = SEAFOOD | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/vegetariansushiroll
	name = "vegetarian sushi roll"
	desc = "A roll of simple vegetarian sushi with rice, carrots, and potatoes. Sliceable into pieces!"
	icon_state = "vegetariansushiroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("boiled rice" = 4, "carrots" = 2, "potato" = 2)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/vegetariansushiroll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/vegetariansushislice, 4, screentip_verb = "Chop")

/obj/item/food/vegetariansushislice
	name = "vegetarian sushi slice"
	desc = "A slice of simple vegetarian sushi with rice, carrots, and potatoes."
	icon_state = "vegetariansushislice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("boiled rice" = 4, "carrots" = 2, "potato" = 2)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/spicyfiletsushiroll
	name = "spicy filet sushi roll"
	desc = "A roll of tasty, spicy sushi made with fish and vegetables. Sliceable into pieces!"
	icon_state = "spicyfiletroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/capsaicin = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("boiled rice" = 4, "рыба" = 2, "spicyness" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/spicyfiletsushiroll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/spicyfiletsushislice, 4, screentip_verb = "Chop")

/obj/item/food/spicyfiletsushislice
	name = "spicy filet sushi slice"
	desc = "A slice of tasty, spicy sushi made with fish and vegetables. Don't eat it too fast!"
	icon_state = "spicyfiletslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("boiled rice" = 4, "рыба" = 2, "spicyness" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

// empty sushi for custom sushi
/obj/item/food/sushi/empty
	name = "sushi"
	foodtypes = NONE
	tastes = list()
	icon_state = "vegetariansushiroll"
	desc = "A roll of customized sushi."
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sushi/empty/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sushislice/empty, 4, screentip_verb = "Chop")

/obj/item/food/sushislice/empty
	name = "sushi slice"
	foodtypes = NONE
	tastes = list()
	icon_state = "vegetariansushislice"
	desc = "A slice of customized sushi."
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/nigiri_sushi
	name = "nigiri sushi"
	desc = "A simple nigiri of fish atop a packed rice ball with a seaweed wrapping and a side of soy sauce."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "nigiri_sushi"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("boiled rice" = 4, "fish filet" = 2, "soy sauce" = 2)
	foodtypes = SEAFOOD | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/meat_poke
	name = "meat poke"
	desc = "Simple poke, rice on the bottom, vegetables and meat on top. Should be mixed before eating."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "pokemeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	foodtypes = SEAFOOD | MEAT | VEGETABLES
	tastes = list("rice and meat" = 4, "lettuce" = 2, "soy sauce" = 2)
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/fish_poke
	name = "fish poke"
	desc = "Simple poke, rice on the bottom, vegetables and fish on top. Should be mixed before eating."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "pokefish"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	foodtypes = SEAFOOD | VEGETABLES
	tastes = list("rice and fish" = 4, "lettuce" = 2, "soy sauce" = 2)
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4

////////////////////////////////////////////MEATS AND ALIKE////////////////////////////////////////////

/obj/item/food/tempeh
	name = "raw tempeh block"
	desc = "Fungus fermented soybean cake, warm to the touch."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempeh"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8)
	tastes = list("earthy" = 3, "nutty" = 2, "bland" = 1 )
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

// sliceable into 4xtempehslices
/obj/item/food/tempeh/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/tempehslice, 4, 5 SECONDS, table_required = TRUE, screentip_verb = "Slice")

//add an icon for slices
/obj/item/food/tempehslice
	name = "tempeh slice"
	desc = "A slice of tempeh, a slice of wkwkwk."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempehslice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("earthy" = 3, "nutty" = 2, "bland" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

//add an icon for blends
/obj/item/food/tempehstarter
	name = "tempeh starter"
	desc = "A mix of soy and joy. It's warm... and moving?"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempehstarter"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("nutty" = 2, "bland" = 2)
	foodtypes = VEGETABLES | GROSS
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/tofu
	name = "тофу"
	desc = "Все мы любим тофу."
	icon_state = "tofu"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("тофу" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/tofu/prison
	name = "размокший тофу"
	desc = "Ты не захочешь есть этот странный бобовый творог."
	tastes = list("кислая, гнилая вода" = 1)
	foodtypes = GROSS

/obj/item/food/spiderleg
	name = "паучья лапка"
	desc = "Все еще дергающаяся нога гигантского паука... Вы же не хотите это съесть, правда?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spiderleg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/toxin = 2,
	)
	tastes = list("паутинки" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spiderleg/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/boiledspiderleg, rand(50 SECONDS, 60 SECONDS), TRUE, TRUE)

/obj/item/food/cornedbeef
	name = "солонина с капустой"
	desc = "Теперь вы можете почувствовать себя настоящим туристом, отдыхающим в Ирландии."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "cornedbeef"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("мясо" = 1, "капуста" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/bearsteak
	name = "филе Мигравр"
	desc = "Потому что просто есть медвежатину было недостаточно мужественно."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "bearsteak"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 9,
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
	)
	tastes = list("мясо" = 1, "лосось" = 1)
	foodtypes = MEAT | ALCOHOL
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_meatball
	name = "сырая фрикаделька"
	desc = "Отличная еда со всех сторон - это вам не бревно погрызть. Пока сыровато."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/meatball_type = /obj/item/food/meatball
	var/patty_type = /obj/item/food/raw_patty

/obj/item/food/raw_meatball/make_grillable()
	AddComponent(/datum/component/grillable, meatball_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_meatball/make_processable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, patty_type, 1, table_required = TRUE, screentip_verb = "Flatten")

/obj/item/food/raw_meatball/human
	name = "странная сырая фрикаделька"
	meatball_type = /obj/item/food/meatball/human
	patty_type = /obj/item/food/raw_patty/human

/obj/item/food/raw_meatball/corgi
	name = "сырая фрикаделька из мяса корги"
	meatball_type = /obj/item/food/meatball/corgi
	patty_type = /obj/item/food/raw_patty/corgi

/obj/item/food/raw_meatball/xeno
	name = "сырая фрикаделька из мяса ксеноморфа"
	meatball_type = /obj/item/food/meatball/xeno
	patty_type = /obj/item/food/raw_patty/xeno

/obj/item/food/raw_meatball/bear
	name = "сырая фрикаделька из медвежатины"
	meatball_type = /obj/item/food/meatball/bear
	patty_type = /obj/item/food/raw_patty/bear

/obj/item/food/raw_meatball/chicken
	name = "сырая куриная фрикаделька"
	meatball_type = /obj/item/food/meatball/chicken
	patty_type = /obj/item/food/raw_patty/chicken

/obj/item/food/meatball
	name = "фрикаделька"
	desc = "Отличная еда со всех сторон - это вам не бревно погрызть."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatball"
	inhand_icon_state = "meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/meatball/human
	name = "странная фрикаделька"

/obj/item/food/meatball/corgi
	name = "фрикаделька из корги"

/obj/item/food/meatball/bear
	name = "фрикаделька из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meatball/xeno
	name = "фрикаделька из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meatball/chicken
	name = "куриная фрикаделька"
	tastes = list("курица" = 1)
	icon_state = "chicken_meatball"

/obj/item/food/raw_patty
	name = "сырая котлета"
	desc = "Я ещё.....НЕ ГОТОООВА."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/patty_type = /obj/item/food/patty/plain

/obj/item/food/raw_patty/make_grillable()
	AddComponent(/datum/component/grillable, patty_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_patty/human
	name = "странная сырая котлета"
	patty_type = /obj/item/food/patty/human

/obj/item/food/raw_patty/corgi
	name = "сырая котлета из мяса корги"
	patty_type = /obj/item/food/patty/corgi

/obj/item/food/raw_patty/bear
	name = "сырая котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)
	patty_type = /obj/item/food/patty/bear

/obj/item/food/raw_patty/xeno
	name = "сырая котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)
	patty_type = /obj/item/food/patty/xeno

/obj/item/food/raw_patty/chicken
	name = "сырая куриная котлета"
	tastes = list("курица" = 1)
	patty_type = /obj/item/food/patty/chicken

/obj/item/food/patty
	name = "котлета"
	desc = "Нанотрейзеновская котлета - для тебя и меня!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

///Exists purely for the crafting recipe (because itll take subtypes)
/obj/item/food/patty/plain

/obj/item/food/patty/human
	name = "странная котлета"

/obj/item/food/patty/corgi
	name = "котлета из мяса корги"

/obj/item/food/patty/bear
	name = "котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/patty/xeno
	name = "котлета из мяса корги"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/patty/chicken
	name = "куриная котлета"
	tastes = list("курица" = 1)
	icon_state = "chicken_patty"

/obj/item/food/raw_sausage
	name = "сырая сосиска"
	desc = "Смешанные длинные, но сырые, волокна мяса."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	eatverbs = list("кусает", "жуёт", "глотает")
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/raw_sausage/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sausage, rand(60 SECONDS, 75 SECONDS), TRUE)

/obj/item/food/sausage
	name = "сосиска"
	desc = "Смешанные длинные волокна мяса."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	eatverbs = list("кусает", "жуёт", "глотает")
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sausage/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/salami, 6, 3 SECONDS, table_required = TRUE,  screentip_verb = "Slice")
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sausage/american, 1, 3 SECONDS, table_required = TRUE,  screentip_verb = "Slice")

/obj/item/food/sausage/american
	name = "американская сосиска"
	desc = "Дерзкая."
	icon_state = "american_sausage"

/obj/item/food/sausage/american/make_processable()
	return

/obj/item/food/salami
	name = "салями"
	desc = "Кусочек вяленой салями."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "salami"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("мясо" = 1, "дымок" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/rawkhinkali
	name = "сырое хинкали"
	desc = "Сотня хинкали? Я что, похож на свинью?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "khinkali"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/garlic = 1,
	)
	tastes = list("мясо" = 1, "лук" = 1, "чеснок" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/rawkhinkali/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/khinkali, rand(50 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/khinkali
	name = "хинкали"
	desc = "Сотня хинкали? Я что, похож на свинью?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "khinkali"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/garlic = 2,
	)
	bite_consumption = 3
	tastes = list("мясо" = 1, "лук" = 1, "чеснок" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/meatbun
	name = "мясная булка"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatbun"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("булочка" = 3, "мясо" = 2)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/stewedsoymeat
	name = "тушеное соевое мясо"
	desc = "Даже невегетарианцы будут в ВОСТОРГЕ от этого блюда!"
	icon_state = "stewedsoymeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("soy" = 1, "vegetables" = 1)
	eatverbs = list("slurp", "sip", "inhale", "drink")
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/boiledspiderleg
	name = "вареная паучья лапка"
	desc = "Нога гигантского паука, которая все еще дергается. Отвратительно!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spiderlegcooked"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/capsaicin = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("перцы" = 1, "паутина" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/spidereggsham
	name = "ветчина из паучих яиц"
	desc = "Стали бы вы есть это в поезде? Съели бы вы есть это в самолете? Съели бы вы это в современной корпоративной смертельной ловушке, летящей через космос?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spidereggsham"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 4
	tastes = list("мясо" = 1, "зелёный цвет" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sashimi
	name = "сашими из карпа"
	desc = "Отпразднуйте нападение враждебных инопланетных форм жизни, госпитализировав себя."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "sashimi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/capsaicin = 9,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("рыба" = 1, "hot peppers" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_TINY
	//total price of this dish is 20 and a small amount more for soy sauce, all of which are available at the orders console
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sashimi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CARP, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/nugget
	name = "куриный наггетс"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	icon = 'icons/obj/food/meat.dmi'
	/// Default nugget icon for recipes that need any nugget
	icon_state = "nugget_lump"
	tastes = list("\"курица\"" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/nugget/Initialize(mapload)
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	switch(shape)
		if("lump")
			desc = "Обычный куриный наггетс."
		if("star")
			desc = "Куриный наггетс в форме звезды."
		if("lizard")
			desc = "Куриный наггетс в форме ящерицы"
		else
			desc = "Куриный наггетс в форме корги"
	icon_state = "nugget_[shape]"

/obj/item/food/pigblanket
	name = "сосиска в тесте"
	desc = "Маленькая сосиска, завернутая в хрустящий рулет с маслом."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "pigblanket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("мясо" = 1, "масло" = 1)
	foodtypes = MEAT | DAIRY | GRAIN
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bbqribs
	name = "ребрышки барбекю"
	desc = "Сладкие, дымные, соленые, и всегда кстати. Идеально подходят для гриля."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "ribs"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/bbqsauce = 10,
	)
	tastes = list("мясо" = 3, "дымный соус" = 1)
	foodtypes = MEAT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/meatclown
	name = "мясной клоун"
	desc = "Восхитительный круглый кусочек мясного клоуна. Какой ужас."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatclown"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/banana = 2,
	)
	tastes = list("мясо" = 5, "клоуны" = 3, "шестнадцать тесл" = 1)
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = MEAT | FRUIT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/meatclown/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 3 SECONDS)

/obj/item/food/lasagna
	name = "лазанья"
	desc = "Кусочек лазаньи. Идеально для понедельника."
	icon_state = "lasagna"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/tomatojuice = 10,
	)
	tastes = list("мясо" = 3, "паста" = 3, "томаты" = 2, "сыр" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

//////////////////////////////////////////// KEBABS AND OTHER SKEWERS ////////////////////////////////////////////

/obj/item/food/kebab
	trash_type = /obj/item/stack/rods
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "kebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 14)
	tastes = list("мясо" = 3, "metal" = 1)
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/kebab/human
	name = "кебаб"
	desc = "Вкуснейшее мясо на палочке."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("нежное мясо" = 3, "металл" = 1)
	foodtypes = MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/monkey
	name = "кебаб"
	desc = "Вкуснейшее мясо на палочке."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("мясо" = 3, "металл" = 1)
	foodtypes = MEAT
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tofu
	name = "кебаб с тофу"
	desc = "Веганское мясо на палочке."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 15)
	tastes = list("тофу" = 3, "металл" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tail
	name = "кебаб из хвоста ящерицы"
	desc = "Отрубленный хвост ящерицы на палке."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 30,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("мясо" = 8, "металл" = 4, "чешуйки" = 1)
	foodtypes = MEAT | GORE

/obj/item/food/kebab/rat
	name = "мышиный кебаб"
	desc = "Не очень вкусное крысиное мясо на палочке."
	icon_state = "ratkebab"
	w_class = WEIGHT_CLASS_NORMAL
	trash_type = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("крысятина" = 1, "металл" = 1)
	foodtypes = MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/rat/double
	name = "двойной мышиный кебаб"
	icon_state = "doubleratkebab"
	tastes = list("крысятина" = 2, "металл" = 1)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/iron = 2,
	)

/obj/item/food/kebab/fiesta
	name = "шпажка \"Фиеста\""
	icon_state = "fiestaskewer"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/capsaicin = 3,
	)
	tastes = list("тмин" = 2)
	foodtypes = MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/fried_chicken
	name = "жареная курица"
	desc = "Сочный кусок обжаренного куриного мяса."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fried_chicken1"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("цыплёнок" = 3, "жареная шкурка" = 1)
	foodtypes = MEAT | FRIED
	junkiness = 25
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/fried_chicken/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "fried_chicken2"

/obj/item/food/beef_stroganoff
	name = "бифстроганов"
	desc = "Русское блюдо, состоящее из говядины и соуса. Очень популярно в Японии, или, по крайней мере, на это намекает мое аниме."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beefstroganoff"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("говядина" = 3, "сметана" = 1, "соль" = 1, "перец" = 1)
	foodtypes = MEAT | VEGETABLES | DAIRY

	w_class = WEIGHT_CLASS_SMALL
	//basic ingredients, but a lot of them. just covering costs here
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/beef_wellington
	name = "биф велингтон"
	desc = "Роскошный брусок говядины, покрытый тонким грибным дюкселем и ветчиной панчетта, затем связанный в слоеном тесте."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beef_wellington"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 21,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("говядина" = 3, "грибы" = 1, "панчетта" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_NORMAL
	venue_value = FOOD_PRICE_EXOTIC
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/beef_wellington/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/beef_wellington_slice, 3, 3 SECONDS, table_required = TRUE,  screentip_verb = "Cut")

/obj/item/food/beef_wellington_slice
	name = "кусочек биф велингтона"
	desc = "Кусочек биф велингтона, покрытый богатым соусом. Просто восхитительно."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beef_wellington_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("говядина" = 3, "грибы" = 1, "панчетта" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/full_english
	name = "английский завтрак"
	desc = "Плотный завтрак с всеми приправами, представляющий собой вершину завтрака."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "full_english"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("сосиски" = 1, "бекон" = 1, "яйца" = 1, "томаты" = 1, "грибы" = 1, "хлеб" = 1, "фасоль" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/raw_meatloaf
	name = "raw meatloaf"
	desc = "A heavy 'loaf' of minced meat, onions, and garlic. Bake it in an oven!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_meatloaf"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 40,
		/datum/reagent/consumable/nutriment/vitamin = 32,
		/datum/reagent/consumable/nutriment = 32,
	)
	tastes = list("raw meat" = 3, "onions" = 1)
	foodtypes = MEAT | RAW | VEGETABLES
	w_class = WEIGHT_CLASS_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/raw_meatloaf/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/meatloaf, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/meatloaf
	name = "meatloaf"
	desc = "A mixture of meat, onions, and garlic formed into a loaf and baked in an oven. It's covered in a generous slathering of ketchup. Use a knife to cut it into slices!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatloaf"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 40,
		/datum/reagent/consumable/nutriment/vitamin = 32,
		/datum/reagent/consumable/nutriment = 32,
	)
	tastes = list("juicy meat" = 3, "onions" = 1, "garlic" = 1, "ketchup" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/meatloaf/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meatloaf_slice, 4, 3 SECONDS, table_required = TRUE,  screentip_verb = "Cut")

/obj/item/food/meatloaf_slice
	name = "meatloaf slice"
	desc = "A slice of delicious, juicy meatloaf with a ketchup topping."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatloaf_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/nutriment = 8,
	)
	tastes = list("juicy meat" = 3, "onions" = 1, "garlic" = 1, "ketchup" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/sweet_and_sour_meatballs
	name = "sweet and sour meatballs"
	desc = "Golden meatballs glazed in a sticky savory sauce, served with pineapple and pepper chunks."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "sweet_and_sour_meatballs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/nutriment = 8,
	)
	tastes = list("мясо" = 5, "savory sauce" = 4, "tangy pineapple" = 3, "pepper" = 2)
	foodtypes = MEAT | VEGETABLES | FRUIT | PINEAPPLE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/kebab/pineapple_skewer
	name = "pineapple skewer"
	desc = "Chunks of glazed meat skewered on a rod with pineapple slices. Surprisingly not bad!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "pineapple_skewer"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("juicy meat" = 4, "pineapple" = 3)
	foodtypes = MEAT | FRUIT | PINEAPPLE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/futomaki_sushi_roll
	name = "futomaki sushi roll"
	desc = "A roll of futomaki sushi, made of boiled egg, fish, and cucumber. Sliceable"
	icon_state = "futomaki_sushi_roll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("boiled rice" = 4, "рыба" = 5, "egg" = 3, "dried seaweed" = 2, "cucumber" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/futomaki_sushi_roll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/futomaki_sushi_slice, 4, screentip_verb = "Chop")

/obj/item/food/futomaki_sushi_slice
	name = "futomaki sushi slice"
	desc = "A slice of futomaki sushi, made of boiled egg, fish, and cucumber."
	icon_state = "futomaki_sushi_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("boiled rice" = 4, "рыба" = 5, "egg" = 3, "dried seaweed" = 2, "cucumber" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/philadelphia_sushi_roll
	name = "Philadelphia sushi roll"
	desc = "A roll of Philadelphia sushi, made of cheese, fish, and cucumber. Sliceable"
	icon_state = "philadelphia_sushi_roll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("boiled rice" = 4, "рыба" = 5, "creamy cheese" = 3, "dried seaweed" = 2, "cucumber" = 2)
	foodtypes = VEGETABLES | SEAFOOD | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/philadelphia_sushi_roll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/philadelphia_sushi_slice, 4, screentip_verb = "Chop")

/obj/item/food/philadelphia_sushi_slice
	name = "Philadelphia sushi slice"
	desc = "A roll of Philadelphia sushi, made of cheese, fish, and cucumber."
	icon_state = "philadelphia_sushi_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("boiled rice" = 4, "рыба" = 5, "creamy cheese" = 3, "dried seaweed" = 2, "cucumber" = 2)
	foodtypes = VEGETABLES | SEAFOOD | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3
