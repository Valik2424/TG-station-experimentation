/// Caused by dirty food. Makes you vomit stars.
/datum/disease/advance/nebula_nausea
	name = "Туманная тошнота"
	desc = "Вы не можете сдержать красочную красоту космоса внутри."
	form = "Состояния"
	agent = "Stars"
	cures = list(/datum/reagent/bluespace)
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_MEDIUM
	required_organ = ORGAN_SLOT_STOMACH
	max_stages = 5

/datum/disease/advance/nebula_nausea/New()
	symptoms = list(new/datum/symptom/vomit/nebula)
	..()

/datum/disease/advance/nebula_nausea/generate_cure()
	cures = list(pick(cures))
	var/datum/reagent/cure = GLOB.chemical_reagents_list[cures[1]]
	cure_text = cure.name

/datum/disease/advance/nebula_nausea/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Красочная красота космоса, кажется, повлияла на моё равновесие."))
		if(3)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Желудок заполнился цветами, невидимыми человеческим глазом."))
		if(4)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Кажется, что я плыву в море небесных цветов."))
		if(5)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Желудок превратился в бурный туман, вращающийся калейдоскопическими узорами.."))
