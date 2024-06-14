/obj/machinery/plantgenes
	name = "манипулятор ДНК растений"
	desc = "Позволяет работать с генетическим кодом растений для увеличения их потенциала."
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "dnamod"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/plantgenes
	pass_flags = PASSTABLE
	anchored = FALSE

	var/obj/item/seeds/seed
	var/obj/item/disk/plantgene/disk

	var/list/core_genes = list()
	var/list/reagent_genes = list()
	var/list/trait_genes = list()

	var/datum/plant_gene/target
	var/operation = ""
	var/max_potency = 50 // See RefreshParts() for how these work
	var/max_yield = 2
	var/min_production = 12
	var/max_endurance = 10 // IMPT: ALSO AFFECTS LIFESPAN
	var/min_wchance = 67
	var/min_wrate = 10
	var/max_instability = 10
	var/list/gene_categories
	var/list/core_stats



/obj/machinery/plantgenes/RefreshParts() // Comments represent the max you can set per tier, respectively. seeds.dm [219] clamps these for us but we don't want to mislead the viewer.
	. = ..()
	for(var/obj/item/stock_parts/servo/M in component_parts)
		if(M.rating > 3)
			max_potency = 95
		else
			max_potency = initial(max_potency) + (M.rating**3) // 53,59,77,95 	 Clamps at 100

		max_yield = initial(max_yield) + (M.rating*2) // 4,6,8,10 	Clamps at 10
		max_instability = initial(max_instability) + (M.rating*20) // 50, 70, 90

	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		if(SM.rating > 3) //If you create t5 parts I'm a step ahead mwahahaha!
			min_production = 1
		else
			min_production = 12 - (SM.rating * 3) //9,6,3,1. Requires if to avoid going below clamp [1]

		max_endurance = initial(max_endurance) + (SM.rating * 25) // 35,60,85,100	Clamps at 10min 100max

	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		var/wratemod = ML.rating * 2.5
		min_wrate = FLOOR(10-wratemod,1) // 7,5,2,0	Clamps at 0 and 10	You want this low
		min_wchance = 67-(ML.rating*16) // 48,35,19,3 	Clamps at 0 and 67	You want this low

//	for(var/obj/item/circuitboard/machine/plantgenes/vaultcheck in component_parts)
//		if(istype(vaultcheck, /obj/item/circuitboard/machine/plantgenes/vault)) // TRAIT_DUMB BOTANY TUTS
//			max_potency = 100
//			max_yield = 10
//			min_production = 1
//			max_endurance = 100
//			min_wchance = 0
//			min_wrate = 0

/obj/machinery/plantgenes/update_icon_state()
	. = ..()
	if((machine_stat & (BROKEN|NOPOWER)))
		icon_state = "dnamod-off"
	else
		icon_state = "dnamod"

/obj/machinery/plantgenes/update_overlays()
	. = ..()
	if(seed)
		. += "dnamod-dna"
	if(panel_open)
		. += "dnamod-open"

/obj/machinery/plantgenes/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "dnamod", "dnamod", I))
		update_icon()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(iscyborg(user))
		return

	if(istype(I, /obj/item/seeds))
		if (operation)
			to_chat(user, span_notice("Please complete current operation."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		eject_seed()
		insert_seed(I)
		to_chat(user, span_notice("You add [I] to the machine."))
		interact(user)
	else if(istype(I, /obj/item/disk/plantgene))
		if (operation)
			to_chat(user, span_notice("Please complete current operation."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		eject_disk()
		disk = I
		to_chat(user, span_notice("You add [I] to the machine."))
		interact(user)
	else
		..()
//
/obj/machinery/plantgenes/ui_interact(mob/user)
	. = ..()
	if(!user)
		return

	var/datum/browser/popup = new(user, "plantdna", "Plant DNA Manipulator", 450, 600)
	if(!(in_range(src, user) || issilicon(user)))
		popup.close()
		return

	var/dat = ""

	if(operation)
		if(!seed || (!target && operation != "insert" && operation != "insert_reagent_gene"))
			operation = ""
			target = null
			interact(user)
			return
		if((operation == "replace" || operation == "insert" || operation == "insert_reagent_gene") && (!disk || !disk.gene))
			operation = ""
			target = null
			interact(user)
			return

		dat += "<div class='line'><h3>Confirm Operation</h3></div>"
		dat += "<div class='statusDisplay'>Are you sure you want to [operation] "
		switch(operation)
			if("remove", "extract", "replace", "insert", "insert_reagent_gene")
				dat += "<span class='highlight'>[target.get_name()]</span> gene from <span class='highlight'>[seed]</span>?<br>"
			if("extract")
				dat += span_bad("The sample will be destroyed in process!")
				// Ограничение характеристик при вытягивании
				var/stat_name = null
				switch(target.type)
					if("/datum/plant_gene/trait/potency")
						stat_name = "Potency"
					if("/datum/plant_gene/trait/lifespan")
						stat_name = "Lifespan"
					if("/datum/plant_gene/trait/endurance")
						stat_name = "Endurance"
					if("/datum/plant_gene/trait/yield")
						stat_name = "Yield"
					if("/datum/plant_gene/trait/production")
						stat_name = "Production"
					if("/datum/plant_gene/trait/weed_rate")
						stat_name = "Weed Rate"
					if("/datum/plant_gene/trait/weed_chance")
						stat_name = "Weed Chance"
					if("/datum/plant_gene/trait/instability")
						stat_name = "Instability"
				if(stat_name)
					var/stat_value = core_stats[stat_name]
					var/max_value = null
					var/min_value = null
					switch(stat_name)
						if("Potency")
							max_value = max_potency
						if("Lifespan", "Endurance")
							max_value = max_endurance
						if("Yield")
							max_value = max_yield
						if("Production")
							min_value = min_production
						if("Weed Rate")
							min_value = min_wrate
						if("Weed Chance")
							min_value = min_wchance
						if("Instability")
							max_value = max_instability
					if((max_value && stat_value > max_value) || (min_value && stat_value < min_value))
						var/limited_value = max_value ? max_value : min_value
						dat += "<br><br>This device's extraction capabilities are currently limited to <span class='highlight'>[limited_value]</span> [stat_name]. "
						dat += "Target gene will be degraded to <span class='highlight'>[limited_value]</span> [stat_name] on extraction."


			if("replace")
				dat += "<span class='highlight'>[target.get_name()]</span> gene with <span class='highlight'>[disk.gene.get_name()]</span>?<br>"
			if("insert")
				dat += "<span class='highlight'>[disk.gene.get_name()]</span> gene into <span class='highlight'>[seed]</span>?<br>"
		dat += "</div><div class='line'><a href='?src=[REF(src)];gene=[REF(target)];op=[operation]'>Confirm</a> "
		dat += "<a href='?src=[REF(src)];abort=1'>Abort</a></div>"
		popup.set_content(dat)
		popup.open()
		return

	dat+= "<div class='statusDisplay'>"

	dat += "<div class='line'><div class='statusLabel'>Plant Sample:</div><div class='statusValue'><a href='?src=[REF(src)];eject_seed=1'>"
	dat += seed ? seed.name : "None"
	dat += "</a></div></div>"

	dat += "<div class='line'><div class='statusLabel'>Data Disk:</div><div class='statusValue'><a href='?src=[REF(src)];eject_disk=1'>"
	if(!disk)
		dat += "None"
	else if(!disk.gene)
		dat += "Empty Disk"
	else
		dat += disk.gene.get_name()
	if(disk && disk.read_only)
		dat += " (RO)"
	dat += "</a></div></div>"

	dat += "<br></div>"

	if(seed)
		var/can_insert = disk && disk.gene && disk.gene.can_add(seed)
		var/can_extract = disk && !disk.read_only
		// --- Отображение Core Stats ---
		dat += "<div class='line'><h3>Core Stats</h3></div>"
		dat += "<div class='statusDisplay'><table>"
		for (var/stat_name in core_stats)
			var/stat_value = core_stats[stat_name]
			dat += "<tr><td width='260px'>[stat_name]:</td><td>[stat_value]</td>"
			if(can_extract) // Проверка, можно ли извлекать гены
				dat += "<td><a href='?src=[REF(src)];extract_stat=[stat_name]'>Extract</a></td></tr>"
			else
				dat += "<td></td></tr>" // Добавляем пустую ячейку, если вытягивание невозможно
		dat += "</table></div>"
		// --- Отображение Reagent Genes ---
		dat += "<div class='line'><h3>Reagent Genes</h3></div>"
		dat += "<div class='statusDisplay'>"

		var has_reagent_genes = FALSE
		for (var/datum/plant_gene/gene in seed.genes)
			if (istype(gene, /datum/plant_gene/reagent))
				has_reagent_genes = TRUE
				break

		if (has_reagent_genes)
			dat += "<table>"
			for (var/datum/plant_gene/gene in seed.genes)
				if (!istype(gene, /datum/plant_gene/reagent))
					continue // Пропускаем гены, которые не являются Reagent Genes

				dat += "<tr><td width='260px'>[gene.get_name()]</td><td>"

				// Проверка наличия диска и защиты от записи для Extract
				if (disk && !disk.read_only)
					dat += "<a href='?src=[REF(src)];gene=[REF(gene)];op=extract'>Extract</a> "

				// Кнопка Remove для реагентов
				if (gene.mutability_flags & PLANT_GENE_REMOVABLE)
					dat += "<a href='?src=[REF(src)];gene=[REF(gene)];op=remove'>Remove</a>"

				dat += "</td></tr>"
			dat += "</table>"
		else
			dat += "No reagent genes detected in sample.<br>"

		dat += "</div>"

		// --- Кнопка вставки гена реагента ---
		if(can_insert && istype(disk.gene, /datum/plant_gene/reagent))
			dat += "<a href='?src=[REF(src)];insert_reagent_gene=1'>Insert: [disk.gene.get_name()]</a><br>"

		dat += "<div class='line'><h3>Trait Genes</h3></div>"
		dat += "<div class='statusDisplay'>"
		var/has_trait_genes = FALSE
		for(var/datum/plant_gene/gene in seed.genes)
			if(istype(gene, /datum/plant_gene/trait))
				has_trait_genes = TRUE
				break
		if(has_trait_genes)
			dat += "<table>"
			for(var/datum/plant_gene/gene in seed.genes)
				if(!istype(gene, /datum/plant_gene/trait))
					continue // Пропускаем гены, которые не являются Trait Genes
				dat += "<tr><td width='260px'>[gene.get_name()]</td><td>"
				if(can_extract && gene.mutability_flags & PLANT_GENE_MUTATABLE)
					dat += "<a href='?src=[REF(src)];gene=[REF(gene)];op=extract'>Extract</a>"
				if(gene.mutability_flags & PLANT_GENE_REMOVABLE)
					dat += "<a href='?src=[REF(src)];gene=[REF(gene)];op=remove'>Remove</a>"
				dat += "</td></tr>"
			dat += "</table>"
		else
			dat += "No trait-related genes detected in sample.<br>"
		dat += "</div>"
		if(can_insert && istype(disk.gene, /datum/plant_gene/trait))
			dat += "<a href='?src=[REF(src)];op=insert'>Insert: [disk.gene.get_name()]</a>"
		dat += "</div>"
	else
		dat += "<br>No sample found.<br><span class='highlight'>Please, insert a plant sample to use this device.</span>"
	popup.set_content(dat)
	popup.open()
//
/obj/machinery/plantgenes/Topic(href, list/href_list)
	if(..()) // Обработка стандартных действий Topic
		return

	usr.set_machine(src) // Запоминаем, что игрок использует это устройство

	// --- Обработка выгрузки семян ---
	if(href_list["eject_seed"] && !operation)
		var/obj/item/I = usr.get_active_held_item()
		if(istype(I, /obj/item/seeds)) // Если игрок держит семена, вставляем их
			if(!usr.transferItemToLoc(I, src))
				return
			eject_seed()
			insert_seed(I)
			to_chat(usr, span_notice("You add [I] to the machine."))
		else // Иначе выгружаем текущие семена
			eject_seed()

	// --- Обработка выгрузки диска ---
	else if(href_list["eject_disk"] && !operation)
		var/obj/item/I = usr.get_active_held_item()
		if(istype(I, /obj/item/disk/plantgene)) // Если игрок держит диск, вставляем его
			if(!usr.transferItemToLoc(I, src))
				return
			eject_disk()
			disk = I
			to_chat(usr, span_notice("You add [I] to the machine."))
		else // Иначе выгружаем текущий диск
			eject_disk()

	// --- Обработка вставки гена ---
	else if(href_list["op"] == "insert" && disk && disk.gene && seed)
		if(!operation) // Ждем подтверждения
			operation = "insert"
		else
			if(disk.gene.can_add(seed)) // Проверяем совместимость гена
				if(istype(disk.gene, /datum/plant_gene/trait/custom_stat)) // Если вставляем характеристику
					var/datum/plant_gene/trait/custom_stat/stat_gene = disk.gene
					core_stats[stat_gene.stat_name] = stat_gene.stat_value // Изменяем значение характеристики в core_stats

					// Обновляем свойства семян, если нужно
					switch (stat_gene.stat_name)
						if ("Potency")
							seed.potency = stat_gene.stat_value
						if ("Yield")
							seed.yield = stat_gene.stat_value
						if ("Production")
							seed.production = stat_gene.stat_value
						if ("Endurance")
							seed.endurance = stat_gene.stat_value
						if ("Lifespan")
							seed.lifespan = stat_gene.stat_value
						if ("Weed Rate")
							seed.weed_rate = stat_gene.stat_value
						if ("Weed Chance")
							seed.weed_chance = stat_gene.stat_value
						if ("Instability")
							seed.instability = stat_gene.stat_value
				else
					seed.genes += disk.gene.Copy() // Копируем ген на семена
					seed.reagents_from_genes() // Обновляем список реагентов, если нужно

				// Действия после успешной вставки
				update_genes() // Обновляем списки генов
				repaint_seed() // Перекрашиваем семена
			else // Обработка, если ген не может быть вставлен
				to_chat(usr, span_warning("Unable to insert gene: [disk.gene.get_name()]")) // Повідомлення про помилку

			operation = "" // Сбрасываем операцию
			target = null // Сбрасываем целевой ген

	// --- Обработка вставки гена реагента ---
	else if(href_list["insert_reagent_gene"] && disk && disk.gene && seed && istype(disk.gene, /datum/plant_gene/reagent))
		if(!operation) // Ждем подтверждения
			operation = "insert_reagent_gene"
		else
			if(disk.gene.can_add(seed)) // Проверяем совместимость гена
				seed.genes += disk.gene.Copy() // Копируем ген на семена
				seed.reagents_from_genes() // Обновляем список реагентов
				update_genes() // Обновляем списки генов
				repaint_seed() // Перекрашиваем семена
			else // Обработка, если ген не может быть вставлен
				to_chat(usr, span_warning("Unable to insert gene: [disk.gene.get_name()]")) // Повідомлення про помилку

			operation = "" // Сбрасываем операцию
			target = null // Сбрасываем целевой ген

	// --- Обработка удаления, извлечения и замены гена ---
	else if(href_list["gene"] && seed)
		var/datum/plant_gene/G = locate(href_list["gene"]) in seed.genes
		var/gene_index = seed.genes.Find(G) // Находим индекс гена

		if(!G || !href_list["op"] || !(href_list["op"] in list("remove", "extract", "replace")) || gene_index == 0)
			interact(usr)
			return

		if(!operation || target != G) // Ждем подтверждения
			target = G
			operation = href_list["op"]

		else if(operation == href_list["op"] && target == G)
			switch(href_list["op"])
				if("remove") // Удаление гена
					if(G.mutability_flags & PLANT_GENE_REMOVABLE) // Проверяем, можно ли удалить ген
						seed.genes.Cut(gene_index, gene_index + 1) // Удаляем ген по индексу
						seed.reagents_from_genes() // Обновляем seed.reagents_add
					repaint_seed()

				if("extract") // Извлечение гена на диск
					if(disk && !disk.read_only)
						disk.gene = G
						disk.gene_categories = gene_categories // Сохраняем ссылку на gene_categories в диске
						seed.genes.Cut(gene_index, gene_index + 1) // Удаляем ген по индексу

						// --- Ограничение характеристик при извлечении ---
						var/stat_name = null
						switch(G.type)
							if("/datum/plant_gene/trait/potency")
								stat_name = "Potency"
							if("/datum/plant_gene/trait/lifespan")
								stat_name = "Lifespan"
							if("/datum/plant_gene/trait/endurance")
								stat_name = "Endurance"
							if("/datum/plant_gene/trait/yield")
								stat_name = "Yield"
							if("/datum/plant_gene/trait/production")
								stat_name = "Production"
							if("/datum/plant_gene/trait/weed_rate")
								stat_name = "Weed Rate"
							if("/datum/plant_gene/trait/weed_chance")
								stat_name = "Weed Chance"
							if("/datum/plant_gene/trait/instability")
								stat_name = "Instability"
						if(stat_name)
							var/stat_value = core_stats[stat_name]
							var/max_value = null
							var/min_value = null
							switch(stat_name)
								if("Potency")
									max_value = max_potency
								if("Lifespan", "Endurance")
									max_value = max_endurance
								if("Yield")
									max_value = max_yield
								if("Production")
									min_value = min_production
								if("Weed Rate")
									min_value = min_wrate
								if("Weed Chance")
									min_value = min_wchance
								if("Instability")
									max_value = max_instability
							core_stats[stat_name] = clamp(stat_value, min_value, max_value)

						disk.update_name()
						seed.reagents_from_genes() // Обновляем список реагентов
						qdel(seed)
						seed = null
						update_icon()

				if("replace") // Замена гена
					if(disk && disk.gene && istype(disk.gene, G.type) && (G.mutability_flags & PLANT_GENE_REMOVABLE))
						seed.genes -= G
						seed.genes += disk.gene.Copy()
						seed.reagents_from_genes() // Обновляем seed.reagents_add
						repaint_seed()

			update_genes()
			operation = ""
			target = null

	// --- Обработка извлечения характеристики ---
	else if(href_list["extract_stat"] && seed && disk && !disk.read_only)
		var/stat_name = href_list["extract_stat"]
		var/stat_value = core_stats[stat_name]

		// Добавляем предупреждение об уничтожении семян
		var/confirm = tgui_alert(usr, "Extracting this stat will destroy the seed sample. Are you sure?", "Confirmation", list("Yes", "No"))
		if(confirm != "Yes")
			return

		// Создание нового гена на основе stat_name и stat_value
		var/datum/plant_gene/new_gene = new /datum/plant_gene/trait/custom_stat(stat_name, stat_value)
		disk.gene = new_gene
		disk.update_name()

		qdel(seed) // Удаляем семена
		seed = null
		interact(usr) // Обновляем интерфейс пользователя

	// --- Отмена операции ---
	else if(href_list["abort"])
		operation = ""
		target = null

	interact(usr) // Обновляем интерфейс пользователя
//
/obj/machinery/plantgenes/proc/insert_seed(obj/item/seeds/S)
	if(!istype(S) || seed)
		return
	S.forceMove(src)
	seed = S
	update_genes()
	update_icon()

/obj/machinery/plantgenes/proc/eject_disk()
	if (disk && !operation)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(disk))
				disk.forceMove(drop_location())
		else
			disk.forceMove(drop_location())
		disk = null
		update_genes()

/obj/machinery/plantgenes/proc/eject_seed()
	if (seed && !operation)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(seed))
				seed.forceMove(drop_location())
		else
			seed.forceMove(drop_location())
		seed = null
		update_genes()

/obj/machinery/plantgenes/proc/update_genes()
    gene_categories = list(
        "Reagent Genes" = list(),
        "Trait Genes" = list(),
        "Core Genes" = list()
    )
    core_stats = list()

    if (seed)
        // Получаем характеристики из seed
        core_stats["Potency"] = seed.potency
        core_stats["Yield"] = seed.yield
        core_stats["Production"] = seed.production
        core_stats["Endurance"] = seed.endurance
        core_stats["Lifespan"] = seed.lifespan
        core_stats["Weed Rate"] = seed.weed_rate
        core_stats["Weed Chance"] = seed.weed_chance
        core_stats["Instability"] = seed.instability

        // Распределяем гены по категориям
        for (var/datum/plant_gene/gene in seed.genes)
            switch (gene.type)
                // Reagent Genes
                if("/datum/plant_gene/reagent",
                   "/datum/plant_gene/reagent/preset",)
                    gene_categories["Reagent Genes"] += gene

                // Trait Genes
                if("/datum/plant_gene/trait/anti_magic",
                   "/datum/plant_gene/trait/attack",
                   "/datum/plant_gene/trait/attack/novaflower_attack",
                   "/datum/plant_gene/trait/attack/sunflower_attack",
                   "/datum/plant_gene/trait/attack/nettle_attack",
                   "/datum/plant_gene/trait/attack/nettle_attack/death",
                   "/datum/plant_gene/trait/backfire",
                   "/datum/plant_gene/trait/backfire/rose_thorns",
                   "/datum/plant_gene/trait/backfire/novaflower_heat",
                   "/datum/plant_gene/trait/backfire/nettle_burn",
                   "/datum/plant_gene/trait/backfire/nettle_burn/death",
                   "/datum/plant_gene/trait/backfire/chili_heat",
                   "/datum/plant_gene/trait/backfire/bluespace",
                   "/datum/plant_gene/trait/mob_transformation",
                   "/datum/plant_gene/trait/mob_transformation/tomato",
                   "/datum/plant_gene/trait/mob_transformation/shroom",
                   "/datum/plant_gene/trait/one_bite",
                   "/datum/plant_gene/trait/modified_volume",
                   "/datum/plant_gene/trait/modified_volume/omega_weed",
                   "/datum/plant_gene/trait/modified_volume/cherry_bomb",
                   "/datum/plant_gene/trait/bomb_plant",
                   "/datum/plant_gene/trait/bomb_plant/potency_based",
                   "/datum/plant_gene/trait/gas_production",
                   "/datum/plant_gene/trait/invasive/galaxythistle",
                   "/datum/plant_gene/trait/carnivory/jupitercup",
                   "/datum/plant_gene/trait/squash",
                   "/datum/plant_gene/trait/slip",
                   "/datum/plant_gene/trait/cell_charge",
                   "/datum/plant_gene/trait/glow",
                   "/datum/plant_gene/trait/glow/shadow",
                   "/datum/plant_gene/trait/glow/white",
                   "/datum/plant_gene/trait/glow/red",
                   "/datum/plant_gene/trait/glow/yellow",
                   "/datum/plant_gene/trait/glow/green",
                   "/datum/plant_gene/trait/glow/blue",
                   "/datum/plant_gene/trait/glow/purple",
                   "/datum/plant_gene/trait/glow/pink",
                   "/datum/plant_gene/trait/teleport",
                   "/datum/plant_gene/trait/maxchem",
                   "/datum/plant_gene/trait/repeated_harvest",
                   "/datum/plant_gene/trait/battery",
                   "/datum/plant_gene/trait/stinging",
                   "/datum/plant_gene/trait/smoke",
                   "/datum/plant_gene/trait/fire_resistance",
                   "/datum/plant_gene/trait/invasive",
                   "/datum/plant_gene/trait/brewing",
                   "/datum/plant_gene/trait/juicing",
                   "/datum/plant_gene/trait/plant_laughter",
                   "/datum/plant_gene/trait/eyes",
                   "/datum/plant_gene/trait/sticky",
                   "/datum/plant_gene/trait/chem_heating",
                   "/datum/plant_gene/trait/chem_cooling",
                   "/datum/plant_gene/trait/never_mutate",
                   "/datum/plant_gene/trait/stable_stats",
                   "/datum/plant_gene/trait/preserved")
                    gene_categories["Trait Genes"] += gene

                // Core Genes
                if("/datum/plant_gene/trait/lifespan",
                   "/datum/plant_gene/trait/endurance",
                   "/datum/plant_gene/trait/production",
                   "/datum/plant_gene/trait/yield",
                   "/datum/plant_gene/trait/potency",
                   "/datum/plant_gene/trait/instability",
                   "/datum/plant_gene/trait/weed_rate",
                   "/datum/plant_gene/trait/weed_chance",
                   "/datum/plant_gene/trait/plant_type",
                   "/datum/plant_gene/trait/plant_type/weed_hardy",
                   "/datum/plant_gene/trait/plant_type/fungal_metabolism",
                   "/datum/plant_gene/trait/plant_type/alien_properties")
                    gene_categories["Core Genes"] += gene

/obj/machinery/plantgenes/proc/repaint_seed()
	if(!seed)
		return
	if(copytext(seed.name, 1, 13) == "experimental")//13 == length("experimental") + 1
		return // Already modded name and icon
	seed.name = "experimental " + seed.name
	seed.icon_state = "seed-x"



/*
 *  Plant DNA disk
 */

/obj/item/disk/plantgene
	name = "диск с ботаническими данными"
	desc = "Диск для записи генетических данных растений."
	icon_state = "datadisk_hydro"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)
	var/datum/plant_gene/gene
	var/read_only = 0 //Well, it's still a floppy disk
	var/list/gene_categories
	obj_flags = UNIQUE_RENAME

/obj/item/disk/plantgene/Initialize(mapload)
	. = ..()
	add_overlay("datadisk_gene")
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/disk/plantgene/update_name()
	if(gene)
		name = "[gene.get_name()] (plant data disk)"
	else
		name = "plant data disk"
	return ..()

/obj/item/disk/plantgene/attack_self(mob/user)
	read_only = !read_only
	to_chat(user, span_notice("You flip the write-protect tab to [src.read_only ? "protected" : "unprotected"]."))

/obj/item/disk/plantgene/examine(mob/user)
	. = ..()

	// Проверяем, есть ли ген потенции в категории "Core Genes"
	var/has_potency_gene = FALSE
	for(var/datum/plant_gene/gene in gene_categories["Core Genes"])
		if(gene.type == "/datum/plant_gene/trait/potency")
			has_potency_gene = TRUE
			break

	if(has_potency_gene)
		. += "<hr><span class='notice'>Percent is relative to potency, not maximum volume of the plant.</span>"

	. += "<hr>The write-protect tab is set to [src.read_only ? "protected" : "unprotected"]."
