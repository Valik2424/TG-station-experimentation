
/*
	Burn wounds
*/

// TODO: well, a lot really, but specifically I want to add potential fusing of clothing/equipment on the affected area, and limb infections, though those may go in body part code
/datum/wound/burn
	name = "Ожог"
	a_or_from = "from"
	sound_effect = 'sound/effects/wounds/sizzle1.ogg'

/datum/wound/burn/flesh
	name = "Ожог плоти"
	a_or_from = "from"
	processes = TRUE

	default_scar_file = FLESH_SCAR_FILE

	treatable_by = list(/obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh) // sterilizer and alcohol will require reagent treatments, coming soon

	// Flesh damage vars
	/// How much damage to our flesh we currently have. Once both this and infestation reach 0, the wound is considered healed
	var/flesh_damage = 5
	/// Our current counter for how much flesh regeneration we have stacked from regenerative mesh/synthflesh/whatever, decrements each tick and lowers flesh_damage
	var/flesh_healing = 0

	// Infestation vars (only for severe and critical)
	/// How quickly infection breeds on this burn if we don't have disinfectant
	var/infestation_rate = 0
	/// Our current level of infection
	var/infestation = 0
	/// Our current level of sanitization/anti-infection, from disinfectants/alcohol/UV lights. While positive, totally pauses and slowly reverses infestation effects each tick
	var/sanitization = 0

	/// Once we reach infestation beyond WOUND_INFESTATION_SEPSIS, we get this many warnings before the limb is completely paralyzed (you'd have to ignore a really bad burn for a really long time for this to happen)
	var/strikes_to_lose_limb = 3

/datum/wound/burn/flesh/handle_process(seconds_per_tick, times_fired)

	if (!victim || HAS_TRAIT(victim, TRAIT_STASIS))
		return

	. = ..()
	if(strikes_to_lose_limb == 0) // we've already hit sepsis, nothing more to do
		victim.adjustToxLoss(0.25 * seconds_per_tick)
		if(SPT_PROB(0.5, seconds_per_tick))
			victim.visible_message(span_smalldanger("Инфекция [ru_gde_zone(limb.name)] <b>[victim]</b> двигается и булькает тошнотворно!") , span_warning("Инфекция на моей [ru_gde_zone(limb.name)] течет по моим венам!"))
		return

	for(var/datum/reagent/reagent as anything in victim.reagents.reagent_list)
		if(reagent.chemical_flags & REAGENT_AFFECTS_WOUNDS)
			reagent.on_burn_wound_processing(src)

	if(HAS_TRAIT(victim, TRAIT_VIRUS_RESISTANCE))
		sanitization += 0.9

	if(limb.current_gauze)
		limb.seep_gauze(WOUND_BURN_SANITIZATION_RATE * seconds_per_tick)

	if(flesh_healing > 0) // good bandages multiply the length of flesh healing
		var/bandage_factor = limb.current_gauze?.burn_cleanliness_bonus || 1
		flesh_damage = max(flesh_damage - (0.5 * seconds_per_tick), 0)
		flesh_healing = max(flesh_healing - (0.5 * bandage_factor * seconds_per_tick), 0) // good bandages multiply the length of flesh healing

	// if we have little/no infection, the limb doesn't have much burn damage, and our nutrition is good, heal some flesh
	if(infestation <= WOUND_INFECTION_MODERATE && (limb.burn_dam < 5) && (victim.nutrition >= NUTRITION_LEVEL_FED))
		flesh_healing += 0.2

	// here's the check to see if we're cleared up
	if((flesh_damage <= 0) && (infestation <= WOUND_INFECTION_MODERATE))
		to_chat(victim, span_green("Ожоги на моей [ru_gde_zone(limb.name)] пропадают!"))
		qdel(src)
		return

	// sanitization is checked after the clearing check but before the actual ill-effects, because we freeze the effects of infection while we have sanitization
	if(sanitization > 0)
		var/bandage_factor = limb.current_gauze?.burn_cleanliness_bonus || 1
		infestation = max(infestation - (WOUND_BURN_SANITIZATION_RATE * seconds_per_tick), 0)
		sanitization = max(sanitization - (WOUND_BURN_SANITIZATION_RATE * bandage_factor * seconds_per_tick), 0)
		return

	infestation += infestation_rate * seconds_per_tick
	switch(infestation)
		if(0 to WOUND_INFECTION_MODERATE)
		if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
			if(SPT_PROB(15, seconds_per_tick))
				victim.adjustToxLoss(0.2)
				if(prob(6))
					to_chat(victim, span_warning("Волдыри на моей [ru_gde_zone(limb.name)] источают гной..."))
		if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
			if(!disabling)
				if(SPT_PROB(1, seconds_per_tick))
					to_chat(victim, span_warning("<b>Моя [limb.name] немеет от инфекциии!</b>"))
					set_disabling(TRUE)
					return
			else if(SPT_PROB(4, seconds_per_tick))
				to_chat(victim, span_notice("Снова чувствую [ru_parse_zone(limb.name)], но она все еще в ужасном состоянии!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(10, seconds_per_tick))
				victim.adjustToxLoss(0.5)

		if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
			if(!disabling)
				if(SPT_PROB(1.5, seconds_per_tick))
					to_chat(victim, span_warning("<b>Перестаю чувствовать гнойную инфекцию в своей [ru_gde_zone(limb.name)]!</b>"))
					set_disabling(TRUE)
					return
			else if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(victim, span_notice("Едва чувствую свою [ru_parse_zone(limb.name)]!"))
				set_disabling(FALSE)
				return

			if(SPT_PROB(2.48, seconds_per_tick))
				if(prob(20))
					to_chat(victim, span_warning("Обдумываю жизнь без своей [ru_gde_zone(limb.name)]..."))
					victim.adjustToxLoss(0.75)
				else
					victim.adjustToxLoss(1)

		if(WOUND_INFECTION_SEPTIC to INFINITY)
			if(SPT_PROB(0.5 * infestation, seconds_per_tick))
				strikes_to_lose_limb--
				switch(strikes_to_lose_limb)
					if(2 to INFINITY)
						to_chat(victim, span_deadsay("<b>Инфекция из моей [ru_gde_zone(limb.name)] просто стекает вниз, это ужасно!</b>"))
					if(1)
						to_chat(victim, span_deadsay("<b>Инфекция почти полностью завладела [ru_gde_zone(limb.name)]!</b>"))
					if(0)
						to_chat(victim, span_deadsay("<b>Последний из нервных окончаний в моей [ru_gde_zone(limb.name)] отмер...</b>"))
						threshold_penalty = 120 // piss easy to destroy
						var/datum/brain_trauma/severe/paralysis/sepsis = new (limb.body_zone)
						victim.gain_trauma(sepsis)

/datum/wound/burn/flesh/get_wound_description(mob/user)
	if(strikes_to_lose_limb <= 0)
		return span_deadsay("<B>[victim.p_Their()] [limb.plaintext_zone] has locked up completely and is non-functional.</B>")

	var/list/condition = list("[victim.p_Their()] [limb.plaintext_zone] [examine_desc]")
	if(limb.current_gauze)
		var/bandage_condition
		switch(limb.current_gauze.absorption_capacity)
			if(0 to 1.25)
				bandage_condition = "почти разрушен "
			if(1.25 to 2.75)
				bandage_condition = "сильно изношенный "
			if(2.75 to 4)
				bandage_condition = "слегка окрашенный гноем "
			if(4 to INFINITY)
				bandage_condition = "чистый "

		condition += " под повязкой [bandage_condition] [limb.current_gauze.name]"
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				condition += ", <span class='deadsay'>с небольшими пятнами обесцвечивания вдоль соседних вен!</span>"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				condition += ", <span class='deadsay'>с темными облаками, распространяющимися наружу под кожей!</span>"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				condition += ", <span class='deadsay'>с полосами гнилой инфекции, пульсирующей наружу!</span>"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				return span_deadsay("<B>[victim.ru_ego(TRUE)] [limb.name] просто гнилой кусок мяса, кожа буквально капает с костей вместе с инфекцией!</B>")
			else
				condition += "!"

	return "<B>[condition.Join()]</B>"

/datum/wound/burn/flesh/get_scanner_description(mob/user)
	if(strikes_to_lose_limb == 0)
		var/oopsie = "Тип: [name]\nТяжесть: [severity_text()]"
		oopsie += "<div class='ml-3'>Инфекция: <span class='deadsay'>Инфекция полная. Конечность потеряна. Ампутируйте или замените конечность немедленно.</span></div>"
		return oopsie

	. = ..()
	. += "<div class='ml-3'>"

	if(infestation <= sanitization && flesh_damage <= flesh_healing)
		. += "Дальнейшего лечения не требуется: ожоги скоро заживут."
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				. += "Инфекция: Умеренная\n"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				. += "Инфекция: Тяжёлая\n"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				. += "Инфекция: <span class='deadsay'>КРИТИЧЕСКАЯ</span>\n"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				. += "Инфекция: <span class='deadsay'>УГРОЗА ПОТЕРИ КОНЕЧНОСТИ</span>\n"
		if(infestation > sanitization)
			. += "\tХирургическая обработка, антибиотики/стерилизаторы, регенеративная сетка или ультрафиолетовый фонарик парамедика помогут избавиться от заразы.\n"

		if(flesh_damage > 0)
			. += "Обнаружены термические повреждения тканей: Пожалуйста, примените мазь или регенеративную сетку, чтобы восстановить ткани.\n"
	. += "</div>"

/*
	new burn common procs
*/

/// if someone is using ointment or mesh on our burns
/datum/wound/burn/flesh/proc/ointmentmesh(obj/item/stack/medical/I, mob/user)
	user.visible_message(span_notice("<b>[user]</b> начинает применять [I] на [ru_parse_zone(limb.name)] <b>[victim]</b>...") , span_notice("Начинаю применять [I] на[user == victim ? " мою" : ""] [ru_parse_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]..."))
	if (I.amount <= 0)
		return TRUE
	if(!do_after(user, (user == victim ? I.self_delay : I.other_delay), extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	limb.heal_damage(I.heal_brute, I.heal_burn)
	user.visible_message(span_green("<b>[user]</b> применяет [I] на [ru_parse_zone(limb.name)] <b>[victim]</b>.") , span_green("Применяю [I] на[user == victim ? " мою" : ""] [ru_parse_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]."))
	I.use(1)
	sanitization += I.sanitization
	flesh_healing += I.flesh_regeneration

	if((infestation <= 0 || sanitization >= infestation) && (flesh_damage <= 0 || flesh_healing > flesh_damage))
		to_chat(user, span_notice("Сделал всё что мог при помощи [I], теперь надо подождать пока [limb.name] <b>[victim]</b> восстановится."))
		return TRUE
	else
		return try_treating(I, user)

/// Paramedic UV penlights
/datum/wound/burn/flesh/proc/uv(obj/item/flashlight/pen/paramedic/I, mob/user)
	if(!COOLDOWN_FINISHED(I, uv_cooldown))
		to_chat(user, span_notice("[I] всё ещё перезаряжается!"))
		return TRUE
	if(infestation <= 0 || infestation < sanitization)
		to_chat(user, span_notice("Здесь нет инфекции на [ru_gde_zone(limb.name)] <b>[victim]</b>!"))
		return TRUE

	user.visible_message(span_notice("<b>[user]</b> делает серию коротких вспышек на [ru_gde_zone(limb.name)] <b>[victim]</b> используя [I].") , span_notice("Начинаю зачищать инфекцию на [user == victim ? " моей" : ""] [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"] используя [I].") , vision_distance=COMBAT_MESSAGE_RANGE)
	sanitization += I.uv_power
	COOLDOWN_START(I, uv_cooldown, I.uv_cooldown_length)
	return TRUE

/datum/wound/burn/flesh/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/ointment))
		return ointmentmesh(I, user)
	else if(istype(I, /obj/item/stack/medical/mesh))
		var/obj/item/stack/medical/mesh/mesh_check = I
		if(!mesh_check.is_open)
			to_chat(user, span_warning("Нужно открыть [mesh_check] сначала."))
			return
		return ointmentmesh(mesh_check, user)
	else if(istype(I, /obj/item/flashlight/pen/paramedic))
		return uv(I, user)

// people complained about burns not healing on stasis beds, so in addition to checking if it's cured, they also get the special ability to very slowly heal on stasis beds if they have the healing effects stored
/datum/wound/burn/flesh/on_stasis(seconds_per_tick, times_fired)
	. = ..()
	if(strikes_to_lose_limb == 0) // we've already hit sepsis, nothing more to do
		if(SPT_PROB(0.5, seconds_per_tick))
			victim.visible_message(span_danger("Инфекция на остатках [ru_gde_zone(limb.name)] [victim] сдвигается и булькает тошнотворно!") , span_warning("Инфекция на остатках моей [ru_gde_zone(limb.name)] течет по моим венам!"))
		return
	if(flesh_healing > 0)
		flesh_damage = max(flesh_damage - (0.1 * seconds_per_tick), 0)
	if((flesh_damage <= 0) && (infestation <= 1))
		to_chat(victim, span_green("Ожоги на моей [limb.name] уходят!"))
		qdel(src)
		return
	if(sanitization > 0)
		infestation = max(infestation - (0.1 * WOUND_BURN_SANITIZATION_RATE * seconds_per_tick), 0)

/datum/wound/burn/flesh/on_synthflesh(reac_volume)
	flesh_healing += reac_volume * 0.5 // 20u patch will heal 10 flesh standard

/datum/wound_pregen_data/flesh_burn
	abstract = TRUE

	required_wounding_types = list(WOUND_BURN)
	required_limb_biostate = BIO_FLESH

	wound_series = WOUND_SERIES_FLESH_BURN_BASIC

/datum/wound/burn/get_limb_examine_description()
	return span_warning("Кожа на этой конечности выглядит поджаренной и покрытой волдырями")

// we don't even care about first degree burns, straight to second
/datum/wound/burn/flesh/moderate
	name = "Ожоги второй степени"
	skloname = "ожогов второй степени"
	desc = "Пациент страдает от значительных ожогов со слабым проникновением в кожу, нарушением целостности конечностей и повышенным ощущением жжения."
	treat_text = "Рекомендуется применение заживляющей мази или регенеративной сетки на пораженной области."
	examine_desc = "сильно обгорела и покрыта волдырями"
	occur_text = "вспыхивает с сильными красными ожогами"
	severity = WOUND_SEVERITY_MODERATE
	damage_multiplier_penalty = 1.1
	threshold_penalty = 30 // burns cause significant decrease in limb integrity compared to other wounds
	status_effect_type = /datum/status_effect/wound/burn/flesh/moderate
	flesh_damage = 5
	scar_keyword = "burnmoderate"

	simple_desc = "Patient's skin is burned, weakening the limb and multiplying percieved damage!"
	simple_treat_text = "Ointment will speed up recovery, as will regenerative mesh. Risk of infection is negligible."
	homemade_treat_text = "Healthy tea will speed up recovery. Salt, or preferably a salt-water mixture, will sanitize the wound, but the former will cause skin irritation, increasing the risk of infection."

/datum/wound_pregen_data/flesh_burn/second_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/moderate

	threshold_minimum = 40

/datum/wound/burn/flesh/severe
	name = "Ожоги третьей степени"
	skloname = "ожогов третьей степени"
	desc = "Пациент страдает от сильных ожогов с глубоким проникновением в кожу, что создает серьезный риск инфекции."
	treat_text = "Рекомендуется немедленная дезинфекция и удаление зараженной ткани, если таковая присутствует, с последующей перевязкой и применением заживляющей мази."
	examine_desc = "кажется серьезно обугленной, с агрессивными красными пятнами"
	occur_text = "быстро обугливается, обнажая разрушенную ткань и покрывается красными ожогами"
	severity = WOUND_SEVERITY_SEVERE
	damage_multiplier_penalty = 1.2
	threshold_penalty = 40
	status_effect_type = /datum/status_effect/wound/burn/flesh/severe
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.07 // appx 9 minutes to reach sepsis without any treatment
	flesh_damage = 12.5
	scar_keyword = "burnsevere"

	simple_desc = "Patient's skin is badly burned, significantly weakening the limb and compounding further damage!!"
	simple_treat_text = "<b>Bandages will speed up recovery</b>, as will <b>ointment or regenerative mesh</b>. <b>Spaceacilin, sterilizine, and 'Miner's Salve'</b> will help with infection."
	homemade_treat_text = "<b>Healthy tea</b> will speed up recovery. <b>Salt</b>, or preferably a <b>salt-water</b> mixture, will sanitize the wound, but the former especially will cause skin irritation and dehydration, speeding up infection. <b>Space Cleaner</b> can be used as disinfectant in a pinch."

/datum/wound_pregen_data/flesh_burn/third_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe

	threshold_minimum = 80

/datum/wound/burn/flesh/critical
	name = "Катастрофические ожоги"
	skloname = "катастрофических ожогов"
	desc = "Пациент страдает от крайне глубоких ожогов, доходящих до костей. Опасный для жизни риск инфекции."
	treat_text = "Немедленное хирургическое удаление любой инфицированной ткани с последующей перевязкой и применеием противоожоговых препаратов."
	examine_desc = "испорченный беспорядок из бланшированной кости, расплавленного жира и обугленной ткани"
	occur_text = "испаряется, как плоть, кости и жир тают вместе в ужасном беспорядке"
	severity = WOUND_SEVERITY_CRITICAL
	damage_multiplier_penalty = 1.3
	sound_effect = 'sound/effects/wounds/sizzle2.ogg'
	threshold_penalty = 80
	status_effect_type = /datum/status_effect/wound/burn/flesh/critical
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.075 // appx 4.33 minutes to reach sepsis without any treatment
	flesh_damage = 20
	scar_keyword = "burncritical"

	simple_desc = "Patient's skin is destroyed and tissue charred, leaving the limb with almost <b>no integrity<b> and a drastic chance of <b>infection<b>!!!"
	simple_treat_text = "Immediately <b>bandage</b> the wound and treat it with <b>ointment or regenerative mesh</b>. <b>Spaceacilin, sterilizine, or 'Miner's Salve'</b> will stave off infection. Seek professional care <b>immediately</b>, before sepsis sets in and the wound becomes untreatable."
	homemade_treat_text = "<b>Healthy tea</b> will help with recovery. A <b>salt-water mixture</b>, topically applied, might help stave off infection in the short term, but pure table salt is NOT recommended. <b>Space Cleaner</b> can be used as disinfectant in a pinch."

/datum/wound_pregen_data/flesh_burn/fourth_degree
	abstract = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/critical

	threshold_minimum = 140

///special severe wound caused by sparring interference or other god related punishments.
/datum/wound/burn/flesh/severe/brand
	name = "Holy Brand"
	desc = "Patient is suffering extreme burns from a strange brand marking, creating serious risk of infection and greatly reduced limb integrity."
	examine_desc = "appears to have holy symbols painfully branded into their flesh, leaving severe burns."
	occur_text = "chars rapidly into a strange pattern of holy symbols, burned into the flesh."

	simple_desc = "Patient's skin has had strange markings burned onto it, significantly weakening the limb and compounding further damage!!"

/datum/wound_pregen_data/flesh_burn/third_degree/holy
	abstract = FALSE
	can_be_randomly_generated = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe/brand
/// special severe wound caused by the cursed slot machine.

/datum/wound/burn/flesh/severe/cursed_brand
	name = "Ancient Brand"
	desc = "Patient is suffering extreme burns with oddly ornate brand markings, creating serious risk of infection and greatly reduced limb integrity."
	examine_desc = "appears to have ornate symbols painfully branded into their flesh, leaving severe burns"
	occur_text = "chars rapidly into a pattern that can only be described as an agglomeration of several financial symbols, burned into the flesh"

/datum/wound/burn/flesh/severe/cursed_brand/get_limb_examine_description()
	return span_warning("The flesh on this limb has several ornate symbols burned into it, with pitting throughout.")

/datum/wound_pregen_data/flesh_burn/third_degree/cursed_brand
	abstract = FALSE
	can_be_randomly_generated = FALSE

	wound_path_to_generate = /datum/wound/burn/flesh/severe/cursed_brand
