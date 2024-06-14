#define GONDOLA_ORGAN_COLOR "#7a503d"
#define GONDOLA_SCLERA_COLOR "#000000"
#define GONDOLA_PUPIL_COLOR "#000000"
#define GONDOLA_COLORS GONDOLA_ORGAN_COLOR + GONDOLA_SCLERA_COLOR + GONDOLA_PUPIL_COLOR

/*
Fluoride Stare: After someone says 5 words, blah blah blah...
*/

///bonus of the observing gondola: you can ignore environmental hazards
/datum/status_effect/organ_set_bonus/gondola
	id = "organ_set_bonus_gondola"
	organs_needed = 3
	bonus_activate_text = span_notice("ДНК гондолы теперь часть меня! Я - абсолютный наблюдатель, не обращающий внимания на окружающую обстановку!")
	bonus_deactivate_text = span_notice("Моя ДНК стала обычной. Я больше не могу игнорировать окружающую обстановку.")
	bonus_traits = list(TRAIT_RESISTHEAT, TRAIT_RESISTCOLD, TRAIT_NOBREATH, TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE)

/// makes you a pacifist and turns most mobs neutral towards you
/obj/item/organ/internal/heart/gondola
	name = "сердце гондолы"
	desc = "ДНК гондолы внедрена в то, что когда-то было обычным сердцем"

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS
	organ_traits = list(TRAIT_PACIFISM)
	///keeps track of whether the reciever actually gained factions
	var/list/factions_to_remove = list()

/obj/item/organ/internal/heart/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)
	AddElement(/datum/element/noticable_organ, "тело изулучает ауру спокойствия.", BODY_ZONE_CHEST)

/obj/item/organ/internal/heart/gondola/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	if(!(FACTION_HOSTILE in receiver.faction))
		factions_to_remove += FACTION_HOSTILE
	if(!(FACTION_MINING in receiver.faction))
		factions_to_remove += FACTION_MINING
	receiver.faction |= list(FACTION_HOSTILE, FACTION_MINING)

/obj/item/organ/internal/heart/gondola/Remove(mob/living/carbon/heartless, special)
	. = ..()
	for(var/faction in factions_to_remove)
		heartless.faction -= faction
	//reset this for a different target
	factions_to_remove = list()

/// Zen (tounge): You can no longer speak, but get a powerful positive moodlet
/obj/item/organ/internal/tongue/gondola
	name = "язык гондолы"
	desc = "ДНК гондолы внедрена в то, что когда-то было обычным языком."
	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "tongue"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS
	organ_traits = list(TRAIT_MUTE)

/obj/item/organ/internal/tongue/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "лицо расплывается в постоянной улыбке.", BODY_ZONE_PRECISE_MOUTH)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)

/obj/item/organ/internal/tongue/gondola/Insert(mob/living/carbon/tongue_owner, special, drop_if_replaced)
	. = ..()
	tongue_owner.add_mood_event("gondola_zen", /datum/mood_event/gondola_serenity)

/obj/item/organ/internal/tongue/gondola/Remove(mob/living/carbon/tongue_owner, special)
	tongue_owner.clear_mood_event("gondola_zen")
	return ..()

/// Loving arms: your hands become unable to hold much of anything but your hugs now infuse the subject with pax.
/obj/item/organ/internal/liver/gondola
	name = "печень гондолы"
	desc = "ДНК гондолы внедрена в то, что когда-то было обычной печенью."
	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "liver"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS
	/// instance of the martial art granted on insertion
	var/datum/martial_art/hugs_of_the_gondola/pax_hugs

/obj/item/organ/internal/liver/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)
	AddElement(/datum/element/noticable_organ, "левая рука покрыта маленькими иголками.", BODY_ZONE_L_ARM)
	AddElement(/datum/element/noticable_organ, "правая рука покрыта маленькими иголками.", BODY_ZONE_R_ARM)
	pax_hugs = new

/obj/item/organ/internal/liver/gondola/Insert(mob/living/carbon/liver_owner, special, drop_if_replaced)
	. = ..()
	var/has_left = liver_owner.has_left_hand(check_disabled = FALSE)
	var/has_right = liver_owner.has_right_hand(check_disabled = FALSE)
	if(has_left && has_right)
		to_chat(liver_owner, span_warning("Я чувствую, как ослабевают мои руки, когда на них вырастают маленькие иголки!"))
	else if(has_left || has_right)
		to_chat(liver_owner, span_warning("Я чувствую, как ослабевает моя рука, когда на ней вырастают маленькие иголки!"))
	else
		to_chat(liver_owner, span_warning("Я чувствую, как что-то произошло бы с моими руками... если бы они у меня еще были."))
	to_chat(liver_owner, span_notice("Обнимая цель, вы успокаиваете ее, но больше не сможете ничего нести."))
	pax_hugs.teach(liver_owner)
	RegisterSignal(liver_owner, COMSIG_HUMAN_EQUIPPING_ITEM, PROC_REF(on_owner_equipping_item))
	RegisterSignal(liver_owner, COMSIG_LIVING_TRY_PULL, PROC_REF(on_owner_try_pull))

/obj/item/organ/internal/liver/gondola/Remove(mob/living/carbon/liver_owner, special)
	. = ..()
	pax_hugs.remove(liver_owner)
	UnregisterSignal(liver_owner, list(COMSIG_HUMAN_EQUIPPING_ITEM, COMSIG_LIVING_TRY_PULL))

/// signal sent when prompting if an item can be equipped
/obj/item/organ/internal/liver/gondola/proc/on_owner_equipping_item(mob/living/carbon/human/owner, obj/item/equip_target, slot)
	SIGNAL_HANDLER
	if(equip_target.w_class > WEIGHT_CLASS_TINY)
		equip_target.balloon_alert(owner, "не могу удержать это!")
		return COMPONENT_BLOCK_EQUIP

/// signal sent when owner tries to pull an item
/obj/item/organ/internal/liver/gondola/proc/on_owner_try_pull(mob/living/carbon/owner, atom/movable/target, force)
	SIGNAL_HANDLER
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.mob_size > MOB_SIZE_TINY)
			living_target.balloon_alert(owner, "слишком тяжело, чтобы тащить!")
			return COMSIG_LIVING_CANCEL_PULL
	if(isitem(target))
		var/obj/item/item_target = target
		if(item_target.w_class > WEIGHT_CLASS_TINY)
			item_target.balloon_alert(owner, "слишком тяжело, чтобы тащить!")
			return COMSIG_LIVING_CANCEL_PULL

#undef GONDOLA_ORGAN_COLOR
#undef GONDOLA_SCLERA_COLOR
#undef GONDOLA_PUPIL_COLOR
#undef GONDOLA_COLORS
