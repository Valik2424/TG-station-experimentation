/* Diffrent misc types of sheets
 * Contains:
 * Iron
 * Plasteel
 * Wood
 * Cloth
 * Plastic
 * Cardboard
 * Paper Frames
 * Runed Metal (cult)
 * Bronze (bake brass)
 */

/*
 * Iron
 */
GLOBAL_LIST_INIT(metal_recipes, list ( \
	new/datum/stack_recipe("Табурет", /obj/structure/chair/stool, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("барный стул", /obj/structure/chair/stool/bar, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("кровать", /obj/structure/bed, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("двухспальная кровать", /obj/structure/bed/double, 4, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe_list("офисные кресла", list( \
		new/datum/stack_recipe("темное офисное кресло", /obj/structure/chair/office, 5, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new/datum/stack_recipe("светлое офисное кресло", /obj/structure/chair/office/light, 5, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("удобные стулья", list( \
		new/datum/stack_recipe("бежевое кресло", /obj/structure/chair/comfy/beige, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new/datum/stack_recipe("чёрное кресло", /obj/structure/chair/comfy/black, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new/datum/stack_recipe("коричневое кресло", /obj/structure/chair/comfy/brown, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new/datum/stack_recipe("лаймовое кресло", /obj/structure/chair/comfy/lime, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new/datum/stack_recipe("бирюзовое кресло", /obj/structure/chair/comfy/teal, 2, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("диваны", list(
		new /datum/stack_recipe("диван (центральный)", /obj/structure/chair/sofa/middle, 1, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("диван (левый)", /obj/structure/chair/sofa/left, 1, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("диван (правый)", /obj/structure/chair/sofa/right, 1, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("диван (угловой)", /obj/structure/chair/sofa/corner, 1, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE)
		)), \
	new/datum/stack_recipe_list("корпоративные диваны", list( \
		new /datum/stack_recipe("диван (центральный)", /obj/structure/chair/sofa/corp, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (левый)", /obj/structure/chair/sofa/corp/left, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (правый)", /obj/structure/chair/sofa/corp/right, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (угловой)", /obj/structure/chair/sofa/corp/corner, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		)), \
	new /datum/stack_recipe_list("скамейки", list( \
		new /datum/stack_recipe("скамейка (центр)", /obj/structure/chair/sofa/bench, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамейка (левая)", /obj/structure/chair/sofa/bench/left, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамейка (правая)", /obj/structure/chair/sofa/bench/right, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамейка (угол)", /obj/structure/chair/sofa/bench/corner, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
		)), \
	new /datum/stack_recipe_list("шахматные фигуры", list( \
		new /datum/stack_recipe("Белая пешка", /obj/structure/chess/whitepawn, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белая ладья", /obj/structure/chess/whiterook, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белый конь", /obj/structure/chess/whiteknight, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белый слон", /obj/structure/chess/whitebishop, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белый ферзь", /obj/structure/chess/whitequeen, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белый король", /obj/structure/chess/whiteking, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрная пешка", /obj/structure/chess/blackpawn, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрная ладья", /obj/structure/chess/blackrook, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрный конь", /obj/structure/chess/blackknight, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрный слон", /obj/structure/chess/blackbishop, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрный ферзь", /obj/structure/chess/blackqueen, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрный король", /obj/structure/chess/blackking, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
	)),
	new /datum/stack_recipe_list("фигуры шашки", list( \
		new /datum/stack_recipe("Белая шашка", /obj/structure/chess/checker/whiteman, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Белая королева", /obj/structure/chess/checker/whiteking, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрная шашка", /obj/structure/chess/checker/blackman, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Чёрная королева", /obj/structure/chess/checker/blackking, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ENTERTAINMENT), \
	)),
	null, \
	new/datum/stack_recipe("части стойки", /obj/item/rack_parts, category = CAT_FURNITURE), \
	new/datum/stack_recipe("шкаф", /obj/structure/closet, 2, time = 1.5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe("каркас канистры", /obj/machinery/portable_atmospherics/canister, 10, time = 3 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_ATMOSPHERIC), \
	null, \
	new/datum/stack_recipe("плитка для пола", /obj/item/stack/tile/iron/base, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("желез. стержень", /obj/item/stack/rods, 1, 2, 60, category = CAT_MISC), \
	null, \
	new/datum/stack_recipe("каркас стены", /obj/structure/girder, 2, time = 4 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, placement_checks = STACK_CHECK_TRAM_FORBIDDEN, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	null, \
	null, \
	new/datum/stack_recipe("компьютерный каркас", /obj/structure/frame/computer, 5, time = 2.5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("модульная консоль", /obj/machinery/modular_computer, 10, time = 2.5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("каркас машины", /obj/structure/frame/machine, 5, time = 2.5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_EQUIPMENT), \
	null, \
	new /datum/stack_recipe_list("каркас шлюза", list( \
		new /datum/stack_recipe("каркас стандартного шлюза", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас публичного шлюза", /obj/structure/door_assembly/door_assembly_public, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас командного шлюза", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас шлюза службы безопасности", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас инженерного шлюза", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас шахтерского шлюза", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас атмосферного шлюза", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас шлюза отдела исследований", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас морозильного шлюза ", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас шлюза научного отдела", /obj/structure/door_assembly/door_assembly_science, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас медицинского шлюза", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас шлюза вирусологии", /obj/structure/door_assembly/door_assembly_viro, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас технического шлюза", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас внешнего шлюза", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас внешнего технического шлюза", /obj/structure/door_assembly/door_assembly_extmai, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас герметичного люка", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
		new /datum/stack_recipe("каркас технического люка", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_solid_ground = 1, category = CAT_DOORS), \
	)), \
	null, \
	new/datum/stack_recipe("каркас пожарного шлюза", /obj/structure/firelock_frame, 3, time = 50, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("каркас турели", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("крюк для разделывания", /obj/structure/kitchenspike_frame, 5, time = 25, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("каркас отражателя", /obj/structure/reflector, 5, time = 25, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("корпус гранаты", /obj/item/grenade/chem_grenade), \
	new/datum/stack_recipe("каркас для лампы дневного света", /obj/item/wallframe/light_fixture, 2, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас для маленькой лампочки", /obj/item/wallframe/light_fixture/small, 1, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас для прожектора", /obj/structure/floodlight_frame, 5, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("рама АПЦ", /obj/item/wallframe/apc, 2, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("рама контроллера воздуха", /obj/item/wallframe/airalarm, 2, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("рама пожарной тревоги", /obj/item/wallframe/firealarm, 2, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("рама для кнопки", /obj/item/wallframe/button, 1, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("рама настенной вспышки", /obj/item/wallframe/flasher, 1, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("шкафчик для огнетушителя", /obj/item/wallframe/extinguisher_cabinet, 2), \
	null, \
	new/datum/stack_recipe("железная дверь", /obj/structure/mineral_door/iron, 20, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("картотека", /obj/structure/filingcabinet, 2, time = 10 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("звонок", /obj/structure/desk_bell, 2, time = 3 SECONDS, category = CAT_FURNITURE), \
	new/datum/stack_recipe("ящик для голосования", /obj/structure/votebox, 15, time = 50, category = CAT_FURNITURE), \
	new/datum/stack_recipe("пестик", /obj/item/pestle, 1, time = 50, category = CAT_TOOLS), \
	new/datum/stack_recipe("каркас гигиенобота", /obj/item/bot_assembly/hygienebot, 2, time = 5 SECONDS, category = CAT_ROBOT), \
	new/datum/stack_recipe("каркас душа", /obj/structure/showerframe, 2, time= 2 SECONDS, category = CAT_FURNITURE), \
))

/obj/item/stack/sheet/iron
	name = "железо"
	desc = "Листы из железа."
	singular_name = "лист железа"
	icon_state = "sheet-metal"
	inhand_icon_state = "sheet-metal"
	mats_per_unit = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	throwforce = 10
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/iron
	grind_results = list(/datum/reagent/iron = 20)
	point_value = 2
	tableVariant = /obj/structure/table
	material_type = /datum/material/iron
	matter_amount = 4
	cost = SHEET_MATERIAL_AMOUNT
	source = /datum/robot_energy_storage/material/iron
	stairs_type = /obj/structure/stairs
	sniffable = TRUE

/obj/item/stack/sheet/iron/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Craft iron rods",
			SCREENTIP_CONTEXT_RMB = "Craft floor tiles",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/stack/sheet/iron/examine(mob/user)
	. = ..()
	. += span_notice("You can build a wall girder (unanchored) by right clicking on an empty floor.")

/obj/item/stack/sheet/iron/narsie_act()
	new /obj/item/stack/sheet/runed_metal(loc, amount)
	qdel(src)

/obj/item/stack/sheet/iron/fifty
	amount = 50

/obj/item/stack/sheet/iron/twenty
	amount = 20

/obj/item/stack/sheet/iron/ten
	amount = 10

/obj/item/stack/sheet/iron/five
	amount = 5

/obj/item/stack/sheet/iron/get_main_recipes()
	. = ..()
	. += GLOB.metal_recipes

/obj/item/stack/sheet/iron/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] начинает лупить [user.ru_na()]себя по голове <b>[src.name]</b>! Похоже на то, что [user.p_theyre()] пытается покончить с собой!"))
	return BRUTELOSS

/obj/item/stack/sheet/iron/welder_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/rods/two/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into floor rods with [tool]."),
			blind_message = span_hear("You hear welding."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/stack/sheet/iron/welder_act_secondary(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/tile/iron/four/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into floor tiles with [tool]."),
			blind_message = span_hear("You hear welding."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/stack/sheet/iron/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if(isopenturf(target))
		var/turf/open/build_on = target
		if(!user.Adjacent(build_on))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(isgroundlessturf(build_on))
			user.balloon_alert(user, "can't place it here!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(build_on.is_blocked_turf())
			user.balloon_alert(user, "something is blocking the tile!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(get_amount() < 2)
			user.balloon_alert(user, "not enough material!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(!do_after(user, 4 SECONDS, build_on))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(build_on.is_blocked_turf())
			user.balloon_alert(user, "something is blocking the tile!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(!use(2))
			user.balloon_alert(user, "not enough material!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		new/obj/structure/girder/displaced(build_on)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/*
 * Plasteel
 */
GLOBAL_LIST_INIT(plasteel_recipes, list ( \
	new/datum/stack_recipe("ядро ИИ", /obj/structure/ai_core, 4, time = 5 SECONDS, one_per_turf = TRUE, check_density = FALSE, category = CAT_ROBOT),
	new/datum/stack_recipe("сборка бомбы", /obj/machinery/syndicatebomb/empty, 10, time = 5 SECONDS, check_density = FALSE, category = CAT_CHEMISTRY),
	null,
	new /datum/stack_recipe_list("Бронешлюзы", list( \
		new/datum/stack_recipe("Каркас укрепленного шлюза", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS),
		new/datum/stack_recipe("Каркас двери хранилища", /obj/structure/door_assembly/door_assembly_vault, 6, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS),
	)), \
))

/obj/item/stack/sheet/plasteel
	name = "пласталь"
	singular_name = "лист пластали"
	desc = "Пласталь является сплавом железа и плазмы. Благодаря отличной прочности и недороговизне этот новомодный сплав завоевал сердца многих инженеров."
	icon_state = "sheet-plasteel"
	inhand_icon_state = "sheet-plasteel"
	mats_per_unit = list(/datum/material/alloy/plasteel=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasteel
	throwforce = 10
	flags_1 = CONDUCT_1
	armor_type = /datum/armor/sheet_plasteel
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/plasteel
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/toxin/plasma = 20)
	point_value = 23
	tableVariant = /obj/structure/table/reinforced
	material_flags = NONE
	matter_amount = 12

/datum/armor/sheet_plasteel
	fire = 100
	acid = 80

/obj/item/stack/sheet/plasteel/get_main_recipes()
	. = ..()
	. += GLOB.plasteel_recipes

/obj/item/stack/sheet/plasteel/twenty
	amount = 20

/obj/item/stack/sheet/plasteel/fifty
	amount = 50

/*
 * Wood
 */
GLOBAL_LIST_INIT(wood_recipes, list ( \
	new/datum/stack_recipe("деревянные сандалии", /obj/item/clothing/shoes/sandal, 1, category = CAT_CLOTHING), \
	new/datum/stack_recipe("деревянный пол", /obj/item/stack/tile/wood, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("деревянный корпус стола", /obj/structure/table_frame/wood, 2, time = 10, category = CAT_FURNITURE), \
	new/datum/stack_recipe("приклад винтовки", /obj/item/weaponcrafting/stock, 10, time = 40, category = CAT_MISC), \
	new/datum/stack_recipe("скалка", /obj/item/kitchen/rollingpin, 2, time = 30, category = CAT_TOOLS), \
	new/datum/stack_recipe("деревянный стул", /obj/structure/chair/wood/, 3, time = 10, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("крылатый стул", /obj/structure/chair/wood/wings, 3, time = 10, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянная застава", /obj/structure/barricade/wooden, 5, time = 50, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянная дверь", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("гроб", /obj/structure/closet/crate/coffin, 5, time = 15, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("книжный шкаф", /obj/structure/bookcase, 4, time = 15, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("сушилка", /obj/machinery/smartfridge/drying_rack, 10, time = 15, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянная бочка", /obj/structure/fermenting_barrel, 8, time = 50, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("собачья кровать", /obj/structure/bed/dogbed, 10, time = 10, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("комод", /obj/structure/dresser, 10, time = 15, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("рамка для фотографии", /obj/item/wallframe/picture, 1, time = 10, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("рамка для рисунка", /obj/item/wallframe/painting, 1, time = 10, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("стенд шасси", /obj/structure/displaycase_chassis, 5, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("пчельник", /obj/structure/beebox, 40, time = 50, category = CAT_FURNITURE),\
	new/datum/stack_recipe("маска Тики", /obj/item/clothing/mask/gas/tiki_mask, 2, category = CAT_CLOTHING), \
	new/datum/stack_recipe("рамка для меда", /obj/item/honey_frame, 5, time = 10, category = CAT_FURNITURE),\
	new/datum/stack_recipe("грабли", /obj/item/cultivator/rake, 5, time = 10, category = CAT_TOOLS),\
	new/datum/stack_recipe("ящик для руды", /obj/structure/ore_box, 4, time = 50, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_TOOLS),\
	new/datum/stack_recipe("деревянный ящик", /obj/structure/closet/crate/wooden, 6, time = 50, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_TOOLS),\
	new/datum/stack_recipe("бейсбольная бита", /obj/item/melee/baseball_bat, 5, time = 15, category = CAT_FURNITURE),\
	new/datum/stack_recipe("ткацкий станок", /obj/structure/loom, 10, time = 15, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_TOOLS), \
	new/datum/stack_recipe("головешка", /obj/item/match/firebrand, 2, time = 100, category = CAT_TOOLS), \
	null, \
	new/datum/stack_recipe_list("церковные скамьи", list(
		new /datum/stack_recipe("скамья (центральная)", /obj/structure/chair/pew, 3, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("скамья (левая)", /obj/structure/chair/pew/left, 3, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("скамья (правая)", /obj/structure/chair/pew/right, 3, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE)
		)),
	null, \
	))

/obj/item/stack/sheet/mineral/wood
	name = "деревянные доски"
	desc = "Можно лишь предположить что это куча дерева."
	singular_name = "деревянная доска"
	icon_state = "sheet-wood"
	inhand_icon_state = "sheet-wood"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/wood=SHEET_MATERIAL_AMOUNT)
	sheettype = "wood"
	armor_type = /datum/armor/mineral_wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/wood
	material_type = /datum/material/wood
	grind_results = list(/datum/reagent/cellulose = 20) //no lignocellulose or lignin reagents yet,
	walltype = /turf/closed/wall/mineral/wood
	stairs_type = /obj/structure/stairs/wood

/datum/armor/mineral_wood
	fire = 50

/obj/item/stack/sheet/mineral/wood/get_main_recipes()
	. = ..()
	. += GLOB.wood_recipes

/obj/item/stack/sheet/mineral/wood/fifty
	amount = 50

/*
 * Bamboo
 */

GLOBAL_LIST_INIT(bamboo_recipes, list ( \
	new/datum/stack_recipe("ловушка волчья яма", /obj/structure/punji_sticks, 5, time = 3 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("бамбуковое копьё", /obj/item/spear/bamboospear, 25, time = 9 SECONDS, check_density = FALSE, category = CAT_WEAPON_MELEE), \
	new/datum/stack_recipe("духовая трубка", /obj/item/gun/syringe/blowgun, 10, time = 7 SECONDS, check_density = FALSE, category = CAT_WEAPON_RANGED), \
	new/datum/stack_recipe("примитивный шприц", /obj/item/reagent_containers/syringe/crude, 5, time = 1 SECONDS, check_density = FALSE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("рисовая шляпа", /obj/item/clothing/head/costume/rice_hat, 10, time = 7 SECONDS, check_density = FALSE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("бамбуковый стул", /obj/structure/chair/stool/bamboo, 2, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("бамбуковый пол", /obj/item/stack/tile/bamboo, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	null, \
	new/datum/stack_recipe_list("бамбуковая скамья", list(
		new /datum/stack_recipe("бамбуковая скамейка (центр)", /obj/structure/chair/sofa/bamboo, 3, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("бамбуковая скамейка (левая)", /obj/structure/chair/sofa/bamboo/left, 3, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE),
		new /datum/stack_recipe("бамбуковая скамейка (правая)", /obj/structure/chair/sofa/bamboo/right, 3, time = 1 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE)
		)),	\
	))

/obj/item/stack/sheet/mineral/bamboo
	name = "черенки бамбука"
	desc = "Мелко нарезанные бамбуковые палочки."
	singular_name = "обрезанная бамбуковая палочка"
	icon_state = "sheet-bamboo"
	inhand_icon_state = "sheet-bamboo"
	icon = 'icons/obj/stack_objects.dmi'
	sheettype = "bamboo"
	mats_per_unit = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT)
	throwforce = 15
	armor_type = /datum/armor/mineral_bamboo
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/bamboo
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/bamboo
	walltype = /turf/closed/wall/mineral/bamboo

/datum/armor/mineral_bamboo
	fire = 50

/obj/item/stack/sheet/mineral/bamboo/get_main_recipes()
	. = ..()
	. += GLOB.bamboo_recipes

/obj/item/stack/sheet/mineral/bamboo/fifty
	amount = 50

/*
 * Cloth
 */
GLOBAL_LIST_INIT(cloth_recipes, list ( \
	new/datum/stack_recipe("белый юбкомбез", /obj/item/clothing/under/color/jumpskirt/white, 3, check_density = FALSE, category = CAT_CLOTHING), /*Ladies first*/ \
	new/datum/stack_recipe("белый комбинезон", /obj/item/clothing/under/color/white, 3, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белые ботинки", /obj/item/clothing/shoes/sneakers/white, 2, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белый шарф", /obj/item/clothing/neck/scarf, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая бандана", /obj/item/clothing/mask/bandana/white, 2, check_density = FALSE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("рюкзак", /obj/item/storage/backpack, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка", /obj/item/storage/backpack/satchel, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("вещмешок", /obj/item/storage/backpack/duffelbag, 6, check_density = FALSE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("сумка для растений", /obj/item/storage/bag/plants, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для книг", /obj/item/storage/bag/books, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("ранец шахтёра", /obj/item/storage/bag/ore, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для химикатов", /obj/item/storage/bag/chemistry, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для био. образцов", /obj/item/storage/bag/bio, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("научная сумка", /obj/item/storage/bag/xeno, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("строительная сумка", /obj/item/storage/bag/construction, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("импровизированная марля", /obj/item/stack/medical/gauze/improvised, 1, 2, 6, check_density = FALSE, category = CAT_TOOLS), \
	new/datum/stack_recipe("тряпка", /obj/item/reagent_containers/cup/rag, 1, check_density = FALSE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("простыня", /obj/item/bedsheet, 3, check_density = FALSE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("двойная простыня", /obj/item/bedsheet/double, 6, check_density = FALSE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("пустой мешок дял песка", /obj/item/emptysandbag, 4, check_density = FALSE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("перчатки без пальцев", /obj/item/clothing/gloves/fingerless, 1, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белый перчатки", /obj/item/clothing/gloves/color/white, 3, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая кепка", /obj/item/clothing/head/soft/mime, 2, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая шапочка", /obj/item/clothing/head/beanie, 2, check_density = FALSE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("повязка на глаза", /obj/item/clothing/glasses/blindfold, 2, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	null, \
	new/datum/stack_recipe("19x19 canvas", /obj/item/canvas/nineteen_nineteen, 3, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("23x19 canvas", /obj/item/canvas/twentythree_nineteen, 4, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("23x23 canvas", /obj/item/canvas/twentythree_twentythree, 5, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("pillow", /obj/item/pillow, 3, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/cloth
	name = "ткань"
	desc = "Это хлопок? Лен? Джинса? Мешковина? Канва? Не могу сказать."
	singular_name = "рулон ткани"
	icon_state = "sheet-cloth"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cloth
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	grind_results = list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += GLOB.cloth_recipes

/obj/item/stack/sheet/cloth/ten
	amount = 10

/obj/item/stack/sheet/cloth/five
	amount = 5

GLOBAL_LIST_INIT(durathread_recipes, list ( \
	new/datum/stack_recipe("дюратканевый комбинезон", /obj/item/clothing/under/misc/durathread, 4, time = 4 SECONDS, check_density = FALSE, category = CAT_CLOTHING),
	new/datum/stack_recipe("дюратканевый берет", /obj/item/clothing/head/beret/durathread, 2, time = 4 SECONDS, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("дюратканевая шапочка", /obj/item/clothing/head/beanie/durathread, 2, time = 4 SECONDS, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("дюратканевая бандана", /obj/item/clothing/mask/bandana/durathread, 1, time = 2.5 SECONDS, check_density = FALSE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/durathread
	name = "дюраткань"
	desc = "Ткань сшитая из невероятно прочных нитей, часто полезна при производстве брони."
	singular_name = "дюратканевый рулон"
	icon_state = "sheet-durathread"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/durathread
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'

/obj/item/stack/sheet/durathread/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/durathread_helmet, /datum/crafting_recipe/durathread_vest)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/durathread/get_main_recipes()
	. = ..()
	. += GLOB.durathread_recipes

/obj/item/stack/sheet/durathread/on_item_crafted(mob/builder, atom/created)
	created.set_armor_rating(CONSUME, max(50, created.get_armor_rating(CONSUME)))

/obj/item/stack/sheet/cotton
	name = "пучок необработанного хлопка"
	desc = "Куча необработанного хлопка готовая к пряже на ткакцом станке."
	singular_name = "шарик хлопка-сырца"
	icon_state = "sheet-cotton"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cotton
	grind_results = list(/datum/reagent/cellulose = 20)
	var/loom_result = /obj/item/stack/sheet/cloth
	var/loom_time = 1 SECONDS

/obj/item/stack/sheet/cotton/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/loomable, resulting_atom = loom_result, loom_time = loom_time)

/obj/item/stack/sheet/cotton/durathread
	name = "пучок необработанной дюраткани"
	desc = "Куча необработанной дюраткани готовая к пряже на ткацком станке."
	singular_name = "шарик необработанной дюраткани"
	icon_state = "sheet-durathreadraw"
	merge_type = /obj/item/stack/sheet/cotton/durathread
	grind_results = list()
	loom_result = /obj/item/stack/sheet/durathread

/obj/item/stack/sheet/cotton/wool
	name = "пучок необработанной шерсти"
	desc = "Куча необработанной шерсти готовая к пряже на ткацком станке."
	singular_name = "шарик необработанной шерсти"
	icon_state = "sheet-wool"
	merge_type = /obj/item/stack/sheet/cotton/wool
	grind_results = list()
	loom_result = /obj/item/stack/sheet/cloth

/*
 * Cardboard
 */
GLOBAL_LIST_INIT(cardboard_recipes, list ( \
	new/datum/stack_recipe("коробка", /obj/item/storage/box, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("костюм картонного киборга", /obj/item/clothing/suit/costume/cardborg, 3, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("шлем картонного киборга", /obj/item/clothing/head/costume/cardborg, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("большая коробка", /obj/structure/closet/cardboard, 4, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("картонная фигурка", /obj/item/cardboard_cutout, 5, check_density = FALSE, category = CAT_ENTERTAINMENT), \
	null, \

	new/datum/stack_recipe("коробка из под пиццы", /obj/item/pizzabox, check_density = FALSE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("папка", /obj/item/folder, check_density = FALSE, category = CAT_CONTAINERS), \
	null, \
	//TO-DO: Find a proper way to just change the illustration on the box. Code isn't the issue, input is.
	new/datum/stack_recipe_list("необычные коробки", list(
		new /datum/stack_recipe("коробка для пончиков", /obj/item/storage/fancy/donut_box, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для яиц", /obj/item/storage/fancy/egg_box, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets box", /obj/item/storage/box/donkpockets, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets spicy box", /obj/item/storage/box/donkpockets/donkpocketspicy, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets teriyaki box", /obj/item/storage/box/donkpockets/donkpocketteriyaki, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets pizza box", /obj/item/storage/box/donkpockets/donkpocketpizza, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets berry box", /obj/item/storage/box/donkpockets/donkpocketberry, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets honk box", /obj/item/storage/box/donkpockets/donkpockethonk, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("monkey cube box", /obj/item/storage/box/monkeycubes, check_density = FALSE, category = CAT_CONTAINERS),
		new /datum/stack_recipe("коробка для наггетсов", /obj/item/storage/fancy/nugget_box, check_density = FALSE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("коробка для летальной дроби", /obj/item/storage/box/lethalshot, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для резиновой дроби", /obj/item/storage/box/rubbershot, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для резиновой дроби", /obj/item/storage/box/beanbag, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для светошумовых гранат", /obj/item/storage/box/flashbangs, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для флешек", /obj/item/storage/box/flashes, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для наручников", /obj/item/storage/box/handcuffs, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для ID карт", /obj/item/storage/box/ids, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для PDA", /obj/item/storage/box/pdas, check_density = FALSE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("коробка для таблеток", /obj/item/storage/box/pillbottles, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для стаканов", /obj/item/storage/box/beakers, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для шприцов", /obj/item/storage/box/syringes, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для латексных перчаток", /obj/item/storage/box/gloves, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для стерильных масок", /obj/item/storage/box/masks, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для мешков для тел", /obj/item/storage/box/bodybags, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для рецептурных очков", /obj/item/storage/box/rxglasses, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для инъекторов", /obj/item/storage/box/medipens, check_density = FALSE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("коробка для дисков", /obj/item/storage/box/disks, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка световых трубок", /obj/item/storage/box/lights/tubes, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для лампочек", /obj/item/storage/box/lights/bulbs, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для разных лампочек", /obj/item/storage/box/lights/mixed, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для мышеловок", /obj/item/storage/box/mousetraps, check_density = FALSE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для свечей", /obj/item/storage/fancy/candle_box, check_density = FALSE, category = CAT_CONTAINERS), \
		)),

	null, \
))

/obj/item/stack/sheet/cardboard //BubbleWrap //it's cardboard you fuck
	name = "картон"
	desc = "Большие листы картона, выглядят как плоские коробки."
	singular_name = "лист картона"
	icon_state = "sheet-card"
	inhand_icon_state = "sheet-card"
	mats_per_unit = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cardboard
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/cardboard

/obj/item/stack/sheet/cardboard/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/cardboard_id)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/cardboard/get_main_recipes()
	. = ..()
	. += GLOB.cardboard_recipes

/obj/item/stack/sheet/cardboard/fifty
	amount = 50

/obj/item/stack/sheet/cardboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stamp/clown) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			playsound(I, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Пнул картонку! Это клоунская коробка! Хонк!"))
			if (amount >= 0)
				new/obj/item/storage/box/clown(droploc) //bugfix
	if(istype(I, /obj/item/stamp/chameleon) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			to_chat(user, span_notice("Зловеще пнул картонку."))
			if (amount >= 0)
				new/obj/item/storage/box/syndie_kit(droploc)
	else
		. = ..()

/*
 * Bronze
 */

GLOBAL_LIST_INIT(bronze_recipes, list ( \
	new/datum/stack_recipe("огромная шестерня", /obj/structure/girder/bronze, 2, time = 2 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_STRUCTURE), \
	null,
	new/datum/stack_recipe("направленное латунное окно", /obj/structure/window/bronze/unanchored, time = 0, on_solid_ground = TRUE, check_direction = TRUE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("латунное окно", /obj/structure/window/bronze/fulltile/unanchored, 2, time = 0, on_solid_ground = TRUE, is_fulltile = TRUE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("латунный шлюз", /obj/structure/door_assembly/door_assembly_bronze, 4, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("латунный шлюз с щелью", /obj/structure/door_assembly/door_assembly_bronze/seethru, 4, time = 5 SECONDS, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("латунная плитка", /obj/item/stack/tile/bronze, 1, 4, 20, check_density = FALSE, category = CAT_TILES), \
	new/datum/stack_recipe("латунная шляпа", /obj/item/clothing/head/costume/bronze, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("латунный костюм", /obj/item/clothing/suit/costume/bronze, check_density = FALSE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("латунные ботинки", /obj/item/clothing/shoes/bronze, check_density = FALSE, category = CAT_CLOTHING), \
	null,
	new/datum/stack_recipe("латунный стул", /obj/structure/chair/bronze, 1, time = 0, one_per_turf = TRUE, on_solid_ground = TRUE, category = CAT_FURNITURE), \
))

/obj/item/stack/sheet/bronze
	name = "латунь"
	desc = "При внимательном рассмотрении становится понятно, что совершенно-непригодная-для-строительства латунь на самом деле куда более структурно устойчивая латунь."
	singular_name = "лист латуни"
	icon_state = "sheet-brass"
	inhand_icon_state = "sheet-brass"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sheettype = "bronze"
	force = 5
	throwforce = 10
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	novariants = FALSE
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/copper = 12) //we have no "tin" reagent so this is the closest thing
	merge_type = /obj/item/stack/sheet/bronze
	tableVariant = /obj/structure/table/bronze
	material_type = /datum/material/bronze
	walltype = /turf/closed/wall/mineral/bronze
	has_unique_girder = TRUE

/obj/item/stack/sheet/bronze/get_main_recipes()
	. = ..()
	. += GLOB.bronze_recipes

/obj/item/stack/sheet/paperframes/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = 0
	pixel_y = 0

/obj/item/stack/sheet/bronze/thirty
	amount = 30

/*
 * Lesser and Greater gems - unused
 */
/obj/item/stack/sheet/lessergem
	name = "самоцветы поменьше"
	desc = "Редкий вид самоцветов, которые можно получить только путем кровавых жертвоприношений младшим богам. Они нужны для созданиможнощественных объектов."
	singular_name = "самоцвет поменьше"
	icon_state = "sheet-lessergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/lessergem

/obj/item/stack/sheet/greatergem
	name = "самоцветы побольше"
	desc = "Редкий вид самоцветов, которые можно получить только путем кровавых жертвоприношений младшим богам. Они нужны для созданиможнощественных объектов."
	singular_name = "самоцвет побольше"
	icon_state = "sheet-greatergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/greatergem

/*
 * Bones
 */
/obj/item/stack/sheet/bone
	name = "кости"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "bone"
	inhand_icon_state = null
	mats_per_unit = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
	singular_name = "кость"
	desc = "Кто-то пил своё молоко."
	force = 7
	throwforce = 5
	max_amount = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	grind_results = list(/datum/reagent/carbon = 10)
	merge_type = /obj/item/stack/sheet/bone
	material_type = /datum/material/bone

/obj/item/stack/sheet/bone/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	// As bone and sinew have just a little too many recipes for this, we'll just split them up.
	// Sinew slapcrafting will mostly-sinew recipes, and bones will have mostly-bones recipes.
	var/static/list/slapcraft_recipe_list = list(\
		/datum/crafting_recipe/bonedagger, /datum/crafting_recipe/bonespear, /datum/crafting_recipe/boneaxe,\
		/datum/crafting_recipe/bonearmor, /datum/crafting_recipe/skullhelm, /datum/crafting_recipe/bracers
		)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)
GLOBAL_LIST_INIT(plastic_recipes, list(
	new /datum/stack_recipe("пластиковый пол", /obj/item/stack/tile/plastic, 1, 4, 20, time = 2 SECONDS, check_density = FALSE, category = CAT_TILES), \
	new /datum/stack_recipe("складной пластиковый стул", /obj/structure/chair/plastic, 2, check_density = FALSE, category = CAT_FURNITURE), \
	new /datum/stack_recipe("пластиковые заслонки", /obj/structure/plasticflaps, 5, one_per_turf = TRUE, on_solid_ground = TRUE, time = 4 SECONDS, category = CAT_FURNITURE), \
	new /datum/stack_recipe("бутылка для воды", /obj/item/reagent_containers/cup/glass/waterbottle/empty, check_density = FALSE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("большая бутылка для воды", /obj/item/reagent_containers/cup/glass/waterbottle/large/empty, 3, check_density = FALSE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("пластиковый стакан", /obj/item/reagent_containers/cup/glass/colocup, 1, check_density = FALSE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("знак мокрый пол", /obj/item/clothing/suit/caution, 2, check_density = FALSE, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("конус", /obj/item/clothing/head/cone, 2, check_density = FALSE, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("пустой настенный знак", /obj/item/sign, 1, check_density = FALSE, category = CAT_FURNITURE)))

/obj/item/stack/sheet/plastic
	name = "пластик"
	desc = "Сжимайте динозавров более миллиона лет, затем очистите, разделите и формируйте и Вуаля! Вот он пластик."
	singular_name = "лист пластика"
	icon_state = "sheet-plastic"
	inhand_icon_state = "sheet-plastic"
	mats_per_unit = list(/datum/material/plastic=SHEET_MATERIAL_AMOUNT)
	throwforce = 7
	material_type = /datum/material/plastic
	merge_type = /obj/item/stack/sheet/plastic

/obj/item/stack/sheet/plastic/fifty
	amount = 50

/obj/item/stack/sheet/plastic/five
	amount = 5

/obj/item/stack/sheet/plastic/get_main_recipes()
	. = ..()
	. += GLOB.plastic_recipes

GLOBAL_LIST_INIT(paperframe_recipes, list(
new /datum/stack_recipe("paper frame separator", /obj/structure/window/paperframe, 2, one_per_turf = TRUE, on_solid_ground = TRUE, is_fulltile = TRUE, time = 1 SECONDS), \
new /datum/stack_recipe("paper frame door", /obj/structure/mineral_door/paperframe, 3, one_per_turf = TRUE, on_solid_ground = TRUE, time = 1 SECONDS )))

/obj/item/stack/sheet/paperframes
	name = "бумажные рамки"
	desc = "Тонкая деревянная рамка с прикрепленной бумагой."
	singular_name = "бумажная рамка"
	icon_state = "sheet-paper"
	inhand_icon_state = "sheet-paper"
	mats_per_unit = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/paperframes
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 20)
	material_type = /datum/material/paper

/obj/item/stack/sheet/paperframes/get_main_recipes()
	. = ..()
	. += GLOB.paperframe_recipes
/obj/item/stack/sheet/paperframes/five
	amount = 5
/obj/item/stack/sheet/paperframes/twenty
	amount = 20
/obj/item/stack/sheet/paperframes/fifty
	amount = 50

/obj/item/stack/sheet/meat
	name = "листы мяса"
	desc = "Чье-то окровавленное мясо, спресованное в неплохой твердый лист."
	singular_name = "лист мяса"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/meat
	material_type = /datum/material/meat
	material_modifier = 1 //None of that wussy stuff

/obj/item/stack/sheet/meat/fifty
	amount = 50
/obj/item/stack/sheet/meat/twenty
	amount = 20
/obj/item/stack/sheet/meat/five
	amount = 5

/obj/item/stack/sheet/pizza
	name = "ломтики пепперони"
	desc = "Вкусные ломтики пепперони!"
	singular_name = "ломтик пепперони"
	icon_state = "sheet-pizza"
	mats_per_unit = list(/datum/material/pizza = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/pizza
	material_type = /datum/material/pizza
	material_modifier = 1

/obj/item/stack/sheet/pizza/fifty
	amount = 50
/obj/item/stack/sheet/pizza/twenty
	amount = 20
/obj/item/stack/sheet/pizza/five
	amount = 5

/obj/item/stack/sheet/sandblock
	name = "блоки песка"
	desc = "Я уже слишком стар для того чтобы играться с песочными замками. Теперь я строю... Песочные станции."
	singular_name = "блок песка"
	icon_state = "sheet-sandstone"
	mats_per_unit = list(/datum/material/sand = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/sandblock
	material_type = /datum/material/sand
	material_modifier = 1

/obj/item/stack/sheet/sandblock/fifty
	amount = 50
/obj/item/stack/sheet/sandblock/twenty
	amount = 20
/obj/item/stack/sheet/sandblock/five
	amount = 5


/obj/item/stack/sheet/hauntium
	name = "листы привидениума"
	desc = "Эти листы выглядят проклятыми."
	singular_name = "haunted sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/hauntium = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/hauntium
	material_type = /datum/material/hauntium
	material_modifier = 1 //None of that wussy stuff
	grind_results = list(/datum/reagent/hauntium = 20)

/obj/item/stack/sheet/hauntium/fifty
	amount = 50
/obj/item/stack/sheet/hauntium/twenty
	amount = 20
/obj/item/stack/sheet/hauntium/five
	amount = 5
