/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_on 	= ru_who(TRUE)
	var/t_ego 	= ru_ego()
	var/t_na 	= ru_na()
	var/t_a 	= ru_a()

	var/obscure_name
	var/obscure_examine

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA) || HAS_TRAIT(L, TRAIT_INVISIBLE_MAN))
			obscure_name = TRUE
		if(HAS_TRAIT(src, TRAIT_UNKNOWN))
			obscure_name = TRUE
			obscure_examine = TRUE

	. = list("")

	if(obscure_examine)
		return list("<span class='warning'>С трудом разбираю детали...")

	var/racetext
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		racetext = get_race_text(human_user.skin_tone)
	. += "<span class='info'>Это же <EM>[!obscure_name ? name : "Неизвестный"]</EM>, [racetext ? "<big class='interface'>[racetext]</big>" : "[get_age_text()]"]!<hr>"

	var/obscured = check_obscured_slots()

	//head
	if(head && !(obscured & ITEM_SLOT_HEAD) && !(head.item_flags & EXAMINE_SKIP))
		. += "На голове у н[t_ego] [head.get_examine_string(user)]."

	//eyes
	if(!(obscured & ITEM_SLOT_EYES) )
		if(glasses  && !(glasses.item_flags & EXAMINE_SKIP))
			. += "Также на [t_na] [glasses.get_examine_string(user)]."
		else if(HAS_TRAIT(src, TRAIT_UNNATURAL_RED_GLOWY_EYES))
			. += span_warning("<B>[ru_ego(TRUE)] глаза ярко-красные и они горят!</B>")
		else if(HAS_TRAIT(src, TRAIT_BLOODSHOT_EYES))
			. += span_warning("<B>[ru_ego(TRUE)] глаза красные!</B>")

	//ears
	if(ears && !(obscured & ITEM_SLOT_EARS) && !(ears.item_flags & EXAMINE_SKIP))
		. += "В ушах у н[t_ego] есть [ears.get_examine_string(user)]."

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK)  && !(wear_mask.item_flags & EXAMINE_SKIP))
		. += "На лице у н[t_ego] [wear_mask.get_examine_string(user)]."

	//suit/armor
	if(wear_suit && !(wear_suit.item_flags & EXAMINE_SKIP))
		//suit/armor storage
		var/suit_thing
		if(s_store && !(obscured & ITEM_SLOT_SUITSTORE) && !(s_store.item_flags & EXAMINE_SKIP))
			suit_thing += " вместе с [s_store.get_examine_string(user)]"

		. += "На [t_na] надет [wear_suit.get_examine_string(user)][suit_thing]."

	//uniform
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING) && !(w_uniform.item_flags & EXAMINE_SKIP))
		//accessory
		var/accessory_message = ""
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/undershirt = w_uniform
			var/list/accessories = undershirt.list_accessories_with_icon(user)
			if(length(accessories))
				accessory_message = " с [english_list(accessories)]"

		. += "Одет[t_a] он[t_a] в [w_uniform.get_examine_string(user)][accessory_message]."
	//back
	if(back && !(back.item_flags & EXAMINE_SKIP))
		. += "Со спины у н[t_ego] свисает [back.get_examine_string(user)]."

	//Hands
	for(var/obj/item/held_thing in held_items)
		if(held_thing.item_flags & (ABSTRACT|EXAMINE_SKIP|HAND_ITEM))
			continue
		. += "В [get_held_index_name(get_held_index_of_item(held_thing))] он[t_a] держит [held_thing.get_examine_string(user)]."

	//gloves
	if(gloves && !(obscured & ITEM_SLOT_GLOVES) && !(gloves.item_flags & EXAMINE_SKIP))
		. += "А на руках у н[t_ego] [gloves.get_examine_string(user)]."
	else if(GET_ATOM_BLOOD_DNA_LENGTH(src))
		if(num_hands)
			. += span_warning("[ru_ego(TRUE)] рук[num_hands > 1 ? "и" : "а"] также в крови!")

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/restraints/handcuffs/cable))
			. += span_warning("[t_on] [icon2html(handcuffed, user)] связан[t_a]!")
		else
			. += span_warning("[t_on] [icon2html(handcuffed, user)] в наручниках!")

	//belt
	if(belt && !(belt.item_flags & EXAMINE_SKIP))
		. += "И ещё на поясе у н[t_ego] [belt.get_examine_string(user)]."

	// neck
	if(wear_neck && !(obscured & ITEM_SLOT_NECK)  && !(wear_neck.item_flags & EXAMINE_SKIP))
		. += "На шее у н[t_ego] [wear_neck.get_examine_string(user)]."


	//shoes
	if(shoes && !(obscured & ITEM_SLOT_FEET)  && !(shoes.item_flags & EXAMINE_SKIP))
		. += "А на [t_ego] ногах [shoes.get_examine_string(user)]."

	//ID
	if(wear_id && !(wear_id.item_flags & EXAMINE_SKIP))
		. += "И конечно же у н[t_ego] есть [wear_id.get_examine_string(user)]."

		. += wear_id.get_id_examine_strings(user)

	//Status effects
	var/list/status_examines = get_status_effect_examinations()
	if (length(status_examines))
		. += status_examines

	var/appears_dead = FALSE
	var/just_sleeping = FALSE

	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE

		var/obj/item/clothing/glasses/G = get_item_by_slot(ITEM_SLOT_EYES)
		var/are_we_in_weekend_at_bernies = G?.tint && buckled && istype(buckled, /obj/vehicle/ridden/wheelchair)

		if(isliving(user) && (HAS_MIND_TRAIT(user, TRAIT_NAIVE) || are_we_in_weekend_at_bernies))
			just_sleeping = TRUE

		if(!just_sleeping)
			if(HAS_TRAIT(src, TRAIT_SUICIDED))
				. += span_warning("[t_on] выглядит как суицидник... [t_ego] уже невозможно спасти.")

			. += generate_death_examine_text()

	if(get_bodypart(BODY_ZONE_HEAD) && !get_organ_by_type(/obj/item/organ/internal/brain))
		. += span_deadsay("Похоже, что у н[t_ego] нет мозга...")

	var/list/msg = list()

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/list/disabled = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/body_part = X
		if(body_part.bodypart_disabled)
			disabled += body_part
		missing -= body_part.body_zone
		for(var/obj/item/I in body_part.embedded_objects)
			if(I.isEmbedHarmless())
				msg += "<B>Из [t_ego] [body_part.name] торчит [icon2html(I, user)] [I]!</B>\n"
			else
				msg += "<B>У н[t_ego] застрял [icon2html(I, user)] [I] в [body_part.name]!</B>\n"

		for(var/i in body_part.wounds)
			var/datum/wound/iter_wound = i
			msg += "[iter_wound.get_examine_description(user)]\n"

	for(var/X in disabled)
		var/obj/item/bodypart/body_part = X
		var/damage_text
		if(HAS_TRAIT(body_part, TRAIT_DISABLED_BY_WOUND))
			continue // skip if it's disabled by a wound (cuz we'll be able to see the bone sticking out!)
		if(!(body_part.get_damage() >= body_part.max_damage)) //we don't care if it's stamcritted
			damage_text = "выглядит безжизненной"
		else
			damage_text = (body_part.brute_dam >= body_part.burn_dam) ? body_part.heavy_brute_msg : body_part.heavy_burn_msg
		msg += "<B>[ru_ego(TRUE)] [body_part.name] [damage_text]!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/t in missing)
		if(t == BODY_ZONE_HEAD)
			msg += span_deadsay("<B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B>\n")
			continue
		if(t == BODY_ZONE_L_ARM || t == BODY_ZONE_L_LEG)
			l_limbs_missing++
		else if(t == BODY_ZONE_R_ARM || t == BODY_ZONE_R_LEG)
			r_limbs_missing++

		msg += span_warning("<B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B>\n")

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_on] стоит на правой части.\n"
	else if(l_limbs_missing == 0 && r_limbs_missing >= 2)
		msg += "[t_on] стоит на левой части.\n"
	else if(l_limbs_missing >= 2 && r_limbs_missing >= 2)
		msg += "[t_on] выглядит как котлетка.\n"

	if(!(user == src && has_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy))) //fake healthy
		var/temp
		if(user == src && has_status_effect(/datum/status_effect/grouped/screwy_hud/fake_crit))//fake damage
			temp = 50
		else
			temp = getBruteLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные ушибы.\n"
			else if(temp < 50)
				msg += "[t_on] <b>тяжело</b> ранен[t_a]!\n"
			else
				msg += "<B>[t_on] смертельно ранен[t_a]!</B>\n"

		temp = getFireLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] немного подгорел[t_a].\n"
			else if (temp < 50)
				msg += "[t_on] имеет <b>серьёзные</b> ожоги!\n"
			else
				msg += "<B>[t_on] имеет смертельные ожоги!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные подтёки на теле.\n"
			else if(temp < 50)
				msg += "[t_on] имеет <b>обвисшую</b> кожу на большей части тела!\n"
			else
				msg += "<b>[t_on] имеет тело состоящее из кусков свисающей плоти!</b>\n"


	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[t_on] в чем-то горючем.\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[t_on] выглядит мокро.\n"


	if(pulledby?.grab_state)
		msg += "[t_on] удерживается захватом [pulledby].\n"

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_on] выглядит смертельно истощённо.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_on] выглядит как толстенький, словно поросёнок. Очень вкусный поросёнок.\n"
		else
			msg += "[t_on] выглядит довольно плотно.\n"
	switch(disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			msg += "[t_on] выглядит немного неприятно.\n"
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			msg += "[t_on] выглядит очень неприятно.\n"
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			msg += "[t_on] выглядит отвратительно.\n"

	var/apparent_blood_volume = blood_volume
	if(HAS_TRAIT(src, TRAIT_USES_SKINTONES) && (skin_tone == "albino"))
		apparent_blood_volume -= 150 // enough to knock you down one tier
	switch(apparent_blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += "[ru_ego(TRUE)] кожа бледная.\n"
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += "[ru_ego(TRUE)] кожа до смерти бледная.\n"
		if(-INFINITY to BLOOD_VOLUME_BAD)
			msg += "[t_on] выглядит, как измельченный пустой пакет из под сока.\n"

	if(is_bleeding())
		var/list/obj/item/bodypart/bleeding_limbs = list()
		var/list/obj/item/bodypart/grasped_limbs = list()

		for(var/obj/item/bodypart/body_part as anything in bodyparts)
			if(body_part.get_modified_bleed_rate())
				bleeding_limbs += body_part
			if(body_part.grasped_by)
				grasped_limbs += body_part

		var/num_bleeds = LAZYLEN(bleeding_limbs)

		var/list/bleed_text
		if(appears_dead)
			bleed_text = list("<span class='deadsay'><B>Кровь брызгает струйками из [ru_ego(FALSE)]")
		else
			bleed_text = list("<B>[t_on] имеет кровотечение из [ru_ego(FALSE)]")

		switch(num_bleeds)
			if(1 to 2)
				bleed_text += " [ru_otkuda_zone(bleeding_limbs[1].name)][num_bleeds == 2 ? " и [ru_otkuda_zone(bleeding_limbs[2].name)]" : ""]"
			if(3 to INFINITY)
				for(var/i in 1 to (num_bleeds - 1))
					var/obj/item/bodypart/body_part = bleeding_limbs[i]
					bleed_text += " [ru_otkuda_zone(body_part.name)],"
				bleed_text += " и [ru_otkuda_zone(bleeding_limbs[num_bleeds].name)]"

		if(appears_dead)
			bleed_text += ", но очень медленно.</span></B>\n"
		else
			if(reagents.has_reagent(/datum/reagent/toxin/heparin, needs_metabolizing = TRUE))
				bleed_text += " невероятно быстро"

			bleed_text += "!</B>\n"

		for(var/i in grasped_limbs)
			var/obj/item/bodypart/grasped_part = i
			bleed_text += "[t_on] сжимает свою [grasped_part.name], пока из той течёт кровь!\n"

		msg += bleed_text.Join()

	if(reagents.has_reagent(/datum/reagent/teslium, needs_metabolizing = TRUE))
		msg += "[t_on] испускает нежное голубое свечение!\n"

	if(just_sleeping)
		msg += "[t_on] похоже спит.\n"

	if(!appears_dead)
		var/mob/living/living_user = user
		if(src != user)
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				if (combat_mode)
					msg += "[t_on] выглядит на готове.\n"
				if (getOxyLoss() >= 10)
					msg += "[t_on] выглядит измотанно.\n"
				if (getToxLoss() >= 10)
					msg += "[t_on] выглядит болезненно.\n"
				if(mob_mood.sanity <= SANITY_DISTURBED)
					msg += "[t_on] выглядит расстроено.\n"
					living_user.add_mood_event("empath", /datum/mood_event/sad_empath, src)
				if(is_blind())
					msg += "[t_on] смотрит в пустоту.\n"
				if (HAS_TRAIT(src, TRAIT_DEAF))
					msg += "Кажется, что [t_on] не реагирует на звуки.\n"
				if (bodytemperature > dna.species.bodytemp_heat_damage_limit)
					msg += "[t_on] краснеет и хрипит.\n"
				if (bodytemperature < dna.species.bodytemp_cold_damage_limit)
					msg += "[t_on] дрожит.\n"

			msg += "</span>"

			if(HAS_TRAIT(user, TRAIT_SPIRITUAL) && mind?.holy_role)
				msg += "От н[t_ego] веет святым духом.\n"
				living_user.add_mood_event("religious_comfort", /datum/mood_event/religiously_comforted)

		switch(stat)
			if(UNCONSCIOUS, HARD_CRIT)
				msg += span_deadsay("[t_on] не реагирует на происходящее вокруг.\n")
			if(SOFT_CRIT)
				msg += span_deadsay("[t_on] едва в сознании.\n")
			if(CONSCIOUS)
				if(HAS_TRAIT(src, TRAIT_DUMB))
					msg += "[t_on] имеет глупое выражение лица.\n"
		if(get_organ_by_type(/obj/item/organ/internal/brain))
			if(!key)
				msg += span_deadsay("[t_on] кататоник. Стресс от жизни в глубоком космосе сильно повлиял на н[t_ego]. Восстановление маловероятно.\n")
			else if(!client)
				msg += span_deadsay("[t_on] имеет пустой, рассеянный взгляд и кажется совершенно не реагирующим ни на что. [t_on] может выйти из этого в ближайшее время.\n")

	var/scar_severity = 0
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			scar_severity += S.severity

	switch(scar_severity)
		if(1 to 4)
			msg += "[span_tinynoticeital("[t_on] похоже имеет шрамы... Стоит присмотреться, чтобы разглядеть ещё.")]\n"
		if(5 to 8)
			msg += "[span_smallnoticeital("<i>[t_on] имеет несколько серьёзных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i>")]\n"
		if(9 to 11)
			msg += "[span_notice("<b><i>[t_on] имеет множество ужасных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i></b>")]\n"
		if(12 to INFINITY)
			msg += "[span_notice("<b><i>[t_on] имеет разорванное в хлам тело состоящее из шрамов... Стоит присмотреться, чтобы разглядеть ещё?</i></b>")]\n"
	msg += "</span>" // closes info class

	if (length(msg))
		. += span_warning("[msg.Join("")]")

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	if(isliving(user))
		var/mob/living/morbid_weirdo = user
		if(HAS_MIND_TRAIT(morbid_weirdo, TRAIT_MORBID))
			if(HAS_TRAIT(src, TRAIT_DISSECTED))
				msg += "[span_notice("Кажется, [t_on] прооперирован[t_a]. Бесполезно для изучения, <b><i>пока что.</i></b>")]\n"
			if(HAS_TRAIT(src, TRAIT_SURGICALLY_ANALYZED))
				msg += "[span_notice("Опытные руки составили карту внутренних хитросплетений этого устройства. В будущем будет гораздо проще проводить эксперименты на [t_na]. <b><i>Изысканно.</i></b>")]\n"

	var/perpname = get_face_name(get_id_name(""))
	if(perpname && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		var/datum/record/crew/target_record = find_record(perpname)
		if(target_record)
			. += "<hr><span class='deptradio'>Должность:</span> [target_record.rank]\n<a href='?src=[REF(src)];hud=1;photo_front=1;examine_time=[world.time]'>\[Фото\]</a><a href='?src=[REF(src)];hud=1;photo_side=1;examine_time=[world.time]'>\[Альт. Фото\]</a>"
		if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD))
			var/cyberimp_detect
			for(var/obj/item/organ/internal/cyberimp/cyberimp in organs)
				if(IS_ROBOTIC_ORGAN(cyberimp) && !(cyberimp.organ_flags & ORGAN_HIDDEN))
					cyberimp_detect += "[!cyberimp_detect ? "[cyberimp.get_examine_string(user)]" : ", [cyberimp.get_examine_string(user)]"]"
			if(cyberimp_detect)
				. += "<hr><span class='notice ml-1'>Обнаружены кибернетические модификации:</span>"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(target_record)
				var/health_record = target_record.physical_status
				. += "<a href='?src=[REF(src)];hud=m;physical_status=1;examine_time=[world.time]'>\[[health_record]\]</a>"
				health_record = target_record.mental_status
				. += "<a href='?src=[REF(src)];hud=m;mental_status=1;examine_time=[world.time]'>\[[health_record]\]</a>"
			target_record = find_record(perpname)
			if(target_record)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1;examine_time=[world.time]'>\[Медицинское заключение\]</a><br>"
			. += "<a href='?src=[REF(src)];hud=m;quirk=1;examine_time=[world.time]'>\[Признаки\]</a>"

		if(HAS_TRAIT(user, TRAIT_SECURITY_HUD))
			if(!user.stat && user != src)
			//|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
				var/wanted_status = WANTED_NONE
				var/security_note = "Нету."

				target_record = find_record(perpname)
				if(target_record)
					wanted_status = target_record.wanted_status
					if(target_record.security_note)
						security_note = target_record.security_note

				. += "<hr><span class='deptradio'>Статус:</span> <a href='?src=[REF(src)];hud=s;status=1;examine_time=[world.time]'>\[[wanted_status]\]</a>"
				. += "<span class='deptradio'>Заметки: [security_note]"
				. += jointext(list("<span class='deptradio'>Security record:</span> <a href='?src=[REF(src)];hud=s;view=1;examine_time=[world.time]'>\[Показать\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_citation=1;examine_time=[world.time]'>\[Добавить цитату\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_crime=1;examine_time=[world.time]'>\[Добавить нарушение\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_note=1;examine_time=[world.time]'>\[Добавить комментарий\]</a>"), "")
	else if(isobserver(user))
		. += span_info("<hr>	<b>Черты:</b> [get_quirk_string(FALSE, CAT_QUIRK_ALL)]")
	. += "</span>"

	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE, user, .)

/**
 * Shows any and all examine text related to any status effects the user has.
 */
/mob/living/proc/get_status_effect_examinations()
	var/list/examine_list = list()

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text()
		if(!effect_text)
			continue

		examine_list += effect_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if ((wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE)))
		return
	var/age_text
	switch(age)
		if(-INFINITY to 25)
			age_text = "очень молод[ru_aya()]"
		if(26 to 35)
			age_text = "молод[ru_aya()]"
		if(36 to 55)
			age_text = "среднего возраста"
		if(56 to 75)
			age_text = "достаточно взросл[ru_aya()]"
		if(76 to 100)
			if(gender == FEMALE)
				age_text = "старуха"
			else
				age_text = "старик"
		if(101 to INFINITY)
			age_text = "сейчас превратится в пыль"
	. += list(span_notice("<hr>[ru_who(TRUE)] на вид [age_text]."))

