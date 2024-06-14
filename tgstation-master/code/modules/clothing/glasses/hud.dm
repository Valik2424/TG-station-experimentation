/obj/item/clothing/glasses/hud
	name = "интерфейс"
	desc = "Главный экран, который предоставляет важную информацию в (почти) реальном времени."
	flags_1 = null //doesn't protect eyes because it's a monocle, duh
	var/hud_type = null
	///Used for topic calls. Just because you have a HUD display doesn't mean you should be able to interact with stuff.
	var/hud_trait = null


/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	..()
	if(!(slot & ITEM_SLOT_EYES))
		return
	if(hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.show_to(user)
	if(hud_trait)
		ADD_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/dropped(mob/living/carbon/human/user)
	..()
	if(!istype(user) || user.glasses != src)
		return
	if(hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.hide_from(user)
	if(hud_trait)
		REMOVE_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/emp_act(severity)
	. = ..()
	if(obj_flags & EMAGGED || . & EMP_PROTECT_SELF)
		return
	obj_flags |= EMAGGED
	desc = "[desc] Дисплей слегка мигает."

/obj/item/clothing/glasses/hud/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "ПЗЗЗЗЗ")
	desc = "[desc] Дисплей слегка мигает."
	return TRUE

/obj/item/clothing/glasses/hud/suicide_act(mob/living/user)
	if(user.is_blind())
		return SHAME
	var/mob/living/living_user = user
	user.visible_message(span_suicide("[user] looks through [src] and looks overwhelmed with the information! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(living_user.get_organ_loss(ORGAN_SLOT_BRAIN) >= BRAIN_DAMAGE_SEVERE)
		var/mob/thing = pick((/mob in view()) - user)
		if(thing)
			user.say("ЭТОТ ЧЕЛОВЕК В РОЗЫСКЕ, ЛОВИТЕ ЕГО!!")
			user.pointed(thing)
		else
			user.say("ПОЧЕМУ ТУТ ПОЛОСКА НАД МОЕЙ ГОЛОВОЙ?!!")
	return OXYLOSS

/obj/item/clothing/glasses/hud/health
	name = "медицинский HUD"
	desc = "Дисплей с заголовком, который сканирует гуманоидов и предоставляет точные данные о состоянии их здоровья."
	icon_state = "healthhud"
	hud_type = DATA_HUD_MEDICAL_ADVANCED
	hud_trait = TRAIT_MEDICAL_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/hud/health/night
	name = "медицинский HUD с ПНВ"
	desc = "Усовершенствованный медицинский дисплей, позволяющий врачам находить пациентов в полной темноте."
	icon_state = "healthhudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Blue green, dark
	color_cutoffs = list(5, 15, 30)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/health/night/meson
	name = "night vision meson health scanner HUD"
	desc = "Truly combat ready."
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/hud/health/night/science
	name = "night vision medical science scanner HUD"
	desc = "An clandestine medical science heads-up display that allows operatives to find \
		dying captains and the perfect poison to finish them off in complete darkness."
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/hud/health/sunglasses
	name = "Тактические медицинские очки"
	desc = "Тактические очки с медицинским интерфейсом и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhudmed"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/blue

/obj/item/clothing/glasses/hud/health/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsunmedremoval)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/diagnostic
	name = "диагностический HUD"
	desc = "Головной дисплей, способный анализировать целостность и состояние робототехники и экзокостюмов."
	icon_state = "diagnostichud"
	hud_type = DATA_HUD_DIAGNOSTIC_BASIC
	hud_trait = TRAIT_DIAGNOSTIC_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "диагностический HUD с ПНВ"
	desc = "Диагностический интерфейс робототехника со встроенной подсветкой."
	icon_state = "diagnostichudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Pale yellow
	color_cutoffs = list(30, 20, 5)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/diagnostic/sunglasses
	name = "Тактические диагностические очки"
	desc = "Тактические очки с диагностическим интерфейсом и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhuddiag"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1

/obj/item/clothing/glasses/hud/diagnostic/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsundiagremoval)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/security
	name = "HUD офицера"
	desc = "Главный дисплей, который сканирует гуманоидов в поле зрения и предоставляет точные данные о состоянии их идентификатора и записях безопасности."
	icon_state = "securityhud"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/security/chameleon
	name = "хамелеонный HUD офицера"
	desc = "Украденный HUD офицера, интегрированный с технологией хамелеона Синдиката. Обеспечивает защиту от вспышек."
	flash_protect = FLASH_PROTECTION_FLASH
	actions_types = list(/datum/action/item_action/chameleon/change/glasses/no_preset)

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "повязка на глаз с HUD"
	desc = "Головной дисплей, который подключается непосредственно к оптическому нерву пользователя, заменяя необходимость в этом бесполезном глазном яблоке."
	icon_state = "hudpatch"
	base_icon_state = "hudpatch"
	actions_types = list(/datum/action/item_action/flip)

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch/attack_self(mob/user, modifiers)
	. = ..()
	icon_state = (icon_state == base_icon_state) ? "[base_icon_state]_flipped" : base_icon_state
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "Тактические очки офицера"
	desc = "Тактические очки с интерфейсом СБ и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhudsec"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/darkred

/obj/item/clothing/glasses/hud/security/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsunsecremoval)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/security/night
	name = "HUD офицера с ПНВ"
	desc = "Усовершенствованный головной дисплей, который обеспечивает идентификационные данные и видение в полной темноте."
	icon_state = "securityhudnight"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Red with a tint of green
	color_cutoffs = list(35, 5, 5)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "тактические GAR очки"
	desc = "GAR очки с HUD."
	icon_state = "gar_sec"
	inhand_icon_state = "gar_black"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/hud/security/sunglasses/gars/giga
	name = "гига HUD GAR очки"
	desc = "GIGA GAR очки с HUD."
	icon_state = "gigagar_sec"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/hud/toggle
	name = "Многофункциональный интерфейс"
	desc = "Интерфейс с несколькими функциями."
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.hide_from(user)

	if (hud_type == DATA_HUD_MEDICAL_ADVANCED)
		hud_type = null
	else if (hud_type == DATA_HUD_SECURITY_ADVANCED)
		hud_type = DATA_HUD_MEDICAL_ADVANCED
	else
		hud_type = DATA_HUD_SECURITY_ADVANCED

	if (hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.show_to(user)

/datum/action/item_action/switch_hud
	name = "Switch HUD"

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "тепловой HUD"
	desc = "Тепловизор в форме очков."
	icon_state = "thermal"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	vision_flags = SEE_MOBS
	color_cutoffs = list(25, 8, 5)
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	switch (hud_type)
		if (DATA_HUD_MEDICAL_ADVANCED)
			icon_state = "meson"
			color_cutoffs = list(5, 15, 5)
			change_glass_color(user, /datum/client_colour/glass_colour/green)
		if (DATA_HUD_SECURITY_ADVANCED)
			icon_state = "thermal"
			color_cutoffs = list(25, 8, 5)
			change_glass_color(user, /datum/client_colour/glass_colour/red)
		else
			icon_state = "purple"
			color_cutoffs = list(15, 0, 25)
			change_glass_color(user, /datum/client_colour/glass_colour/purple)
	user.update_sight()
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/hud/spacecop
	name = "полицейские Авиаторы"
	desc = "Чтобы чуствовать себя круто во время жестокого обращения с протестующими и меньшинствами."
	icon_state = "bigsunglasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray


/obj/item/clothing/glasses/hud/spacecop/hidden // for the undercover cop
	name = "солнцезащитные очки"
	desc = "Эти очки особенные и позволяют увидеть потенциальных преступников."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"
