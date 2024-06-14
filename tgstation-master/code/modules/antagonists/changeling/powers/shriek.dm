/datum/action/changeling/resonant_shriek
	name = "Резонансный вопль"
	desc = "Наши легкие и голосовые связки смещаются, что позволяет нам на короткое время издавать шум, который оглушает и сбивает с толку слабоумных. Стоит 20 химикатов."
	helptext = "Издает высокочастотный звук, который сбивает с толку и оглушает людей, гасит близлежащие лампочки и перегружает датчики киборгов."
	button_icon_state = "resonant_shriek"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

//A flashy ability, good for crowd control and sowing chaos.
/datum/action/changeling/resonant_shriek/sting_action(mob/user)
	..()
	if(user.movement_type & VENTCRAWLING)
		user.balloon_alert(user, "не можем использовать вопль в трубе!")
		return FALSE
	for(var/mob/living/M in get_hearers_in_view(4, user))
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.mind || !C.mind.has_antag_datum(/datum/antagonist/changeling))
				var/obj/item/organ/internal/ears/ears = C.get_organ_slot(ORGAN_SLOT_EARS)
				if(ears)
					ears.adjustEarDamage(0, 30)
				C.adjust_confusion(25 SECONDS)
				C.set_jitter_if_lower(100 SECONDS)
			else
				SEND_SOUND(C, sound('sound/effects/screech.ogg'))

		if(issilicon(M))
			SEND_SOUND(M, sound('sound/weapons/flash.ogg'))
			M.Paralyze(rand(100,200))

	for(var/obj/machinery/light/L in range(4, user))
		L.on = TRUE
		L.break_light_tube()
		stoplag()
	return TRUE

/datum/action/changeling/dissonant_shriek
	name = "Диссонирующий вопль"
	desc = "Мы сдвигаем наши голосовые связки, чтобы издавать высокочастотный звук, который перегружает соседнюю электронику. Стоит 20 химикатов."
	button_icon_state = "dissonant_shriek"
	chemical_cost = 20
	dna_cost = 1

/datum/action/changeling/dissonant_shriek/sting_action(mob/user)
	..()
	if(user.movement_type & VENTCRAWLING)
		user.balloon_alert(user, "не можем использовать вопль в трубе!")
		return FALSE
	empulse(get_turf(user), 2, 5, 1)
	for(var/obj/machinery/light/L in range(5, usr))
		L.on = TRUE
		L.break_light_tube()
		stoplag()

	return TRUE