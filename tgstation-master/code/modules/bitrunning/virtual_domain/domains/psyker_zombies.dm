/datum/lazy_template/virtual_domain/psyker_zombies
	name = "Зараженный домен"
	cost = BITRUNNER_COST_MEDIUM
	desc = "Еще один заброшенный уголок виртуального мира. Этот пришлось забросить из-за зомби-вируса. \
		Предупреждение: Виртуальный домен не поддерживает визуальное отображение. Это задание должно быть выполнено с помощью эхолокации."
	difficulty = BITRUNNER_DIFFICULTY_MEDIUM
	help_text = "Этот некогда любимый виртуальный домен был поврежден вирусом, в результате чего он стал нестабильным, полным дыр и ЗОМБИ! \
		Поблизости должен быть Тайный ящик, который поможет вам вооружиться. Вооружитесь и закончите начатое киберполицией!"
	key = "psyker_zombies"
	map_name = "psyker_zombies"
	reward_points = BITRUNNER_REWARD_HIGH
	safehouse_path = /datum/map_template/safehouse/bathroom
	forced_outfit = /datum/outfit/echolocator
	extra_loot = list(/obj/item/radio/headset/psyker = 1) //Looks cool, might make your local burdened chaplain happy.
