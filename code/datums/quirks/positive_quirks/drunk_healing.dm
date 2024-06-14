/datum/quirk/drunkhealing
	name = "Лечение от алкоголя"
	desc = "Ничего, кроме очередной хорошей выпивки не будет придавать мне чувство, что вы находитесь на вершине мира. Когда вы пьяны, то медленно будете регенерировать повреждения."
	icon = FA_ICON_WINE_BOTTLE
	value = 8
	gain_text = span_notice("Чувствую, что алкоголь может принести мне пользу.")
	lose_text = span_danger("Больше не могу чувствовать, как алкоголь лечит меня!")
	medical_record_text = "Пациент имеет необычную эффективность метаболизма печени лечить его от ран, употребляя алкогольные напитки."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/booze)

/datum/quirk/drunkhealing/process(seconds_per_tick)
	var/need_mob_update = FALSE
	switch(quirk_holder.get_drunk_amount())
		if (6 to 40)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.1 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.05 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		if (41 to 60)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.4 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.2 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		if (61 to INFINITY)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.8 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.4 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	if(need_mob_update)
		quirk_holder.updatehealth()
