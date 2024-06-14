/datum/station_trait/bananium_shipment
	name = "Отгрузка бананиума"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	report_message = "Ходят слухи, что планета клоунов отправляет пакеты поддержки клоунам в этой системе."
	trait_to_give = STATION_TRAIT_BANANIUM_SHIPMENTS

/datum/station_trait/unnatural_atmosphere
	name = "Неестественные атмосферные свойства"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = TRUE
	report_message = "Локальная планета системы имеет необычные атмосферные свойства."
	trait_to_give = STATION_TRAIT_UNNATURAL_ATMOSPHERE

/datum/station_trait/spider_infestation
	name = "Spider Infestation"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	report_message = "We have introduced a natural countermeasure to reduce the number of rodents on board your station."
	trait_to_give = STATION_TRAIT_SPIDER_INFESTATION

/datum/station_trait/unique_ai
	name = "Уникальный ИИ"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = TRUE
	report_message = "В экспериментальных целях ИИ этой станции может показывать отклонение от установленного по умолчанию закона. Не вмешивайтесь в этот эксперимент."
	trait_to_give = STATION_TRAIT_UNIQUE_AI

/datum/station_trait/unique_ai/on_round_start()
	. = ..()
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		ai.show_laws()

/datum/station_trait/ian_adventure
	name = "Приключение Яна"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = FALSE
	report_message = "Ян отправился исследовать станцию."

/datum/station_trait/ian_adventure/on_round_start()
	for(var/mob/living/basic/pet/dog/corgi/dog in GLOB.mob_list)
		if(!(istype(dog, /mob/living/basic/pet/dog/corgi/ian) || istype(dog, /mob/living/basic/pet/dog/corgi/puppy/ian)))
			continue

		// Makes this station trait more interesting. Ian probably won't go anywhere without a little external help.
		// Also gives him a couple extra lives to survive eventual tiders.
		dog.deadchat_plays(DEMOCRACY_MODE|MUTE_DEMOCRACY_MESSAGES, 3 SECONDS)
		dog.AddComponent(/datum/component/multiple_lives, 2)
		RegisterSignal(dog, COMSIG_ON_MULTIPLE_LIVES_RESPAWN, PROC_REF(do_corgi_respawn))

		// The extended safety checks at time of writing are about chasms and lava
		// if there are any chasms and lava on stations in the future, woah
		var/turf/current_turf = get_turf(dog)
		var/turf/adventure_turf = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)

		// Poof!
		do_smoke(location=current_turf)
		dog.forceMove(adventure_turf)
		do_smoke(location=adventure_turf)

/// Moves the new dog somewhere safe, equips it with the old one's inventory and makes it deadchat_playable.
/datum/station_trait/ian_adventure/proc/do_corgi_respawn(mob/living/basic/pet/dog/corgi/old_dog, mob/living/basic/pet/dog/corgi/new_dog, gibbed, lives_left)
	SIGNAL_HANDLER

	var/turf/current_turf = get_turf(new_dog)
	var/turf/adventure_turf = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)

	do_smoke(location=current_turf)
	new_dog.forceMove(adventure_turf)
	do_smoke(location=adventure_turf)

	if(old_dog.inventory_back)
		var/obj/item/old_dog_back = old_dog.inventory_back
		old_dog.inventory_back = null
		old_dog_back.forceMove(new_dog)
		new_dog.inventory_back = old_dog_back

	if(old_dog.inventory_head)
		var/obj/item/old_dog_hat = old_dog.inventory_head
		old_dog.inventory_head = null
		new_dog.place_on_head(old_dog_hat)

	new_dog.update_corgi_fluff()
	new_dog.regenerate_icons()
	new_dog.deadchat_plays(DEMOCRACY_MODE|MUTE_DEMOCRACY_MESSAGES, 3 SECONDS)
	if(lives_left)
		RegisterSignal(new_dog, COMSIG_ON_MULTIPLE_LIVES_RESPAWN, PROC_REF(do_corgi_respawn))

	if(!gibbed) //The old dog will now disappear so we won't have more than one Ian at a time.
		qdel(old_dog)

/datum/station_trait/colored_assistants
	name = "Цветные ассистенты"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 10
	show_in_report = TRUE
	report_message = "Из-за нехватки стандартных комбинезонов мы предоставили вашим ассистентам комбинезоны из наших резервных запасов."

/datum/station_trait/colored_assistants/New()
	. = ..()

	var/new_colored_assistant_type = pick(subtypesof(/datum/colored_assistant) - get_configured_colored_assistant_type())
	GLOB.colored_assistant = new new_colored_assistant_type

/datum/station_trait/cargorilla
	name = "Cargo Gorilla"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = FALSE // Selective attention test. Did you spot the gorilla?

	/// The gorilla we created, we only hold this ref until the round starts.
	var/mob/living/basic/gorilla/cargorilla/cargorilla

/datum/station_trait/cargorilla/New()
	. = ..()
	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(replace_cargo))

/// Replace some cargo equipment and 'personnel' with a gorilla.
/datum/station_trait/cargorilla/proc/replace_cargo(datum/source)
	SIGNAL_HANDLER

	var/mob/living/basic/sloth/cargo_sloth = GLOB.cargo_sloth
	if(isnull(cargo_sloth))
		return

	cargorilla = new(cargo_sloth.loc)
	cargorilla.name = cargo_sloth.name
	// We do a poll on roundstart, don't let ghosts in early
	INVOKE_ASYNC(src, PROC_REF(make_id_for_gorilla))
	// hm our sloth looks funny today
	qdel(cargo_sloth)

	// monkey carries the crates, the age of robot is over
	if(GLOB.cargo_ripley)
		qdel(GLOB.cargo_ripley)

/// Makes an ID card for the gorilla
/datum/station_trait/cargorilla/proc/make_id_for_gorilla()
	var/obj/item/card/id/advanced/cargo_gorilla/gorilla_id = new(cargorilla.loc)
	gorilla_id.registered_name = cargorilla.name
	gorilla_id.update_label()

	cargorilla.put_in_hands(gorilla_id, del_on_fail = TRUE)

/datum/station_trait/cargorilla/on_round_start()
	if(!cargorilla)
		return

	addtimer(CALLBACK(src, PROC_REF(get_ghost_for_gorilla), cargorilla), 12 SECONDS) // give ghosts a bit of time to funnel in
	cargorilla = null

/// Get us a ghost for the gorilla.
/datum/station_trait/cargorilla/proc/get_ghost_for_gorilla(mob/living/basic/gorilla/cargorilla/gorilla)
	if(QDELETED(gorilla))
		return

	gorilla.poll_for_gorilla()

/datum/station_trait/birthday
	name = "День рождения сотрудинка"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 2
	show_in_report = TRUE
	report_message = "Сегодня у нас день рождения сотрудника. Поздравляем сотрудника с днем рождения!"
	trait_to_give = STATION_TRAIT_BIRTHDAY
	///Variable that stores a reference to the person selected to have their birthday celebrated.
	var/mob/living/carbon/human/birthday_person
	///Variable that holds the real name of the birthday person once selected, just incase the birthday person's real_name changes.
	var/birthday_person_name = ""
	///Variable that admins can override with a player's ckey in order to set them as the birthday person when the round starts.
	var/birthday_override_ckey

/datum/station_trait/birthday/New()
	. = ..()
	RegisterSignals(SSdcs, list(COMSIG_GLOB_JOB_AFTER_SPAWN), PROC_REF(on_job_after_spawn))

/datum/station_trait/birthday/revert()
	for (var/obj/effect/landmark/start/hangover/party_spot in GLOB.start_landmarks_list)
		QDEL_LIST(party_spot.party_debris)
	return ..()

/datum/station_trait/birthday/on_round_start()
	. = ..()
	if(birthday_override_ckey)
		if(!check_valid_override())
			message_admins("Attempted to make [birthday_override_ckey] the birthday person but they are not a valid station role. A random birthday person has be selected instead.")

	if(!birthday_person)
		var/list/birthday_options = list()
		for(var/mob/living/carbon/human/human in GLOB.human_list)
			if(human.mind?.assigned_role.job_flags & JOB_CREW_MEMBER)
				birthday_options += human
		if(length(birthday_options))
			birthday_person = pick(birthday_options)
			birthday_person_name = birthday_person.real_name
	addtimer(CALLBACK(src, PROC_REF(announce_birthday)), 10 SECONDS)

/datum/station_trait/birthday/proc/check_valid_override()

	var/mob/living/carbon/human/birthday_override_mob = get_mob_by_ckey(birthday_override_ckey)

	if(isnull(birthday_override_mob))
		return FALSE

	if(birthday_override_mob.mind?.assigned_role.job_flags & JOB_CREW_MEMBER)
		birthday_person = birthday_override_mob
		birthday_person_name = birthday_person.real_name
		return TRUE
	else
		return FALSE


/datum/station_trait/birthday/proc/announce_birthday()
	report_message = "Сегодня у нас день рождения [birthday_person ? birthday_person_name : "сотрудника"]. Поздравляем [birthday_person ? birthday_person_name : "сотрудника"] с днем рождения!"
	priority_announce("Сегодня у нас день рождения [birthday_person ? birthday_person_name : "сотрудника"]. Поздравляем [birthday_person ? birthday_person_name : "сотрудника"] с днем рождения!")
	if(birthday_person)
		playsound(birthday_person, 'sound/items/party_horn.ogg', 50)
		birthday_person.add_mood_event("birthday", /datum/mood_event/birthday)
		birthday_person = null

/datum/station_trait/birthday/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned_mob)
	SIGNAL_HANDLER

	var/obj/item/hat = pick_weight(list(
		/obj/item/clothing/head/costume/party/festive = 12,
		/obj/item/clothing/head/costume/party = 12,
		/obj/item/clothing/head/costume/festive = 2,
		/obj/item/clothing/head/utility/hardhat/cakehat = 1,
	))
	hat = new hat(spawned_mob)
	if(!spawned_mob.equip_to_slot_if_possible(hat, ITEM_SLOT_HEAD, disable_warning = TRUE))
		spawned_mob.equip_to_slot_or_del(hat, ITEM_SLOT_BACKPACK, indirect_action = TRUE)
	var/obj/item/toy = pick_weight(list(
		/obj/item/reagent_containers/spray/chemsprayer/party = 4,
		/obj/item/toy/balloon = 2,
		/obj/item/sparkler = 2,
		/obj/item/clothing/mask/party_horn = 2,
		/obj/item/storage/box/tail_pin = 1,
	))
	toy = new toy(spawned_mob)
	if(istype(toy, /obj/item/toy/balloon))
		spawned_mob.equip_to_slot_or_del(toy, ITEM_SLOT_HANDS) //Balloons do not fit inside of backpacks.
	else
		spawned_mob.equip_to_slot_or_del(toy, ITEM_SLOT_BACKPACK, indirect_action = TRUE)
	if(birthday_person_name) //Anyone who joins after the annoucement gets one of these.
		var/obj/item/birthday_invite/birthday_invite = new(spawned_mob)
		birthday_invite.setup_card(birthday_person_name)
		if(!spawned_mob.equip_to_slot_if_possible(birthday_invite, ITEM_SLOT_HANDS, disable_warning = TRUE))
			spawned_mob.equip_to_slot_or_del(birthday_invite, ITEM_SLOT_BACKPACK) //Just incase someone spawns with both hands full.

/obj/item/birthday_invite
	name = "приглашение на день рождения"
	desc = "Карточка, указывающая, что сегодня день рождения кого-то."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/birthday_invite/proc/setup_card(birthday_name)
	desc = "Карточка, указывающая, что сегодня день рождения [birthday_name]."
	icon_state = "paperslip_words"
	icon = 'icons/obj/service/bureaucracy.dmi'

/obj/item/clothing/head/costume/party
	name = "праздничная бумажная шапочка"
	desc = "Дешёвая бумажная шапочка, которую вы ОБЯЗАНЫ носить."
	icon_state = "party_hat"
	greyscale_config =  /datum/greyscale_config/party_hat
	greyscale_config_worn = /datum/greyscale_config/party_hat/worn
	flags_inv = 0
	armor_type = /datum/armor/none
	var/static/list/hat_colors = list(
		COLOR_PRIDE_RED,
		COLOR_PRIDE_ORANGE,
		COLOR_PRIDE_YELLOW,
		COLOR_PRIDE_GREEN,
		COLOR_PRIDE_BLUE,
		COLOR_PRIDE_PURPLE,
	)

/obj/item/clothing/head/costume/party/Initialize(mapload)
	set_greyscale(colors = list(pick(hat_colors)))
	return ..()

/obj/item/clothing/head/costume/party/festive
	name = "фестивальная бумажная шапочка"
	icon_state = "xmashat_grey"
	greyscale_config = /datum/greyscale_config/festive_hat
	greyscale_config_worn = /datum/greyscale_config/festive_hat/worn

/// Tells the area map generator to ADD MORE TREEEES
/datum/station_trait/forested
	name = "Лесистая местность"
	trait_type = STATION_TRAIT_NEUTRAL
	trait_to_give = STATION_TRAIT_FORESTED
	trait_flags = STATION_TRAIT_PLANETARY
	weight = 10
	show_in_report = TRUE
	report_message = "Джонни, они на деревьях! Варите напалм!"

