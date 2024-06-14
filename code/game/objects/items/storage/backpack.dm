/* Backpacks
 * Contains:
 * Backpack
 * Backpack Types
 * Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "рюкзак"
	desc = "Ты носишь это на спине и кладешь туда вещи."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK //ERROOOOO
	resistance_flags = NONE
	max_integrity = 300
	storage_type = /datum/storage/backpack

/obj/item/storage/backpack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/attack_equip)

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 12

/obj/item/bag_of_holding_inert
	name = "инертная блюспейс сумка"
	desc = "То, что в настоящее время представляет собой просто громоздкий металлический блок со слотом, готовым принять ядро блюспейс аномалии."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "bag_of_holding-inert"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/bag_of_holding_inert/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slapcrafting,\
		slapcraft_recipes = list(/datum/crafting_recipe/boh)\
	)

/obj/item/storage/backpack/holding
	name = "блюспейс сумка"
	desc = "Рюкзак, который открывает портал в локализованный карман блюспейс пространства."
	icon_state = "bag_of_holding"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor_type = /datum/armor/backpack_holding
	storage_type = /datum/storage/bag_of_holding

/datum/armor/backpack_holding
	fire = 60
	acid = 50

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] прыгает в [src]! Похоже, [user.ru_who()] пытается совершить суицид."))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(2 SECONDS)
	playsound(src, SFX_RUSTLE, 50, TRUE, -5)
	user.suicide_log()
	qdel(user)


/obj/item/storage/backpack/santabag
	name = "подарочный мешок Санты"
	desc = "Космический Санта использует это, чтобы доставить подарки всем хорошим детям в пространстве в Рождество! Вау, он довольно большой!"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] places [src] over [user.p_their()] head and pulls it tight! It looks like [user.p_they()] [user.p_are()]n't in the Christmas spirit..."))
	return OXYLOSS

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/user = get(loc, /mob)
	if(!istype(user))
		return
	if(HAS_MIND_TRAIT(user, TRAIT_CANNOT_OPEN_PRESENTS))
		var/turf/floor = get_turf(src)
		var/obj/item/thing = new /obj/item/a_gift/anything(floor)
		if(!atom_storage.attempt_insert(thing, user, override = TRUE, force = STORAGE_SOFT_LOCKED))
			qdel(thing)


/obj/item/storage/backpack/cultpack
	name = "рюкзак для трофеев"
	desc = "Он полезен как для переноски дополнительного снаряжения, так и для гордого декларирования безумия."
	icon_state = "backpack-cult"
	inhand_icon_state = "backpack"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "Рюкзак, сделанный Хонком!"
	icon_state = "backpack-clown"
	inhand_icon_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "рюкзак исследователя"
	desc = "Прочный рюкзак для хранения добытого имущества."
	icon_state = "backpack-explorer"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "Безмолвный рюкзак, сделанный для тех безмолвных рабочих. Тишина Ко."
	icon_state = "backpack-mime"
	inhand_icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "медицинский рюкзак"
	desc = "Рюкзак, специально разработанный для использования в стерильных условиях."
	icon_state = "backpack-medical"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/coroner
	name = "рюкзак коронера"
	desc = "Рюкзак, специально разработанный для использования в морге."
	icon_state = "backpack-coroner"
	inhand_icon_state = "coronerpack"

/obj/item/storage/backpack/security
	name = "рюкзак офицера"
	desc = "Очень прочный рюкзак."
	icon_state = "backpack-security"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "капитанский рюкзак"
	desc = "Специальный рюкзак, сделанный исключительно для офицеров Nanotrasen."
	icon_state = "backpack-captain"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "промышленный рюкзак"
	desc = "Жесткий рюкзак для повседневной работы на станции."
	icon_state = "backpack-engineering"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "ботанический рюкзак"
	desc = "Рюкзак из натуральных волокон."
	icon_state = "backpack-hydroponics"
	inhand_icon_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "химический рюкзак"
	desc = "Рюкзак, специально разработанный для защиты от пятен и опасных жидкостей."
	icon_state = "backpack-chemistry"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "генетический рюкзак"
	desc = "Сумка, разработанная для того, чтобы быть суперпрочной, на случай, если кто-нибудь на меня набросится."
	icon_state = "backpack-genetics"
	inhand_icon_state = "genepack"

/obj/item/storage/backpack/science
	name = "научный рюкзак"
	desc = "Специально разработанный рюкзак. Он огнестойкий и смутно пахнет плазмой."
	icon_state = "backpack-science"
	inhand_icon_state = "scipack"

/obj/item/storage/backpack/virology
	name = "вирусологический рюкзак"
	desc = "Рюкзак из гипоаллергенных волокон. Он разработан для предотвращения распространения болезней. Пахнет обезьяной."
	icon_state = "backpack-virology"
	inhand_icon_state = "viropack"

/obj/item/storage/backpack/ert
	name = "рюкзак командира группы реагирования на чрезвычайные ситуации"
	desc = "Просторный рюкзак с большим количеством карманов, который носит командир группы быстрого реагирования."
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/ert/security
	name = "рюкзак службы безопасности группы реагирования на чрезвычайные ситуации"
	desc = "Просторный рюкзак с большим количеством карманов, который носят сотрудники службы безопасности Группы реагирования на чрезвычайные ситуации."
	icon_state = "ert_security"

/obj/item/storage/backpack/ert/medical
	name = "медицинский рюкзак группы экстренного реагирования"
	desc = "Просторный рюкзак с большим количеством карманов, который носят медицинские работники бригады быстрого реагирования."
	icon_state = "ert_medical"

/obj/item/storage/backpack/ert/engineer
	name = "рюкзак инженера группы реагирования на чрезвычайные ситуации"
	desc = "Просторный рюкзак с большим количеством карманов, который носят инженеры аварийно-спасательной службы."
	icon_state = "ert_engineering"

/obj/item/storage/backpack/ert/janitor
	name = "emergency response team janitor backpack"
	desc = "A spacious backpack with lots of pockets, worn by Janitors of an Emergency Response Team."
	icon_state = "ert_janitor"

/obj/item/storage/backpack/ert/clown
	name = "emergency response team clown backpack"
	desc = "A spacious backpack with lots of pockets, worn by Clowns of an Emergency Response Team."
	icon_state = "ert_clown"

/obj/item/storage/backpack/saddlepack
	name = "saddlepack"
	desc = "A backpack designed to be saddled on a mount or carried on your back, and switch between the two on the fly. It's quite spacious, at the cost of making you feel like a literal pack mule."
	icon = 'icons/obj/storage/ethereal.dmi'
	worn_icon = 'icons/mob/clothing/back/ethereal.dmi'
	icon_state = "saddlepack"

/obj/item/storage/backpack/saddlepack/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 26

// MEAT MEAT MEAT MEAT MEAT

/obj/item/storage/backpack/meat
	name = "\improper MEAT"
	desc = "MEAT MEAT MEAT MEAT MEAT MEAT"
	icon_state = "meatmeatmeat"
	inhand_icon_state = "meatmeatmeat"
	force = 15
	throwforce = 15
	attack_verb_continuous = list("MEATS", "MEAT MEATS")
	attack_verb_simple = list("MEAT", "MEAT MEAT")
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 25) // MEAT
	///Sounds used in the squeak component
	var/list/meat_sounds = list('sound/effects/blobattack.ogg' = 1)
	///Reagents added to the edible component, ingested when you EAT the MEAT
	var/list/meat_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	///The food types of the edible component
	var/foodtypes = MEAT | RAW
	///How our MEAT tastes. It tastes like MEAT
	var/list/tastes = list("MEAT" = 1)
	///Eating verbs when consuming the MEAT
	var/list/eatverbs = list("MEAT", "absorb", "gnaw", "consume")

/obj/item/storage/backpack/meat/Initialize(mapload)
	. = ..()
	AddComponent(
		/datum/component/edible,\
		initial_reagents = meat_reagents,\
		foodtypes = foodtypes,\
		tastes = tastes,\
		eatverbs = eatverbs,\
	)
	AddComponent(/datum/component/squeak, meat_sounds)
	AddComponent(
		/datum/component/blood_walk,\
		blood_type = /obj/effect/decal/cleanable/blood,\
		blood_spawn_chance = 15,\
		max_blood = 300,\
	)
	AddComponent(
		/datum/component/bloody_spreader,\
		blood_left = INFINITY,\
		blood_dna = list("MEAT DNA" = "MT+"),\
		diseases = null,\
	)

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "сумка"
	desc = "Модная сумка."
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "кожаная сумка"
	desc = "Очень модная сумка из тонкой кожи."
	icon_state = "satchel-leather"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "промышленная сумка"
	desc = "Прочная сумка с дополнительными карманами."
	icon_state = "satchel-engineering"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "медицинская сумка"
	desc = "Стерильная сумка, используемая для хирургических инструментов."
	icon_state = "satchel-medical"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "сумка вирусолога"
	desc = "Стерильная сумка для переноски вирусов."
	icon_state = "satchel-virology"
	inhand_icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "аптекарская сумка"
	desc = "Стерильная сумка для лекарств."
	icon_state = "satchel-chemistry"
	inhand_icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/coroner
	name = "сумка коронера"
	desc = "Сумка, используемая для переноски того, что осталось от человеческих тел."
	icon_state = "satchel-coroner"
	inhand_icon_state = "satchel-coroner"

/obj/item/storage/backpack/satchel/gen
	name = "сумка генетика"
	desc = "Стерильная сумка голубого цвета."
	icon_state = "satchel-genetics"
	inhand_icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/science
	name = "сумка ученого"
	desc = "Полезно для хранения научных материалов."
	icon_state = "satchel-science"
	inhand_icon_state = "satchel-sci"

/obj/item/storage/backpack/satchel/hyd
	name = "сумка ботаника"
	desc = "Сумка из натуральных волокон."
	icon_state = "satchel-hydroponics"
	inhand_icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "сумка офицера"
	desc = "Надежная сумка для нужд офицеров СБ."
	icon_state = "satchel-security"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "сумка исследователя"
	desc = "Надежная сумка для хранения награбленного."
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "сумка капитана"
	desc = "Эксклюзивная сумка для офицеров Nanotrasen."
	icon_state = "satchel-captain"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "сумка контрабандиста"
	desc = "Очень тонкая сумка, которая легко помещается в ограниченном пространстве."
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)
	atom_storage.max_total_storage = 15
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	for(var/items in 1 to 4)
		new /obj/effect/spawner/random/contraband(src)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/iron/base(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return

/obj/item/storage/backpack/duffelbag
	name = "вещмешок"
	desc = "Большая сумка для хранения лишних вещей."
	icon_state = "duffel"
	inhand_icon_state = "duffel"
	actions_types = list(/datum/action/item_action/zipper)
	storage_type = /datum/storage/duffel
	// How much to slow you down if your bag isn't zipped up
	var/zip_slowdown = 1
	/// If this bag is zipped (contents hidden) up or not
	/// Starts enabled so you're forced to interact with it to "get" it
	var/zipped_up = TRUE
	// How much time it takes to zip up (close) the duffelbag
	var/zip_up_duration = 0.5 SECONDS
	// Audio played during zipup
	var/zip_up_sfx = 'sound/items/zip_up.ogg'
	// How much time it takes to unzip the duffel
	var/unzip_duration = 2.1 SECONDS
	// Audio played during unzip
	var/unzip_sfx = 'sound/items/un_zip.ogg'

/obj/item/storage/backpack/duffelbag/Initialize(mapload)
	. = ..()
	set_zipper(TRUE)

/obj/item/storage/backpack/duffelbag/update_desc(updates)
	. = ..()
	desc = "[initial(desc)]<br>[zipped_up ? "It's zipped up, preventing you from accessing its contents." : "It's unzipped, and harder to move in."]"

/obj/item/storage/backpack/duffelbag/attack_self(mob/user, modifiers)
	if(loc != user) // God fuck TK
		return ..()
	if(zipped_up)
		return attack_hand(user, modifiers)
	else
		return attack_hand_secondary(user, modifiers)

/obj/item/storage/backpack/duffelbag/attack_self_secondary(mob/user, modifiers)
	attack_self(user, modifiers)
	return ..()

// If we're zipped, click to unzip
/obj/item/storage/backpack/duffelbag/attack_hand(mob/user, list/modifiers)
	if(loc != user)
		// Hacky, but please don't be cringe yeah?
		atom_storage.silent = TRUE
		. = ..()
		atom_storage.silent = initial(atom_storage.silent)
		return
	if(!zipped_up)
		return ..()

	balloon_alert(user, "unzipping...")
	playsound(src, unzip_sfx, 100, FALSE)
	var/datum/callback/can_unzip = CALLBACK(src, PROC_REF(zipper_matches), TRUE)
	if(!do_after(user, unzip_duration, src, extra_checks = can_unzip))
		user.balloon_alert(user, "unzip failed!")
		return
	balloon_alert(user, "unzipped")
	set_zipper(FALSE)
	return TRUE

// Vis versa
/obj/item/storage/backpack/duffelbag/attack_hand_secondary(mob/user, list/modifiers)
	if(loc != user)
		return ..()
	if(zipped_up)
		return SECONDARY_ATTACK_CALL_NORMAL

	balloon_alert(user, "zipping...")
	playsound(src, zip_up_sfx, 100, FALSE)
	var/datum/callback/can_zip = CALLBACK(src, PROC_REF(zipper_matches), FALSE)
	if(!do_after(user, zip_up_duration, src, extra_checks = can_zip))
		user.balloon_alert(user, "zip failed!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	balloon_alert(user, "zipped")
	set_zipper(TRUE)
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/// Checks to see if the zipper matches the passed in state
/// Returns true if so, false otherwise
/obj/item/storage/backpack/duffelbag/proc/zipper_matches(matching_value)
	return zipped_up == matching_value

/obj/item/storage/backpack/duffelbag/proc/set_zipper(new_zip)
	zipped_up = new_zip
	SEND_SIGNAL(src, COMSIG_DUFFEL_ZIP_CHANGE, new_zip)
	if(zipped_up)
		slowdown = initial(slowdown)
		atom_storage.locked = STORAGE_SOFT_LOCKED
		atom_storage.display_contents = FALSE
		for(var/obj/item/weapon as anything in get_all_contents_type(/obj/item)) //close ui of this and all items inside dufflebag
			weapon.atom_storage?.close_all() //not everything has storage initialized
	else
		slowdown = zip_slowdown
		atom_storage.locked = STORAGE_NOT_LOCKED
		atom_storage.display_contents = TRUE

	if(isliving(loc))
		var/mob/living/wearer = loc
		wearer.update_equipment_speed_mods()
	update_appearance()

/obj/item/storage/backpack/duffelbag/cursed
	name = "живая сумка"
	desc = "Огромная, проклятая, всеядная и весьма голодная сумка. Если такая цапнет то уже не отпустит. Кажется если ее кормить то она ненадолго успокаивается. Тут сбоку есть этикетка и на ней написано \"Не смейте кормить мою прелесть всякой гадостью, ее от этого тошнит. Она предпочитает мясные блюда, желательно из ассистентов.\""
	icon_state = "duffel-curse"
	inhand_icon_state = "duffel-curse"
	zip_slowdown = 2
	max_integrity = 100

/obj/item/storage/backpack/duffelbag/cursed/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/curse_of_hunger, add_dropdel = TRUE)

/obj/item/storage/backpack/duffelbag/captain
	name = "капитанский вещмешок"
	desc = "Большая сумка для хранения дополнительных капитанских вещей."
	icon_state = "duffel-captain"
	inhand_icon_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/med
	name = "медицинская сумка для вещей"
	desc = "Большая сумка для хранения дополнительных медицинских принадлежностей."
	icon_state = "duffel-medical"
	inhand_icon_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/med/surgery
	name = "хирургический вещмешок"
	desc = "Большая сумка для хранения дополнительных медицинских принадлежностей - похоже, она предназначена для хранения хирургических инструментов."

/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/coroner
	name = "вещмешок коронера"
	icon_state = "duffel-coroner"
	inhand_icon_state = "duffel-coroner"

/obj/item/storage/backpack/duffelbag/explorer
	name = "вещмешок исследователя"
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/hydroponics
	name = "ботанический вещмешок"
	icon_state = "duffel-hydroponics"
	inhand_icon_state = "duffel-hydroponics"

/obj/item/storage/backpack/duffelbag/chemistry
	name = "вещмешок химика"
	icon_state = "duffel-chemistry"
	inhand_icon_state = "duffel-chemistry"

/obj/item/storage/backpack/duffelbag/genetics
	name = "вещмешок генетика"
	icon_state = "duffel-genetics"
	inhand_icon_state = "duffel-genetics"

/obj/item/storage/backpack/duffelbag/science
	name = "вещмешок ученого"
	icon_state = "duffel-science"
	inhand_icon_state = "duffel-sci"

/obj/item/storage/backpack/duffelbag/virology
	name = "вещмешок вирусолога"
	desc = "A large duffel bag for holding extra viral bottles."
	icon_state = "duffel-virology"
	inhand_icon_state = "duffel-virology"

/obj/item/storage/backpack/duffelbag/sec
	name = "вещмешок офицера"
	icon_state = "duffel-security"
	inhand_icon_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "хирургический вещмешок"
	desc = "Большая сумка для хранения дополнительных медицинских принадлежностей - похоже, она предназначена для хранения хирургических инструментов."

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "промышленный  вещмешок"
	desc = "Большая сумка для хранения дополнительных инструментов и принадлежностей."
	icon_state = "duffel-engineering"
	inhand_icon_state = "duffel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone
	name = "вещмешок дрона"
	desc = "Большая сумка для хранения инструментов и шляп."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "вещмешок клоуна"
	desc = "Большая сумка для хранения смешных шуток!"
	icon_state = "duffel-clown"
	inhand_icon_state = "duffel-clown"

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/food/pie/cream(src)

/obj/item/storage/backpack/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie
	name = "подозрительно выглядящий вещевой мешок"
	desc = "Большая сумка для хранения дополнительных тактических принадлежностей."
	icon_state = "duffel-syndie"
	inhand_icon_state = "duffel-syndieammo"
	storage_type = /datum/storage/duffel/syndicate
	resistance_flags = FIRE_PROOF
	// Less slowdown while unzipped. Still bulky, but it won't halve your movement speed in an active combat situation.
	zip_slowdown = 0.3
	// Faster unzipping. Utilizes the same noise as zipping up to fit the unzip duration.
	unzip_duration = 0.5 SECONDS
	unzip_sfx = 'sound/items/zip_up.ogg'

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "Большая сумка для хранения лишних вещей. Сзади виднеется логотип Nanotrasen."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/costume/buttondown/slacks/service(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "медицинская сумка для вещей"
	desc = "Большая сумка для хранения дополнительных медицинских принадлежностей."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "хирургический вещмешок"
	desc = "Большая сумка для хранения дополнительных медицинских принадлежностей - похоже, она предназначена для хранения хирургических инструментов."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/reagent_containers/medigel/sterilizine(src)
	new /obj/item/bonesetter(src)
	new /obj/item/blood_filter(src)
	new /obj/item/stack/medical/bone_gel(src)
	new /obj/item/stack/sticky_tape/surgical(src)
	new /obj/item/emergency_bed(src)
	new /obj/item/clothing/suit/jacket/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "вещмешок с аммуницией"
	desc = "Большая сумка для хранения дополнительных боеприпасов и принадлежностей для оружия."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	desc = "Большая сумка для вещей, упакованная до краев с различными экзотическими боеприпасами."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech/PopulateContents()
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/storage/belt/utility/syndicate(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "Большая сумка для вещей, упакованная до краев с различными экзотическими боеприпасами."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "Большая сумка с медицинским оборудованием, газонокосилкой Donksoft LMG, большой гигантской коробкой с метательными дротиками и парой поддельных магбутсов."

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/mod/module/magboot(src)
	new /obj/item/storage/medkit/tactical/premium(src)
	new /obj/item/gun/ballistic/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "Большая сумка со смертоносными химикатами, ручной химический распылитель, пенная граната Bioterror, штурмовая винтовка Donksoft, коробка со стрелами, пистолет-пулемет и коробка со шприцами."

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/food/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "Большая спортивная сумка, содержащая новый российский пиротехнический ранцевый распылитель, костюм Elite MOD, пистолет Stechkin APS, мини-бомбу, боеприпасы и другое снаряжение."

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/mod/control/pre_equipped/elite/flamethrower(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/reagent_containers/cup/glass/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie
	storage_type = /datum/storage/duffel/syndicate

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/modular_computer/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/henchmen
	name = "wings"
	desc = "Granted to the henchmen who deserve it. This probably doesn't include you."
	icon_state = "henchmen"
	inhand_icon_state = null

/obj/item/storage/backpack/duffelbag/cops
	name = "police bag"
	desc = "A large duffel bag for holding extra police gear."

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "mining conscription kit"
	desc = "A duffel bag containing everything a crewmember needs to support a shaft miner in the field."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/id/advanced/mining(src)
	new /obj/item/gun/energy/recharge/kinetic_accelerator(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)

/*
 * сумка-мессенджер Types
 */

/obj/item/storage/backpack/messenger
	name = "сумка-мессенджер"
	desc = "Модная сумка-мессенджер."
	icon_state = "messenger"
	inhand_icon_state = "messenger"
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'

/obj/item/storage/backpack/messenger/eng
	name = "промышленная сумка-мессенджер"
	desc = "Прочная сумка-мессенджер с дополнительными карманами."
	icon_state = "messenger_engineering"
	inhand_icon_state = "messenger_engineering"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/messenger/med
	name = "медицинская сумка-мессенджер"
	desc = "Стерильная сумка-мессенджер, хорошо знакомая медикам за ее портативность и элегантный профиль."
	icon_state = "messenger_medical"
	inhand_icon_state = "messenger_medical"

/obj/item/storage/backpack/messenger/vir
	name = "сумка-мессенджер вирусолога"
	icon_state = "messenger_virology"
	inhand_icon_state = "messenger_virology"

/obj/item/storage/backpack/messenger/chem
	name = "сумка-мессенджер химика"
	desc = "Стерильная сумка-мессенджер. Хороша для того, чтобы проносить товар на сделки."
	icon_state = "messenger_chemistry"
	inhand_icon_state = "messenger_chemistry"

/obj/item/storage/backpack/messenger/coroner
	name = "сумка-мессенджер коронера"
	desc = "Сумка, используемая для переноски того, что осталось от человеческих тел."
	icon_state = "messenger_coroner"
	inhand_icon_state = "messenger_coroner"

/obj/item/storage/backpack/messenger/gen
	name = "сумка-мессенджер генетика"
	desc = "Стерильная сумка-мессенджер голубого цвета."
	icon_state = "messenger_genetics"
	inhand_icon_state = "messenger_genetics"

/obj/item/storage/backpack/messenger/science
	name = "сумка-мессенджер ученого"
	desc = "Полезна для хранения научных материалов."
	icon_state = "messenger_science"
	inhand_icon_state = "messenger_science"

/obj/item/storage/backpack/messenger/hyd
	name = "ботаническая сумка-мессенджер"
	desc = "Сумка-мессенджер из натуральных волокон."
	icon_state = "messenger_hydroponics"
	inhand_icon_state = "messenger_hydroponics"

/obj/item/storage/backpack/messenger/sec
	name = "сумка-мессенджер офицера"
	desc = "A robust сумка-мессенджер for security related needs."
	desc = "Надежная сумка-мессенджер для нужд офицеров СБ."
	icon_state = "messenger_security"
	inhand_icon_state = "messenger_security"

/obj/item/storage/backpack/messenger/explorer
	name = "исследовательская сумка-мессенджер"
	icon_state = "messenger_explorer"
	inhand_icon_state = "messenger_explorer"

/obj/item/storage/backpack/messenger/cap
	name = "капитанская сумка-мессенджер"
	desc = "Эксклюзивная сумка-мессенджер для старших офицеров Nanotrasen."
	icon_state = "messenger_captain"
	inhand_icon_state = "messenger_captain"

/obj/item/storage/backpack/messenger/clown
	name = "Giggles von Honkerton Jr."
	desc = "Новинка в области хранения от Honk Co. Эй, как туда помещается так много вещей?"
	icon_state = "messenger_clown"
	inhand_icon_state = "messenger_clown"
