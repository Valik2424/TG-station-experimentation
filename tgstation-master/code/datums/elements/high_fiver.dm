/**
 * # High Fiver Element
 *
 * Attach to an item to make it offer a "high five" when offered to people
 */
/datum/element/high_fiver

/datum/element/high_fiver/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_OFFERING, PROC_REF(on_offer))
	RegisterSignal(target, COMSIG_ITEM_OFFER_TAKEN, PROC_REF(on_offer_taken))

/datum/element/high_fiver/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_OFFERING, COMSIG_ITEM_OFFER_TAKEN))

/// Signal proc for [COMSIG_ITEM_OFFERING] to set up the high-five on offer
/datum/element/high_fiver/proc/on_offer(obj/item/source, mob/living/carbon/offerer)
	SIGNAL_HANDLER

	offerer.visible_message(
		span_danger("[offerer] пытается дать кому-нибудь пять, но проваливает свою попытку!"),
			span_warning("Пытаюсь дать кому-нибудь пять, но рядом никого нет!"),
		vision_distance = 2,
	)
	offerer.apply_status_effect(/datum/status_effect/offering/no_item_received/high_five, source, /atom/movable/screen/alert/give/highfive)

	return COMPONENT_OFFER_INTERRUPT

/// Signal proc for [COMSIG_ITEM_OFFER_TAKEN] to continue through with the high-five on take
/datum/element/high_fiver/proc/on_offer_taken(obj/item/source, mob/living/carbon/offerer, mob/living/carbon/taker)
	SIGNAL_HANDLER

	var/open_hands_taker = 0
	var/slappers_giver = 0
	// see how many hands the taker has open for high'ing
	for(var/hand in taker.held_items)
		if(isnull(hand))
			open_hands_taker++

	// see how many hands the offerer is using for high'ing
	for(var/obj/item/slap_check in offerer.held_items)
		if(slap_check.item_flags & HAND_ITEM)
			slappers_giver++

	var/high_ten = (slappers_giver >= 2)
	var/descriptor = "high-[high_ten ? "ten" : "five"]"

	if(open_hands_taker <= 0)
		to_chat(taker, span_warning("Не могу дать пять [offerer] с занятыми руками!"))
		taker.add_mood_event(descriptor, /datum/mood_event/high_five_full_hand) // not so successful now!
		return COMPONENT_OFFER_INTERRUPT

	playsound(offerer, 'sound/weapons/slap.ogg', min(50 * slappers_giver, 300), TRUE, 1)
	offerer.add_mob_memory(/datum/memory/high_five, deuteragonist = taker, high_five_type = descriptor, high_ten = high_ten)
	taker.add_mob_memory(/datum/memory/high_five, deuteragonist = offerer, high_five_type = descriptor, high_ten = high_ten)

	if(high_ten)
		offerer.visible_message(span_notice("[taker] с энтузиазмом даёт десять [offerer]!"), span_nicegreen("Вау! Даю десять [taker]!"), span_hear("Слышу звук разрывающейся плоти!"), ignored_mobs=taker)
		to_chat(taker, span_nicegreen("Даю все десять [offerer]!"))


		offerer.add_mood_event(descriptor, /datum/mood_event/high_ten)
		taker.add_mood_event(descriptor, /datum/mood_event/high_ten)
	else
		offerer.visible_message(span_notice("[taker] даёт пять [offerer]!"), span_nicegreen("Класс! Даю пять [taker]!"), span_hear("Слышу звук разрывающейся плоти!"), ignored_mobs=taker)
		to_chat(taker, span_nicegreen("Даю пять [offerer]!"))


		offerer.add_mood_event(descriptor, /datum/mood_event/high_five)
		taker.add_mood_event(descriptor, /datum/mood_event/high_five)

	offerer.remove_status_effect(/datum/status_effect/offering/no_item_received/high_five)
	return COMPONENT_OFFER_INTERRUPT
