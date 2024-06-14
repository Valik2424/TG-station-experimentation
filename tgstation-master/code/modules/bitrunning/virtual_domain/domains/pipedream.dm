/datum/lazy_template/virtual_domain/pipedream
	name = "Фабрика Труб"
	cost = BITRUNNER_COST_LOW
	desc = "Заброшенный и зараженный завод по производству утилизационных труб."
	difficulty = BITRUNNER_DIFFICULTY_MEDIUM
	extra_loot = list(/obj/item/stack/pipe_cleaner_coil/random/five = 1)
	help_text = "Не так давно здесь кипела бурная деятельность. Рабочие \
	похоже, ушли в спешке, и теперь производительность труда на нуле. Что-то \
	должно быть, разгромило это место, но что?"
	key = "pipedream"
	map_name = "pipedream"
	reward_points = BITRUNNER_REWARD_LOW
	safehouse_path = /datum/map_template/safehouse/shuttle

// ID Trims
/datum/id_trim/factory
	assignment = "Factory Worker"
	trim_state = "trim_cargotechnician"
	department_color = COLOR_CARGO_BROWN
	subdepartment_color = COLOR_CARGO_BROWN
	sechud_icon_state = SECHUD_CARGO_TECHNICIAN
	access = list(
		ACCESS_AWAY_SUPPLY
		)

/datum/id_trim/factory/qm
	assignment = "Factory Quartermaster"
	trim_state = "trim_quartermaster"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_CARGO_BROWN
	department_state = "departmenthead"
	sechud_icon_state = SECHUD_QUARTERMASTER
	access = list(
		ACCESS_AWAY_SUPPLY,
		ACCESS_AWAY_COMMAND
		)

// ID Cards
/obj/item/card/id/advanced/factory
	name = "карта работника фабрики"
	trim = /datum/id_trim/factory

/obj/item/card/id/advanced/factory/qm
	name = "карта квартермейстера фабрики"
	trim = /datum/id_trim/factory/qm

//Outfits
/datum/outfit/factory
	name = "Factory Worker"

	id_trim = /datum/id_trim/factory
	id = /obj/item/card/id/advanced/
	uniform = /obj/item/clothing/under/rank/cargo/tech
	suit = /obj/item/clothing/suit/hazardvest
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/yellow
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/flashlight/seclite

/datum/outfit/factory/guard
	name = "Factory Guard"

	uniform = /obj/item/clothing/under/rank/security/officer/grey
	suit = /obj/item/clothing/suit/armor/vest/alt
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/sec
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

/datum/outfit/factory/qm
	name = "Factory Quatermaster"

	id_trim = /datum/id_trim/factory/qm
	id = /obj/item/card/id/advanced/silver
	uniform = /obj/item/clothing/under/rank/cargo/qm
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/yellow
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/melee/baton/telescopic
	r_pocket = /obj/item/stamp/head/qm

// Corpses
/obj/effect/mob_spawn/corpse/human/factory
	name = "Factory Worker"
	outfit = /datum/outfit/factory
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/factory/guard
	name = "Factory Guard"
	outfit = /datum/outfit/factory/guard
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/factory/qm
	name = "Factory Quartermaster"
	outfit = /datum/outfit/factory/qm
	icon_state = "corpsecargotech"
