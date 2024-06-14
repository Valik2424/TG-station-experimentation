/obj/item/implantpad
	name = "имплантер"
	desc = "Используется для модификации имплантов."
	icon = 'icons/obj/device.dmi'
	icon_state = "implantpad-0"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/implantcase/case = null

/obj/item/implantpad/update_icon_state()
	icon_state = "implantpad-[!QDELETED(case)]"
	return ..()

/obj/item/implantpad/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "<hr>Внутри [case ? "[case.name]" : "пусто"]."
		if(case)
			. += span_info("Alt-клик для изъятия [case].")
	else
		if(case)
			. += span_warning("Он что-то имеет внутри, нужно подойти поближе, чтобы рассмотреть...")

/obj/item/implantpad/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == case)
		case = null
		update_appearance()
		updateSelfDialog()

/obj/item/implantpad/AltClick(mob/user)
	..()
	if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	if(!case)
		to_chat(user, span_warning("Внутри нет имплантов."))
		return

	user.put_in_hands(case)

	add_fingerprint(user)
	case.add_fingerprint(user)

	updateSelfDialog()
	update_appearance()

/obj/item/implantpad/attackby(obj/item/implantcase/C, mob/user, params)
	if(istype(C, /obj/item/implantcase) && !case)
		if(!user.transferItemToLoc(C, src))
			return
		case = C
		updateSelfDialog()
		update_appearance()
	else
		return ..()

/obj/item/implantpad/ui_interact(mob/user)
	if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		user.unset_machine(src)
		user << browse(null, "window=implantpad")
		return

	user.set_machine(src)
	var/dat = "<B>Мини-Компьютер Имплантера:</B><HR>"
	if(case)
		if(case.imp)
			if(istype(case.imp, /obj/item/implant))
				dat += case.imp.get_data()
		else
			dat += "Чехол пуст."
	else
		dat += "Не обнаружено чехла!"
	user << browse(dat, "window=implantpad")
	onclose(user, "implantpad")
