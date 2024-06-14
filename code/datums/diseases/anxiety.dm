/datum/disease/anxiety
	name = "Сильное беспокойство"
	form = "Инфекционное заболевание"
	max_stages = 4
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Этанол"
	cures = list(/datum/reagent/consumable/ethanol)
	agent = "Избыток лепидоптицидов"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Если не лечить, у субъекта будут извергаться бабочки."
	severity = DISEASE_SEVERITY_MINOR


/datum/disease/anxiety/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2) //also changes say, see say.dm
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_notice("Беспокойно."))
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_notice("Живот трепещет."))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_notice("Паника накатывает."))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("ПАНИКУЮ!"))
				affected_mob.adjust_confusion(rand(2 SECONDS, 3 SECONDS))
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Ощущаю бабочек в своём животе."))
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] спотыкается в панике.") , \
												span_userdanger("ПАНИЧЕСКАЯ АТАКА!"))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
				affected_mob.adjust_jitter(rand(12 SECONDS, 16 SECONDS))
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] выкашливает бабочек!") , \
													span_userdanger("Выкашливаю бабочек!"))
				new /mob/living/basic/butterfly(affected_mob.loc)
				new /mob/living/basic/butterfly(affected_mob.loc)
