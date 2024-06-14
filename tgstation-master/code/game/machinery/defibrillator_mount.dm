//Holds defibs does NOT recharge them
//You can activate the mount with an empty hand to grab the paddles
//Not being adjacent will cause the paddles to snap back
/obj/machinery/defibrillator_mount
	name = "крепеж для дефибриллятора"
	desc = "Рама для закрепления дефибриллятора на стене."
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	density = FALSE
	use_power = NO_POWER_USE
	power_channel = AREA_USAGE_EQUIP
	req_one_access = list(ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_SECURITY) //used to control clamps
	processing_flags = NONE
/// The mount's defib
	var/obj/item/defibrillator/defib
/// if true, and a defib is loaded, it can't be removed without unlocking the clamps
	var/clamps_locked = FALSE
/// the type of wallframe it 'disassembles' into
	var/wallframe_type = /obj/item/wallframe/defib_mount

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/defibrillator_mount, 28)

/obj/machinery/defibrillator_mount/loaded/Initialize(mapload) //loaded subtype for mapping use
	. = ..()
	defib = new/obj/item/defibrillator/loaded(src)
	find_and_hang_on_wall()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/defibrillator_mount, 28)

/obj/machinery/defibrillator_mount/Destroy()
	QDEL_NULL(defib)
	return ..()

/obj/machinery/defibrillator_mount/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == defib)
		// Make sure processing ends before the defib is nulled
		end_processing()
		defib = null
		update_appearance()

/obj/machinery/defibrillator_mount/examine(mob/user)
	. = ..()
	if(defib)
		. += span_notice("Тут зафиксирован дефибриллятор. Alt-клик чтоб открепить.")
		if(SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED)
			. += span_notice("В связи с Красным кодом фиксаторы могут быть разблокированы картой с любым уровнем доступа.")
		else
			. += span_notice("Фиксаторы могут быть [clamps_locked ? "разблокированы" : "заблокированы"], картой с требуемым доступом.")

/obj/machinery/defibrillator_mount/update_overlays()
	. = ..()

	if(!defib)
		return

	. += "defib"

	if(defib.powered)
		var/obj/item/stock_parts/cell/C = get_cell()
		. += (defib.safety ? "online" : "emagged")
		var/ratio = C.charge / C.maxcharge
		ratio = CEILING(ratio * 4, 1) * 25
		. += "charge[ratio]"

	if(clamps_locked)
		. += "clamps"

/obj/machinery/defibrillator_mount/get_cell()
	if(defib)
		return defib.get_cell()

//defib interaction
/obj/machinery/defibrillator_mount/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!defib)
		to_chat(user, span_warning("Тут нет дефибриллятора!"))
		return
	if(defib.paddles.loc != defib)
		to_chat(user, span_warning("[defib.paddles.loc == user ? "Уже держу" : "Кто-то уже держит"] электроды [defib]!"))
		return
	if(!in_range(src, user))
		to_chat(user, span_warning("Электроды [defib] перетянуты и вылетают из рук!"))
		return
	user.put_in_hands(defib.paddles)

/obj/machinery/defibrillator_mount/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/defibrillator))
		if(defib)
			to_chat(user, span_warning("[src] уже занят!"))
			return
		var/obj/item/defibrillator/D = I
		if(!D.get_cell())
			to_chat(user, span_warning("Только дефибриллятор с батарейкой может зафиксирован в [src]!"))
			return
		if(HAS_TRAIT(I, TRAIT_NODROP) || !user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I] прилип к моим рукам!"))
			return
		user.visible_message(span_notice("[user] фиксирует [I] в [src]!") , \
		span_notice("Фиксирую [I] в крепление с характерным звуком."))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		// Make sure the defib is set before processing begins.
		defib = I
		begin_processing()
		update_appearance()
		return
	else if(defib && I == defib.paddles)
		defib.paddles.snap_back()
		return
	var/obj/item/card/id = I.GetID()
	if(id)
		if(check_access(id) || SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED) //anyone can toggle the clamps in red alert!
			if(!defib)
				to_chat(user, span_warning("Не могу заблокировать крепления дефибриллятора когда его самого нет."))
				return
			clamps_locked = !clamps_locked
			to_chat(user, span_notice("Крепления [clamps_locked ? "заблокированы" : "разблокированы"]."))
			update_appearance()
		else
			to_chat(user, span_warning("Неавторизированный доступ."))
		return
	..()

/obj/machinery/defibrillator_mount/multitool_act(mob/living/user, obj/item/multitool)
	..()
	if(!defib)
		to_chat(user, span_warning("Нет дефибриллятора!"))
		return TRUE
	if(!clamps_locked)
		to_chat(user, span_warning("[capitalize(src.name)] фиксаторы разблокированы!"))
		return TRUE
	user.visible_message(span_notice("[user] прижимает [multitool] в ID считыватель [src]...") , \
	span_notice("Начинаю перегружать фиксаторы на [src]..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	if(!do_after(user, 100, target = src) || !clamps_locked)
		return
	user.visible_message(span_notice("[user] применяет [multitool], и [src] разблокируется.") , \
	span_notice("Перезагружаю фиксаторы на [src]!"))
	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)
	clamps_locked = FALSE
	update_appearance()
	return TRUE

/obj/machinery/defibrillator_mount/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!wallframe_type)
		return ..()
	if(user.combat_mode)
		return ..()
	if(defib)
		to_chat(user, span_warning("Крепление не может быть демонтировано пока к нему подключен дефибриллятор"))
		..()
		return TRUE
	new wallframe_type(get_turf(src))
	qdel(src)
	tool.play_tool_sound(user)
	to_chat(user, span_notice("Демонтирую [src] со стены."))
	return TRUE

/obj/machinery/defibrillator_mount/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.can_perform_action(src))
		return
	if(!defib)
		to_chat(user, span_warning("Было бы трудно достать дефибриллятор которого нет."))
		return
	if(clamps_locked)
		to_chat(user, span_warning("Пытаюсь вытащить [defib], но фиксаторы надёжно держат его!"))
		return
	if(!user.put_in_hands(defib))
		to_chat(user, span_warning("Для этого нужна свободная рука!"))
		user.visible_message(span_notice("[user] открепляет [defib] из [src] и он выпадает на пол.") , \
		span_notice("Отключаю питание и открепляю [defib] из [src] и он выпадает на пол."))
	else
		user.visible_message(span_notice("[user] unhooks [defib] from [src].") , \
		span_notice("Отключаю питание и открепляю [defib] из [src]."))
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)

/obj/machinery/defibrillator_mount/charging
	name = "крепеж для дефибриллятора PENLITE"
	desc = "Рама для закрепления дефибриллятора на стене. Подключает устройство к станционной энергосети."
	icon_state = "penlite_mount"
	use_power = IDLE_POWER_USE
	wallframe_type = /obj/item/wallframe/defib_mount/charging


/obj/machinery/defibrillator_mount/charging/Initialize(mapload)
	. = ..()
	if(is_operational)
		begin_processing()


/obj/machinery/defibrillator_mount/charging/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()


/obj/machinery/defibrillator_mount/charging/process(seconds_per_tick)
	var/obj/item/stock_parts/cell/C = get_cell()
	if(!C || !is_operational)
		return PROCESS_KILL
	if(C.charge < C.maxcharge)
		use_power(active_power_usage * seconds_per_tick)
		C.give(40 * seconds_per_tick)
		defib.update_power()

//wallframe, for attaching the mounts easily
/obj/item/wallframe/defib_mount
	name = "настенный крепеж для дефибриллятора"
	desc = "Рама для закрепления дефибриллятора на стене"
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	w_class = WEIGHT_CLASS_BULKY
	result_path = /obj/machinery/defibrillator_mount
	pixel_shift = 28

/obj/item/wallframe/defib_mount/charging
	name = "настенный крепеж для дефибриллятора PENLITE"
	desc = "Рама для закрепления дефибриллятора на стене. Подключает устройство к станционной энергосети."
	icon_state = "penlite_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 0.5)
	result_path = /obj/machinery/defibrillator_mount/charging
