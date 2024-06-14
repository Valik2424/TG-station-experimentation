/datum/lazy_template/virtual_domain/beach_bar
	name = "Пляжный бар"
	desc = "Веселый приморский уголок, где дружелюбные скелеты подают напитки. Так как вы, ребята, умерли?"
	extra_loot = list(/obj/item/toy/beach_ball = 1)
	help_text = "Это место управляется командой скелетов, и они не особо хотят делится информацией. \
	Может быть, несколько рюмок жидкого очарования поднимут настроение. Как говорится, если не можешь победить их - присоединяйся к ним."
	key = "beach_bar"
	map_name = "beach_bar"
	safehouse_path = /datum/map_template/safehouse/mine

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/virtual_domain
	name = "пина колада"
	desc = "Чей это напиток? Не твой, это точно. Ну, не факт, что они это пропустят."
	list_reagents = list(/datum/reagent/consumable/ethanol/pina_colada = 30)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/virtual_domain/Initialize(mapload, vol)
	. = ..()

	AddComponent(/datum/component/bitrunning_points, \
		signal_type = COMSIG_GLASS_DRANK, \
		points_per_signal = 0.5, \
	)
