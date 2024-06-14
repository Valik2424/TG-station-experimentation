//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild
	abstract_type = /datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Параноидальная шизофрения"
	desc = "Пациент страдает от постоянных слуховых и визуальных галлюцинаций."
	scan_desc = "<b>параноидальной шизофрении</b>"
	gain_text = span_warning("Реальность изменятся...")
	lose_text = span_notice("Теперь могу сосредоточиться и способность отличать реальность от фантазии вернулась ко мне.")

/datum/brain_trauma/mild/hallucinations/on_life(seconds_per_tick, times_fired)
	if(owner.stat != CONSCIOUS || owner.IsSleeping() || owner.IsUnconscious())
		return
	if(HAS_TRAIT(owner, TRAIT_RDS_SUPPRESSED))
		return

	owner.adjust_hallucinations_up_to(10 SECONDS * seconds_per_tick, 100 SECONDS)

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.remove_status_effect(/datum/status_effect/hallucination)
	return ..()

/datum/brain_trauma/mild/stuttering
	name = "Заикание"
	desc = "Пациент не может нормально говорить."
	scan_desc = "<b>легкого повреждения речевого центра мозга</b>"
	gain_text = span_warning("Говорить ясно становится все труднее.")
	lose_text = span_notice("Чувствую, что наконец-то способен контролировать свою речь.")

/datum/brain_trauma/mild/stuttering/on_life(seconds_per_tick, times_fired)
	owner.adjust_stutter_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.remove_status_effect(/datum/status_effect/speech/stutter)
	return ..()

/datum/brain_trauma/mild/dumbness
	name = "Даунизм"
	desc = "У пациента снижена мозговая активность, что делает его менее умным."
	scan_desc = "<b>пониженной мозговой активности</b>"
	gain_text = span_warning("Мне кажется, что мир вокруг меня с каждой секундой становится все более сложным для понимания.")
	lose_text = span_notice("Осознаю себя более умным.")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.add_mood_event("dumb", /datum/mood_event/oblivious)
	return ..()

/datum/brain_trauma/mild/dumbness/on_life(seconds_per_tick, times_fired)
	owner.adjust_derpspeech_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)
	if(SPT_PROB(1.5, seconds_per_tick))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && SPT_PROB(1.5, seconds_per_tick))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage", filterproof = TRUE)

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.remove_status_effect(/datum/status_effect/speech/stutter/derpspeech)
	owner.clear_mood_event("dumb")
	return ..()

/datum/brain_trauma/mild/speech_impediment
	name = "Дефект речи"
	desc = "Пациент не в состоянии составлять сложные, связные предложения."
	scan_desc = "<b>коммуникативного расстройства</b>"
	gain_text = span_danger("Кажется, я не могу сформулировать ни одной связной мысли!")
	lose_text = span_danger("Мой разум становится более ясным.")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Сотрясение мозга"
	desc = "У пациента сотрясение мозга."
	scan_desc = "<b>сотрясения мозга</b>"
	gain_text = span_warning("Голова болит!")
	lose_text = span_notice("Давление в моей голове начинает ослабевать.")

/datum/brain_trauma/mild/concussion/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick))
		switch(rand(1,11))
			if(1)
				owner.vomit(VOMIT_CATEGORY_DEFAULT)
			if(2,3)
				owner.adjust_dizzy(20 SECONDS)
			if(4,5)
				owner.adjust_confusion(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(6 to 9)
				owner.adjust_slurring(1 MINUTES)
			if(10)
				to_chat(owner, span_notice("А что делать то надо было?"))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("Слабею."))
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/healthy
	name = "Анозогнозия"
	desc = "Пациент всегда чувствует себя здоровым, независимо от своего состояния."
	scan_desc = "<b>критического нарушения самооценки</b>"
	gain_text = span_notice("Прекрасно себя чувствую!")
	lose_text = span_warning("Бльше не чувствую себя совершенно здоровым.")

/datum/brain_trauma/mild/healthy/on_gain()
	owner.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/healthy/on_life(seconds_per_tick, times_fired)
	owner.adjustStaminaLoss(-2.5 * seconds_per_tick) //no pain, no fatigue

/datum/brain_trauma/mild/healthy/on_lose()
	owner.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Мышечная слабость"
	desc = "Пациент время от времени испытывает приступы мышечной слабости."
	scan_desc = "<b>ослабления сигнала двигательного нерва</b>"
	gain_text = span_warning("Мои мышцы внезапно ослабевают.")
	lose_text = span_notice("Мои мышцы вновь полны сил.")

/datum/brain_trauma/mild/muscle_weakness/on_life(seconds_per_tick, times_fired)
	var/fall_chance = 1
	if(owner.move_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(SPT_PROB(0.5 * fall_chance, seconds_per_tick) && owner.body_position == STANDING_UP)
		to_chat(owner, span_warning("Моя нога подкашивается!"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(SPT_PROB(0.5 * drop_chance, seconds_per_tick) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("Роняю [I]!"))

	else if(SPT_PROB(1.5, seconds_per_tick))
		to_chat(owner, span_warning("Чувствую внезапную слабость в мышцах!"))
		owner.adjustStaminaLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "мышечные спазмы"
	desc = "У пациента время от времени возникают мышечные спазмы, заставляющие их непреднамеренно двигаться."
	scan_desc = "<b>нейротического спазма мышц</b>"
	gain_text = span_warning("Мои мышцы самопроизвольно сокращаются.")
	lose_text = span_notice("Снова чувствую контроль над своими мышцами.")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(/datum/status_effect/spasms)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(/datum/status_effect/spasms)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Нервный кашель"
	desc = "Пациент испытывает постоянную потребность в кашле."
	scan_desc = "<b>нервного кашля</b>"
	gain_text = span_warning("У меня постоянно першит в горле...")
	lose_text = span_notice("Першение в горле наконец то прошло.")

/datum/brain_trauma/mild/nervous_cough/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(6, seconds_per_tick) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, span_warning("[pick("У меня приступ кашля!", "Не могу перестать кашлять!")]"))
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 6)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 12)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Экспрессивная афазия"
	desc = "Пациент страдает частичной потерей речи, приводящей к сокращению словарного запаса."
	scan_desc = "<b>повреждения сенсорно-вербального речевого центра</b>"
	gain_text = span_warning("Теряю понимание сложных слов.")
	lose_text = span_notice("Чувствую, что мой словарный запас снова приходит в норму.")

	var/static/list/common_words = world.file2list("strings/1000_most_common.txt")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = ""
			var/suffix_foundon = 0
			for(var/potential_suffix in list("." , "," , ";" , "!" , ":" , "?"))
				suffix_foundon = findtext(word, potential_suffix, -length(potential_suffix))
				if(suffix_foundon)
					suffix = potential_suffix
					break

			if(suffix_foundon)
				word = copytext(word, 1, suffix_foundon)
			word = html_decode(word)

			if(lowertext(word) in common_words)
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("ых","хех")
					break
				else
					var/list/charlist = text2charlist(word)
					charlist.len = round(charlist.len * 0.5, 1)
					shuffle_inplace(charlist)
					new_message += jointext(charlist, "") + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "Эхо разума"
	desc = "Языковые нейроны пациента не заканчиваются должным образом, в результате чего предыдущие речевые паттерны иногда всплывают спонтанно."
	scan_desc = "<b>циклического аудио-вербального нейронного паттерна</b>"
	gain_text = span_warning("Чувствую слабое эхо моих мыслей...")
	lose_text = span_notice("Слабое эхо затихает вдали.")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return

	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_RAW_MESSAGE] = quoted_spoken_message.Replace(hearing_args[HEARING_RAW_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]

/datum/brain_trauma/mild/color_blindness
	name = "Дальтонизм"
	desc = "Пациент не в состоянии распознавать и интерпретировать цвет, делая его полностью цветовым слепым."
	scan_desc = "<b>полной цветовой слепоты</b>"
	gain_text = span_warning("Мир вокруг меня теряет свои цвета.")
	lose_text = span_notice("Мир вокруг меня снова становится ярким и красочным.")

/datum/brain_trauma/mild/color_blindness/on_gain()
	owner.add_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()

/datum/brain_trauma/mild/color_blindness/on_lose(silent)
	owner.remove_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()
