/datum/lazy_template/virtual_domain/stairs_and_cliffs
	name = "Измельчение ледника"
	cost = BITRUNNER_COST_LOW
	desc = "Коварный подъем, который мало кто выдержит. Зато отличное кардио."
	help_text = "Слышали когда-нибудь о 'Змеях и лестницах'? Это похоже на то, но \
	вместо лестницы - лестница, а вместо змей - крутое падение с обрыва \
	об острые камни или в жидкую плазму."

	extra_loot = list(/obj/item/clothing/suit/costume/snowman = 2)
	difficulty = BITRUNNER_DIFFICULTY_LOW
	forced_outfit = /datum/outfit/job/virtual_domain_iceclimber
	key = "stairs_and_cliffs"
	map_name = "stairs_and_cliffs"
	reward_points = BITRUNNER_REWARD_MEDIUM
	safehouse_path = /datum/map_template/safehouse/ice

/turf/open/cliff/snowrock/virtual_domain
	name = "ледяной утёс"
	initial_gas_mix = "o2=22;n2=82;TEMP=180"

/turf/open/lava/plasma/virtual_domain
	name = "плазменное озеро"
	initial_gas_mix = "o2=22;n2=82;TEMP=180"

/datum/outfit/job/virtual_domain_iceclimber
	name = "Альпинист"

	uniform = /obj/item/clothing/under/color/grey
	backpack = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/winterboots
