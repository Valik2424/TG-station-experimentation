/*
Mineral Sheets
	Contains:
		- Sandstone
		- Sandbags
		- Diamond
		- Snow
		- Uranium
		- Plasma
		- Gold
		- Silver
		- Clown
		- Titanium
		- Plastitanium
	Others:
		- Adamantine
		- Mythril
		- Alien Alloy
		- Coal
*/

/*
 * Sandstone
 */

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("Дверь из Песчаника", /obj/structure/mineral_door/sandstone, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Breakdown into sand", /obj/item/stack/ore/glass, 1, one_per_turf = FALSE, on_solid_ground = TRUE, category = CAT_MISC) \
	))

/obj/item/stack/sheet/mineral/sandstone
	name = "Кирпич из песчаника"
	desc = "Кажется, это комбинация из песка и камня."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	inhand_icon_state = null
	throw_speed = 3
	throw_range = 5
	mats_per_unit = list(/datum/material/sandstone=SHEET_MATERIAL_AMOUNT)
	sheettype = "sandstone"
	merge_type = /obj/item/stack/sheet/mineral/sandstone
	walltype = /turf/closed/wall/mineral/sandstone
	material_type = /datum/material/sandstone

/obj/item/stack/sheet/mineral/sandstone/get_main_recipes()
	. = ..()
	. += GLOB.sandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/thirty
	amount = 30

/*
 * Sandbags
 */

/obj/item/stack/sheet/mineral/sandbags
	name = "Мешки с песком"
	icon_state = "sandbags"
	singular_name = "Мешок с песком"
	layer = LOW_ITEM_LAYER
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/mineral/sandbags

GLOBAL_LIST_INIT(sandbag_recipes, list ( \
	new/datum/stack_recipe("мешки с песком", /obj/structure/barricade/sandbags, 1, time = 3 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	))

/obj/item/stack/sheet/mineral/sandbags/get_main_recipes()
	. = ..()
	. += GLOB.sandbag_recipes

/obj/item/emptysandbag
	name = "пустой мешок для песка"
	desc = "Мешок для песка."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "sandbag"
	w_class = WEIGHT_CLASS_TINY

/obj/item/emptysandbag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/glass/G = W
		to_chat(user, span_notice("Наполняю мешок с песком."))
		var/obj/item/stack/sheet/mineral/sandbags/I = new /obj/item/stack/sheet/mineral/sandbags(drop_location())
		qdel(src)
		if (Adjacent(user) && !issilicon(user))
			user.put_in_hands(I)
		G.use(1)
	else
		return ..()

/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "алмаз"
	icon_state = "sheet-diamond"
	inhand_icon_state = "sheet-diamond"
	singular_name = "алмаз"
	sheettype = "diamond"
	mats_per_unit = list(/datum/material/diamond=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/carbon = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/diamond
	material_type = /datum/material/diamond
	walltype = /turf/closed/wall/mineral/diamond

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("Алмазная дверь", /obj/structure/mineral_door/transparent/diamond, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Алмазная плитка", /obj/item/stack/tile/mineral/diamond, 1, 4, 20, check_density = FALSE, category = CAT_TILES),  \
	))

/obj/item/stack/sheet/mineral/diamond/get_main_recipes()
	. = ..()
	. += GLOB.diamond_recipes

/*
 * Uranium
 */
/obj/item/stack/sheet/mineral/uranium
	name = "уран"
	icon_state = "sheet-uranium"
	inhand_icon_state = "sheet-uranium"
	singular_name = "урановый лист"
	sheettype = "uranium"
	mats_per_unit = list(/datum/material/uranium=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/uranium
	material_type = /datum/material/uranium
	walltype = /turf/closed/wall/mineral/uranium

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("Урановая дверь", /obj/structure/mineral_door/uranium, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Урановая плитка", /obj/item/stack/tile/mineral/uranium, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/uranium/get_main_recipes()
	. = ..()
	. += GLOB.uranium_recipes

/obj/item/stack/sheet/mineral/uranium/five
	amount = 5

/obj/item/stack/sheet/mineral/uranium/half
	amount = 25

/*
 * Plasma
 */
/obj/item/stack/sheet/mineral/plasma
	name = "твердая плазма"
	icon_state = "sheet-plasma"
	inhand_icon_state = "sheet-plasma"
	singular_name = "лист плазмы"
	sheettype = "plasma"
	resistance_flags = FLAMMABLE
	max_integrity = 100
	mats_per_unit = list(/datum/material/plasma=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/plasma = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/plasma
	material_type = /datum/material/plasma
	walltype = /turf/closed/wall/mineral/plasma

/obj/item/stack/sheet/mineral/plasma/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] начинает облизывать <b>[src.name]</b>! Похоже [user.p_theyre()] пытается совершить самоубийство!"))
	return TOXLOSS//dont you kids know that stuff is toxic?

GLOBAL_LIST_INIT(plasma_recipes, list ( \
	new/datum/stack_recipe("Плазменная дверь", /obj/structure/mineral_door/transparent/plasma, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Плазменная плитка", /obj/item/stack/tile/mineral/plasma, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/plasma/get_main_recipes()
	. = ..()
	. += GLOB.plasma_recipes

/obj/item/stack/sheet/mineral/plasma/five
	amount = 5

/obj/item/stack/sheet/mineral/plasma/thirty
	amount = 30

/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "золото"
	icon_state = "sheet-gold"
	inhand_icon_state = "sheet-gold"
	singular_name = "золотой слиток"
	sheettype = "gold"
	mats_per_unit = list(/datum/material/gold=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/gold
	material_type = /datum/material/gold
	walltype = /turf/closed/wall/mineral/gold

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("Золотая дверь", /obj/structure/mineral_door/gold, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Золотая плитка", /obj/item/stack/tile/mineral/gold, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	new/datum/stack_recipe("Пустая табличка", /obj/item/plaque, 1, check_density = FALSE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("Обычная корона", /obj/item/clothing/head/costume/crown, 5, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/mineral/gold/get_main_recipes()
	. = ..()
	. += GLOB.gold_recipes

/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "серебро"
	icon_state = "sheet-silver"
	inhand_icon_state = "sheet-silver"
	singular_name = "серебряный слиток"
	sheettype = "silver"
	mats_per_unit = list(/datum/material/silver=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/silver = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/silver
	material_type = /datum/material/silver
	tableVariant = /obj/structure/table/optable
	walltype = /turf/closed/wall/mineral/silver

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("Серебряная дверь", /obj/structure/mineral_door/silver, 10, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, applies_mats = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Серебряная плитка", /obj/item/stack/tile/mineral/silver, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/silver/get_main_recipes()
	. = ..()
	. += GLOB.silver_recipes

/*
 * Clown
 */
/obj/item/stack/sheet/mineral/bananium
	name = "бананиум"
	icon_state = "sheet-bananium"
	inhand_icon_state = null
	singular_name = "лист бананиума"
	sheettype = "bananium"
	mats_per_unit = list(/datum/material/bananium=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/consumable/banana = 20)
	point_value = 50
	merge_type = /obj/item/stack/sheet/mineral/bananium
	material_type = /datum/material/bananium
	walltype = /turf/closed/wall/mineral/bananium

GLOBAL_LIST_INIT(bananium_recipes, list ( \
	new/datum/stack_recipe("Бананиевая плитка", /obj/item/stack/tile/mineral/bananium, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/bananium/get_main_recipes()
	. = ..()
	. += GLOB.bananium_recipes

/obj/item/stack/sheet/mineral/bananium/five
	amount = 5

/*
 * Titanium
 */
/obj/item/stack/sheet/mineral/titanium
	name = "титан"
	icon_state = "sheet-titanium"
	inhand_icon_state = "sheet-titanium"
	singular_name = "лист титана"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "titanium"
	mats_per_unit = list(/datum/material/titanium=SHEET_MATERIAL_AMOUNT)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/titanium
	material_type = /datum/material/titanium
	walltype = /turf/closed/wall/mineral/titanium

GLOBAL_LIST_INIT(titanium_recipes, list ( \
	new/datum/stack_recipe("Титановая плитка", /obj/item/stack/tile/mineral/titanium, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	new/datum/stack_recipe("Сиденье для шаттла", /obj/structure/chair/comfy/shuttle, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/mineral/titanium/get_main_recipes()
	. = ..()
	. += GLOB.titanium_recipes

/obj/item/stack/sheet/mineral/titanium/fifty
	amount = 50

/*
 * Plastitanium
 */
/obj/item/stack/sheet/mineral/plastitanium
	name = "пластитан"
	desc = "Пластитан является сплавом титана и плазмы. Довольно крепкий, однако из за новизны ученые еще не спроектировали основные производственные чертежи."
	icon_state = "sheet-plastitanium"
	inhand_icon_state = "sheet-plastitanium"
	singular_name = "лист пластитаниума"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "plastitanium"
	mats_per_unit = list(/datum/material/alloy/plastitanium=SHEET_MATERIAL_AMOUNT)
	point_value = 45
	material_type = /datum/material/alloy/plastitanium
	merge_type = /obj/item/stack/sheet/mineral/plastitanium
	material_flags = NONE
	walltype = /turf/closed/wall/mineral/plastitanium

GLOBAL_LIST_INIT(plastitanium_recipes, list ( \
	new/datum/stack_recipe("Пластитаниумная плитка", /obj/item/stack/tile/mineral/plastitanium, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/plastitanium/get_main_recipes()
	. = ..()
	. += GLOB.plastitanium_recipes


/*
 * Snow
 */

/obj/item/stack/sheet/mineral/snow
	name = "снег"
	icon_state = "sheet-snow"
	inhand_icon_state = null
	mats_per_unit = list(/datum/material/snow = SHEET_MATERIAL_AMOUNT)
	singular_name = "блок снега"
	force = 1
	throwforce = 2
	grind_results = list(/datum/reagent/consumable/ice = 20)
	merge_type = /obj/item/stack/sheet/mineral/snow
	walltype = /turf/closed/wall/mineral/snow
	material_type = /datum/material/snow

GLOBAL_LIST_INIT(snow_recipes, list ( \
	new/datum/stack_recipe("стена из снега", /turf/closed/wall/mineral/snow, 5, time = 4 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("снеговик", /obj/structure/statue/snow/snowman, 5, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("снежок", /obj/item/toy/snowball, 1, check_density = FALSE, category = CAT_WEAPON_RANGED), \
	new/datum/stack_recipe("снежный пол", /obj/item/stack/tile/mineral/snow, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
))

/obj/item/stack/sheet/mineral/snow/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddComponent(/datum/component/storm_hating)

/obj/item/stack/sheet/mineral/snow/get_main_recipes()
	. = ..()
	. += GLOB.snow_recipes

/****************************** Others ****************************/

/*
 * Adamantine
*/


GLOBAL_LIST_INIT(adamantine_recipes, list(
	new /datum/stack_recipe("незаконченная оболочка голема-слуги", /obj/item/golem_shell/servant, req_amount=1, res_amount=1, category = CAT_ROBOT),
	))

/obj/item/stack/sheet/mineral/adamantine
	name = "адамантий"
	icon_state = "sheet-adamantine"
	inhand_icon_state = "sheet-adamantine"
	singular_name = "лист адамантия"
	mats_per_unit = list(/datum/material/adamantine=SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/adamantine

/obj/item/stack/sheet/mineral/adamantine/get_main_recipes()
	. = ..()
	. += GLOB.adamantine_recipes

/*
 * Runite
 */

/obj/item/stack/sheet/mineral/runite
	name = "Рунит"
	desc = "Редкий материал найденный в далеких краях."
	singular_name = "рунитовый слиток"
	icon_state = "sheet-runite"
	inhand_icon_state = "sheet-runite"
	mats_per_unit = list(/datum/material/runite=SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/runite
	material_type = /datum/material/runite


/*
 * Mythril
 */
/obj/item/stack/sheet/mineral/mythril
	name = "мифрил"
	icon_state = "sheet-mythril"
	inhand_icon_state = "sheet-mythril"
	singular_name = "лист мифрила"
	novariants = TRUE
	mats_per_unit = list(/datum/material/mythril=SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/mythril

/*
 * Alien Alloy
 */
/obj/item/stack/sheet/mineral/abductor
	name = "инопланетный сплав"
	desc = "Загадочный материал с неизведанными свойствами."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "sheet-abductor"
	inhand_icon_state = "sheet-abductor"
	singular_name = "лист инопланетного сплава"
	sheettype = "abductor"
	mats_per_unit = list(/datum/material/alloy/alien=SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/abductor
	material_type = /datum/material/alloy/alien
	walltype = /turf/closed/wall/mineral/abductor

GLOBAL_LIST_INIT(abductor_recipes, list ( \
	new/datum/stack_recipe("инопланетная кровать", /obj/structure/bed/abductor, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("инопланетный шкафчик", /obj/structure/closet/abductor, 2, time = 2 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("инопланетная рама стола", /obj/structure/table_frame/abductor, 1, time = 2 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("сборка инопланетного шлюза", /obj/structure/door_assembly/door_assembly_abductor, 4, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	null, \
	new/datum/stack_recipe("инопланетная плитка пола", /obj/item/stack/tile/mineral/abductor, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/abductor/get_main_recipes()
	. = ..()
	. += GLOB.abductor_recipes

/*
 * Coal
 */

/obj/item/stack/sheet/mineral/coal
	name = "уголь"
	desc = "Черный как негр."
	icon = 'icons/obj/ore.dmi'
	icon_state = "slag"
	singular_name = "кусок угля"
	merge_type = /obj/item/stack/sheet/mineral/coal
	grind_results = list(/datum/reagent/carbon = 20)
	novariants = TRUE

/obj/item/stack/sheet/mineral/coal/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Coal ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		user.log_message("ignited coal", LOG_GAME)
		fire_act(W.get_temperature())
		return TRUE
	else
		return ..()

/obj/item/stack/sheet/mineral/coal/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("[GAS_CO2]=[amount*10];[TURF_TEMPERATURE(exposed_temperature)]")
	qdel(src)

/obj/item/stack/sheet/mineral/coal/five
	amount = 5

/obj/item/stack/sheet/mineral/coal/ten
	amount = 10

//Metal Hydrogen
GLOBAL_LIST_INIT(metalhydrogen_recipes, list(
	new /datum/stack_recipe("незаконченная оболочка голема-слуги", /obj/item/golem_shell/servant, req_amount=20, res_amount=1, check_density = FALSE, category = CAT_ROBOT),
	new /datum/stack_recipe("древняя броня", /obj/item/clothing/suit/armor/elder_atmosian, req_amount = 5, res_amount = 1, check_density = FALSE, category = CAT_CLOTHING),
	new /datum/stack_recipe("древний шлем", /obj/item/clothing/head/helmet/elder_atmosian, req_amount = 3, res_amount = 1, check_density = FALSE, category = CAT_CLOTHING),
	new /datum/stack_recipe("топор из металлического водорода", /obj/item/fireaxe/metal_h2_axe, req_amount = 15, res_amount = 1, check_density = FALSE, category = CAT_WEAPON_MELEE),
	))

/obj/item/stack/sheet/mineral/metal_hydrogen
	name = "металлический водород"
	icon_state = "sheet-metalhydrogen"
	inhand_icon_state = null
	singular_name = "лист металлического водорода"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE
	point_value = 100
	mats_per_unit = list(/datum/material/metalhydrogen = SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/metalhydrogen
	merge_type = /obj/item/stack/sheet/mineral/metal_hydrogen

/obj/item/stack/sheet/mineral/metal_hydrogen/get_main_recipes()
	. = ..()
	. += GLOB.metalhydrogen_recipes

/obj/item/stack/sheet/mineral/zaukerite
	name = "Заукерит"
	icon_state = "zaukerite"
	inhand_icon_state = "sheet-zaukerite"
	singular_name = "заукерит"
	w_class = WEIGHT_CLASS_NORMAL
	point_value = 120
	mats_per_unit = list(/datum/material/zaukerite = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/zaukerite
	material_type = /datum/material/zaukerite
