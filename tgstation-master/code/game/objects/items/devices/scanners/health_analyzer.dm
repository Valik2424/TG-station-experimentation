// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more
#define SCANNER_CONDENSED 0
#define SCANNER_VERBOSE 1
// Not updating above count because you're not meant to switch to this mode.
#define SCANNER_NO_MODE -1

/obj/item/healthanalyzer
	name = "анализатор здоровья"
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT *2)
	var/mode = SCANNER_VERBOSE
	var/scanmode = SCANMODE_HEALTH
	var/advanced = FALSE
	custom_price = PAYCHECK_COMMAND
	/// If this analyzer will give a bonus to wound treatments apon woundscan.
	var/give_wound_treatment_bonus = FALSE

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	. += span_notice("Альт-клик для переключения индикации повреждения конечностей.")

/obj/item/healthanalyzer/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to analyze [user.ru_na()] self with [src]! The display shows that [user.p_theyre()] dead!"))
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	if(!user.can_read(src) || user.is_blind())
		return

	scanmode = (scanmode + 1) % SCANMODE_COUNT
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, span_notice("Переключаю анализатор в режим сканирования жизненных показателей."))
		if(SCANMODE_WOUND)
			to_chat(user, span_notice("Переключаю анализатор в режим сканирования травм."))

/obj/item/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)
	if(!user.can_read(src) || user.is_blind())
		return

	flick("[icon_state]-scan", src) //makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		user.visible_message(span_warning("[user] анализирует жизненные показатели пола!") , \
							span_notice("Глупо анализирую показатели пола!"))
		to_chat(user, "<span class='info'>Результаты анализа пола:\n\tОбщий статус: <b>Здоров</b></span>\
					\n<span class='info'>Тип: <font color='blue'>Удушение</font>/<font color='green'>Токсины</font>/<font color='#FF8000'>Ожоги</font>/<font color='red'>Травмы</font></span>\
					\n<span class='info'>\tПоказатели: <font color='blue'>0</font>-<font color='green'>0</font>-<font color='#FF8000'>0</font>-<font color='red'>0</font></span>\
					\n<span class='info'>Температура тела: ???</span>")
		return

	if(ispodperson(M) && !advanced)
		to_chat(user, "<span class='info'>Биологическая структура <b>[M]</b> слишком сложная для анализа.")
		return

	user.visible_message(span_notice("<b>[user]</b> анализирует жизненные показатели <b>[M]</b>.") , \
						span_notice("Анализирую жизненные показатели <b>[M]</b>."))
	playsound(user.loc, 'sound/items/healthanalyzer.ogg', 50)

	switch (scanmode)
		if (SCANMODE_HEALTH)
			healthscan(user, M, mode, advanced)
		if (SCANMODE_WOUND)
			woundscan(user, M, src)

	add_fingerprint(user)

/obj/item/healthanalyzer/attack_secondary(mob/living/victim, mob/living/user, params)
	if(!user.can_read(src) || user.is_blind())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	chemscan(user, victim)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/healthanalyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/M,
)
	if (!isliving(M))
		return NONE

	switch (scanmode)
		if (SCANMODE_HEALTH)
			context[SCREENTIP_CONTEXT_LMB] = "Сканировать состояние"
		if (SCANMODE_WOUND)
			context[SCREENTIP_CONTEXT_LMB] = "Сканировать раны"

	context[SCREENTIP_CONTEXT_LMB] = "Сканировать химикаты"

	return CONTEXTUAL_SCREENTIP_SET

/**
 * healthscan
 * returns a list of everything a health scan should give to a player.
 * Examples of where this is used is Health Analyzer and the Physical Scanner tablet app.
 * Args:
 * user - The person with the scanner
 * M - The person being scanned
 * mode - Uses SCANNER_CONDENSED or SCANNER_VERBOSE to decide whether to give a list of all individual limb damage
 * advanced - Whether it will give more advanced details, such as husk source.
 * tochat - Whether to immediately post the result into the chat of the user, otherwise it will return the results.
 */
/proc/healthscan(mob/user, mob/living/M, mode = SCANNER_VERBOSE, advanced = FALSE, tochat = TRUE)
	if(user.incapacitated())
		return

	// the final list of strings to render
	var/render_list = list()

	// Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat == DEAD ? span_alert("<b>Мёртв</b>") : "<b>[round(M.health/M.maxHealth,0.01)*100]% здоров</b>")

	if(HAS_TRAIT(M, TRAIT_FAKEDEATH) && !advanced)
		mob_status = span_alert("<b>Мёртв</b>")
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.undergoing_cardiac_arrest() && H.stat != DEAD)
			render_list += "<span class='alert'>У пациента сердечный приступ: срочно требуется дефибриллирование или удар током!</span>\n"
		if(H.has_reagent(/datum/reagent/inverse/technetium))
			advanced = TRUE

	SEND_SIGNAL(M, COMSIG_LIVING_HEALTHSCAN, render_list, advanced, user, mode)

	render_list += "<span class='info'>Результаты анализа [M]:</span>\n<span class='info ml-1'>Общий статус: [mob_status]</span>\n"

	// Husk detection
	if(HAS_TRAIT(M, TRAIT_HUSK))
		if(advanced)
			if(HAS_TRAIT_FROM(M, TRAIT_HUSK, BURN))
				render_list += "<span class='alert ml-1'>Жертва была хаскирована из ожогов высшей степени тяжести.</span>\n"
			else if (HAS_TRAIT_FROM(M, TRAIT_HUSK, CHANGELING_DRAIN))
				render_list += "<span class='alert ml-1'>Жертва была хаскирована из за иссушения кровеносной и лимфатической системы.</span>\n"
			else
				render_list += "<span class='alert ml-1'>Жертва была хаскирована мистическим образом.</span>\n"
		else
			render_list += "<span class='alert ml-1'>Жертва была хаскирована.</span>\n"

	// Damage descriptions (why stamina was first?)

	if(brute_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружены [brute_loss > 50 ? "Серьёзные" : "Небольшие"] физические раны.</span>\n"
	if(fire_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружены [fire_loss > 50 ? "Серьёзные" : "Небольшие"] ожоги.</span>\n"
	if(oxy_loss > 10)
		render_list += "<span class='info ml-1'><span class='alert'>Обнаружено [oxy_loss > 50 ? "Серьёзное" : "Небольшое"] удушье.</span>\n"
	if(tox_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружен [tox_loss > 50 ? "Серьёзный" : "Небольшой"] объём токсинов.</span>\n"
	if(M.getStaminaLoss())
		render_list += "<span class='alert ml-1'>Пациент страдает от переутомления.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Уровень переутомления: [M.getStaminaLoss()]%.</span>\n"
	if (M.getCloneLoss())
		render_list += "<span class='alert ml-1'>Пациент имеет [M.getCloneLoss() > 30 ? "серьёзный" : "небольшой"] клеточный урон.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Уровень клеточного урона: [M.getCloneLoss()].</span>\n"
		if (!M.get_organ_slot(ORGAN_SLOT_BRAIN)) // brain not added to carbon/human check because it's funny to get to bully simple mobs
			render_list += "<span class='alert ml-1'>У пациента отсутствует мозг.</span>\n"

	if(iscarbon(M))
		var/mob/living/carbon/carbontarget = M
		if(LAZYLEN(carbontarget.get_traumas()))
			var/list/trauma_text = list()
			for(var/datum/brain_trauma/trauma in carbontarget.get_traumas())
				var/trauma_desc = ""
				switch(trauma.resilience)
					if(TRAUMA_RESILIENCE_SURGERY)
						trauma_desc += "серьёзного "
					if(TRAUMA_RESILIENCE_LOBOTOMY)
						trauma_desc += "глубокого "
					if(TRAUMA_RESILIENCE_WOUND)
						trauma_desc += "травматического "
					if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
						trauma_desc += "вечного "
				trauma_desc += trauma.scan_desc
				trauma_text += trauma_desc
			render_list += "<span class='alert ml-1'>Церебральные травмы обнаружены: пациент страдает от [english_list(trauma_text)].</span>\n"
		if(carbontarget.quirks.len)
			render_list += "<span class='info ml-1'>Пациент имеет серьёзные отклонения в виде: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY, from_scan = TRUE)].</span>\n"
			if(advanced)
				render_list += "<span class='info ml-1'>Пациент имеет незначительные отклонения в виде: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY, TRUE)].</span>\n"

	if (HAS_TRAIT(M, TRAIT_IRRADIATED))
		render_list += "<span class='alert ml-1'>Обнаружено радиоактивное заражение.</span>\n"

	//Eyes and ears
	if(advanced && iscarbon(M))
		var/mob/living/carbon/carbontarget = M

		// Ear status
		var/obj/item/organ/internal/ears/ears = carbontarget.get_organ_slot(ORGAN_SLOT_EARS)
		if(istype(ears))
			if(HAS_TRAIT_FROM(carbontarget, TRAIT_DEAF, GENETIC_MUTATION))
				render_list += "<span class='alert ml-2'>Пациент генетически глухой.\n</span>"
			else if(HAS_TRAIT_FROM(carbontarget, TRAIT_DEAF, EAR_DAMAGE))
				render_list += "<span class='alert ml-2'>Пациент глухой из-за повреждений ушей.\n</span>"
			else if(HAS_TRAIT(carbontarget, TRAIT_DEAF))
				render_list += "<span class='alert ml-2'>Пациент глухой.\n</span>"
			else
				if(ears.damage)
					render_list += "<span class='alert ml-2'>Пациент имеет [ears.damage > ears.maxHealth ? "вечный ": "временный "]ушной урон.\n</span>"
				if(ears.deaf)
					render_list += "<span class='alert ml-2'>Пациент [ears.damage > ears.maxHealth ? "вечно ": "временно "]глух.\n</span>"

		// Eye status
		var/obj/item/organ/internal/eyes/eyes = carbontarget.get_organ_slot(ORGAN_SLOT_EYES)
		if(istype(eyes))
			if(carbontarget.is_blind())
				render_list += "<span class='alert ml-2'>Пациент слепой.\n</span>"
			else if(carbontarget.is_nearsighted())
				render_list += "<span class='alert ml-2'>Пациент близорукий.\n</span>"

	// Body part damage report
	if(iscarbon(M))
		var/mob/living/carbon/carbontarget = M
		var/list/damaged = carbontarget.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			var/dmgreport = "<span class='info ml-1'>Тело:</span>\
							<table class='ml-2'><tr><font face='Verdana'>\
							<td style='width:7em;'><font color='#7777CC'>Урон:</font></td>\
							<td style='width:5em;'><font color='red'><b>Травмы</b></font></td>\
							<td style='width:4em;'><font color='orange'><b>Ожоги</b></font></td>\
							<td style='width:4em;'><font color='green'><b>Токсины</b></font></td>\
							<td style='width:8em;'><font color='pink'><b>Удушье</b></font></td></tr>\
							<tr><td><font color='#7777CC'>Общий:</font></td>\
							<td><font color='red'>[CEILING(brute_loss,1)]</font></td>\
							<td><font color='orange'>[CEILING(fire_loss,1)]</font></td>\
							<td><font color='green'>[CEILING(tox_loss,1)]</font></td>\
							<td><font color='blue'>[CEILING(oxy_loss,1)]</font></td></tr>"

			if(mode == SCANNER_VERBOSE)
				for(var/obj/item/bodypart/limb as anything in damaged)
					if(limb.bodytype & BODYTYPE_ROBOTIC)
						dmgreport += "<tr><td><font color='#7777CC'>[capitalize(limb.name)]:</font></td>"
					else
						dmgreport += "<tr><td><font color='#7777CC'>[capitalize(limb.plaintext_zone)]:</font></td>"
					dmgreport += "<td><font color='red'>[(limb.brute_dam > 0) ? "[CEILING(limb.brute_dam,1)]" : "0"]</font></td>"
					dmgreport += "<td><font color='orange'>[(limb.burn_dam > 0) ? "[CEILING(limb.burn_dam,1)]" : "0"]</font></td></tr>"
			dmgreport += "</font></table>"
			render_list += dmgreport // tables do not need extra linebreak
		for(var/obj/item/bodypart/limb as anything in carbontarget.bodyparts)
			for(var/obj/item/embed as anything in limb.embedded_objects)
				render_list += "<span class='alert ml-1>Внимание в [ru_gde_zone(limb.plaintext_zone)] пациента торчит [embed]</span>\n"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		// Organ damage, missing organs
		if(H.organs && H.organs.len)
			var/render = FALSE
			var/toReport = "<span class='info ml-1'>Органы:\n</span>\
				<table class='ml-2'><tr>\
				<td style='width:6em;'><font color='#7777CC'><b>Орган</b></font></td>\
				[advanced ? "<td style='width:3em;'><font color='#7777CC'><b>Урон</b></font></td>" : ""]\
				<td style='width:12em;'><font color='#7777CC'><b>Состояние</b></font></td>"

			for(var/obj/item/organ/organ as anything in H.organs)
				var/status = organ.get_status_text()
				if(H.has_reagent(/datum/reagent/inverse/technetium))
					if(organ.damage)
						status = "<font color='#E42426'> Повреждён на [round((organ.damage/organ.maxHealth)*100, 1)]%.</font>"
				else
					if (organ.organ_flags & ORGAN_FAILING)
						status = "<font color='#cc3333'>Не работает</font>"
					else if (organ.damage > organ.high_threshold)
						status = "<font color='#ff9933'>Сильно повреждён</font>"
					else if (organ.damage > organ.low_threshold)
						status = "<font color='#ffcc33'>Повреждён</font>"
				if (status != "")
					render = TRUE
					toReport += "<tr><td><font color='#7777CC'>[organ.name]</font></td>\
						[advanced ? "<td><font color='#7777CC'>[CEILING(organ.damage,1)]</font></td>" : ""]\
						<td>[status]</td></tr>"

			toReport += "</table>"

			var/missing_organs = list()
			if(!H.get_organ_slot(ORGAN_SLOT_BRAIN))
				missing_organs += "мозга"
			if(!HAS_TRAIT_FROM(H, TRAIT_NOBLOOD, SPECIES_TRAIT) && !H.get_organ_slot(ORGAN_SLOT_HEART))
				missing_organs += "сердца"
			if(!HAS_TRAIT_FROM(H, TRAIT_NOBREATH, SPECIES_TRAIT) && !H.get_organ_slot(ORGAN_SLOT_LUNGS))
				missing_organs += "лёгких"
			if(!HAS_TRAIT_FROM(H, TRAIT_LIVERLESS_METABOLISM, SPECIES_TRAIT) && !H.get_organ_slot(ORGAN_SLOT_LIVER))
				missing_organs += "печени"
			if(!HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, SPECIES_TRAIT) && !H.get_organ_slot(ORGAN_SLOT_STOMACH))
				missing_organs += "желудка"
			if(!H.get_organ_slot(ORGAN_SLOT_TONGUE))
				missing_organs += "языка"
			if(!H.get_organ_slot(ORGAN_SLOT_EARS))
				missing_organs += "глаз"
			if(!H.get_organ_slot(ORGAN_SLOT_EYES))
				missing_organs += "ушей"

			if(length(missing_organs))
				render = TRUE
				for(var/organ in missing_organs)
					toReport += "\n<span class='alert ml-2'>У пациента нет [organ].</span>"

			if(render)
				render_list += toReport

		//Genetic stability
		if(advanced && H.has_dna())
			render_list += "<span class='info ml-1'>Генетическая стабильность: [H.dna.stability]%.</span>\n"

		// Species and body temperature
		var/datum/species/targetspecies = H.dna.species
		var/mutant = H.dna.check_mutation(/datum/mutation/human/hulk) \
			|| targetspecies.mutantlungs != initial(targetspecies.mutantlungs) \
			|| targetspecies.mutantbrain != initial(targetspecies.mutantbrain) \
			|| targetspecies.mutantheart != initial(targetspecies.mutantheart) \
			|| targetspecies.mutanteyes != initial(targetspecies.mutanteyes) \
			|| targetspecies.mutantears != initial(targetspecies.mutantears) \
			|| targetspecies.mutanttongue != initial(targetspecies.mutanttongue) \
			|| targetspecies.mutantliver != initial(targetspecies.mutantliver) \
			|| targetspecies.mutantstomach != initial(targetspecies.mutantstomach) \
			|| targetspecies.mutantappendix != initial(targetspecies.mutantappendix) \
			|| istype(H.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS), /obj/item/organ/external/wings/functional)

		render_list += "<span class='info ml-1'>Селекционный тип: [targetspecies.name][mutant ? "-мутант" : ""]</span>\n"
		var/core_temperature_message = "Внутрення температура: [round(H.coretemperature-T0C, 0.1)] &deg;C ([round(H.coretemperature*1.8-459.67,0.1)] &deg;F)"
		if(H.coretemperature >= H.get_body_temp_heat_damage_limit())
			render_list += "<span class='alert ml-1'>☼ [core_temperature_message] ☼</span>\n"
		else if(H.coretemperature <= H.get_body_temp_cold_damage_limit())
			render_list += "<span class='alert ml-1'>❄ [core_temperature_message] ❄</span>\n"
		else
			render_list += "<span class='info ml-1'>[core_temperature_message]</span>\n"

	var/body_temperature_message = "Внешняя температура: [round(M.bodytemperature-T0C, 0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)"
	if(M.bodytemperature >= M.get_body_temp_heat_damage_limit())
		render_list += "<span class='alert ml-1'>☼ [body_temperature_message] ☼</span>\n"
	else if(M.bodytemperature <= M.get_body_temp_cold_damage_limit())
		render_list += "<span class='alert ml-1'>❄ [body_temperature_message] ❄</span>\n"
	else
		render_list += "<span class='info ml-1'>[body_temperature_message]</span>\n"

	// Time of death
	if(M.station_timestamp_timeofdeath && (M.stat == DEAD || ((HAS_TRAIT(M, TRAIT_FAKEDEATH)) && !advanced)))
		render_list += "<span class='info ml-1'>Время смерти: [M.station_timestamp_timeofdeath]</span>\n"
		var/tdelta = round(world.time - M.timeofdeath)
		render_list += "<span class='alert ml-1'><b>Пациент умер [DisplayTimeText(tdelta)] назад.</b></span>\n"

	// Wounds
	if(iscarbon(M))
		var/mob/living/carbon/carbontarget = M
		var/list/wounded_parts = carbontarget.get_wounded_bodyparts()
		for(var/i in wounded_parts)
			var/obj/item/bodypart/wounded_part = i
			render_list += "<span class='alert ml-1'><b>Внимание: [LAZYLEN(wounded_part.wounds) > 1 ? "Обнаружены физические травмы" : "Обнаружена физическая травма"] в [ru_gde_zone(wounded_part.name)]</b>"
			for(var/k in wounded_part.wounds)
				var/datum/wound/W = k
				render_list += "<div class='ml-2'>Тип: [W.name]\nТяжесть: ([W.severity_text()])</div>" //Recommended treatment: [W.treat_text]</div>" // less lines than in woundscan() so we don't overload people trying to get basic med info
			render_list += "</span>"

	//Diseases
	for(var/datum/disease/disease as anything in M.diseases)
		if(!(disease.visibility_flags & HIDDEN_SCANNER))
			render_list += "<span class='alert ml-1'><b>Внимание: [disease.form] обнаружена</b>\n\
			<div class='ml-2'>Название: [disease.name].\nТип: [disease.spread_text].\nСтадия: [disease.stage]/[disease.max_stages].\nВозможное лекарство: [disease.cure_text]</div>\
			</span>" // divs do not need extra linebreak

	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/carbontarget = M
		var/blood_id = carbontarget.get_blood_id()
		if(blood_id)
			if(carbontarget.is_bleeding())
				render_list += "<span class='alert ml-1'><b>Пациент истекает кровью!</b></span>\n"
			var/blood_percent = round((carbontarget.blood_volume / BLOOD_VOLUME_NORMAL) * 100)
			var/blood_type = carbontarget.dna.blood_type
			if(blood_id != /datum/reagent/blood) // special blood substance
				var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
				blood_type = R ? R.name : blood_id
			if(carbontarget.blood_volume <= BLOOD_VOLUME_SAFE && carbontarget.blood_volume > BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Уровень крови: НИЗКИЙ [blood_percent] %, [carbontarget.blood_volume] cl,</span> [span_info("Тип: [blood_type]")]\n"
			else if(carbontarget.blood_volume <= BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Уровень крови: <b>КРИТИЧЕСКИЙ [blood_percent] %</b>, [carbontarget.blood_volume] cl,</span> [span_info("Тип: [blood_type]")]\n"
			else
				render_list += "<span class='info ml-1'>Уровень крови: [blood_percent] %, [carbontarget.blood_volume] cl, Тип: [blood_type]</span>\n"

	// Cybernetics
	if(iscarbon(M))
		var/mob/living/carbon/carbontarget = M
		var/cyberimp_detect
		for(var/obj/item/organ/internal/cyberimp/cyberimp in carbontarget.organs)
			if(IS_ROBOTIC_ORGAN(cyberimp) && !(cyberimp.organ_flags & ORGAN_HIDDEN))
				cyberimp_detect += "[!cyberimp_detect ? "[cyberimp.get_examine_string(user)]" : ", [cyberimp.get_examine_string(user)]"]"
		if(cyberimp_detect)
			render_list += "<span class='notice ml-1'>Обнаружены кибернетические модификации:</span>\n"
			render_list += "<span class='notice ml-2'>[cyberimp_detect]</span>\n"
	// we handled the last <br> so we don't need handholding
	SEND_SIGNAL(M, COMSIG_NANITE_SCAN, user, FALSE)
	if(tochat)
		to_chat(user, examine_block(jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
	else
		return(jointext(render_list, ""))

/proc/chemscan(mob/living/user, mob/living/M)
	if(user.incapacitated())
		return

	if(istype(M) && M.reagents)
		var/list/render_list = list() //The master list of readouts, including reagents in the blood/stomach, addictions, quirks, etc.
		var/list/render_block = list() //A second block of readout strings. If this ends up empty after checking stomach/blood contents, we give the "empty" header.

		// Blood reagents
		if(M.reagents.reagent_list.len)
			for(var/r in M.reagents.reagent_list)
				var/datum/reagent/reagent = r
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				render_block += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] юнитов [reagent.name][reagent.overdosed ? "</span> - [span_boldannounce("ПЕРЕДОЗИРОВКА")]" : ".</span>"]\n"

		if(!length(render_block)) //If no VISIBLY DISPLAYED reagents are present, we report as if there is nothing.
			render_list += "<span class='notice ml-1'>Не обнаружено реагентов в крови.</span>\n"
		else
			render_list += "<span class='notice ml-1'>В крови пациента обнаружены следующие химикаты:</span>\n"
			render_list += render_block //Otherwise, we add the header, reagent readouts, and clear the readout block for use on the stomach.
			render_block.Cut()

		// Stomach reagents
		var/obj/item/organ/internal/stomach/belly = M.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE)
						continue
					if(!belly.food_reagents[bit.type])
						render_block += "<span class='notice ml-2'>[round(bit.volume, 0.001)] юнитов [bit.name][bit.overdosed ? "</span> - [span_boldannounce("ПЕРЕДОЗИРОВКА")]" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_block += "<span class='notice ml-2'>[round(bit_vol, 0.001)] юнитов [bit.name][bit.overdosed ? "</span> - [span_boldannounce("ПЕРЕДОЗИРОВКА")]" : ".</span>"]\n"

			if(!length(render_block))
				render_list += "<span class='notice ml-1'>Не обнаружено реагентов в желудке.</span>\n"
			else
				render_list += "<span class='notice ml-1'>В желудке пациента обнаружены следующие химикаты:</span>\n"
				render_list += render_block

		// Addictions
		if(LAZYLEN(M.mind?.active_addictions))
			render_list += "<span class='boldannounce ml-1'>У пациента есть зависимость от следующих химикатов:</span>\n"
			for(var/datum/addiction/addiction_type as anything in M.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span>\n"

		// Special eigenstasium addiction
		if(M.has_status_effect(/datum/status_effect/eigenstasium))
			render_list += "<span class='notice ml-1'>Пациент временно нестабилен. Стабилизирующее средство рекомендуется для уменьшения проблем.</span>\n"

		// Allergies
		for(var/datum/quirk/quirky as anything in M.quirks)
			if(istype(quirky, /datum/quirk/item_quirk/allergic))
				var/datum/quirk/item_quirk/allergic/allergies_quirk = quirky
				var/allergies = allergies_quirk.allergy_string
				render_list += "<span class='alert ml-1'>Пациент крайне аллергичен на следующие химические вещества:</span>\n"
				render_list += "<span class='alert ml-2'>[allergies]</span>\n"

		// we handled the last <br> so we don't need handholding
		to_chat(user, examine_block(jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)

/obj/item/healthanalyzer/AltClick(mob/user)
	..()

	if(!user.can_perform_action(src, NEED_LITERACY|NEED_LIGHT) || user.is_blind())
		return

	if(mode == SCANNER_NO_MODE)
		return

	mode = !mode
	to_chat(user, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/advanced
	name = "продвинутый анализатор здоровья"
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента с более высокой точностью."
	name = "advanced health analyzer"
	icon_state = "health_adv"
	advanced = TRUE

#define AID_EMOTION_NEUTRAL "neutral"
#define AID_EMOTION_HAPPY "happy"
#define AID_EMOTION_WARN "cautious"
#define AID_EMOTION_ANGRY "angery"
#define AID_EMOTION_SAD "sad"

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/scanner, simple_scan = FALSE)
	if(!istype(patient) || user.incapacitated())
		return

	var/render_list = ""
	var/advised = FALSE
	for(var/limb in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = limb
		render_list += "<span class='alert ml-1'><b>Опасность: Физическ[LAZYLEN(wounded_part.wounds) > 1? "ие травмы" : "ая травма"] обнаружена в [ru_gde_zone(wounded_part.name)]</b>"
		for(var/limb_wound in wounded_part.wounds)
			var/datum/wound/current_wound = limb_wound
			render_list += "<div class='ml-2'>[simple_scan ? current_wound.get_simple_scanner_description() : current_wound.get_scanner_description()]</div>\n"
			if (scanner.give_wound_treatment_bonus)
				ADD_TRAIT(current_wound, TRAIT_WOUND_SCANNED, ANALYZER_TRAIT)
				if(!advised)
					to_chat(user, span_notice("Замечаю как яркие голо-изображения появляются над [(length(wounded_part.wounds) || length(patient.get_wounded_bodyparts()) ) > 1 ? "моими травмами" : "моей травмой"]. Изображение заполнено полезной информацией, это должно сделать лечение проще!"))
					advised = TRUE
		render_list += "</span>"

	if(render_list == "")
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(simple_scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, span_notice("[capitalize(simple_scanner)] издаёт радостный пинг и выводит смешную рожицу с тремя восклицательными знаками! Это невероятно приятный отчёт о том, что [patient] не имеет травм!"))
			simple_scanner.show_emotion(AID_EMOTION_HAPPY)
		to_chat(user, "<span class='notice ml-1'>У пациента не найдено травм.</span>")
	else
		to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			simple_scanner.show_emotion(AID_EMOTION_WARN)
			playsound(simple_scanner, 'sound/machines/twobeep.ogg', 50, FALSE)


/obj/item/healthanalyzer/simple
	name = "wound analyzer"
	icon_state = "first_aid"
	desc = "A helpful, child-proofed, and most importantly, extremely cheap MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds. While it might not sound very informative for it to be able to tell you if you have a gaping hole in your body or not, it applies a temporary holoimage near the wound with information that is guaranteed to double the efficacy and speed of treatment."
	mode = SCANNER_NO_MODE
	// Cooldown for when the analyzer will allow you to ask it for encouragement. Don't get greedy!
	var/next_encouragement
	// The analyzer's current emotion. Affects the sprite overlays and if it's going to prick you for being greedy or not.
	var/emotion = AID_EMOTION_NEUTRAL
	// Encouragements to play when attack_selfing
	var/list/encouragements = list("briefly displays a happy face, gazing emptily at you", "briefly displays a spinning cartoon heart", "displays an encouraging message about eating healthy and exercising", \
			"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a sincere thank-you for your interest in first-aid", "formally absolves you of all your sins")
	// How often one can ask for encouragement
	var/patience = 10 SECONDS
	give_wound_treatment_bonus = TRUE

/obj/item/healthanalyzer/simple/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice(" [src] makes a happy ping and [pick(encouragements)]!"))
		next_encouragement = world.time + 10 SECONDS
		show_emotion(AID_EMOTION_HAPPY)
	else if(emotion != AID_EMOTION_ANGRY)
		greed_warning(user)
	else
		violence(user)

/obj/item/healthanalyzer/simple/proc/greed_warning(mob/user)
	to_chat(user, span_warning(" [src] displays an eerily high-definition frowny face, chastizing you for asking it for too much encouragement."))
	show_emotion(AID_EMOTION_ANGRY)

/obj/item/healthanalyzer/simple/proc/violence(mob/user)
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
	if(isliving(user))
		var/mob/living/L = user
		to_chat(L, span_warning(" [src] makes a disappointed buzz and pricks your finger for being greedy. Ow!"))
		flick(icon_state + "_pinprick", src)
		L.adjustBruteLoss(4)
		L.dropItemToGround(src)
		show_emotion(AID_EMOTION_HAPPY)

/obj/item/healthanalyzer/simple/attack(mob/living/carbon/patient, mob/living/carbon/human/user)
	if(!user.can_read(src) || user.is_blind())
		return

	add_fingerprint(user)
	user.visible_message(span_notice("[user] scans [patient] for serious injuries."), span_notice("You scan [patient] for serious injuries."))

	if(!istype(patient))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, span_notice(" [src] makes a sad buzz and briefly displays an unhappy face, indicating it can't scan [patient]."))
		show_emotion(AI_EMOTION_SAD)
		return

	woundscan(user, patient, src, simple_scan = TRUE)
	flick(icon_state + "_pinprick", src)

/obj/item/healthanalyzer/simple/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+no_wounds")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+wound_warn")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+angry")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+fail_scan")

/// Sets a new emotion display on the scanner, and resets back to neutral in a moment
/obj/item/healthanalyzer/simple/proc/show_emotion(new_emotion)
	emotion = new_emotion
	update_appearance(UPDATE_OVERLAYS)
	if (emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions), AID_EMOTION_NEUTRAL), 2 SECONDS)

// Resets visible emotion back to neutral
/obj/item/healthanalyzer/simple/proc/reset_emotions()
	emotion = AID_EMOTION_NEUTRAL
	update_appearance(UPDATE_OVERLAYS)

/obj/item/healthanalyzer/simple/miner
	name = "mining wound analyzer"
	icon_state = "miner_aid"
	desc = "A helpful, child-proofed, and most importantly, extremely cheap MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds. While it might not sound very informative for it to be able to tell you if you have a gaping hole in your body or not, it applies a temporary holoimage near the wound with information that is guaranteed to double the efficacy and speed of treatment. This one has a cool aesthetic antenna that doesn't actually do anything!"

/obj/item/healthanalyzer/simple/disease
	name = "disease state analyzer"
	desc = "Another of MeLo-Tech's dubiously useful medsci scanners, the disease analyzer is a pretty rare find these days - NT found out that giving their hospitals the lowest-common-denominator pandemic equipment resulted in too much financial loss of life to be profitable. There's rumours that the inbuilt AI is jealous of the first aid analyzer's success."
	icon_state = "disease_aid"
	mode = SCANNER_NO_MODE
	encouragements = list("encourages you to take your medication", "briefly displays a spinning cartoon heart", "reasures you about your condition", \
			"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a message saying how proud it is that you're taking care of yourself", "formally absolves you of all your sins")
	patience = 20 SECONDS

/obj/item/healthanalyzer/simple/disease/greed_warning(mob/user)
	to_chat(user, span_warning(" [src] displays an eerily high-definition frowny face, chastizing you for asking it for too much encouragement."))
	show_emotion(AID_EMOTION_ANGRY)

/obj/item/healthanalyzer/simple/disease/violence(mob/user)
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
	if(isliving(user))
		var/mob/living/L = user
		to_chat(L, span_warning(" [src] makes a disappointed buzz and pricks your finger for being greedy. Ow!"))
		flick(icon_state + "_pinprick", src)
		L.adjustBruteLoss(1)
		L.reagents.add_reagent(/datum/reagent/toxin, rand(1, 3))
		L.dropItemToGround(src)
		show_emotion(AID_EMOTION_ANGRY)

/obj/item/healthanalyzer/simple/disease/attack(mob/living/carbon/patient, mob/living/carbon/human/user)
	if(!user.can_read(src) || user.is_blind())
		return

	add_fingerprint(user)
	user.visible_message(span_notice("[user] scans [patient] for diseases."), span_notice("You scan [patient] for diseases."))

	if(!istype(user))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, span_notice(" [src] makes a sad buzz and briefly displays a frowny face, indicating it can't scan [patient]."))
		emotion = AID_EMOTION_SAD
		update_appearance(UPDATE_OVERLAYS)
		return

	diseasescan(user, patient, src) // this updates emotion
	update_appearance(UPDATE_OVERLAYS)
	flick(icon_state + "_pinprick", src)

/obj/item/healthanalyzer/simple/disease/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+not_infected")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+infected")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+rancurous")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+unknown_scan")
	if(emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions)), 4 SECONDS) // longer on purpose

//Checks the individual for any diseases that are visible to the scanner, and displays the diseases in the attacked to the attacker.
/proc/diseasescan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/simple/scanner)
	if(!istype(patient) || user.incapacitated())
		return

	var/list/render = list()
	for(var/datum/disease/disease as anything in patient.diseases)
		if(!(disease.visibility_flags & HIDDEN_SCANNER))
			render += "<span class='alert ml-1'><b>Warning: [disease.form] detected</b>\n\
			<div class='ml-2'>Название: [disease.name].\nType: [disease.spread_text].\nStage: [disease.stage]/[disease.max_stages].\nPossible Cure: [disease.cure_text]</div>\
			</span>"

	if(!length(render))
		playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice(" [scanner] makes a happy ping and briefly displays a smiley face with several exclamation points! It's really excited to report that [patient] has no diseases!"))
		scanner.emotion = AID_EMOTION_HAPPY
	else
		to_chat(user, span_notice(render.Join("")))
		scanner.emotion = AID_EMOTION_WARN
		playsound(scanner, 'sound/machines/twobeep.ogg', 50, FALSE)

#undef SCANMODE_HEALTH
#undef SCANMODE_WOUND
#undef SCANMODE_COUNT
#undef SCANNER_CONDENSED
#undef SCANNER_VERBOSE
#undef SCANNER_NO_MODE

#undef AID_EMOTION_NEUTRAL
#undef AID_EMOTION_HAPPY
#undef AID_EMOTION_WARN
#undef AID_EMOTION_ANGRY
#undef AID_EMOTION_SAD
