/datum/disease/gbs
	name = "GBS"
	max_stages = 4
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Синаптизин и сера"
	cures = list(/datum/reagent/medicine/synaptizine,/datum/reagent/sulfur)
	cure_chance = 7.5 //higher chance to cure, since two reagents are required
	agent = "Гравитокинетические бипотенциальные SADS+"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 1
	severity = DISEASE_SEVERITY_BIOHAZARD

/datum/disease/gbs/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("cough")
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("gasp")
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Всё тело болит!"))
		if(4)
			to_chat(affected_mob, span_userdanger("Тело разрывается на куски!"))
			if(SPT_PROB(30, seconds_per_tick))
				affected_mob.investigate_log("has been gibbed by GBS.", INVESTIGATE_DEATHS)
				affected_mob.gib(DROP_ALL_REMAINS)
				return FALSE
