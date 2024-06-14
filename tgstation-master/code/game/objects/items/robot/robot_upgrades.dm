// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "модуль улучшения киборга"
	desc = "Защищено FRM."
	icon = 'icons/obj/assemblies/module.dmi'
	icon_state = "cyborg_upgrade"
	w_class = WEIGHT_CLASS_SMALL
	var/locked = FALSE
	var/installed = FALSE
	var/require_model = FALSE
	var/list/model_type = null
	/// Bitflags listing model compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/model_flags = NONE
	// if true, is not stored in the robot to be ejected
	// if model is reset
	var/one_use = FALSE

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R, user = usr)
	if(R.stat == DEAD)
		to_chat(user, span_warning("[capitalize(src.name)] невозможно подключить к деактевированному киборгу!"))
		return FALSE

	return TRUE

/obj/item/borg/upgrade/proc/deactivate(mob/living/silicon/robot/R, user = usr)
	if (!(src in R.upgrades))
		return FALSE
	return TRUE

/obj/item/borg/upgrade/rename
	name = "модуль смены имени"
	desc = "Используется для смены позывного у киборга."
	icon_state = "cyborg_upgrade1"
	var/heldname = ""
	one_use = TRUE

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = sanitize_name(tgui_input_text(user, "Введите новое имя киборга", "Киборг переименован", heldname, MAX_NAME_LEN), allow_numbers = TRUE)
	user.log_message("set \"[heldname]\" as a name in a cyborg reclassification board at [loc_name(user)]", LOG_GAME)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/oldname = R.real_name
		var/oldkeyname = key_name(R)
		R.custom_name = heldname
		R.updatename()
		if(oldname == R.real_name)
			R.notify_ai(AI_NOTIFICATION_CYBORG_RENAMED, oldname, R.real_name)
		usr.log_message("used a cyborg reclassification board to rename [oldkeyname] to [key_name(R)]", LOG_GAME)

/obj/item/borg/upgrade/disablercooler
	name = "радиатор Усмирителя"
	desc = "Устанавливает дополнительные системы охлаждения, тем самым повышая скорострельность."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/security)
	model_flags = BORG_MODEL_SECURITY

/obj/item/borg/upgrade/disablercooler/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.model.modules
		if(!T)
			to_chat(user, span_warning("У этого киборга нет Усмирителя!"))
			return FALSE
		if(T.charge_delay <= 2)
			to_chat(R, span_warning("Радиатор уже установлен!"))
			to_chat(user, span_warning("Радиатор уже установлен!"))
			return FALSE

		T.charge_delay = max(2 , T.charge_delay - 4)

/obj/item/borg/upgrade/disablercooler/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.model.modules
		if(!T)
			return FALSE
		T.charge_delay = initial(T.charge_delay)

/obj/item/borg/upgrade/thrusters
	name = "ионные двигатели"
	desc = "Модернизация которая позволяет перемещатся в безгравитационном пространстве при помощи миниатюрных двигателей. Потребляет энергию при использовании."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/thrusters/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.ionpulse)
			to_chat(user, span_warning("Ионные двигатели уже установлены!"))
			return FALSE

		R.ionpulse = TRUE
		R.toggle_ionpulse() //Enabled by default

/obj/item/borg/upgrade/thrusters/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.ionpulse = FALSE

/obj/item/borg/upgrade/ddrill
	name = "алмазный бур"
	desc = "Заменяет стандартный бур на его продвинутый аналог."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/ddrill/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/pickaxe/drill/cyborg/D in R.model)
			R.model.remove_module(D, TRUE)
		for(var/obj/item/shovel/S in R.model)
			R.model.remove_module(S, TRUE)

		var/obj/item/pickaxe/drill/cyborg/diamond/DD = new /obj/item/pickaxe/drill/cyborg/diamond(R.model)
		R.model.basic_modules += DD
		R.model.add_module(DD, FALSE, TRUE)

/obj/item/borg/upgrade/ddrill/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/pickaxe/drill/cyborg/diamond/DD in R.model)
			R.model.remove_module(DD, TRUE)

		var/obj/item/pickaxe/drill/cyborg/D = new (R.model)
		R.model.basic_modules += D
		R.model.add_module(D, FALSE, TRUE)
		var/obj/item/shovel/S = new (R.model)
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/soh
	name = "безразмерная сумка для руды"
	desc = "Снимает ограничение емкости для Рудной Сумки."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/soh/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/ore/cyborg/S in R.model)
			R.model.remove_module(S, TRUE)

		var/obj/item/storage/bag/ore/holding/H = new /obj/item/storage/bag/ore/holding(R.model)
		R.model.basic_modules += H
		R.model.add_module(H, FALSE, TRUE)

/obj/item/borg/upgrade/soh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/bag/ore/holding/H in R.model)
			R.model.remove_module(H, TRUE)

		var/obj/item/storage/bag/ore/cyborg/S = new (R.model)
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/tboh
	name = "безразмерный мешок для мусора"
	desc = "Снимает ограничение емкости для Мусорного Мешка."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/janitor)
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/tboh/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/cyborg/TB in R.model.modules)
			R.model.remove_module(TB, TRUE)

		var/obj/item/storage/bag/trash/bluespace/cyborg/B = new /obj/item/storage/bag/trash/bluespace/cyborg(R.model)
		R.model.basic_modules += B
		R.model.add_module(B, FALSE, TRUE)

/obj/item/borg/upgrade/tboh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/bluespace/cyborg/B in R.model.modules)
			R.model.remove_module(B, TRUE)

		var/obj/item/storage/bag/trash/cyborg/TB = new (R.model)
		R.model.basic_modules += TB
		R.model.add_module(TB, FALSE, TRUE)

/obj/item/borg/upgrade/amop
	name = "экспериментальная швабра"
	desc = "Заменяет швабру на продвинутую, при активации та начинает со временем собирать влагу из воздуха."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/janitor)
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/amop/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/mop/cyborg/M in R.model.modules)
			R.model.remove_module(M, TRUE)

		var/obj/item/mop/advanced/cyborg/mop = new /obj/item/mop/advanced/cyborg(R.model)
		R.model.basic_modules += mop
		R.model.add_module(mop, FALSE, TRUE)

/obj/item/borg/upgrade/amop/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/mop/advanced/cyborg/A in R.model.modules)
			R.model.remove_module(A, TRUE)

		var/obj/item/mop/cyborg/M = new (R.model)
		R.model.basic_modules += M
		R.model.add_module(M, FALSE, TRUE)

/obj/item/borg/upgrade/prt
	name = "инструмент для ремонта плитки"
	desc = "Позволяет ремонтировать поврежденный пол под собой."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/janitor)
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/prt/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		var/obj/item/cautery/prt/P = new (R.model)
		R.model.basic_modules += P
		R.model.add_module(P, FALSE, TRUE)

/obj/item/borg/upgrade/prt/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/cautery/prt/P in R.model.modules)
			R.model.remove_module(P, TRUE)

/obj/item/borg/upgrade/syndicate
	name = "модуль нелегальной модернизации"
	desc = "Разблокирует Киборгу нелегальные модернизации, это действие не меняет его Законы, но может нарушить работу других устройств (не обязательно)."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.emagged)
			return FALSE

		R.SetEmagged(TRUE)
		R.logevent("ВНИМАНИЕ: у модуля отсутствует сертификат безопасности!") //A bit of fluff to hint it was an illegal tech item
		R.logevent("ВНИМАНИЕ: получен доступ администратора для псевдо ИИ № [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error

		return TRUE

/obj/item/borg/upgrade/syndicate/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.SetEmagged(FALSE)

/obj/item/borg/upgrade/lavaproof
	name = "лава-стойкие траки"
	desc = "Дает возможность перемещаться по лаве."
	icon_state = "ash_plating"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/lavaproof/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.add_traits(list(TRAIT_LAVA_IMMUNE, TRAIT_SNOWSTORM_IMMUNE), type)

/obj/item/borg/upgrade/lavaproof/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.remove_traits(list(TRAIT_LAVA_IMMUNE, TRAIT_SNOWSTORM_IMMUNE), type)

/obj/item/borg/upgrade/selfrepair
	name = "модуль саморемонта"
	desc = "Позволяет медленно восстанавливать текущую прочность за счет энергии."
	icon_state = "cyborg_upgrade5"
	require_model = TRUE
	var/repair_amount = -1
	/// world.time of next repair
	var/next_repair = 0
	/// Minimum time between repairs in seconds
	var/repair_cooldown = 4
	var/on = FALSE
	var/powercost = 10
	var/datum/action/toggle_action

/obj/item/borg/upgrade/selfrepair/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/selfrepair/U = locate() in R
		if(U)
			to_chat(user, span_warning("Киборг уже оснащен системой саморемонта!"))
			return FALSE

		icon_state = "selfrepair_off"
		toggle_action = new /datum/action/item_action/toggle(src)
		toggle_action.Grant(R)

/obj/item/borg/upgrade/selfrepair/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		toggle_action.Remove(R)
		QDEL_NULL(toggle_action)
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/ui_action_click()
	if(on)
		to_chat(toggle_action.owner, span_notice("Протокол саморемонта деактивирован."))
		deactivate_sr()
	else
		to_chat(toggle_action.owner, span_notice("Протокол саморемонта активирован."))
		activate_sr()


/obj/item/borg/upgrade/selfrepair/update_icon_state()
	if(toggle_action)
		icon_state = "selfrepair_[on ? "on" : "off"]"
	else
		icon_state = "cyborg_upgrade5"
	return ..()

/obj/item/borg/upgrade/selfrepair/proc/activate_sr()
	START_PROCESSING(SSobj, src)
	on = TRUE
	update_appearance()

/obj/item/borg/upgrade/selfrepair/proc/deactivate_sr()
	STOP_PROCESSING(SSobj, src)
	on = FALSE
	update_appearance()

/obj/item/borg/upgrade/selfrepair/process()
	if(world.time < next_repair)
		return

	var/mob/living/silicon/robot/cyborg = toggle_action.owner

	if(istype(cyborg) && (cyborg.stat != DEAD) && on)
		if(!cyborg.cell)
			to_chat(cyborg, span_alert("Протокол саморемонта деактивирован. Вставьте батарею."))
			deactivate_sr()
			return

		if(cyborg.cell.charge < powercost * 2)
			to_chat(cyborg, span_alert("Протокол саморемонта деактивирован. Низкий уровень заряда."))
			deactivate_sr()
			return

		if(cyborg.health < cyborg.maxHealth)
			if(cyborg.health < 0)
				repair_amount = -2.5
				powercost = 30
			else
				repair_amount = -1
				powercost = 10
			cyborg.adjustBruteLoss(repair_amount)
			cyborg.adjustFireLoss(repair_amount)
			cyborg.updatehealth()
			cyborg.cell.use(powercost)
		else
			cyborg.cell.use(5)
		next_repair = world.time + repair_cooldown * 10 // Multiply by 10 since world.time is in deciseconds

		if(TIMER_COOLDOWN_FINISHED(src, COOLDOWN_BORG_SELF_REPAIR))
			TIMER_COOLDOWN_START(src, COOLDOWN_BORG_SELF_REPAIR, 200 SECONDS)
			var/msgmode = "standby"
			if(cyborg.health < 0)
				msgmode = "critical"
			else if(cyborg.health < cyborg.maxHealth)
				msgmode = "normal"
			to_chat(cyborg, span_notice("Self-repair is active in [span_boldnotice("[msgmode]")] mode."))
	else
		deactivate_sr()

/obj/item/borg/upgrade/hypospray
	name = "медицинский гипоспрей"
	desc = "Позволяет синтезировать химические соединения за счет энергии."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL
	var/list/additional_reagents = list()

/obj/item/borg/upgrade/hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.model.modules)
			H.upgrade_hypo()

/obj/item/borg/upgrade/hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.model.modules)
			H.remove_hypo_upgrade()

/obj/item/borg/upgrade/hypospray/expanded
	name = "расширенный медицинский гипоспрей"
	desc = "Значительно увеличивает диапазон синтезируемых медикаментов."

/obj/item/borg/upgrade/piercing_hypospray
	name = "пробивающий гипоспрей"
	desc = "Позволяет колоть химикаты из Гипоспрея сквозь РИГи или другие прочные материалы. Так же поддерживает другие модели киборгов."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/piercing_hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/found_hypo = FALSE
		for(var/obj/item/reagent_containers/borghypo/H in R.model.modules)
			H.bypass_protection = TRUE
			found_hypo = TRUE

		if(!found_hypo)
			return FALSE

/obj/item/borg/upgrade/piercing_hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/H in R.model.modules)
			H.bypass_protection = initial(H.bypass_protection)

/obj/item/borg/upgrade/defib
	name = "дефибриллятор"
	desc = "Позволяет реанимировать людей."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/defib/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/defib/backpack/BP = locate() in R //If a full defib unit was used to upgrade prior, we can just pop it out now and replace
		if(BP)
			BP.deactivate(R, user)
			to_chat(user, span_notice("Вы демонтируете дефибриллятор для замены на более компактную версию."))
		var/obj/item/shockpaddles/cyborg/S = new(R.model)
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/defib/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/shockpaddles/cyborg/S = locate() in R.model
		R.model.remove_module(S, TRUE)

///A version of the above that also acts as a holder of an actual defibrillator item used in place of the upgrade chip.
/obj/item/borg/upgrade/defib/backpack
	var/obj/item/defibrillator/defib_instance

/obj/item/borg/upgrade/defib/backpack/Initialize(mapload, obj/item/defibrillator/D)
	. = ..()
	if(!D)
		D = new /obj/item/defibrillator
	defib_instance = D
	name = defib_instance.name
	defib_instance.moveToNullspace()
	RegisterSignals(defib_instance, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(on_defib_instance_qdel_or_moved))

/obj/item/borg/upgrade/defib/backpack/proc/on_defib_instance_qdel_or_moved(obj/item/defibrillator/D)
	SIGNAL_HANDLER
	defib_instance = null
	if(!QDELETED(src))
		qdel(src)

/obj/item/borg/upgrade/defib/backpack/Destroy()
	if(!QDELETED(defib_instance))
		QDEL_NULL(defib_instance)
	return ..()

/obj/item/borg/upgrade/defib/backpack/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		defib_instance?.forceMove(R.drop_location()) // [on_defib_instance_qdel_or_moved()] handles the rest.

/obj/item/borg/upgrade/processor
	name = "хирургический процессор"
	desc = "После синхронизации с Операционный Компьютером позволяет проводить все операции которые были загружены в него"
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical, /obj/item/robot_model/syndicate_medical)
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/processor/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/surgical_processor/SP = new(R.model)
		R.model.basic_modules += SP
		R.model.add_module(SP, FALSE, TRUE)

/obj/item/borg/upgrade/processor/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/surgical_processor/SP = locate() in R.model
		R.model.remove_module(SP, TRUE)

/obj/item/borg/upgrade/ai
	name = "модуль Б.О.Р.И.С."
	desc = "Подключает модуль удаленного управления для ИИ. Занимает слот Позитронного Мозга и MMI. Киборг становится оболочкой ИИ с открытым каналом связи."
	icon_state = "boris"

/obj/item/borg/upgrade/ai/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(locate(/obj/item/borg/upgrade/ai) in R.upgrades)
			to_chat(user, span_warning("Данный киборг уже является оболочкой ИИ!"))
			return FALSE
		if(R.key) //You cannot replace a player unless the key is completely removed.
			to_chat(user, span_warning("Зарегестрирован интеллект класса [R.braintype]. Отмена операции."))
			return FALSE

		R.make_shell(src)

/obj/item/borg/upgrade/ai/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		if(R.shell)
			R.undeploy()
			R.notify_ai(AI_NOTIFICATION_AI_SHELL)

/obj/item/borg/upgrade/expand
	name = "модуль расширения"
	desc = "Визуально увеличивает Киборга."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/expand/action(mob/living/silicon/robot/robot, user = usr)
	. = ..()
	if(!. || HAS_TRAIT(robot, TRAIT_NO_TRANSFORM))
		return FALSE

	if(robot.hasExpanded)
		to_chat(usr, span_warning("Этот киборг уже оснащен модулем расширения!"))
		return FALSE

	ADD_TRAIT(robot, TRAIT_NO_TRANSFORM, REF(src))
	var/prev_lockcharge = robot.lockcharge
	robot.SetLockdown(TRUE)
	robot.set_anchored(TRUE)
	var/datum/effect_system/fluid_spread/smoke/smoke = new
	smoke.set_up(1, holder = robot, location = robot.loc)
	smoke.start()
	sleep(0.2 SECONDS)
	for(var/i in 1 to 4)
		playsound(robot, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, TRUE, -1)
		sleep(1.2 SECONDS)
	if(!prev_lockcharge)
		robot.SetLockdown(FALSE)
	robot.set_anchored(FALSE)
	REMOVE_TRAIT(robot, TRAIT_NO_TRANSFORM, REF(src))
	robot.hasExpanded = TRUE
	robot.update_transform(2)

/obj/item/borg/upgrade/expand/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		if (R.hasExpanded)
			R.hasExpanded = FALSE
			R.update_transform(0.5)

/obj/item/borg/upgrade/rped
	name = "кибернетический РПЕД"
	desc = "позволяет переносить 50 электронных компонентов, а так же устанавливать их в каркас Машины или Консоли."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "borgrped"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/engineering, /obj/item/robot_model/saboteur)
	model_flags = BORG_MODEL_ENGINEERING

/obj/item/borg/upgrade/rped/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R
		if(RPED)
			to_chat(user, span_warning("Этот киборг уже оснащен РПЕД модулем!"))
			return FALSE

		RPED = new(R.model)
		R.model.basic_modules += RPED
		R.model.add_module(RPED, FALSE, TRUE)

/obj/item/borg/upgrade/rped/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R.model
		if (RPED)
			R.model.remove_module(RPED, TRUE)

/obj/item/borg/upgrade/pinpointer
	name = "монитор жизненных показателей экипажа"
	desc = "Позволяет наблюдать данные с датчиков жизнеобеспечения аналогично Консоли наблюдения за Экипажем, а так же добавляет трекер для поиска Экипажа."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinpointer_crew"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical, /obj/item/robot_model/syndicate_medical)
	model_flags = BORG_MODEL_MEDICAL
	var/datum/action/crew_monitor

/obj/item/borg/upgrade/pinpointer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/pinpointer/crew/PP = locate() in R.model
		if(PP)
			to_chat(user, span_warning("Этот киборг уже оснащен монитором экипажа!"))
			return FALSE

		PP = new(R.model)
		R.model.basic_modules += PP
		R.model.add_module(PP, FALSE, TRUE)
		crew_monitor = new /datum/action/item_action/crew_monitor(src)
		crew_monitor.Grant(R)
		icon_state = "scanner"


/obj/item/borg/upgrade/pinpointer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		icon_state = "pinpointer_crew"
		crew_monitor.Remove(R)
		QDEL_NULL(crew_monitor)
		var/obj/item/pinpointer/crew/PP = locate() in R.model
		R.model.remove_module(PP, TRUE)

/obj/item/borg/upgrade/pinpointer/ui_action_click()
	if(..())
		return
	var/mob/living/silicon/robot/Cyborg = usr
	GLOB.crewmonitor.show(Cyborg,Cyborg)

/datum/action/item_action/crew_monitor
	name = "Interface With Crew Monitor"

/obj/item/borg/upgrade/transform
	name = "модуль выбора модели (Базовая)"
	desc = "Позволяет вернуть борга к стандартной модели."
	icon_state = "cyborg_upgrade3"
	var/obj/item/robot_model/new_model = null

/obj/item/borg/upgrade/transform/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(. && new_model)
		R.model.transform_to(new_model)

/obj/item/borg/upgrade/transform/clown
	name = "модуль специализации (Клоун)"
	desc = "Модуль специа@#$# HOONK!"
	icon_state = "cyborg_upgrade3"
	new_model = /obj/item/robot_model/clown

/obj/item/borg/upgrade/circuit_app
	name = "манипулятор плат"
	desc = "Позволяет переносить 1 плату, а так же устанавливать ее в каркас Машины или Консоли."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/engineering, /obj/item/robot_model/saboteur)
	model_flags = BORG_MODEL_ENGINEERING

/obj/item/borg/upgrade/circuit_app/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/apparatus/circuit/C = locate() in R.model.modules
		if(C)
			to_chat(user, span_warning("This unit is already equipped with a circuit apparatus!"))
			return FALSE

		C = new(R.model)
		R.model.basic_modules += C
		R.model.add_module(C, FALSE, TRUE)

/obj/item/borg/upgrade/circuit_app/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/apparatus/circuit/C = locate() in R.model.modules
		if (C)
			R.model.remove_module(C, TRUE)

/obj/item/borg/upgrade/beaker_app
	name = "дополнительный манипулятор хим посуды"
	desc = "Если одного недостаточно."
	icon_state = "cyborg_upgrade3"
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/beaker_app/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/apparatus/beaker/extra/E = locate() in R.model.modules
		if(E)
			to_chat(user, span_warning("Нет места!"))
			return FALSE

		E = new(R.model)
		R.model.basic_modules += E
		R.model.add_module(E, FALSE, TRUE)

/obj/item/borg/upgrade/beaker_app/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/apparatus/beaker/extra/E = locate() in R.model.modules
		if (E)
			R.model.remove_module(E, TRUE)

/obj/item/borg/upgrade/drink_app
	name = "дополнительное хранилище стаканов"
	desc = "Если одного недостаточно."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/drink_app/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/apparatus/beaker/drink/E = locate() in R.model.modules
		if(E)
			to_chat(user, span_warning("Нет места!"))
			return FALSE

		E = new(R.model)
		R.model.basic_modules += E
		R.model.add_module(E, FALSE, TRUE)

/obj/item/borg/upgrade/drink_app/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/apparatus/beaker/drink/E = locate() in R.model.modules
		if (E)
			R.model.remove_module(E, TRUE)

/obj/item/borg/upgrade/broomer
	name = "экспериментальный толкатель"
	desc = "При активации позволяет толкать предметы перед собой в большой куче."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/janitor)
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/broomer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (!.)
		return
	var/obj/item/pushbroom/cyborg/BR = locate() in R.model.modules
	if (BR)
		to_chat(user, span_warning("Этот киборг уже оснащен экспериментальным толкателем!"))
		return FALSE
	BR = new(R.model)
	R.model.basic_modules += BR
	R.model.add_module(BR, FALSE, TRUE)

/obj/item/borg/upgrade/broomer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (!.)
		return
	var/obj/item/pushbroom/cyborg/BR = locate() in R.model.modules
	if (BR)
		R.model.remove_module(BR, TRUE)

/obj/item/borg/upgrade/condiment_synthesizer
	name = "Service Cyborg Condiment Synthesiser"
	desc = "An upgrade to the service model cyborg, allowing it to produce solid condiments."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/condiment_synthesizer/action(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/reagent_containers/borghypo/condiment_synthesizer/cynthesizer = locate() in install.model.modules
	if(cynthesizer)
		install.balloon_alert_to_viewers("already installed!")
		return FALSE
	cynthesizer = new(install.model)
	install.model.basic_modules += cynthesizer
	install.model.add_module(cynthesizer, FALSE, TRUE)

/obj/item/borg/upgrade/condiment_synthesizer/deactivate(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if (!.)
		return FALSE
	var/obj/item/reagent_containers/borghypo/condiment_synthesizer/cynthesizer = locate() in install.model.modules
	if (cynthesizer)
		install.model.remove_module(cynthesizer, TRUE)

/obj/item/borg/upgrade/silicon_knife
	name = "Service Cyborg Kitchen Toolset"
	desc = "An upgrade to the service model cyborg, to help process foods."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/silicon_knife/action(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/knife/kitchen/silicon/snife = locate() in install.model.modules
	if(snife)
		install.balloon_alert_to_viewers("already installed!")
		return FALSE
	snife = new(install.model)
	install.model.basic_modules += snife
	install.model.add_module(snife, FALSE, TRUE)

/obj/item/borg/upgrade/silicon_knife/deactivate(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if (!.)
		return FALSE
	var/obj/item/knife/kitchen/silicon/snife = locate() in install.model.modules
	if (snife)
		install.model.remove_module(snife, TRUE)

/obj/item/borg/upgrade/service_apparatus
	name = "Service Cyborg Service Apparatus"
	desc = "An upgrade to the service model cyborg, to help handle foods and paper."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/service_apparatus/action(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/borg/apparatus/service/saparatus = locate() in install.model.modules
	if(saparatus)
		install.balloon_alert_to_viewers("already installed!")
		return FALSE
	saparatus = new(install.model)
	install.model.basic_modules += saparatus
	install.model.add_module(saparatus, FALSE, TRUE)

/obj/item/borg/upgrade/service_apparatus/deactivate(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if (!.)
		return FALSE
	var/obj/item/borg/apparatus/service/saparatus = locate() in install.model.modules
	if (saparatus)
		install.model.remove_module(saparatus, TRUE)

/obj/item/borg/upgrade/rolling_table
	name = "Service Cyborg Rolling Table Dock"
	desc = "An upgrade to the service model cyborg, to help provide mobile service."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/rolling_table/action(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/rolling_table_dock/rtable = locate() in install.model.modules
	if(rtable)
		install.balloon_alert_to_viewers("already installed!")
		return FALSE
	rtable = new(install.model)
	install.model.basic_modules += rtable
	install.model.add_module(rtable, FALSE, TRUE)

/obj/item/borg/upgrade/rolling_table/deactivate(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if (!.)
		return FALSE
	var/obj/item/rolling_table_dock/rtable = locate() in install.model.modules
	if (rtable)
		install.model.remove_module(rtable, TRUE)

/obj/item/borg/upgrade/service_cookbook
	name = "Service Cyborg Cookbook"
	desc = "An upgrade to the service model cyborg, that lets them create more foods."
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/service)
	model_flags = BORG_MODEL_SERVICE

/obj/item/borg/upgrade/service_cookbook/action(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/borg/cookbook/book = locate() in install.model.modules
	if(book)
		install.balloon_alert_to_viewers("already installed!")
		return FALSE
	book = new(install.model)
	install.model.basic_modules += book
	install.model.add_module(book, FALSE, TRUE)

/obj/item/borg/upgrade/service_cookbook/deactivate(mob/living/silicon/robot/install, user = usr)
	. = ..()
	if (!.)
		return FALSE
	var/obj/item/borg/cookbook/book = locate() in install.model.modules
	if(book)
		install.model.remove_module(book, TRUE)

///This isn't an upgrade or part of the same path, but I'm gonna just stick it here because it's a tool used on cyborgs.
//A reusable tool that can bring borgs back to life. They gotta be repaired first, though.
/obj/item/borg_restart_board
	name = "cyborg emergency reboot module"
	desc = "A reusable firmware reset tool that can force a reboot of a disabled-but-repaired cyborg, bringing it back online."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/assemblies/module.dmi'
	icon_state = "cyborg_upgrade1"

/obj/item/borg_restart_board/pre_attack(mob/living/silicon/robot/borgo, mob/living/user, params)
	if(!istype(borgo))
		return ..()
	if(!borgo.opened)
		to_chat(user, span_warning("You must access the cyborg's internals!"))
		return ..()
	if(borgo.health < 0)
		to_chat(user, span_warning("You have to repair the cyborg before using this module!"))
		return ..()
	if(!(borgo.stat & DEAD))
		to_chat(user, span_warning("This cyborg is already operational!"))
		return ..()

	if(borgo.mind)
		borgo.mind.grab_ghost()
		playsound(loc, 'sound/voice/liveagain.ogg', 75, TRUE)
	else
		playsound(loc, 'sound/machines/ping.ogg', 75, TRUE)

	borgo.revive()
	borgo.logevent("WARN -- System recovered from unexpected shutdown.")
	borgo.logevent("System brought online.")
	return ..()
