/datum/disease/tuberculosis
	form = "Болезнь"
	name = "Грибковый туберкулез"
	max_stages = 5
	spread_text = "Воздушное"
	cure_text = "Космоциллин и конвермол"
	cures = list(/datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/c2/convermol)
	agent = "Грибковая туберкулезная космическая палочка"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 2.5 //like hell are you getting out of hell
	desc = "Редкий высокотрансмиссивный вирулентный вирус. Существует немного образцов, которые, по слухам, были тщательно выращены и культивированы тайными специалистами по биологическому оружию. Вызывает лихорадку, рвоту кровью, повреждение легких, потерю веса и усталость."
	required_organ = ORGAN_SLOT_LUNGS
	severity = DISEASE_SEVERITY_BIOHAZARD
	bypasses_immunity = TRUE // TB primarily impacts the lungs; it's also bacterial or fungal in nature; viral immunity should do nothing.

/datum/disease/tuberculosis/stage_act(seconds_per_tick, times_fired) //it begins
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("cough")
				to_chat(affected_mob, span_danger("Грудь болит."))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Желужок жужжит!"))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Потею."))
		if(4)
			var/need_mob_update = FALSE
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("Вижу всего по четыре!"))
				affected_mob.set_dizzy_if_lower(10 SECONDS)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Грудь болит!"))
				need_mob_update += affected_mob.adjustOxyLoss(5, updating_health = FALSE)
				affected_mob.emote("gasp")
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("Воздух больно выходит из моих лёгких."))
				need_mob_update += affected_mob.adjustOxyLoss(25, updating_health = FALSE)
				affected_mob.emote("gasp")
			if(need_mob_update)
				affected_mob.updatehealth()
		if(5)
			var/need_mob_update = FALSE
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("[pick("Сердце замедляется...", "Расслабляюсь вместе с сердечным ритмом.")]"))
				need_mob_update += affected_mob.adjustStaminaLoss(70, updating_stamina = FALSE)
			if(SPT_PROB(5, seconds_per_tick))
				need_mob_update += affected_mob.adjustStaminaLoss(100, updating_stamina = FALSE)
				affected_mob.visible_message(span_warning("[affected_mob] ослабевает!") , span_userdanger("Сдаюсь и ощущаю умиротворение..."))
				affected_mob.AdjustSleeping(100)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("Мой разум расслабляется и мысли текут!"))
				affected_mob.adjust_confusion_up_to(8 SECONDS, 100 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("<i>[pick("Желудок тихо жужжит...", "Живот содрогается в последний раз, безжизненный взгляд застывает...", "Хочу съесть мелок")]</i>"))
				affected_mob.overeatduration = max(affected_mob.overeatduration - (200 SECONDS), 0)
				affected_mob.adjust_nutrition(-100)
			if(SPT_PROB(7.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("[pick("Слишком жарко...", "Надо расстегнуть костюм...", "Надо снять одежду...")]"))
				affected_mob.adjust_bodytemperature(40)
			if(need_mob_update)
				affected_mob.updatehealth()
