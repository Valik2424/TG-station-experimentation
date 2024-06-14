/datum/disease/death_sandwich_poisoning
	name = "Отравление смертельным сэндвичем"
	desc = "Если не лечить, то субъект в конечном итоге погибнет."
	form = "Состояние"
	spread_text = "Неизвестное"
	max_stages = 3
	cure_text = "Анацея" // I ain't about to make a second sandwich to counteract the first one, so closest thing I'm going for is this.
	cures = list(/datum/reagent/toxin/anacea)
	cure_chance = 4
	agent = "поедание смертельного сэндвича"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_DANGEROUS
	disease_flags = CURABLE
	spread_flags = DISEASE_SPREAD_SPECIAL
	visibility_flags = HIDDEN_SCANNER
	bypasses_immunity = TRUE
	required_organ = ORGAN_SLOT_STOMACH

/datum/disease/death_sandwich_poisoning/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(1.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.adjustToxLoss(5)
		if(2)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Мне жарко!"))
				if(prob(20))
					affected_mob.take_bodypart_damage(burn = 1)
			if(SPT_PROB(3, seconds_per_tick))
				affected_mob.adjustToxLoss(10)

		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.emote("gasp")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 20)
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Мне жарко!"))
				if(prob(60))
					affected_mob.take_bodypart_damage(burn = 2)
			if(SPT_PROB(6, seconds_per_tick))
				affected_mob.adjustToxLoss(15)
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Пытаюсь кричать, но ничего не получается!"))
				affected_mob.set_silence_if_lower(5 SECONDS)

