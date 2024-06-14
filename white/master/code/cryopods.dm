/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */
GLOBAL_LIST_EMPTY(cryopods)
GLOBAL_LIST_EMPTY(cryopod_computers)
GLOBAL_LIST_EMPTY(ghost_records)

/datum/mind
	var/list/datum/objective/objectives = list()

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "консоль криогенных камер"
	desc = "Интерфейс для управления криогенным хранилищем."
	icon = 'white/master/icons/cryopod.dmi'
	icon_state = "cellconsole_1"
	icon_keyboard = null
	icon_screen = null
	use_power = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	req_one_access = list(ACCESS_COMMAND, ACCESS_ARMORY) // Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	var/mode = null

	// Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()

	var/storage_type = "crewmembers"
	var/storage_name = "консоль криогенных камер"
	var/allow_items = TRUE

/obj/machinery/computer/cryopod/Initialize(mapload)
	. = ..()
	GLOB.cryopod_computers += src

/obj/machinery/computer/cryopod/Destroy()
	GLOB.cryopod_computers -= src
	. = ..()

/obj/machinery/computer/cryopod/update_icon_state()
	if(machine_stat & (NOPOWER|BROKEN))
		icon_state = "cellconsole"
		return ..()
	icon_state = "cellconsole_1"
	return ..()

/obj/machinery/computer/cryopod/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	add_fingerprint(user)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryopodConsole", name)
		ui.open()

/obj/machinery/computer/cryopod/ui_data(mob/user)
	var/list/data = list()
	data["allow_items"] = allow_items
	data["frozen_crew"] = frozen_crew
	data["frozen_items"] = list()

	if(allow_items)
		data["frozen_items"] = frozen_items

	var/obj/item/card/id/id_card
	var/datum/bank_account/current_user
	if(isliving(user))
		var/mob/living/person = user
		id_card = person.get_idcard()
	if(id_card?.registered_account)
		current_user = id_card.registered_account
	if(current_user)
		data["account_name"] = current_user.account_holder

	return data

/obj/machinery/computer/cryopod/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	add_fingerprint(user)

	switch(action)
		if("one_item")
			if(!allowed(user))
				to_chat(user, span_warning("Доступ запрещён."))
				return

			if(!allow_items) return

			if(!params["item"])
				return

			var/obj/item/item = frozen_items[text2num(params["item"])]
			if(!item)
				to_chat(user, span_notice("[capitalize(item.name)] более не в хранилище."))
				return

			visible_message(span_notice("[capitalize(src.name)] выдавливает [item]."))
			item.forceMove(get_turf(src))
			frozen_items -= item

		if("all_items")
			if(!allowed(user))
				to_chat(user, span_warning("Доступ запрещён."))
				return

			if(!allow_items) return

			visible_message(span_notice("[capitalize(src.name)] выдавливает кучу хлама на пол."))

			for(var/obj/item/item in frozen_items)
				item.forceMove(get_turf(src))
				frozen_items -= item

	return TRUE

GLOBAL_VAR_INIT(cryopods_enabled, FALSE)
// Cryopods themselves.
/obj/machinery/cryopod
	name = "криокамера"
	desc = "Подходит для людей и не только людей."
	icon = 'white/master/icons/cryopod.dmi'
	icon_state = "cryopod-off"
	density = TRUE
	anchored = TRUE
	state_open = TRUE
	use_power = FALSE

	var/on_store_message = "входит в хранилище."
	var/on_store_name = "Криогенный Надзор"

	// 3 minutes-ish safe period before being despawned.
	var/time_till_despawn = 3 MINUTES // This is reduced to 30 seconds if a player manually enters cryo
	var/fast_despawn = 30 SECONDS
	var/despawn_world_time = null // Used to keep track of the safe period.

	/// What was the ckey of the client that entered the cryopod?
	var/stored_ckey = null
	/// The name of the mob that entered the cryopod.
	var/stored_name = null
	/// The rank (job title) of the mob that entered the cryopod, if it was a human. "N/A" by default.
	var/stored_rank = "N/A"


	var/obj/machinery/computer/cryopod/control_computer
	COOLDOWN_DECLARE(last_no_computer_message)

/obj/machinery/cryopod/Initialize(mapload)
	..()
	GLOB.cryopods += src
	return INITIALIZE_HINT_LATELOAD //Gotta populate the cryopod computer GLOB first

/obj/machinery/cryopod/LateInitialize()
	update_icon()
	find_control_computer()

/obj/machinery/cryopod/proc/PowerOn()
	if(!occupant)
		open_machine()

// This is not a good situation
/obj/machinery/cryopod/Destroy()
	GLOB.cryopods -= src
	control_computer = null
	return ..()

/obj/machinery/cryopod/proc/find_control_computer(urgent = FALSE)

	for(var/cryo_console as anything in GLOB.cryopod_computers)
		var/obj/machinery/computer/cryopod/console = cryo_console
		if(get_area(console) == get_area(src))
			control_computer = console
			break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && COOLDOWN_FINISHED(src, last_no_computer_message))
		COOLDOWN_START(src, last_no_computer_message, 5 MINUTES)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/close_machine(mob/user, density_to_set = TRUE)
	if(!control_computer)
		find_control_computer(TRUE)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, span_boldnotice("Холодный воздух, брр... кажется я засыпаю..."))
			stored_ckey = mob_occupant.ckey
			stored_name = mob_occupant.name

			if(mob_occupant.mind)
				stored_rank = mob_occupant.mind.assigned_role.title
				if(isnull(stored_ckey))
					stored_ckey = mob_occupant.mind.key // if mob does not have a ckey and was placed in cryo by someone else, we can get the key this way

		if(mob_occupant.client || !mob_occupant.key) // Self cryos and SSD
			despawn_world_time = world.time + (fast_despawn) // This gives them 30 seconds
		else
			despawn_world_time = world.time + time_till_despawn
	icon_state = "cryopod"


/obj/machinery/cryopod/open_machine(drop = TRUE, density_to_set = FALSE)
	..()
	icon_state = GLOB.cryopods_enabled ? "cryopod-open" : "cryopod-off"
	density = TRUE
	name = initial(name)
	stored_ckey = null
	stored_name = null
	stored_rank = "N/A"

/obj/machinery/cryopod/container_resist_act(mob/living/user)
	visible_message(span_notice("[occupant] вылезает из [src]!"),
		span_notice("Вылезаю из [src]!"))
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist_act(user)

/obj/machinery/cryopod/process()
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		// Eject dead people
		if(mob_occupant.stat == DEAD)
			open_machine()

		if(world.time <= despawn_world_time)
			return

		if(!mob_occupant.client && mob_occupant.stat <= SOFT_CRIT) // Occupant is living and has no client.
			if(!control_computer)
				find_control_computer(urgent = TRUE) // better hope you found it this time

			despawn_occupant()

/obj/machinery/cryopod/proc/handle_objectives()
	var/mob/living/mob_occupant = occupant
	// Update any existing objectives involving this mob.
	for(var/datum/objective/objective in GLOB.objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(istype(objective,/datum/objective/mutiny) && objective.target == mob_occupant.mind)
			objective.team.objectives -= objective
			qdel(objective)
			for(var/datum/mind/mind in objective.team.members)
				to_chat(mind.current, "<BR><span class='userdanger'>Цели более не существует. Задачи обновлены!</span>")
				mind.announce_objectives()
		else if(objective.target && istype(objective.target, /datum/mind))
			if(objective.target == mob_occupant?.mind)
				var/old_target = objective.target
				objective.target = null
				if(!objective)
					return
				objective.find_target()
				if(!objective.target && objective.owner)
					to_chat(objective.owner.current, "<BR><span class='userdanger'>Цели более не существует. Задачи обновлены!</span>")
					for(var/datum/antagonist/antag in objective.owner.antag_datums)
						antag.objectives -= objective
				if (!objective.team)
					objective.update_explanation_text()
					objective.owner.announce_objectives()
					to_chat(objective.owner.current, "<BR><span class='userdanger'>Цели более не существует. Время плана [pick("А","Б","В","Г","Э","Ю","Я","Ъ")]. Задачи обновлены!</span>")
				else
					var/list/objectivestoupdate
					for(var/datum/mind/objective_owner in objective.get_owners())
						to_chat(objective_owner.current, "<BR><span class='userdanger'>Цели более не существует. Время плана [pick("А","Б","В","Г","Э","Ю","Я","Ъ")]. Задачи обновлены!</span>")
						for(var/datum/objective/update_target_objective in objective_owner.get_all_objectives())
							LAZYADD(objectivestoupdate, update_target_objective)
					objectivestoupdate += objective.team.objectives
					for(var/datum/objective/update_objective in objectivestoupdate)
						if(update_objective.target != old_target || !istype(update_objective,objective.type))
							continue
						update_objective.target = objective.target
						update_objective.update_explanation_text()
						to_chat(objective.owner.current, "<BR><span class='userdanger'>Цели более не существует. Время плана [pick("А","Б","В","Г","Э","Ю","Я","Ъ")]. Задачи обновлены!</span>")
						update_objective.owner.announce_objectives()
				qdel(objective)

/obj/machinery/cryopod/proc/should_preserve_item(obj/item/item)
	for(var/datum/objective_item/steal/possible_item in GLOB.possible_items)
		if(istype(item, possible_item.targetitem))
			return TRUE
	return FALSE

/// This function can not be undone; do not call this unless you are sure.
/// Handles despawning the player.
/obj/machinery/cryopod/proc/despawn_occupant()
	var/mob/living/mob_occupant = occupant

	SSjob.FreeRole(stored_rank)

	if(mob_occupant.mind)
		// Handle tater cleanup.
		if(LAZYLEN(mob_occupant.mind.objectives))
			mob_occupant.mind.objectives.Cut()
			mob_occupant.mind.special_role = null

	// Delete them from datacore and ghost records.
	var/announce_rank = null

	for(var/list/record in GLOB.ghost_records)
		if(record["name"] == stored_name)
			announce_rank = record["rank"]
			GLOB.ghost_records.Remove(list(record))
			break

	if(!announce_rank) // No need to loop over all of those if we already found it beforehand.
		for(var/datum/record/crew/possible_target_record as anything in GLOB.manifest.general)
			if(possible_target_record.name == stored_name && (stored_rank == "N/A" || possible_target_record.trim == stored_rank))
				announce_rank = possible_target_record.rank
				qdel(possible_target_record)
				break

	control_computer.frozen_crew += list(list("name" = stored_name, "job" = stored_rank))

	// Make an announcement and log the person entering storage.
	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())

	visible_message(span_notice("[capitalize(src.name)] начинает дико шуметь, когда [mob_occupant.real_name] входит в хранилище."))

	for(var/obj/item/item in mob_occupant.get_all_contents())
		if(item.loc.loc && (item.loc.loc == loc || item.loc.loc == control_computer))
			continue // means we already moved whatever this thing was in
			// I'm a professional, okay

		if(!should_preserve_item(item))
			continue

		if(control_computer && control_computer.allow_items)
			control_computer.frozen_items += item
			mob_occupant.transferItemToLoc(item, control_computer, TRUE)
		else
			mob_occupant.transferItemToLoc(item, loc, TRUE)

	var/list/contents = mob_occupant.get_all_contents()
	QDEL_LIST(contents)

	// Ghost and delete the mob.
	if(!mob_occupant.get_ghost(TRUE))
		if(world.time < 15 MINUTES) // before the 15 minute mark
			mob_occupant.ghostize(FALSE) // Players despawned too early may not re-enter the game
		else
			mob_occupant.ghostize(TRUE)
	handle_objectives()
	QDEL_NULL(occupant)
	open_machine()
	name = initial(name)

/obj/machinery/cryopod/MouseDrop_T(mob/living/target, mob/user)
	if(!istype(target) || !can_interact(user) || !target.Adjacent(user) || !ismob(target) || isanimal(target) || !istype(user.loc, /turf) || target.buckled)
		return

	if(!GLOB.cryopods_enabled)
		to_chat(user, span_boldnotice("Криокамера отключена на данный момент времени. Она заработает через [round(((30 MINUTES) - world.time) / (1 MINUTES))] минут."))
		return

	if(occupant)
		to_chat(user, span_notice("[capitalize(src.name)] занято!"))
		return

	if(target.stat == DEAD)
		to_chat(user, span_notice("Мёртвых нельзя сюда поместить."))
		return

	if(target.client && user != target)
		if(iscyborg(target))
			to_chat(user, span_danger("Не могу уложить [target] в [src], пока киборг включен."))
		else
			to_chat(user, span_danger("Не могу уложить [target] в [src], пока цель в сознании."))
		return
	else if(target.client)
		if(alert(target,"Войдём в криокамеру?",,"Да","Нет") != "Да")
			return

	if(target == user && COOLDOWN_FINISHED(target.client, cryo_warned))
		var/caught = FALSE
		if(target.mind.assigned_role.req_admin_notify)
			tgui_alert(target, "Моя роль важная! Надо точно подумать над этим!")
			caught = TRUE
		var/datum/antagonist/antag = target.mind.has_antag_datum(/datum/antagonist)
		if(antag)
			tgui_alert(target, "Да я же [antag.name]! Надо точно подумать над этим!")
			caught = TRUE
		if(caught)
			COOLDOWN_START(target.client, cryo_warned, 5 MINUTES)
			return

	if(!istype(target) || !can_interact(user) || !target.Adjacent(user) || !ismob(target) || isanimal(target) || !istype(user.loc, /turf) || target.buckled)
		return
		// rerun the checks in case of shenanigans

	if(LAZYLEN(target.buckled_mobs) > 0)
		if(target == user)
			to_chat(user, span_danger("Не могу войти в криопод, пока кто-то на мне сидит."))
		else
			to_chat(user, span_danger("Не могу поместить [target] в криопод, пока кто-то на нём сидит."))
		return

	if(target == user)
		visible_message("[user] начинает забираться в криокамеру.")
	else
		visible_message("[user] начинает запихивать [target] в криокамеру.")

	if(occupant)
		to_chat(user, span_notice("[capitalize(src.name)] уже используется."))
		return
	close_machine(target)

	to_chat(target, span_boldnotice("<b>Если вы выйдите из тела, выйдите из игры или закроете клиент - ваш персонаж сразу же будет навсегда удалён из раунда.</b>"))

	name = "[name] ([occupant.name])"
	log_admin("[key_name(target)] entered a stasis pod.")
	message_admins("[key_name_admin(target)] entered a stasis pod. [ADMIN_JMP(src)]")
	add_fingerprint(target)

// Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return // Sorta gamey, but we don't really want these to be destroyed.
