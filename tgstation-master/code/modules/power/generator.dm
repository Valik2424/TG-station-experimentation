/obj/machinery/power/generator
	name = "термоэлектрический генератор"
	desc = "Высокоэффективный газовый термоэлектрический генератор. Может быть нестабилен, если разогнан слишком сильно."
	icon = 'white/valtos/icons/teg.dmi'
	icon_state = "teg-unassembled"
	density = TRUE
	use_power = NO_POWER_USE

	circuit = /obj/item/circuitboard/machine/generator

	var/obj/machinery/atmospherics/components/binary/circulator/cold_circ
	var/obj/machinery/atmospherics/components/binary/circulator/hot_circ

	var/lastgen = 0
	var/lastgenlev = -1
	var/lastcirc = "00"


/obj/machinery/power/generator/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)
	find_circs()
	connect_to_network()
	SSair.start_processing_machine(src)
	update_appearance()
	component_parts = list(new /obj/item/circuitboard/machine/generator)

/obj/machinery/power/generator/Destroy()
	kill_circs()
	SSair.stop_processing_machine(src)
	return ..()

/obj/machinery/power/generator/update_overlays()
	. = ..()
	cut_overlays()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)

	if(machine_stat & (BROKEN))
		icon_state = "teg-broken"
		return
	if(hot_circ && cold_circ)
		icon_state = "teg-assembled"
	else
		icon_state = "teg-unassembled"
		if(panel_open)
			add_overlay("teg-panel")
		return

	if(machine_stat & (NOPOWER))
		return
	else
		var/L = min(round(lastgenlev/500000),11)
		if(L != 0)
			SSvis_overlays.add_vis_overlay(src, icon, "teg-op[L]", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)

#define GENRATE 800 // generator output coefficient from Q

/obj/machinery/power/generator/process_atmos()

	if(!cold_circ || !hot_circ)
		return

	if(powernet)
		var/datum/gas_mixture/cold_air = cold_circ.return_transfer_air()
		var/datum/gas_mixture/hot_air = hot_circ.return_transfer_air()

		if(cold_air && hot_air)

			var/cold_air_heat_capacity = cold_air.heat_capacity()
			var/hot_air_heat_capacity = hot_air.heat_capacity()

			var/delta_temperature = hot_air.temperature - cold_air.temperature


			if(delta_temperature > 0 && cold_air_heat_capacity > 0 && hot_air_heat_capacity > 0)
				var/efficiency = 0.65

				var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

				var/heat = energy_transfer*(1-efficiency)
				lastgen += energy_transfer*efficiency

				hot_air.temperature = hot_air.temperature - energy_transfer/hot_air_heat_capacity
				cold_air.temperature = cold_air.temperature + heat/cold_air_heat_capacity

				//add_avail(lastgen) This is done in process now
		// update icon overlays only if displayed level has changed

		if(hot_air)
			var/datum/gas_mixture/hot_circ_air1 = hot_circ.airs[1]
			hot_circ_air1.merge(hot_air)

		if(cold_air)
			var/datum/gas_mixture/cold_circ_air1 = cold_circ.airs[1]
			cold_circ_air1.merge(cold_air)

		update_appearance()

	// var/circ = "[cold_circ?.last_pressure_delta > 0 ? "1" : "0"][hot_circ?.last_pressure_delta > 0 ? "1" : "0"]"
	// if(circ != lastcirc)
	// 	lastcirc = circ
	// 	update_appearance()

	src.updateDialog()

/obj/machinery/power/generator/process()
	//Setting this number higher just makes the change in power output slower, it doesnt actualy reduce power output cause **math**
	var/power_output = round(lastgen / 10)
	add_avail(power_output)
	lastgenlev = power_output
	lastgen -= power_output
	..()

/obj/machinery/power/generator/proc/get_menu(include_link = TRUE)
	var/t = ""
	if(!powernet)
		t += span_bad("Нет соединения с энергосетью!")
	else if(cold_circ && hot_circ)
		var/datum/gas_mixture/cold_circ_air1 = cold_circ.airs[1]
		var/datum/gas_mixture/cold_circ_air2 = cold_circ.airs[2]
		var/datum/gas_mixture/hot_circ_air1 = hot_circ.airs[1]
		var/datum/gas_mixture/hot_circ_air2 = hot_circ.airs[2]

		t += "<div class='statusDisplay'>"

		t += "Выход: [display_power(lastgenlev)]"

		t += "<BR>"

		t += "<B><font color='blue'>Холодная петля</font></B><BR>"
		t += "Температура: [round(cold_circ_air2.temperature, 0.1)] К / Выход: [round(cold_circ_air1.temperature, 0.1)] К<BR>"
		t += "Давление: [round(cold_circ_air2.return_pressure(), 0.1)] кПа /  Выход: [round(cold_circ_air1.return_pressure(), 0.1)] кПа<BR>"

		t += "<B><font color='red'>Hot loop</font></B><BR>"
		t += "Temperature: [round(hot_circ_air2.temperature, 0.1)] к / Выход: [round(hot_circ_air1.temperature, 0.1)] К<BR>"
		t += "Давление: [round(hot_circ_air2.return_pressure(), 0.1)] кПа / Выход: [round(hot_circ_air1.return_pressure(), 0.1)] кПа<BR>"

		t += "</div>"
	else if(!hot_circ && cold_circ)
		t += span_bad("Не найден циркулятор!")
	else if(hot_circ && !cold_circ)
		t += span_bad("Не найден холодный циркулятор!")
	else
		t += span_bad("Не найдены части!")
	if(include_link)
		t += "<BR><A href='?src=[REF(src)];close=1'>Закрыть</A>"

	return t

/obj/machinery/power/generator/ui_interact(mob/user)
	. = ..()
	var/datum/browser/popup = new(user, "teg", "Термо-Электрический Генератор", 460, 300)
	popup.set_content(get_menu())
	popup.open()

/obj/machinery/power/generator/Topic(href, href_list)
	if(..())
		return
	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return FALSE
	return TRUE



/obj/machinery/power/generator/proc/find_circs()
	kill_circs()
	var/list/circs = list()
	var/obj/machinery/atmospherics/components/binary/circulator/C
	var/circpath = /obj/machinery/atmospherics/components/binary/circulator
	if(dir == NORTH || dir == SOUTH)
		C = locate(circpath) in get_step(src, EAST)
		if(C && C.dir == WEST)
			circs += C

		C = locate(circpath) in get_step(src, WEST)
		if(C && C.dir == EAST)
			circs += C

	else
		C = locate(circpath) in get_step(src, NORTH)
		if(C && C.dir == SOUTH)
			circs += C

		C = locate(circpath) in get_step(src, SOUTH)
		if(C && C.dir == NORTH)
			circs += C

	if(circs.len)
		for(C in circs)
			if(C.mode == CIRCULATOR_COLD && !cold_circ)
				cold_circ = C
				C.generator = src
			else if(C.mode == CIRCULATOR_HOT && !hot_circ)
				hot_circ = C
				C.generator = src

/obj/machinery/power/generator/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		return
	set_anchored(!anchored)
	I.play_tool_sound(src)
	if(!anchored)
		kill_circs()
	connect_to_network()
	to_chat(user, span_notice("[anchored?"Прикручиваю":"Откручиваю"] [src]."))
	return TRUE

/obj/machinery/power/generator/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(!anchored)
		return
	find_circs()
	to_chat(user, span_notice("Обновляю соединение с циркуляторами."))
	return TRUE

/obj/machinery/power/generator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	toggle_panel_open()
	I.play_tool_sound(src)
	to_chat(user, span_notice("[panel_open?"Открываю":"Закрываю"] панель [src]."))
	return TRUE

/obj/machinery/power/generator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/power/generator/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/power/generator/on_deconstruction()
	kill_circs()

/obj/machinery/power/generator/proc/kill_circs()
	if(hot_circ)
		hot_circ.generator = null
		hot_circ = null
	if(cold_circ)
		cold_circ.generator = null
		cold_circ = null

#undef GENRATE
