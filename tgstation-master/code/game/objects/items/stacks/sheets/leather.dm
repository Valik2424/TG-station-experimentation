/obj/item/stack/sheet/animalhide
	name = "кожа"
	desc = "Что-то пошло не так."
	icon_state = "sheet-hide"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/animalhide

/obj/item/stack/sheet/animalhide/human
	name = "человеческая кожа"
	desc = "Побочный продукт человеческого происхождения... у тебя все нормально с головой?"
	singular_name = "кусок человеческой кожи"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/human

GLOBAL_LIST_INIT(human_recipes, list( \
	new/datum/stack_recipe("раздутый человеческий костюм", /obj/item/clothing/suit/hooded/bloated_human, 5, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("шляпа из человеческой кожи", /obj/item/clothing/head/fedora/human_leather, 1, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/human/get_main_recipes()
	. = ..()
	. += GLOB.human_recipes

/obj/item/stack/sheet/animalhide/human/five
	amount = 5

/obj/item/stack/sheet/animalhide/generic
	name = "кожа"
	desc = "Кусочек кожи."
	singular_name = "кусочек кожи"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/generic

/obj/item/stack/sheet/animalhide/corgi
	name = "шкура корги"
	desc = "Побочный продукт выращивания корги."
	singular_name = "кусочек кожи корги"
	icon_state = "sheet-corgi"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/corgi

GLOBAL_LIST_INIT(gondola_recipes, list ( \
	new/datum/stack_recipe("маска гондолы", /obj/item/clothing/mask/gondola, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("костюм гондолы", /obj/item/clothing/under/costume/gondola, 2, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/corgi/five
	amount = 5

/obj/item/stack/sheet/animalhide/mothroach
	name = "шкура гондолы"
	desc = "Чрезвычайно ценный продукт охоты на гондол."
	singular_name = "кусочек шкуры гондолы"
	icon_state = "sheet-mothroach"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/mothroach

/obj/item/stack/sheet/animalhide/mothroach/five
	amount = 5

/obj/item/stack/sheet/animalhide/gondola
	name = "шкура гондолы"
	desc = "Чрезвычайно ценный продукт охоты на гондол."
	singular_name = "кусочек шкуры гондолы"
	icon_state = "sheet-gondola"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/gondola

/obj/item/stack/sheet/animalhide/gondola/get_main_recipes()
	. = ..()
	. += GLOB.gondola_recipes

GLOBAL_LIST_INIT(corgi_recipes, list ( \
	new/datum/stack_recipe("костюм корги", /obj/item/clothing/suit/hooded/ian_costume, 3, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/corgi/get_main_recipes()
	. = ..()
	. += GLOB.corgi_recipes

/obj/item/stack/sheet/animalhide/cat
	name = "кошачья шкура"
	desc = "Побочный продукт разведения кошек."
	singular_name = "кусок шкуры кошки"
	icon_state = "sheet-cat"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/cat

/obj/item/stack/sheet/animalhide/cat/five
	amount = 5

/obj/item/stack/sheet/animalhide/monkey
	name = "шкура обезьяны"
	desc = "Побочный продукт разведения обезьян."
	singular_name = "кусок шкуры обезьяны"
	icon_state = "sheet-monkey"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/monkey

GLOBAL_LIST_INIT(monkey_recipes, list ( \
	new/datum/stack_recipe("маска обезьяны", /obj/item/clothing/mask/gas/monkeymask, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("костюм обезьяны", /obj/item/clothing/suit/costume/monkeysuit, 2, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/monkey/get_main_recipes()
	. = ..()
	. += GLOB.monkey_recipes

/obj/item/stack/sheet/animalhide/monkey/five
	amount = 5

/obj/item/stack/sheet/animalhide/lizard
	name = "кожа ящерицы"
	desc = "Ссссссс..."
	singular_name = "кусок кожи ящерицы"
	icon_state = "sheet-lizard"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/lizard

/obj/item/stack/sheet/animalhide/lizard/five
	amount = 5

/obj/item/stack/sheet/animalhide/xeno
	name = "инопланетная шкура"
	desc = "Кожа ужасного существа."
	singular_name = "кусок кожи инопланетянина"
	icon_state = "sheet-xeno"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/xeno

GLOBAL_LIST_INIT(xeno_recipes, list ( \
	new/datum/stack_recipe("голова ксеноса", /obj/item/clothing/head/costume/xenos, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("костюм ксеноса", /obj/item/clothing/suit/costume/xenos, 2, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/xeno/get_main_recipes()
	. = ..()
	. += GLOB.xeno_recipes

/obj/item/stack/sheet/animalhide/xeno/five
	amount = 5

/obj/item/stack/sheet/animalhide/carp
	name = "чешуя карпа"
	desc = "Чешуя карпа. Выглядит довольно красиво, когда отделена от гадкого существа, которое носило ее."
	singular_name = "carp scale"
	icon_state = "sheet-carp"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/carp

GLOBAL_LIST_INIT(carp_recipes, list ( \
	new/datum/stack_recipe("костюм карпа", /obj/item/clothing/suit/hooded/carp_costume, 4, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("маска карпа", /obj/item/clothing/mask/gas/carp, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("стул из чешуи карпа", /obj/structure/chair/comfy/carp, 2, check_density = FALSE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("костюм из чешуи карпа", /obj/item/clothing/under/suit/carpskin, 3, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("федора из чешуи карпа", /obj/item/clothing/head/fedora/carpskin, 2, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/carp/get_main_recipes()
	. = ..()
	. += GLOB.carp_recipes

/obj/item/stack/sheet/animalhide/carp/five
	amount = 5

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/sheet/xenochitin
	name = "инопланетный хитин"
	desc = "Кусок шкуры ужасного существа."
	singular_name = "кусок кожи инопланетянина"
	icon = 'icons/mob/nonhuman-player/alien.dmi'
	icon_state = "chitin"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/xenochitin

/obj/item/xenos_claw
	name = "инопланетный коготь"
	desc = "Коготь ужасного существа."
	icon = 'icons/mob/nonhuman-player/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "экстракт сорняков"
	desc = "Кусочек слизистой пурпурной травы."
	icon = 'icons/mob/nonhuman-player/alien.dmi'
	icon_state = "weed_extract"

/*
 * Leather SHeet
 */
/obj/item/stack/sheet/leather
	name = "кожа"
	desc = "Побочный продукт разведения животных."
	singular_name = "кусок кожи"
	icon_state = "sheet-leather"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/leather

GLOBAL_LIST_INIT(leather_recipes, list ( \
	new/datum/stack_recipe("бумажник", /obj/item/storage/wallet, 1, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("намордник", /obj/item/clothing/mask/muzzle, 2, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("баскетбольный мяч", /obj/item/toy/basketball, 20, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("бейсбольный мяч", /obj/item/toy/beach_ball/baseball, 3, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("седло", /obj/item/goliath_saddle, 5, check_density = FALSE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("кожаные ботинки", /obj/item/clothing/shoes/laceup, 2, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("ковбойские ботинки", /obj/item/clothing/shoes/cowboy, 2, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("ботанические перчатки", /obj/item/clothing/gloves/botanic_leather, 3, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("кожаная сумка", /obj/item/storage/backpack/satchel/leather, 5, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("жилет шерифа", /obj/item/clothing/accessory/vest_sheriff, 4, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("кожаный пиджак", /obj/item/clothing/suit/jacket/leather, 7, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("куртка байкера", /obj/item/clothing/suit/jacket/leather/biker, 7, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe_list("пояса", list( \
		new/datum/stack_recipe("пояс с инструментами", /obj/item/storage/belt/utility, 4, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("ботанический пояс", /obj/item/storage/belt/plant, 2, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("пояс уборщика", /obj/item/storage/belt/janitor, 2, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("медицинский пояс", /obj/item/storage/belt/medical, 2, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("пояс офицера", /obj/item/storage/belt/security, 2, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("пистолетная кобура", /obj/item/storage/belt/holster, 3, check_density = FALSE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("бандольер", /obj/item/storage/belt/bandolier, 5, check_density = FALSE, category = CAT_CONTAINERS), \
	)),
))

/obj/item/stack/sheet/leather/get_main_recipes()
	. = ..()
	. += GLOB.leather_recipes

/obj/item/stack/sheet/leather/five
	amount = 5

/*
 * Sinew
 */
/obj/item/stack/sheet/sinew
	name = "сухожилия стражника"
	icon = 'icons/obj/mining.dmi'
	desc = "Длинные волокнистые нити, которые предположительно пришли с крыльев наблюдателя."
	singular_name = "сухожилие стражника"
	icon_state = "sinew"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/sinew

/obj/item/stack/sheet/sinew/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	// As bone and sinew have just a little too many recipes for this, we'll just split them up.
	// Sinew slapcrafting will mostly-sinew recipes, and bones will have mostly-bones recipes.
	var/static/list/slapcraft_recipe_list = list(\
		/datum/crafting_recipe/goliathcloak, /datum/crafting_recipe/skilt, /datum/crafting_recipe/drakecloak,\
		)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/sinew/wolf
	name = "волчьи сухожилия"
	desc = "Длинные волокнистые нити, которые пришли изнутри волка."
	singular_name = "волчье сухожилие"
	merge_type = /obj/item/stack/sheet/sinew/wolf

GLOBAL_LIST_INIT(sinew_recipes, list ( \
	new/datum/stack_recipe("сухожильные наручники", /obj/item/restraints/handcuffs/cable/sinew, 1, check_density = FALSE, category = CAT_EQUIPMENT), \
))

/obj/item/stack/sheet/sinew/get_main_recipes()
	. = ..()
	. += GLOB.sinew_recipes


/*Plates*/
/obj/item/stack/sheet/animalhide/goliath_hide
	name = "шкурные пластины голиафа"
	desc = "Осколки скалистой шкуры Голиафа могут сделать ваш костюм более стойким к атакам местной фауны."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "goliath_hide"
	singular_name = "шкурная пластина"
	max_amount = 6
	novariants = FALSE
	item_flags = NOBLUDGEON
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide

/obj/item/stack/sheet/animalhide/goliath_hide/polar_bear_hide
	name = "шкура полярного медведя"
	desc = "Кусочки меха белого медведможнот сделать ваш костюм более стойким к атакам местной фауны."
	icon_state = "polar_bear_hide"
	singular_name = "шкура медведя"
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide/polar_bear_hide

/obj/item/stack/sheet/animalhide/ashdrake
	name = "шкура пепельного дракона"
	desc = "Сильная чешуйчатая шкура пепельного дракона."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "dragon_hide"
	singular_name = "драконьи пластины"
	max_amount = 10
	novariants = FALSE
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/ashdrake

/obj/item/stack/sheet/animalhide/ashdrake/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/drakecloak)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		playsound(loc, 'sound/weapons/slice.ogg', 50, TRUE, -1)
		user.visible_message(span_notice("<b>[user]</b> начинает срезать шерсть с <b>[src]</b>.") , span_notice("Начинаю срезать шерсть с <b>[src]</b>...") , span_hear("Слыш как нож режет плоть."))
		if(do_after(user, 50, target = src))
			to_chat(user, span_notice("Срезаю шерсть с <b>[src.singular_name]</b>."))
			new /obj/item/stack/sheet/hairlesshide(user.drop_location(), amount)
			use(amount)
	else
		return ..()

/obj/item/stack/sheet/animalhide/examine(mob/user)
	. = ..()
	. += span_notice("Можно срезать шерсть любым острым предметом.")

//Step two - washing..... it's actually in washing machine code.

/obj/item/stack/sheet/hairlesshide
	name = "безволосая шкура"
	desc = "Эта шкура была лишена волос, но все еще нуждается в мытье и загаре."
	singular_name = "кусок безволосой шкуры"
	icon_state = "sheet-hairlesshide"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/hairlesshide

/obj/item/stack/sheet/hairlesshide/examine(mob/user)
	. = ..()
	. += span_notice("Можно очистить, намочив в воде.")

//Step three - drying
/obj/item/stack/sheet/wethide
	name = "мокрая шкура"
	desc = "Эта шкура была очищена, но все еще нуждается в сушке."
	singular_name = "мокрая шкура"
	icon_state = "sheet-wetleather"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/wethide
	/// Reduced when exposed to high temperatures
	var/wetness = 30
	/// Kelvin to start drying
	var/drying_threshold_temperature = 500

/obj/item/stack/sheet/wethide/examine(mob/user)
	. = ..()
	. += span_notice("Можно высушить, чтобы получить кожу.")

/obj/item/stack/sheet/wethide/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)
	AddElement(/datum/element/dryable, /obj/item/stack/sheet/leather)
	AddElement(/datum/element/microwavable, /obj/item/stack/sheet/leather)
	AddComponent(/datum/component/grillable, /obj/item/stack/sheet/leather, rand(1 SECONDS, 3 SECONDS), TRUE)
	AddComponent(/datum/component/bakeable, /obj/item/stack/sheet/leather, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/stack/sheet/wethide/burn()
	visible_message(span_notice("[src] высыхает!"))
	new /obj/item/stack/sheet/leather(loc, amount) // all the sheets to incentivize not losing your whole stack by accident
	qdel(src)

/obj/item/stack/sheet/wethide/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return (exposed_temperature > drying_threshold_temperature)

/obj/item/stack/sheet/wethide/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	wetness--
	if(wetness == 0)
		new /obj/item/stack/sheet/leather(drop_location(), amount)
		wetness = initial(wetness)
		use(1)
