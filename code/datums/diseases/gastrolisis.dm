/datum/disease/gastrolosis
	name = "Инвазивный гастролоз"
	max_stages = 4
	spread_text = "Неизвестное"
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_text = "Соль и мутадон"
	agent = "Агент S и реструктуризация ДНК"
	viable_mobtypes = list(/mob/living/carbon/human)
	stage_prob = 0.5
	disease_flags = CURABLE
	cures = list(/datum/reagent/consumable/salt,  /datum/reagent/medicine/mutadone)


/datum/disease/gastrolosis/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	if(is_species(affected_mob, /datum/species/snail))
		cure()
		return FALSE

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(0.5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 40)
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(2.5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)
		if(4)
			var/obj/item/organ/internal/eyes/eyes = locate(/obj/item/organ/internal/eyes/snail) in affected_mob.organs
			if(!eyes && SPT_PROB(2.5, seconds_per_tick))
				var/obj/item/organ/internal/eyes/snail/new_eyes = new()
				new_eyes.Insert(affected_mob, drop_if_replaced = TRUE)
				affected_mob.visible_message(span_warning("Глаза [affected_mob] выпадают, их место занимают глаза улитки!") , \
				span_userdanger("Кричу от боли, когда твои мои глаза улитки выталкивают глаза!"))
				affected_mob.emote("scream")
				return

			var/obj/item/shell = affected_mob.get_item_by_slot(ITEM_SLOT_BACK)
			if(!istype(shell, /obj/item/storage/backpack/snail))
				shell = null
			if(!shell && SPT_PROB(2.5, seconds_per_tick))
				if(affected_mob.dropItemToGround(affected_mob.get_item_by_slot(ITEM_SLOT_BACK)))
					affected_mob.equip_to_slot_or_del(new /obj/item/storage/backpack/snail(affected_mob), ITEM_SLOT_BACK)
					affected_mob.visible_message(span_warning("[affected_mob] выращивает на спине гротескный панцирь!") , \
					span_userdanger("Кричу от боли, когда панцирь вырывается из-под кожи!"))
					affected_mob.emote("scream")
					return

			var/obj/item/organ/internal/tongue/tongue = locate(/obj/item/organ/internal/tongue/snail) in affected_mob.organs
			if(!tongue && SPT_PROB(2.5, seconds_per_tick))
				var/obj/item/organ/internal/tongue/snail/new_tongue = new()
				new_tongue.Insert(affected_mob)
				to_chat(affected_mob, span_userdanger("Речь замедляется..."))
				return

			if(shell && eyes && tongue && SPT_PROB(2.5, seconds_per_tick))
				affected_mob.set_species(/datum/species/snail)
				affected_mob.client?.give_award(/datum/award/achievement/jobs/snail, affected_mob)
				affected_mob.visible_message(span_warning("[affected_mob] превращается в улитку!") , \
				span_boldnotice("Кажется теперь я улитка! Пора пооолзааааать..."))
				cure()
				return FALSE

			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)


/datum/disease/gastrolosis/cure()
	. = ..()
	if(affected_mob && !is_species(affected_mob, /datum/species/snail)) //undo all the snail fuckening
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/internal/tongue/tongue = locate(/obj/item/organ/internal/tongue/snail) in H.organs
		if(tongue)
			var/obj/item/organ/internal/tongue/new_tongue = new H.dna.species.mutanttongue ()
			new_tongue.Insert(H)
		var/obj/item/organ/internal/eyes/eyes = locate(/obj/item/organ/internal/eyes/snail) in H.organs
		if(eyes)
			var/obj/item/organ/internal/eyes/new_eyes = new H.dna.species.mutanteyes ()
			new_eyes.Insert(H)
		var/obj/item/storage/backpack/bag = H.get_item_by_slot(ITEM_SLOT_BACK)
		if(istype(bag, /obj/item/storage/backpack/snail))
			bag.emptyStorage()
			H.temporarilyRemoveItemFromInventory(bag, TRUE)
			qdel(bag)
