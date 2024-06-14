/datum/lazy_template/virtual_domain/syndicate_assault
	name = "Штурм Синдиката"
	cost = BITRUNNER_COST_MEDIUM
	desc = "Возьми на абордаж вражеский корабль и верни похищенный груз."
	difficulty = BITRUNNER_DIFFICULTY_MEDIUM
	extra_loot = list(/obj/item/toy/plush/nukeplushie = 1)
	help_text = "Группа боевиков Синдиката похитила ценный груз со станции. \
	Они поднялись на борт своего корабля и пытаются скрыться. Проникните на их корабль и заберите \
	ящик. Будьте осторожны - они вооружены до зубов и очень опасны."
	key = "syndicate_assault"
	map_name = "syndicate_assault"
	reward_points = BITRUNNER_REWARD_MEDIUM
	safehouse_path = /datum/map_template/safehouse/shuttle
