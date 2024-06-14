/datum/lazy_template/virtual_domain/wendigo
	name = "Ледниковый опустошитель"
	cost = BITRUNNER_COST_HIGH
	desc = "Легенды рассказывают о хищных вендиго, скрывающихся в глубине пещер Ледяной Луны."
	difficulty = BITRUNNER_DIFFICULTY_HIGH
	forced_outfit = /datum/outfit/job/miner
	key = "wendigo"
	map_name = "wendigo"
	reward_points = BITRUNNER_REWARD_HIGH
	safehouse_path = /datum/map_template/safehouse/lavaland_boss

/mob/living/simple_animal/hostile/megafauna/wendigo/virtual_domain
	can_be_cybercop = FALSE
	crusher_loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	guaranteed_butcher_results = list(/obj/item/wendigo_skull = 1)
	health = 2000
	loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	maxHealth = 2000
	true_spawn = FALSE
