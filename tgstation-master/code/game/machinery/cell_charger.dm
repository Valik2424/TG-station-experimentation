/obj/machinery/cell_charger
	name = "зарядник батарей"
	desc = "Заряжает аккумуляторные батареи, не подходит для вооружения."
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "ccharger"
	power_channel = AREA_USAGE_EQUIP
	circuit = /obj/item/circuitboard/machine/cell_charger
	pass_flags = PASSTABLE
	var/obj/item/stock_parts/cell/charging = null
	var/charge_rate = 250

/obj/machinery/cell_charger/update_overlays()
	. = ..()

	if(!charging)
		return

	if(!(machine_stat & (BROKEN|NOPOWER)))
		var/newlevel = round(charging.percent() * 4 / 100)
		. += "ccharger-o[newlevel]"
	. += image(charging.icon, charging.icon_state)
	if(charging.grown_battery)
		. += mutable_appearance('icons/obj/machines/cell_charger.dmi', "grown_wires")
	. += "ccharger-[charging.connector_type]-on"
	if((charging.charge > 0.01) && charging.charge_light_type)
		. += mutable_appearance('icons/obj/machines/cell_charger.dmi', "cell-[charging.charge_light_type]-o[(charging.percent() >= 99.5) ? 2 : 1]")

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	. += "<hr>Внутри [charging ? "батарейка" : "нет батарейки"] в заряднике."
	if(charging)
		. += "<hr><b>Заряд:</b> [round(charging.percent(), 1)]%."
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: [charge_rate == 1 ? "Стандартная скорость зарядки." : "Скорость зарядки увеличена в <b>[charge_rate]</b> раза."]</span>"

/obj/machinery/cell_charger/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(charging)
		return FALSE
	if(default_unfasten_wrench(user, tool))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell) && !panel_open)
		if(machine_stat & BROKEN)
			to_chat(user, span_warning("[capitalize(src.name)] сломан!"))
			return
		if(!anchored)
			to_chat(user, span_warning("[capitalize(src.name)] не прикручен!"))
			return
		if(charging)
			to_chat(user, span_warning("Здесь уже есть батарейка!"))
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, span_warning("[capitalize(src.name)] мигает красным диодом!"))
				return
			if(!user.transferItemToLoc(W,src))
				return

			charging = W
			user.visible_message(span_notice("[user] вставляет батарейку в [src].") , span_notice("Вставляю батарейку в [src]."))
			update_appearance()
	else
		if(!charging && default_deconstruction_screwdriver(user, icon_state, icon_state, W))
			return
		if(default_deconstruction_crowbar(W))
			return
		return ..()

/obj/machinery/cell_charger/deconstruct()
	if(charging)
		charging.forceMove(drop_location())
	return ..()

/obj/machinery/cell_charger/Destroy()
	QDEL_NULL(charging)
	return ..()

/obj/machinery/cell_charger/proc/removecell()
	charging.update_appearance()
	charging = null
	update_appearance()

/obj/machinery/cell_charger/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!charging)
		return

	user.put_in_hands(charging)
	charging.add_fingerprint(user)

	user.visible_message(span_notice("[user] достаёт [charging] из [src].") , span_notice("Достаю [charging] из [src]."))

	removecell()


/obj/machinery/cell_charger/attack_tk(mob/user)
	if(!charging)
		return

	charging.forceMove(loc)
	to_chat(user, span_notice("Телекинетически достаю [charging] из [src]."))

	removecell()
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/machinery/cell_charger/attack_ai(mob/user)
	return

/obj/machinery/cell_charger/emp_act(severity)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_CONTENTS)
		return

	if(charging)
		charging.emp_act(severity)

/obj/machinery/cell_charger/RefreshParts()
	. = ..()
	charge_rate = 250
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		charge_rate *= capacitor.tier

/obj/machinery/cell_charger/process(seconds_per_tick)
	if(!charging || !anchored || (machine_stat & (BROKEN|NOPOWER)))
		return

	if(charging.percent() >= 100)
		return

	var/main_draw = use_power_from_net(charge_rate * seconds_per_tick, take_any = TRUE) //Pulls directly from the Powernet to dump into the cell
	if(!main_draw)
		return
	charging.give(main_draw)
	use_power(charge_rate / 100) //use a small bit for the charger itself, but power usage scales up with the part tier

	update_appearance()
