/datum/disease/beesease
	name = "Пчелозис"
	form = "Инфекционное заболевание"
	max_stages = 4
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Сахар"
	cures = list(/datum/reagent/consumable/sugar)
	agent = "Инфекция медовых"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Если не лечить субъект, пчелы изрыгнут его."
	severity = DISEASE_SEVERITY_MEDIUM
	infectable_biotypes = MOB_ORGANIC|MOB_UNDEAD //bees nesting in corpses


/datum/disease/beesease/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2) //also changes say, see say.dm
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_notice("На вкус как мёд."))
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_notice("Желудок жужжит."))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Желудок колется больно."))
				if(prob(20))
					affected_mob.adjustToxLoss(2)
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] жужжит.") , \
												span_userdanger("Желудок жёстко жужжит!"))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Что-то двигается в моём рту."))
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] выкашливает пчёл!") , \
													span_userdanger("Выкашливаю рой пчёл!"))
				new /mob/living/basic/bee(affected_mob.loc)
