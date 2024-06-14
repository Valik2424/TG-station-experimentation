/datum/disease/fluspanish
	name = "Грипп Испанской инквизиции"
	max_stages = 3
	spread_text = "Воздушное"
	cure_text = "Космоциллин и антитела к простому гриппу"
	cures = list(/datum/reagent/medicine/spaceacillin)
	cure_chance = 5
	agent = "1nqu1s1t10n вирион гриппа"
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 0.75
	desc = "Если не лечить, субъект сгорит за то, что был еретиком."
	severity = DISEASE_SEVERITY_DANGEROUS
	required_organ = ORGAN_SLOT_LUNGS

/datum/disease/fluspanish/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			affected_mob.adjust_bodytemperature(5 * seconds_per_tick)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Горю изнутри!"))
				affected_mob.take_bodypart_damage(0, 5, updating_health = FALSE)

		if(3)
			affected_mob.adjust_bodytemperature(10 * seconds_per_tick)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Горю изнутри!"))
				affected_mob.take_bodypart_damage(0, 5, updating_health = FALSE)
