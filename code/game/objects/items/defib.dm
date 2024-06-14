//backpack item
#define HALFWAYCRITDEATH ((HEALTH_THRESHOLD_CRIT + HEALTH_THRESHOLD_DEAD) * 0.5)
#define DEFIB_CAN_HURT(source) (source.combat || (source.req_defib && !source.defib.safety))

/obj/item/defibrillator
	name = "дефибриллятор"
	desc = "Устройство генерирует короткий высоковольтный импульс, вызывающий полное сокращение миокарда. После того, как сердце полностью сократилось, существует вероятность восстановления нормального синусового ритма."
	icon = 'icons/obj/medical/defib.dmi'
	icon_state = "defibunit"
	inhand_icon_state = "defibunit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	actions_types = list(/datum/action/item_action/toggle_paddles)
	armor_type = /datum/armor/item_defibrillator

	var/obj/item/shockpaddles/paddle_type = /obj/item/shockpaddles
	/// If the paddles are equipped (1) or on the defib (0)
	var/on = FALSE
	/// If you can zap people with the defibs on harm mode
	var/safety = TRUE
	/// If there's a cell in the defib with enough power for a revive, blocks paddles from reviving otherwise
	var/powered = FALSE
	/// If the cell can be removed via screwdriver
	var/cell_removable = TRUE
	var/obj/item/shockpaddles/paddles
	var/obj/item/stock_parts/cell/high/cell
	/// If true, revive through space suits, allow for combat shocking
	var/combat = FALSE
	/// How long does it take to recharge
	var/cooldown_duration = 5 SECONDS
	/// The icon state for the paddle overlay, not applied if null
	var/paddle_state = "defibunit-paddles"
	/// The icon state for the powered on overlay, not applied if null
	var/powered_state = "defibunit-powered"
	/// The icon state for the charge bar overlay, not applied if null
	var/charge_state = "defibunit-charge"
	/// The icon state for the missing cell overlay, not applied if null
	var/nocell_state = "defibunit-nocell"
	/// The icon state for the emagged overlay, not applied if null
	var/emagged_state = "defibunit-emagged"

/datum/armor/item_defibrillator
	fire = 50
	acid = 50

/obj/item/defibrillator/get_cell()
	return cell

/obj/item/defibrillator/Initialize(mapload) //starts without a cell for rnd
	. = ..()
	paddles = new paddle_type(src)
	update_power()
	RegisterSignal(paddles, COMSIG_DEFIBRILLATOR_SUCCESS, PROC_REF(on_defib_success))

/obj/item/defibrillator/loaded/Initialize(mapload) //starts with hicap
	. = ..()
	cell = new(src)
	update_power()

/obj/item/defibrillator/examine(mob/user)
	. = ..()
	if(!cell_removable)
		return
	if(cell)
		. += span_notice("Можно использовать отвёртку, чтобы извлечь батарею.")
	else
		. += span_warning("Батарея отсутствует!")

/obj/item/defibrillator/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if(paddles?.loc == src)
		paddles.fire_act(exposed_temperature, exposed_volume)

/obj/item/defibrillator/extinguish()
	. = ..()
	if(paddles?.loc == src)
		paddles.extinguish()

/obj/item/defibrillator/proc/update_power()
	if(!QDELETED(cell))
		if(QDELETED(paddles) || cell.charge < paddles.revivecost)
			powered = FALSE
		else
			powered = TRUE
	else
		powered = FALSE
	update_appearance()
	if(istype(loc, /obj/machinery/defibrillator_mount))
		loc.update_appearance()

/obj/item/defibrillator/update_overlays()
	. = ..()

	if(!on && paddle_state)
		. += paddle_state
	if(powered && powered_state)
		. += powered_state
		if(!QDELETED(cell) && charge_state)
			var/ratio = cell.charge / cell.maxcharge
			ratio = CEILING(ratio*4, 1) * 25
			. += "[charge_state][ratio]"
	if(!cell && nocell_state)
		. += "[nocell_state]"
	if(!safety && emagged_state)
		. += emagged_state

/obj/item/defibrillator/CheckParts(list/parts_list)
	..()
	cell = locate(/obj/item/stock_parts/cell) in contents
	update_power()

/obj/item/defibrillator/ui_action_click()
	INVOKE_ASYNC(src, PROC_REF(toggle_paddles))

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/defibrillator/attack_hand(mob/user, list/modifiers)
	if(loc == user)
		if(slot_flags & ITEM_SLOT_BACK)
			if(user.get_item_by_slot(ITEM_SLOT_BACK) == src)
				ui_action_click()
			else
				to_chat(user, span_warning("Для этого нужно экипировать дефибриллятор на спину!"))

		else if(slot_flags & ITEM_SLOT_BELT)
			if(user.get_item_by_slot(ITEM_SLOT_BELT) == src)
				ui_action_click()
			else
				to_chat(user, span_warning("Для этого нужно экипировать дефибриллятор на поясе!"))
		return
	else if(istype(loc, /obj/machinery/defibrillator_mount))
		ui_action_click() //checks for this are handled in defibrillator.mount.dm
	return ..()

/obj/item/defibrillator/MouseDrop(obj/over_object)
	. = ..()
	if(ismob(loc))
		var/mob/M = loc
		if(!M.incapacitated() && istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			M.putItemFromInventoryInHandIfPossible(src, H.held_index)

/obj/item/defibrillator/screwdriver_act(mob/living/user, obj/item/tool)
	if(!cell || !cell_removable)
		return FALSE

	cell.update_appearance()
	cell.forceMove(get_turf(src))
	balloon_alert(user, "вытаскиваю [cell]")
	cell = null
	tool.play_tool_sound(src, 50)
	update_power()
	return TRUE

/obj/item/defibrillator/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		toggle_paddles()
	else if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, span_warning("[capitalize(src.name)] уже имеет батарейку!"))
		else
			if(C.maxcharge < paddles.revivecost)
				to_chat(user, span_notice("[capitalize(src.name)] требует батарейку большей ёмкости."))
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, span_notice("Устанавливаю батарейку в [src]."))
			update_power()
	else
		return ..()

/obj/item/defibrillator/emag_act(mob/user, obj/item/card/emag/emag_card)

	safety = !safety

	var/enabled_or_disabled = (safety ? "включены" : "выключены")
	balloon_alert(user, "протоколы безопасности [enabled_or_disabled]")

	return TRUE

/obj/item/defibrillator/emp_act(severity)
	. = ..()
	if(cell && !(. & EMP_PROTECT_CONTENTS))
		deductcharge(1000 / severity)
	if (. & EMP_PROTECT_SELF)
		return

	update_power()

/obj/item/defibrillator/proc/toggle_paddles()
	set name = "Достать электроды"
	set category = "Объект"
	on = !on

	var/mob/living/carbon/user = usr
	if(on)
		//Detach the paddles into the user's hands
		if(!usr.put_in_hands(paddles))
			on = FALSE
			to_chat(user, span_warning("Нужна свободная рука чтобы держать электроды!"))
			update_power()
			return
	else
		//Remove from their hands and back onto the defib unit
		remove_paddles(user)

	update_power()
	update_item_action_buttons()


/obj/item/defibrillator/equipped(mob/user, slot)
	..()
	if(!(slot_flags & slot))
		remove_paddles(user)
		update_power()

/obj/item/defibrillator/item_action_slot_check(slot, mob/user)
	if(slot_flags & slot)
		return TRUE

/obj/item/defibrillator/proc/remove_paddles(mob/user) //this fox the bug with the paddles when other player stole you the defib when you have the paddles equiped
	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		M.dropItemToGround(paddles, TRUE)
	return

/obj/item/defibrillator/Destroy()
	if(on)
		var/M = get(paddles, /mob)
		remove_paddles(M)
	QDEL_NULL(paddles)
	QDEL_NULL(cell)
	return ..()

/obj/item/defibrillator/proc/deductcharge(chrgdeductamt)
	if(cell)
		if(cell.charge < (paddles.revivecost+chrgdeductamt))
			powered = FALSE
			update_power()
		if(cell.use(chrgdeductamt))
			update_power()
			return TRUE
		else
			return FALSE

/obj/item/defibrillator/proc/cooldowncheck()
		addtimer(CALLBACK(src, PROC_REF(finish_charging)), cooldown_duration)

/obj/item/defibrillator/proc/finish_charging()
	if(cell)
		if(cell.charge >= paddles.revivecost)
			visible_message(span_notice("[capitalize(src.name)] пищит: Конденсатор заряжен."))
			playsound(src, 'sound/machines/defib_ready.ogg', 50, FALSE)
		else
			visible_message(span_notice("[capitalize(src.name)] пищит: Недостаточно энергии."))
			playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
	paddles.cooldown = FALSE
	paddles.update_appearance()
	update_power()

/obj/item/defibrillator/proc/on_defib_success(obj/item/shockpaddles/source)
	deductcharge(source.revivecost)
	source.cooldown = TRUE
	cooldowncheck()
	return COMPONENT_DEFIB_STOP

/obj/item/defibrillator/compact
	name = "компактный дефибриллятор"
	desc = "Более компактная и продвинутая версия дефибриллятора. Можно носить на поясе."
	icon_state = "defibcompact"
	inhand_icon_state = null
	worn_icon_state = "defibcompact"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	paddle_state = "defibcompact-paddles"
	powered_state = "defibcompact-powered"
	charge_state = "defibcompact-charge"
	nocell_state = "defibcompact-nocell"
	emagged_state = "defibcompact-emagged"

/obj/item/defibrillator/compact/item_action_slot_check(slot, mob/user)
	if(slot & user.getBeltSlot())
		return TRUE

/obj/item/defibrillator/compact/loaded/Initialize(mapload)
	. = ..()
	cell = new(src)
	update_power()

/obj/item/defibrillator/compact/combat
	name = "боевой дефибриллятор"
	desc = "Военный образец дефибриллятора. Его мощные конденсаторы позволяют реанимировать пациента через одежду, а так же он может быть использован в бою в обезоруживающей или агрессивной манере."
	icon_state = "defibcombat" //needs defib inhand sprites
	inhand_icon_state = null
	worn_icon_state = "defibcombat"
	combat = TRUE
	safety = FALSE
	cooldown_duration = 2.5 SECONDS
	paddle_type = /obj/item/shockpaddles/syndicate
	paddle_state = "defibcombat-paddles"
	powered_state = null
	emagged_state = null

/obj/item/defibrillator/compact/combat/loaded
	cell_removable = FALSE // Don't let people just have an infinite power cell

/obj/item/defibrillator/compact/combat/loaded/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/cell/infinite(src)
	update_power()

/obj/item/defibrillator/compact/combat/loaded/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		toggle_paddles()
		return

/obj/item/defibrillator/compact/combat/loaded/nanotrasen
	name = "элитный дефибриллятор Nanotrasen"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	icon_state = "defibnt" //needs defib inhand sprites
	inhand_icon_state = null
	worn_icon_state = "defibnt"
	paddle_type = /obj/item/shockpaddles/syndicate/nanotrasen
	paddle_state = "defibnt-paddles"

//paddles

/obj/item/shockpaddles
	name = "электроды дефибриллятора"
	desc = "Пара токопроводящих электродов."
	icon = 'icons/obj/medical/defib.dmi'
	icon_state = "defibpaddles0"
	inhand_icon_state = "defibpaddles0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	force = 0
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE
	base_icon_state = "defibpaddles"

	var/revivecost = 1000
	var/cooldown = FALSE
	var/busy = FALSE
	var/obj/item/defibrillator/defib
	var/req_defib = TRUE // Whether or not the paddles require a defibrilator object
	var/recharge_time = 6 SECONDS // Only applies to defibs that do not require a defibrilator. See: do_success()
	var/combat = FALSE //If it penetrates armor and gives additional functionality

/obj/item/shockpaddles/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_BACK)
	AddComponent(/datum/component/two_handed, force_unwielded=8, force_wielded=12)

/obj/item/shockpaddles/Destroy()
	defib = null
	return ..()

/obj/item/shockpaddles/equipped(mob/user, slot)
	. = ..()
	if(!req_defib)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_range))

/obj/item/shockpaddles/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	check_range()

/obj/item/shockpaddles/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if((req_defib && defib) && loc != defib)
		defib.fire_act(exposed_temperature, exposed_volume)

/obj/item/shockpaddles/proc/check_range()
	SIGNAL_HANDLER

	if(!req_defib || !defib)
		return
	if(!in_range(src,defib))
		if(isliving(loc))
			var/mob/living/user = loc
			to_chat(user, span_warning("Электроды [defib] перетянуты и вылетают из рук!"))
		else
			visible_message(span_notice("[capitalize(src.name)] возвращаются обратно в [defib]."))
		snap_back()

/obj/item/shockpaddles/proc/recharge(time = 0)
	if(req_defib)
		return
	cooldown = TRUE
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(finish_recharge)), time)

/obj/item/shockpaddles/proc/finish_recharge()
	var/turf/current_turf = get_turf(src)
	current_turf.audible_message(span_notice("[capitalize(src.name)] пищит: Конденсатор заряжен."))
	playsound(src, 'sound/machines/defib_ready.ogg', 50, FALSE)
	cooldown = FALSE
	update_appearance()

/obj/item/shockpaddles/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_STORAGE_INSERT, TRAIT_GENERIC) //stops shockpaddles from being inserted in BoH
	if(!req_defib)
		return //If it doesn't need a defib, just say it exists
	if (!loc || !istype(loc, /obj/item/defibrillator)) //To avoid weird issues from admin spawns
		return INITIALIZE_HINT_QDEL
	defib = loc
	busy = FALSE
	update_appearance()

/obj/item/shockpaddles/suicide_act(mob/living/user)
	user.visible_message(span_danger("[user] прикладывает активные электроды себе на грудь! Похоже [user.p_theyre()] пытается покончить с собой!"))
	if(req_defib)
		defib.deductcharge(revivecost)
	playsound(src, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
	return OXYLOSS

/obj/item/shockpaddles/update_icon_state()
	icon_state = "[base_icon_state][HAS_TRAIT(src, TRAIT_WIELDED)]"
	inhand_icon_state = icon_state
	if(cooldown)
		icon_state = "[base_icon_state][HAS_TRAIT(src, TRAIT_WIELDED)]_cooldown"
	return ..()

/obj/item/shockpaddles/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(req_defib)
		if(user)
			to_chat(user, span_notice("Электроды возвращаются обратно в дефибриллятор."))
		snap_back()

/obj/item/shockpaddles/proc/snap_back()
	if(!defib)
		return
	defib.on = FALSE
	forceMove(defib)
	defib.update_power()

/obj/item/shockpaddles/attack(mob/M, mob/living/user, params)
	if(busy)
		return
	defib?.update_power()
	if(req_defib && !defib.powered)
		user.visible_message(span_notice("[defib] пищит: Устройство обесточено."))
		playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
		return
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		if(iscyborg(user))
			to_chat(user, span_warning("Требуется активация модуля дефибриллятора для работы электродов!"))
		else
			to_chat(user, span_warning("Необходимо взять электроды в обе руки для использования!"))
		return
	if(cooldown)
		if(req_defib)
			to_chat(user, span_warning("[defib] перезаряжается!"))
		else
			to_chat(user, span_warning("[capitalize(src.name)] перезаряжается!"))
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		do_disarm(M, user)
		return

	if(!iscarbon(M))
		if(req_defib)
			to_chat(user, span_warning("Приложенные инструкции не поясняют как работать... с этим..."))
		else
			to_chat(user, span_warning("Понятия не имею как можно это реанимировать..."))
		return
	var/mob/living/carbon/H = M

	if(user.zone_selected != BODY_ZONE_CHEST)
		to_chat(user, span_warning("Нужно нацелиться на грудь пациента!"))
		return

	if(user.combat_mode)
		do_harm(H, user)
		return

	if(H.can_defib() == DEFIB_POSSIBLE)
		H.notify_ghost_cloning("Кто-то пытается меня откачать!")
		H.grab_ghost() // Shove them back in their body.

	do_help(H, user)

/// Called whenever the paddles successfuly shock something
/obj/item/shockpaddles/proc/do_success()
	if(busy)
		busy = FALSE

	update_appearance()
	if(SEND_SIGNAL(src, COMSIG_DEFIBRILLATOR_SUCCESS) & COMPONENT_DEFIB_STOP)
		return
	recharge(recharge_time)

/// Called whenever the paddles fail to shock something after a do_x proc
/obj/item/shockpaddles/proc/do_cancel()
	if(busy)
		busy = FALSE

	update_appearance()

/obj/item/shockpaddles/proc/shock_pulling(dmg, mob/H)
	if(isliving(H.pulledby)) //CLEAR!
		var/mob/living/M = H.pulledby
		if(M.electrocute_act(dmg, H))
			M.visible_message(span_danger("[M] получает удар током при контакте с [H]"))
			M.emote("scream")

/obj/item/shockpaddles/proc/do_disarm(mob/living/M, mob/living/user)
	if(!DEFIB_CAN_HURT(src))
		return
	busy = TRUE
	M.visible_message(span_danger("[user] касается [M] [src]!") , \
			span_userdanger("[user] касается [M] [src]!"))
	M.adjustStaminaLoss(60)
	M.Knockdown(75)
	M.set_jitter_if_lower(100 SECONDS)
	M.apply_status_effect(/datum/status_effect/convulsing)
	playsound(src,  'sound/machines/defib_zap.ogg', 50, TRUE, -1)
	if(HAS_TRAIT(M,MOB_ORGANIC))
		M.emote("gasp")
	log_combat(user, M, "zapped", src)
	do_success()

/obj/item/shockpaddles/proc/do_harm(mob/living/carbon/H, mob/living/user)
	if(!DEFIB_CAN_HURT(src))
		return
	user.visible_message(span_warning("[user] начинает устанавливать [src] на грудь [H].") ,
		span_warning("Перегружаю электроды и устанавливаю на грудь [H]..."))
	busy = TRUE
	update_appearance()
	if(do_after(user, 1.5 SECONDS, H, extra_checks = CALLBACK(src, PROC_REF(is_wielded))))
		user.visible_message(span_notice("[user] устанавливает [src] на грудь [H].") ,
			span_warning("Устанавливаю [src] на грудь [H] и начинаю зарядку."))
		var/turf/T = get_turf(defib)
		playsound(src, 'sound/machines/defib_charge.ogg', 50, FALSE)
		if(req_defib)
			T.audible_message(span_warning("<b>[capitalize(defib)]</b> издаёт громкий звуковой сигнал и начинает сильно гудеть..."))
		else
			user.audible_message(span_warning("[capitalize(src.name)] издаёт громкий звуковой сигнал."))
		if(do_after(user, 1.5 SECONDS, H, extra_checks = CALLBACK(src, PROC_REF(is_wielded)))) //Takes longer due to overcharging
			if(!H)
				do_cancel()
				return
			if(H && H.stat == DEAD)
				to_chat(user, span_warning("[H] мёртв."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
				do_cancel()
				return
			user.visible_message(span_boldannounce("<i>[user] ударяет током [H] используя <b>[src.name]</b>!") , span_warning("Ударяю током [H] используя <b>[src.name]</b>!"))
			playsound(src, 'sound/machines/defib_zap.ogg', 100, TRUE, -1)
			playsound(src, 'sound/weapons/egloves.ogg', 100, TRUE, -1)
			H.emote("scream")
			shock_pulling(45, H)
			if(H.can_heartattack() && !H.undergoing_cardiac_arrest())
				if(!H.stat)
					H.visible_message(span_warning("[H] изгибается в дугу, хватаясь [H.ru_ego()] грудь!") ,
						span_userdanger("Чувствую ужасно сильную боль у себя в груди!"))
				H.set_heartattack(TRUE)
			H.apply_damage(50, BURN, BODY_ZONE_CHEST)
			log_combat(user, H, "overloaded the heart of", defib)
			H.Paralyze(100)
			H.set_jitter_if_lower(200 SECONDS)
			do_success()
			return
	do_cancel()

/obj/item/shockpaddles/proc/do_help(mob/living/carbon/H, mob/living/user)
	user.visible_message(span_warning("[user] устанавливает [src] на грудь [H].") , span_warning("Начинаю устанавливать [src] на грудь [H]..."))
	busy = TRUE
	update_appearance()
	if(do_after(user, 3 SECONDS, H, extra_checks = CALLBACK(src, PROC_REF(is_wielded)))) //beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
		user.visible_message(span_notice("[user] устанавливает [src] на грудь [H].") , span_warning("Устанавливаю [src] на грудь [H]."))
		playsound(src, 'sound/machines/defib_charge.ogg', 75, FALSE)
		var/obj/item/organ/internal/heart = H.get_organ_by_type(/obj/item/organ/internal/heart)
		if(do_after(user, 2 SECONDS, H, extra_checks = CALLBACK(src, PROC_REF(is_wielded)))) //placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
			if((!combat && !req_defib) || (req_defib && !defib.combat))
				for(var/obj/item/clothing/C in H.get_equipped_items())
					if((C.body_parts_covered & CHEST) && (C.clothing_flags & THICKMATERIAL)) //check to see if something is obscuring their chest.
						user.audible_message(span_warning("[req_defib ? "[defib]" : "[src]"] buzzes: Patient's chest is obscured. Operation aborted."))
						playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
						do_cancel()
						return
			if(SEND_SIGNAL(H, COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP, user, src) & COMPONENT_DEFIB_STOP)
				do_cancel()
				return
			if(H.stat == DEAD)
				H.visible_message(span_warning("[H] недолго бьется в конвульсиях."))
				playsound(src, SFX_BODYFALL, 50, TRUE)
				playsound(src, 'sound/machines/defib_zap.ogg', 75, TRUE, -1)
				shock_pulling(30, H)

				var/defib_result = H.can_defib()
				var/fail_reason

				switch (defib_result)
					if (DEFIB_FAIL_SUICIDE)
						fail_reason = "Восстановление пациента невозможно. Дальнейшие попытки будут безрезультативны."
					if (DEFIB_FAIL_NO_HEART)
						fail_reason = "Сердце пациента отсутствует."
					if (DEFIB_FAIL_FAILING_HEART)
						fail_reason = "Сердце пациента слишком сильно повреждено. Требуется замена или хирургическое вмешательство."
					if (DEFIB_FAIL_TISSUE_DAMAGE)
						fail_reason = "Ткани пациента слишком сильно повреждены. Требуется хирургическое вмешательство."
					if (DEFIB_FAIL_HUSK)
						fail_reason = "Тело пациента хаскировано. Требуется регенерация всех тканей."
					if (DEFIB_FAIL_FAILING_BRAIN)
						fail_reason = "Мозг пациента слишком сильно поврежден. Требуется хирургическое вмешательство."
					if (DEFIB_FAIL_NO_INTELLIGENCE)
						fail_reason = "Не обнаружены признаки разума. Дальнейшие попытки будут безрезультативны."
					if (DEFIB_FAIL_NO_BRAIN)
						fail_reason = "Мозг пациента отсутсвует. Дальнейшие попытки будут безрезультативны."
					if (DEFIB_FAIL_BLACKLISTED)
						fail_reason = "Пациент внесён в черный список. Дальнейшие попытки будут безрезультативны."

				if(fail_reason)
					user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Реанимация провалена - [fail_reason]"))
					playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
				else
					var/total_brute = H.getBruteLoss()
					var/total_burn = H.getFireLoss()

					var/need_mob_update = FALSE
					//If the body has been fixed so that they would not be in crit when defibbed, give them oxyloss to put them back into crit
					if (H.health > HALFWAYCRITDEATH)
						need_mob_update += H.adjustOxyLoss(H.health - HALFWAYCRITDEATH, updating_health = FALSE)
					else
						var/overall_damage = total_brute + total_burn + H.getToxLoss() + H.getOxyLoss()
						var/mobhealth = H.health
						need_mob_update += H.adjustOxyLoss((mobhealth - HALFWAYCRITDEATH) * (H.getOxyLoss() / overall_damage), updating_health = FALSE)
						need_mob_update += H.adjustToxLoss((mobhealth - HALFWAYCRITDEATH) * (H.getToxLoss() / overall_damage), updating_health = FALSE, forced = TRUE) // force tox heal for toxin lovers too
						need_mob_update += H.adjustFireLoss((mobhealth - HALFWAYCRITDEATH) * (total_burn / overall_damage), updating_health = FALSE)
						need_mob_update += H.adjustBruteLoss((mobhealth - HALFWAYCRITDEATH) * (total_brute / overall_damage), updating_health = FALSE)
					if(need_mob_update)
						H.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
					user.visible_message(span_notice("[req_defib ? "[defib]" : "[src]"] pings: Resuscitation successful."))
					playsound(src, 'sound/machines/defib_success.ogg', 50, FALSE)
					H.set_heartattack(FALSE)
					if(defib_result == DEFIB_POSSIBLE)
						H.grab_ghost()
					H.revive()
					H.emote("gasp")
					H.set_jitter_if_lower(200 SECONDS)
					SEND_SIGNAL(H, COMSIG_LIVING_MINOR_SHOCK)
					if(HAS_MIND_TRAIT(user, TRAIT_MORBID))
						user.add_mood_event("morbid_saved_life", /datum/mood_event/morbid_saved_life)
					else
						user.add_mood_event("saved_life", /datum/mood_event/saved_life)
					log_combat(user, H, "revived", defib)
				do_success()
				return
			else if (!H.get_organ_by_type(/obj/item/organ/internal/heart))
				user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] buzzes: Patient's heart is missing. Operation aborted."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
			else if(H.undergoing_cardiac_arrest())
				playsound(src, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
				if(!(heart.organ_flags & ORGAN_FAILING))
					H.set_heartattack(FALSE)
					user.visible_message(span_notice("[req_defib ? "[defib]" : "[src]"] pings: Patient's heart is now beating again."))
				else
					user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] buzzes: Resuscitation failed, heart damage detected."))

			else
				user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] buzzes: Patient is not in a valid state. Operation aborted."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
	do_cancel()

/obj/item/shockpaddles/proc/is_wielded()
	return HAS_TRAIT(src, TRAIT_WIELDED)

/obj/item/shockpaddles/cyborg
	name = "кибернетические электроды дефибриллятора"
	icon = 'icons/obj/medical/defib.dmi'
	icon_state = "defibpaddles0"
	inhand_icon_state = "defibpaddles0"
	req_defib = FALSE

/obj/item/shockpaddles/cyborg/attack(mob/M, mob/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(R.emagged)
			combat = TRUE
		else
			combat = FALSE
	else
		combat = FALSE

	. = ..()

/obj/item/shockpaddles/syndicate
	name = "электроды дефибриллятора Синдиката"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	combat = TRUE
	icon = 'icons/obj/medical/defib.dmi'
	icon_state = "syndiepaddles0"
	inhand_icon_state = "syndiepaddles0"
	base_icon_state = "syndiepaddles"

/obj/item/shockpaddles/syndicate/nanotrasen
	name = "электроды элитного дефибриллятора НаноТрейзен"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	icon_state = "ntpaddles0"
	inhand_icon_state = "ntpaddles0"
	base_icon_state = "ntpaddles"

/obj/item/shockpaddles/syndicate/cyborg
	req_defib = FALSE

#undef HALFWAYCRITDEATH
#undef DEFIB_CAN_HURT
