#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/cqc
	name = "CQC"
	id = MARTIALART_CQC
	help_verb = /mob/living/proc/CQC_help
	block_chance = 75
	smashes_tables = TRUE
	display_combos = TRUE
	var/old_grab_state = null
	var/mob/restraining_mob

/datum/martial_art/cqc/teach(mob/living/cqc_user, make_temporary)
	. = ..()
	RegisterSignal(cqc_user, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))

/datum/martial_art/cqc/on_remove(mob/living/cqc_user)
	UnregisterSignal(cqc_user, COMSIG_ATOM_ATTACKBY)
	. = ..()

///Signal from getting attacked with an item, for a special interaction with touch spells
/datum/martial_art/cqc/proc/on_attackby(mob/living/cqc_user, obj/item/attack_weapon, mob/A, params)
	SIGNAL_HANDLER

	if(!istype(attack_weapon, /obj/item/melee/touch_attack))
		return
	if(!can_use(cqc_user))
		return
	cqc_user.visible_message(
		span_danger("[cqc_user] twists [A]'s arm, sending their [attack_weapon] back towards them!"),
		span_userdanger("Making sure to avoid [A]'s [attack_weapon], you twist their arm to send it right back at them!"),
	)
	var/obj/item/melee/touch_attack/touch_weapon = attack_weapon
	var/datum/action/cooldown/spell/touch/touch_spell = touch_weapon.spell_which_made_us?.resolve()
	if(!touch_spell)
		return
	INVOKE_ASYNC(touch_spell, TYPE_PROC_REF(/datum/action/cooldown/spell/touch, do_hand_hit), touch_weapon, A, A)
	return COMPONENT_NO_AFTERATTACK

/datum/martial_art/cqc/reset_streak(mob/living/new_target)
	if(new_target && new_target != restraining_mob)
		restraining_mob = null
	return ..()

/datum/martial_art/cqc/proc/check_streak(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(findtext(streak, SLAM_COMBO))
		reset_streak()
		return Slam(A, D)
	if(findtext(streak, KICK_COMBO))
		reset_streak()
		return Kick(A, D)
	if(findtext(streak, RESTRAIN_COMBO))
		reset_streak()
		return Restrain(A, D)
	if(findtext(streak, PRESSURE_COMBO))
		reset_streak()
		return Pressure(A, D)
	if(findtext(streak, CONSECUTIVE_COMBO))
		reset_streak()
		return Consecutive(A, D)
	return FALSE

/datum/martial_art/cqc/proc/Slam(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(D.body_position == STANDING_UP)
		D.visible_message(span_danger("[A] укладывает [D] на пол!"), \
						span_userdanger("[A] укладывает меня на пол!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
		to_chat(A, span_danger("Укладываю [D] на пол!"))
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, TRUE, -1)
		D.apply_damage(10, BRUTE)
		D.Paralyze(12 SECONDS)
		log_combat(A, D, "slammed (CQC)")
		return TRUE

/datum/martial_art/cqc/proc/Kick(mob/living/A, mob/living/D)
	if(!can_use(A) || D.stat != CONSCIOUS)
		return FALSE

	if(D.body_position == LYING_DOWN && !D.IsUnconscious() && D.getStaminaLoss() >= 100)
		log_combat(A, D, "knocked out (Head kick)(CQC)")
		D.visible_message(span_danger("[A] лупит по голове [D], принуждая отрубиться!"), \
						span_userdanger("[A] лупит меня по голове!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
		to_chat(A, span_danger("Луплю [D], принуждая отрубиться!"))
		playsound(get_turf(A), 'sound/weapons/genhit1.ogg', 50, TRUE, -1)

		var/helmet_protection = D.run_armor_check(BODY_ZONE_HEAD, MELEE)
		D.apply_effect(20 SECONDS, EFFECT_KNOCKDOWN, helmet_protection)
		D.apply_effect(10 SECONDS, EFFECT_UNCONSCIOUS, helmet_protection)
		D.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 150)
	else
		D.visible_message(span_danger("[A] пинает [D] в спину!"), \
						span_userdanger("[A] пинает меня в спину!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Пинаю [D] в спину!"))
		playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
		var/atom/throw_target = get_edge_target_turf(D, A.dir)
		D.throw_at(throw_target, 1, 14, A)
		D.apply_damage(10, A.get_attack_type())
		if(D.body_position == LYING_DOWN && !D.IsUnconscious())
			D.adjustStaminaLoss(45)
		log_combat(A, D, "kicked (CQC)")
	. = TRUE

/datum/martial_art/cqc/proc/Pressure(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "pressured (CQC)")
	D.visible_message(span_danger("[A] бьёт [D] в шею!"), \
					span_userdanger("[A] бьёт меня в шею!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью в шею [D]!"))
	D.adjustStaminaLoss(60)
	playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/cqc/proc/Restrain(mob/living/A, mob/living/D)
	if(restraining_mob)
		return
	if(!can_use(A))
		return FALSE
	if(!D.stat)
		log_combat(A, D, "restrained (CQC)")
		D.visible_message(span_warning("[A] фиксирует [D] в удерживающем положении!"), \
						span_userdanger("[A] фиксирует меня жёстко!"), span_hear("Слышу потасовку и тихий рёв!"), null, A)
		to_chat(A, span_danger("Фиксирую [D] в удерживающем положении!"))
		D.adjustStaminaLoss(20)
		D.Stun(10 SECONDS)
		restraining_mob = D
		addtimer(VARSET_CALLBACK(src, restraining_mob, null), 50, TIMER_UNIQUE)
		return TRUE

/datum/martial_art/cqc/proc/Consecutive(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(!D.stat)
		log_combat(A, D, "consecutive CQC'd (CQC)")
		D.visible_message(span_danger("[A] лупит [D] в живот, шею и спину последовательно!"), \
						span_userdanger("Мой живот, шея и спина были последовательно наказаны ударами [A]!"), span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Бью живот, шею и спину [D] последовательно!"))
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
		var/obj/item/held_item = D.get_active_held_item()
		if(held_item && D.temporarilyRemoveItemFromInventory(held_item))
			A.put_in_hands(held_item)
		D.adjustStaminaLoss(50)
		D.apply_damage(25, A.get_attack_type())
		return TRUE

/datum/martial_art/cqc/grab_act(mob/living/A, mob/living/D)
	if(A != D && can_use(A)) // A != D prevents grabbing yourself
		add_to_streak("G", D)
		if(check_streak(A, D)) //if a combo is made no grab upgrade is done
			return TRUE
		old_grab_state = A.grab_state
		D.grabbedby(A, 1)
		if(old_grab_state == GRAB_PASSIVE)
			D.drop_all_held_items()
			A.setGrabState(GRAB_AGGRESSIVE) //Instant aggressive grab if on grab intent
			log_combat(A, D, "grabbed", addition="aggressively")
			D.visible_message(span_warning("[A] берёт в захват [D]!"), \
							span_userdanger("[A] берёт меня в захват!"), span_hear("Слышу звуки агрессивной потасовки!"), COMBAT_MESSAGE_RANGE, A)
			to_chat(A, span_danger("Беру в захват [D]!"))
		return TRUE
	else
		return FALSE

/datum/martial_art/cqc/harm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE

	if(A.resting && D.stat != DEAD && D.body_position == STANDING_UP)
		D.visible_message(span_danger("[A] сбивает с ног [D]!"), \
						span_userdanger("[A] сбивает меня с ног!"), span_hear("Слышу звук разрывающейся плоти!") , null, A)
		to_chat(A, span_danger("Сбиваю [D] с ног!"))
		playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
		A.do_attack_animation(D)
		D.apply_damage(10, BRUTE)
		D.Knockdown(5 SECONDS)
		log_combat(A, D, "sweeped (CQC)")
		reset_streak()
		return TRUE

	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "attacked (CQC)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("CQCрует", "Биг Боссит")
	var/bonus_damage = 13
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = pick("пинает", "втаптывает в пол")
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "пинает" || picked_hit_type == "втаптывает в пол")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
	else
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
	D.visible_message(span_danger("[A] [picked_hit_type]ed [D]!"), \
					span_userdanger("You're [picked_hit_type]ed by [A]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("You [picked_hit_type] [D]!"))
	log_combat(A, D, "[picked_hit_type]s (CQC)")

	return TRUE

/datum/martial_art/cqc/disarm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("D", D)
	var/obj/item/held_item = null
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "disarmed (CQC)", "[held_item ? " grabbing  [held_item]" : ""]")
	if(restraining_mob && A.pulling == restraining_mob)
		log_combat(A, D, "knocked out (Chokehold)(CQC)")
		D.visible_message(span_danger("[A] хватает [D] за шею!"), \
						span_userdanger("[A] хватает меня за шею!"), span_hear("Слышу шорох и приглушенный стон!"), null, A)
		to_chat(A, span_danger("Беру [D] в удушающий захват!"))
		D.SetSleeping(40 SECONDS)
		restraining_mob = null
		if(A.grab_state < GRAB_NECK && !HAS_TRAIT(A, TRAIT_PACIFISM))
			A.setGrabState(GRAB_NECK)
		return TRUE
	if(prob(65))
		if(!D.stat || !D.IsParalyzed() || !restraining_mob)
			held_item = D.get_active_held_item()
			D.visible_message(span_danger("[A] лупит по челюсти [D]!"), \
							span_userdanger("[A] бьёт меня по челюсти, мне плохо!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
			to_chat(A, span_danger("Бью в [D] челюсть, от чего тот пошатывается!"))
			playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
			if(held_item && D.temporarilyRemoveItemFromInventory(held_item))
				A.put_in_hands(held_item)
			D.set_jitter_if_lower(4 SECONDS)
			D.apply_damage(5, A.get_attack_type())
	else
		D.visible_message(span_danger("[A] проваливает попытку обезоружить [D]!"), \
						span_userdanger("Почти получилось обезоружить [A]!"), span_hear("Слышу взмах!"), COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_warning("Не вышло обезоружить [D]!"))
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
	return FALSE


/mob/living/proc/CQC_help()
	set name = "Вспомнить приёмы"
	set category = "CQC"
	to_chat(usr, "<b><i>Пытаюсь вспомнить базовую программу CQC.</i></b>")

	to_chat(usr, "<span class='notice'>Уложить</span>: Захват Удар. Роняет противника на пол, обездвиживая его.")
	to_chat(usr, "<span class='notice'>Удар CQC</span>: Удар Удар. Отталкивает противника. Вырубает поверженных противников.")
	to_chat(usr, "<span class='notice'>Удержать</span>: Захват Захват. Удерживает противника, обезоруживание возьмёт противника в удушающий захват.")
	to_chat(usr, "<span class='notice'>Давление</span>: Обезоружить Захват. Заставляет противника выдохнуться.")
	to_chat(usr, "<span class='notice'>Последовательный CQC</span>: Обезоружить Обезоружить Удар. Наносит противнику огромный урон и заставляет его выдохнуться.")

///Subtype of CQC. Only used for the chef.
/datum/martial_art/cqc/under_siege
	name = "Close Quarters Cooking"
	///List of all areas that CQC will work in, defaults to Kitchen.
	var/list/kitchen_areas = list(/area/station/service/kitchen)

/// Refreshes the valid areas from the cook's mapping config, adding areas in config to the list of possible areas.
/datum/martial_art/cqc/under_siege/proc/refresh_valid_areas()
	var/list/additional_cqc_areas = CHECK_MAP_JOB_CHANGE(JOB_COOK, "additional_cqc_areas")
	if(!additional_cqc_areas)
		return

	if(!islist(additional_cqc_areas))
		stack_trace("Incorrect CQC area format from mapping configs. Expected /list, got: \[[additional_cqc_areas.type]\]")
		return

	for(var/path_as_text in additional_cqc_areas)
		var/path = text2path(path_as_text)
		if(!ispath(path, /area))
			stack_trace("Invalid path in mapping config for chef CQC: \[[path_as_text]\]")
			continue

		kitchen_areas |= path

/// Limits where the chef's CQC can be used to only whitelisted areas.
/datum/martial_art/cqc/under_siege/can_use(mob/living/owner)
	if(!is_type_in_list(get_area(owner), kitchen_areas))
		return FALSE
	return ..()

#undef SLAM_COMBO
#undef KICK_COMBO
#undef RESTRAIN_COMBO
#undef PRESSURE_COMBO
#undef CONSECUTIVE_COMBO
