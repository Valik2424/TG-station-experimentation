/datum/quirk/social_anxiety
	name = "Социофоб"
	desc = "Разговор с людьми очень сложен для вас, и вы будете заикаться при попытке заговорить, или просто молчать."
	icon = FA_ICON_COMMENT_SLASH
	value = -3
	gain_text = span_danger("Начинаю волноваться насчёт мнения окружающих.")
	lose_text = span_notice("Становится легче говорить.")  //if only it were that easy!
	medical_record_text = "Пациент, как правило, беспокоится о социальных связях и предпочитает избегать их."
	hardcore_value = 4
	mob_trait = TRAIT_ANXIOUS
	mail_goodies = list(/obj/item/storage/pill_bottle/psicodine)
	var/dumb_thing = TRUE

/datum/quirk/social_anxiety/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, PROC_REF(eye_contact))
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, PROC_REF(looks_at_floor))
	RegisterSignal(quirk_holder, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE, COMSIG_MOB_SAY))

/datum/quirk/social_anxiety/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/moodmod
	if(quirk_holder.mob_mood)
		moodmod = (1+0.02*(50-(max(50, quirk_holder.mob_mood.mood_level*(7-quirk_holder.mob_mood.sanity_level))))) //low sanity levels are better, they max at 6
	else
		moodmod = (1+0.02*(50-(max(50, 0.1*quirk_holder.nutrition))))
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()
		var/mob/living/carbon/human/quirker = quirk_holder
		for(var/word in message_split)
			if(prob(max(5,(nearby_people*12.5*moodmod))) && word != message_split[1]) //Minimum 1/20 chance of filler
				new_message += pick("uh,","erm,","um,")
				if(prob(min(5,(0.05*(nearby_people*12.5)*moodmod)))) //Max 1 in 20 chance of cutoff after a successful filler roll, for 50% odds in a 15 word sentence
					quirker.set_silence_if_lower(6 SECONDS)
					to_chat(quirker, span_danger("Решаю просто немного помолчать. Мне <i>совсем</i> не хочется разговаривать."))
					break
			if(prob(max(5,(nearby_people*12.5*moodmod)))) //Minimum 1/20 chance of stutter
				// Add a short stutter, THEN treat our word
				quirker.adjust_stutter(0.5 SECONDS)
				var/list/message_data = quirker.treat_message(word, capitalize_message = FALSE)
				new_message += message_data["message"]
			else
				new_message += word

		message = jointext(new_message, " ")
	var/mob/living/carbon/human/quirker = quirk_holder
	if(prob(min(50,(0.50*(nearby_people*12.5)*moodmod)))) //Max 50% chance of not talking
		if(dumb_thing)
			to_chat(quirker, span_userdanger("Вспоминаю дурацкую вещь, которую сказали давным давно и испытываю внутреннюю боль."))
			dumb_thing = FALSE //only once per life
			if(prob(1))
				new/obj/item/food/spaghetti/pastatomato(get_turf(quirker)) //now that's what I call spaghetti code
		else
			to_chat(quirk_holder, span_warning("Решаю, что мне лучше промолчать."))
			if(prob(min(25,(0.25*(nearby_people*12.75)*moodmod)))) //Max 25% chance of silence stacks after successful not talking roll
				to_chat(quirker, span_danger("Решаю просто немного помолчать. Мне <i>совсем</i> не хочется разговаривать."))
				quirker.set_silence_if_lower(10 SECONDS)

		speech_args[SPEECH_MESSAGE] = pick("Эм.","Ааа.","Мгм.")
	else
		speech_args[SPEECH_MESSAGE] = message

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	SIGNAL_HANDLER

	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_smallnotice("You make eye contact with [A].")), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "[capitalize(other_mob.name)] смотрит прямо на меня, "
	else
		msg = "[capitalize(other_mob.name)] смотрит прямо на меня, "

	switch(rand(1,3))
		if(1)
			quirk_holder.set_jitter_if_lower(20 SECONDS)
			msg += "жуть!"
		if(2)
			quirk_holder.set_stutter_if_lower(6 SECONDS)
			msg += "страшно!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "АХ!"

	quirk_holder.add_mood_event("anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_userdanger("[msg]")), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "<span class='warning'>Sometimes eye contact makes me so nervous...</span>\n"
	mood_change = -5
	timeout = 3 MINUTES
