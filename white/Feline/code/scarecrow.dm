/obj/item/clothing/head/scarecrow
	name = "маска пугала"
	desc = "Угрожающая маска, замкнутого цикла не требующая кислородного баллона. Имеет функцию обратной акселирации фильтров, при использовании выдыхая дым и ненадолго активирую термосенсорный визор."
	icon = 'white/Feline/icons/scarecrow.dmi'
	icon_state = "scarecrow"
	worn_icon = 'white/Feline/icons/scarecrow_body.dmi'
	worn_icon_state = "scarecrow"
	inhand_icon_state = "gas_alt"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_traits = list(TRAIT_NOBREATH)
	clothing_flags = STOPSPRESSUREDAMAGE | SNUG_FIT
	actions_types = list(/datum/action/cooldown/spell/smoke/scarecrow)
	armor_type = /datum/armor/scarecrow_head_armor

/datum/armor/scarecrow_head_armor
	melee = 30
	bullet = 10
	laser = 15
	energy = 25
	bomb = 5
	bio = 100
	fire = 10
	acid = 100
