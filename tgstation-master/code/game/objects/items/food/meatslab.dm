/obj/item/food/meat
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 4)
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/food/meat.dmi'
	var/subjectname = ""
	var/subjectjob = null
	var/blood_decal_type = /obj/effect/decal/cleanable/blood

/obj/item/food/meat/Initialize(mapload)
	. = ..()

	if(!blood_decal_type)
		return

	AddComponent(
		/datum/component/blood_walk,\
		blood_type = blood_decal_type,\
		blood_spawn_chance = 45,\
		max_blood = custom_materials[custom_materials[1]],\
	)

	AddComponent(
		/datum/component/bloody_spreader,\
		blood_left = custom_materials[custom_materials[1]],\
		blood_dna = list("meaty DNA" = "MT-"),\
		diseases = null,\
	)

/obj/item/food/meat/slab
	name = "мясо"
	desc = "Кусок мяса."
	icon_state = "meat"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) //Meat has fats that a food processor can process into cooking oil
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	///Legacy code, handles the coloring of the overlay of the cutlets made from this.
	var/slab_color = "#FF0000"


/obj/item/food/meat/slab/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/sosjerky/healthy)

/obj/item/food/meat/slab/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////

/obj/item/food/meat/slab/human
	name = "мясо"
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_HUMAN

/obj/item/food/meat/slab/human/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/human/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/human, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/human/mutant/slime
	icon_state = "slimemeat"
	desc = "Потому что даже желе не было достаточно оскорбительным для веганов."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/slimejelly = 3,
	)
	tastes = list("слаймы" = 1, "желе" = 1)
	foodtypes = MEAT | RAW | TOXIC
	venue_value = FOOD_MEAT_MUTANT_RARE
	blood_decal_type = null

/obj/item/food/meat/slab/human/mutant/golem
	icon_state = "golemmeat"
	desc = "Съедобные камни, добро пожаловать в будущее."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 3,
	)
	tastes = list("rock" = 1)
	foodtypes = MEAT | RAW | GROSS
	venue_value = FOOD_MEAT_MUTANT_RARE
	blood_decal_type = null

/obj/item/food/meat/slab/human/mutant/golem/adamantine
	icon_state = "agolemmeat"
	desc = "Съедобные камни, добро пожаловать в будущее."
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/lizard
	icon_state = "lizardmeat"
	desc = "Вкуснейшее мясо динозвара."
	tastes = list("мясо" = 4, "чешуйки" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_MUTANT
	starting_reagent_purity = 0.4 // Take a look at their diet

/obj/item/food/meat/slab/human/mutant/lizard/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/lizard, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/human/mutant/plant
	icon_state = "plantmeat"
	desc = "Все радости здорового питания со всеми удовольствиями каннибализма."
	tastes = list("салат" = 1, "дерево" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_MEAT_MUTANT_RARE
	blood_decal_type = /obj/effect/decal/cleanable/food/plant_smudge

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "shadowmeat"
	desc = "Ой, край."
	tastes = list("тьма" = 1, "мясо" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/fly
	icon_state = "flymeat"
	desc = "Ничто так не вкусно, как наполненная личинками радиоактивная плоть мутанта."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/uranium = 3,
	)
	tastes = list("личинки" = 1, "внутренности реактора" = 1)
	foodtypes = MEAT | RAW | GROSS | BUGS | GORE
	venue_value = FOOD_MEAT_MUTANT
	blood_decal_type = /obj/effect/decal/cleanable/insectguts

/obj/item/food/meat/slab/human/mutant/moth
	icon_state = "mothmeat"
	desc = "Неприятно порошкообразное и сухое. Хотя и довольно симпатичное."
	tastes = list("пыль" = 1, "порох" = 1, "мясо" = 2)
	foodtypes = MEAT | RAW | BUGS | GORE
	venue_value = FOOD_MEAT_MUTANT

/obj/item/food/meat/slab/human/mutant/skeleton
	name = "кость"
	icon_state = "skeletonmeat"
	desc = "Есть момент, когда нужно остановиться. Очевидно, что мы его упустили."
	tastes = list("кости" = 1)
	foodtypes = GROSS | GORE
	venue_value = FOOD_MEAT_MUTANT_RARE
	blood_decal_type = null

/obj/item/food/meat/slab/human/mutant/skeleton/make_processable()
	return //skeletons dont have cutlets

/obj/item/food/meat/slab/human/mutant/zombie
	name = "гнилое мясо"
	icon_state = "rottenmeat"
	desc = "На полпути к тому, чтобы стать удобрением для вашего сада."
	tastes = list("мозги" = 1, "мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC | GORE | GROSS

/obj/item/food/meat/slab/human/mutant/ethereal
	icon_state = "etherealmeat"
	desc = "Такой блестящий, что, кажется, проглотив его, ты тоже засияешь."
	food_reagents = list(/datum/reagent/consumable/liquidelectricity/enriched = 10)
	tastes = list("электричество" = 2, "мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC | GORE
	venue_value = FOOD_MEAT_MUTANT
	blood_decal_type = null

////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////

/obj/item/food/meat/slab/synthmeat
	name = "синтетическое мясо"
	icon_state = "meat_old"
	desc = "Кусок синтетического мяса."
	foodtypes = RAW | MEAT //hurr durr chemicals were harmed in the production of this meat thus its non-vegan.
	venue_value = FOOD_PRICE_WORTHLESS
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/synthmeat/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/synth, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/meatproduct
	name = "мясной продукт"
	icon_state = "meatproduct"
	desc = "Кусок переработанного и химически обработанного мясного продукта."
	tastes = list("мясной ароматизатор" = 2, "модифицированные крахмалы" = 2, "натуральные и искусственные красители" = 1, "масляная кислота" = 1)
	foodtypes = RAW | MEAT
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/meatproduct/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/monkey
	name = "обезьянье мясо"
	foodtypes = RAW | MEAT
	starting_reagent_purity = 0.3 // Monkeys are considered synthetic life

/obj/item/food/meat/slab/bugmeat
	name = "мясо жука"
	icon_state = "spidermeat"
	foodtypes = RAW | MEAT | BUGS
	blood_decal_type = /obj/effect/decal/cleanable/insectguts

/obj/item/food/meat/slab/mouse
	name = "мышиное мясо"
	desc = "Кусок мышиного мяса. Лучше не есть сырым."
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/mouse/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOUSE, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/corgi
	name = "мясо корги"
	desc = "На вкус как...ну...ты знаешь..."
	tastes = list("мясо" = 4, "любовь к ношению шляп" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/corgi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CORGI, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/mothroach
	name = "мясо моли"
	desc = "Лёгкий кусок мяса."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/mothroach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pug
	name = "мясо мопса"
	desc = "На вкус как...ну...ты знаешь..."
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/pug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PUG, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/killertomato
	name = "мясо томата"
	desc = "Кусок огромного томата."
	icon_state = "tomatomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("томаты" = 1)
	foodtypes = FRUIT
	blood_decal_type = /obj/effect/decal/cleanable/food/tomato_smudge

/obj/item/food/meat/slab/killertomato/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/killertomato, rand(70 SECONDS, 85 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/killertomato/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/killertomato, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/bear
	name = "медвежатина"
	desc = "Очень мужественный кусок мяса."
	icon_state = "bearmeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/medicine/morphine = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/fat = 6,
	)
	tastes = list("мясо" = 1, "лосось" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bear/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/bear, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/bear/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/bear, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/xeno
	name = "мясо ксеноморфа"
	desc = "Кусок мяса."
	icon_state = "xenomeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 4
	tastes = list("мясо" = 1, "кислота" = 1)
	foodtypes = RAW | MEAT
	blood_decal_type = /obj/effect/decal/cleanable/xenoblood

/obj/item/food/meat/slab/xeno/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/xeno, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/xeno/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/xeno, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/spider
	name = "паучье мясо"
	desc = "Кусок паучьего мяса. Это так по-кафкиански."
	icon_state = "spidermeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/toxin = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("паутина" = 1)
	foodtypes = RAW | MEAT | TOXIC
	blood_decal_type = /obj/effect/decal/cleanable/insectguts

/obj/item/food/meat/slab/spider/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/spider, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/spider/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/spider, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/goliath
	name = "мясо голиафа"
	desc = "Кусок мяса голиафа. Сейчас оно не очень съедобно, но оно отлично готовится в лаве."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/toxin = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	icon_state = "goliathmeat"
	tastes = list("мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/goliath/burn()
	visible_message(span_notice("[src] finishes cooking!"))
	new /obj/item/food/meat/steak/goliath(loc)
	qdel(src)

/obj/item/food/meat/slab/meatwheat
	name = "мясной комочек"
	desc = "Это не похоже на мясо, но ваши стандарты не <i>настолько</i> высоки..."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/blood = 5, /datum/reagent/consumable/nutriment/fat = 1)
	icon_state = "meatwheat_clump"
	bite_consumption = 4
	tastes = list("мясо" = 1, "пшеница" = 1)
	foodtypes = GRAIN

/obj/item/food/meat/slab/gorilla
	name = "мясо гориллы"
	desc = "Намного мяснее, чем обезьянье мясо."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/nutriment/fat = 5, //Plenty of fat!
	)

/obj/item/food/meat/rawbacon
	name = "сырой бекон"
	desc = "Кусочек сырого бекона."
	icon_state = "baconb"
	bite_consumption = 2
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("бекон" = 1)
	foodtypes = RAW | MEAT
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/meat/rawbacon/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/bacon, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/meat/bacon
	name = "кусочек бекона"
	desc = "Кусочек вкуснейшего бекона."
	icon_state = "baconcookedb"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/nutriment/fat = 2,
	)
	tastes = list("бекон" = 1)
	foodtypes = MEAT | BREAKFAST
	crafting_complexity = FOOD_COMPLEXITY_1
	blood_decal_type = null

/obj/item/food/meat/slab/gondola
	name = "мясо гондолы"
	desc = "Согласно старым легендам, употребление сырой плоти гондолы дарует человеку внутренний покой."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/gondola_mutation_toxin = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("мясо" = 4, "спокойствие" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/gondola/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/gondola, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/gondola/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/gondola, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/penguin
	name = "мясо пингвина"
	icon_state = "birdmeat"
	desc = "Кусок мяса пингвина."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/slab/penguin/make_processable()
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/penguin, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/penguin/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/penguin, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/rawcrab
	name = "сырое крабовое мясо"
	desc = "Груда сырого крабового мяса."
	icon_state = "crabmeatraw"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("сырой краб" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/rawcrab/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/crab, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/crab
	name = "крабовое мясо"
	desc = "Вкусно приготовленное крабовое мясо."
	icon_state = "crabmeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/fat = 2,
	)
	tastes = list("краб" = 1)
	foodtypes = SEAFOOD
	crafting_complexity = FOOD_COMPLEXITY_1
	blood_decal_type = null

/obj/item/food/meat/slab/chicken
	name = "куриное мясо"
	icon_state = "birdmeat"
	desc = "Кусок сырой курицы. Не забудьте вымыть руки!"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6) //low fat
	tastes = list("цыплёнок" = 1)
	starting_reagent_purity = 1

/obj/item/food/meat/slab/chicken/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/chicken, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/chicken/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe? (no this is chicken)

/obj/item/food/meat/slab/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pig
	name = "raw pork"
	desc = "A slab of raw pork. This little piggy went to the butcher's."
	icon_state = "pig_meat"
	tastes = list("pig" = 1)
	foodtypes = RAW | MEAT | GORE
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/fat = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) // Fatty piece
	starting_reagent_purity = 1

/obj/item/food/meat/slab/pig/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/pig, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/grassfed
	name = "eco meat"
	desc = "A slab of 100% grass fed award-winning farm meat."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/fat = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) // Marble
	starting_reagent_purity = 1

////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////
/obj/item/food/meat/steak
	name = "стейк"
	desc = "Кусок горячего острого мяса."
	icon_state = "meatsteak"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	foodtypes = MEAT
	tastes = list("мясо" = 1)
	crafting_complexity = FOOD_COMPLEXITY_1
	blood_decal_type = null

/obj/item/food/meat/steak/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(on_microwave_cooked))

/obj/item/food/meat/steak/proc/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency = 1)
	SIGNAL_HANDLER

	name = "стейк из [source_item.name]"

/obj/item/food/meat/steak/plain
	foodtypes = MEAT

/obj/item/food/meat/steak/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | GORE

///Make sure the steak has the correct name
/obj/item/food/meat/steak/plain/human/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency = 1)
	. = ..()
	if(!istype(source_item, /obj/item/food/meat))
		return

	var/obj/item/food/meat/origin_meat = source_item
	subjectname = origin_meat.subjectname
	subjectjob = origin_meat.subjectjob
	if(subjectname)
		name = "стейк из [origin_meat.subjectname]"
	else if(subjectjob)
		name = "стейк из [origin_meat.subjectjob]"


/obj/item/food/meat/steak/killertomato
	name = "стейк из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/steak/bear
	name = "стейк из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/steak/xeno
	name = "стейк из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meat/steak/spider
	name = "стейк из паучьего мяса"
	tastes = list("паутина" = 1)

/obj/item/food/meat/steak/goliath
	name = "стейк из голиафа"
	desc = "Вкуснейший, приготовленный в лаве стейк."
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	icon_state = "goliathsteak"
	trash_type = null
	tastes = list("мясо" = 1, "камни" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/gondola
	name = "стейк из гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/steak/penguin
	name = "стейк из пингвина"
	icon_state = "birdsteak"
	tastes = list("говядина" = 1, "треска" = 1)
/obj/item/food/meat/steak/chicken
	name = "стейк из курицы" //Can you have chicken steaks? Maybe this should be renamed once it gets new sprites.
	icon_state = "birdsteak"
	tastes = list("говядина" = 1)

/obj/item/food/meat/steak/plain/human/lizard
	name = "стейк из ящерицы"
	icon_state = "birdsteak"
	tastes = list("juicy chicken" = 3, "scales" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/meatproduct
	name = "термически обработанный мясной продукт"
	icon_state = "meatproductsteak"
	tastes = list("мясной ароматизатор" = 2, "модифицированные крахмалы" = 2, "натуральные и искусственные красители" = 1, "эмульгаторы" = 1)

/obj/item/food/meat/steak/plain/synth
	name = "стейк из синтетического мяса"
	desc = "Стейк из синтетического мяса. Это выглядит не совсем правильно, не так ли?"
	icon_state = "meatsteak_old"
	tastes = list("мясо" = 4, "криоксадон" = 1)

/obj/item/food/meat/steak/plain/pig
	name = "свиной стейк"
	desc = "Стейк из свинины. Не надо меня дразнить!"
	icon_state = "pigsteak"
	tastes = list("свинина" = 1)
	foodtypes = MEAT

//////////////////////////////// MEAT CUTLETS ///////////////////////////////////////////////////////

//Raw cutlets

/obj/item/food/meat/rawcutlet
	name = "сырая котлета"
	desc = "Сырая мясная котлета."
	icon_state = "rawcutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	var/meat_type = "meat"

/obj/item/food/meat/rawcutlet/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/OnCreatedFromProcessing(mob/living/user, obj/item/work_tool, list/chosen_option, atom/original_atom)
	. = ..()
	if(!istype(original_atom, /obj/item/food/meat/slab))
		return
	var/obj/item/food/meat/slab/original_slab = original_atom
	var/mutable_appearance/filling = mutable_appearance(icon, "rawcutlet_coloration")
	filling.color = original_slab.slab_color
	add_overlay(filling)
	name = "сырая котлета из [original_atom.name]"
	meat_type = original_atom.name

/obj/item/food/meat/rawcutlet/plain
	foodtypes = MEAT

/obj/item/food/meat/rawcutlet/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | RAW | GORE

/obj/item/food/meat/rawcutlet/plain/human/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain/human, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/plain/human/OnCreatedFromProcessing(mob/living/user, obj/item/item, list/chosen_option, atom/original_atom)
	. = ..()
	if(!istype(original_atom, /obj/item/food/meat))
		return
	var/obj/item/food/meat/origin_meat = original_atom
	subjectname = origin_meat.subjectname
	subjectjob = origin_meat.subjectjob
	if(subjectname)
		name = "сырая котлета из [origin_meat.subjectname]"
	else if(subjectjob)
		name = "сырая котлета из [origin_meat.subjectjob]"

/obj/item/food/meat/rawcutlet/killertomato
	name = "сырая котлета из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT
	blood_decal_type = /obj/effect/decal/cleanable/food/tomato_smudge

/obj/item/food/meat/rawcutlet/killertomato/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/killertomato, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/bear
	name = "сырая котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/rawcutlet/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/rawcutlet/bear/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/bear, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/xeno
	name = "сырая котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)
	blood_decal_type = /obj/effect/decal/cleanable/xenoblood

/obj/item/food/meat/rawcutlet/xeno/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/xeno, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/spider
	name = "сырая котлета из паучьего мяса"
	tastes = list("паутина" = 1)
	blood_decal_type = /obj/effect/decal/cleanable/insectguts

/obj/item/food/meat/rawcutlet/spider/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/spider, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/gondola
	name = "сырая котлета из мяса гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/rawcutlet/gondola/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/gondola, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/penguin
	name = "сырая котлета из мяса пингвина"
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/rawcutlet/penguin/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/penguin, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken
	name = "сырая куриная котлета"
	tastes = list("цыплёнок" = 1)

/obj/item/food/meat/rawcutlet/chicken/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/chicken, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

//Cooked cutlets

/obj/item/food/meat/cutlet
	name = "котлета"
	desc = "Приготовленная мясная котлета."
	icon_state = "cutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	crafting_complexity = FOOD_COMPLEXITY_1
	blood_decal_type = null

/obj/item/food/meat/cutlet/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(on_microwave_cooked))

///This proc handles setting up the correct meat name for the cutlet, this should definitely be changed with the food rework.
/obj/item/food/meat/cutlet/proc/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency)
	SIGNAL_HANDLER

	if(!istype(source_item, /obj/item/food/meat/rawcutlet))
		return

	var/obj/item/food/meat/rawcutlet/original_cutlet = source_item
	name = "[original_cutlet.meat_type] котлета"

/obj/item/food/meat/cutlet/plain

/obj/item/food/meat/cutlet/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | GORE

/obj/item/food/meat/cutlet/plain/human/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency)
	. = ..()
	if(!istype(source_item, /obj/item/food/meat))
		return

	var/obj/item/food/meat/origin_meat = source_item
	if(subjectname)
		name = "[origin_meat.subjectname] [initial(name)]"
	else if(subjectjob)
		name = "[origin_meat.subjectjob] [initial(name)]"

/obj/item/food/meat/cutlet/killertomato
	name = "котлета из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/cutlet/bear
	name = "котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/cutlet/xeno
	name = "котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meat/cutlet/spider
	name = "котлета из паучьего мяса"
	tastes = list("паутина" = 1)

/obj/item/food/meat/cutlet/gondola
	name = "котлета из мяса гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/cutlet/penguin
	name = "котлета из мяса пингвина"
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/cutlet/chicken
	name = "куриная котлета"
	tastes = list("цыплёнок" = 1)
