/datum/mutation/human/geladikinesis
	name = "Аквакрионика"
	desc = "Позволяет сконденсировать влагу из воздуха в руках и обратить ее в снег."
	quality = POSITIVE
	text_gain_indication = span_notice("Мои руки холодные, как снег...")
	instability = 10
	difficulty = 10
	synchronizer_coeff = 1
	power_path = /datum/action/cooldown/spell/conjure_item/snow

/datum/action/cooldown/spell/conjure_item/snow
	name = "Десублимация влаги"
	desc = "Позволяет сконденсировать влагу из воздуха в руках и обратить ее в снег."
	button_icon_state = "snow"

	cooldown_time = 5 SECONDS
	spell_requirements = NONE

	item_type = /obj/item/stack/sheet/mineral/snow
	delete_old = FALSE
	delete_on_failure = FALSE

/datum/mutation/human/cryokinesis
	name = "Криокинез"
	desc = "Псионическая способность заморозить цель на расстоянии."
	quality = POSITIVE //upsides and downsides
	text_gain_indication = span_notice("Мои руки холодные, как лед...")
	instability = 30
	difficulty = 12
	synchronizer_coeff = 1
	energy_coeff = 1
	power_path = /datum/action/cooldown/spell/pointed/projectile/cryo

/datum/action/cooldown/spell/pointed/projectile/cryo
	name = "Криокинез"
	desc = "Псионическая способность заморозить цель на расстоянии."
	button_icon_state = "icebeam"
	base_icon_state = "icebeam"
	active_overlay_icon_state = "bg_spell_border_active_blue"
	cooldown_time = 16 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE

	active_msg = "Выпускаю стужу на свободу!"
	deactive_msg = "Втягиваю холод обратно в себя."
	projectile_type = /obj/projectile/temp/cryo
