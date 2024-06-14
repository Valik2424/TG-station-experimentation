/datum/action/changeling/headcrab
	name = "Последний шанс"
	desc = "Мы жертвуем нашим текущим телом в момент нужды, давая нам контроль над сосудом, который может посадить наше подобие в новом хозяине. Стоит 20 химикатов."
	helptext = "Мы будем контролировать маленькое хрупкое существо. Мы можем напасть на труп, подобный этому, чтобы посадить яйцо, которое постепенно созреет для нас в новой форме."
	button_icon_state = "last_resort"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

/datum/action/changeling/headcrab/sting_action(mob/living/user)
	set waitfor = FALSE
	var/confirm = tgui_alert(user, "Точно хотим покончить с собой и стать червем?", "Последний шанс", list("Да", "Нет"))
	if(confirm != "Yes")
		return

	..()
	var/datum/mind/stored_mind = user.mind
	var/list/organs = user.get_organs_for_zone(BODY_ZONE_HEAD, TRUE)

	explosion(user, light_impact_range = 2, adminlog = TRUE, explosion_cause = src)
	for(var/mob/living/carbon/human/blinded_human in range(2, user))
		var/obj/item/organ/internal/eyes/eyes = blinded_human.get_organ_slot(ORGAN_SLOT_EYES)
		if(!eyes || blinded_human.is_blind())
			continue
		to_chat(blinded_human, span_userdanger("Меня ослепило душем из крови!"))
		blinded_human.Stun(2 SECONDS)
		blinded_human.set_eye_blur_if_lower(40 SECONDS)
		blinded_human.adjust_confusion(3 SECONDS)

	for(var/mob/living/silicon/blinded_silicon in range(2,user))
		to_chat(blinded_silicon, span_userdanger("Мои датчики закоротило потоком крови!"))
		blinded_silicon.Paralyze(6 SECONDS)

	var/turf/user_turf = get_turf(user)
	user.transfer_observers_to(user_turf) // user is about to be deleted, store orbiters on the turf
	if(user.stat != DEAD)
		user.investigate_log("has been gibbed by headslug burst.", INVESTIGATE_DEATHS)
	user.gib(DROP_ALL_REMAINS)
	. = TRUE
	addtimer(CALLBACK(src, PROC_REF(spawn_headcrab), stored_mind, user_turf, organs), 1 SECONDS)

/datum/action/changeling/headcrab/proc/spawn_headcrab(datum/mind/stored_mind, turf/spawn_location, list/organs)
	var/mob/living/basic/headslug/crab = new(spawn_location)
	for(var/obj/item/organ/I in organs)
		I.forceMove(crab)

	stored_mind.transfer_to(crab, force_key_move = TRUE)
	spawn_location.transfer_observers_to(crab)
	to_chat(crab, span_warning("Мы вырвались из остатков своего бывшего тела в потоке крови!"))
