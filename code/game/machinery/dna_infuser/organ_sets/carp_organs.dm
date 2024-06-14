#define CARP_ORGAN_COLOR "#4caee7"
#define CARP_SCLERA_COLOR "#ffffff"
#define CARP_PUPIL_COLOR "#00b1b1"
#define CARP_COLORS CARP_ORGAN_COLOR + CARP_SCLERA_COLOR + CARP_PUPIL_COLOR

///bonus of the carp: you can swim through space!
/datum/status_effect/organ_set_bonus/carp
	id = "organ_set_bonus_carp"
	organs_needed = 4
	bonus_activate_text = span_notice("ДНК карпа теперь часть меня! Теперь я могу \"плавать\" в космосе!")
	bonus_deactivate_text = span_notice("Моя ДНК стала обычной и теперь я не могу \"плавать\" в космосе...")
	bonus_traits = list(TRAIT_SPACEWALK)

///Carp lungs! You can breathe in space! Oh... you can't breathe on the station, you need low oxygen environments.
/// Inverts behavior of lungs. Bypasses suffocation due to space / lack of gas, but also allows Oxygen to suffocate.
/obj/item/organ/internal/lungs/carp
	name = "легкие карпа"
	desc = "ДНК карпа внедрена в то, что когда-то было обычными легкими."
	// Oxygen causes suffocation.
	safe_oxygen_min = 0
	safe_oxygen_max = 15

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "lungs"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

/obj/item/organ/internal/lungs/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "шея покрыта странными жабрами.", BODY_ZONE_HEAD)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)
	ADD_TRAIT(src, TRAIT_SPACEBREATHING, REF(src))

///occasionally sheds carp teeth, stronger melee (bite) attacks, but you can't cover your mouth anymore.
/obj/item/organ/internal/tongue/carp
	name = "челюсти карпа"
	desc = "ДНК карпа внедрена в то, что когда-то было обычными зубами."
	say_mod = "gnashes"

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "tongue"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

/obj/item/organ/internal/tongue/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "зубы выглядят большими и острыми.", BODY_ZONE_PRECISE_MOUTH)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)

/obj/item/organ/internal/tongue/carp/on_insert(mob/living/carbon/tongue_owner)
	. = ..()
	if(!ishuman(tongue_owner))
		return
	var/mob/living/carbon/human/human_receiver = tongue_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(tongue_owner, rec_species.no_equip_flags | ITEM_SLOT_MASK)
	var/obj/item/bodypart/head/head = human_receiver.get_bodypart(BODY_ZONE_HEAD)
	head.unarmed_damage_low = 10
	head.unarmed_damage_high = 15
	head.unarmed_stun_threshold = 15

/obj/item/organ/internal/tongue/carp/on_remove(mob/living/carbon/tongue_owner)
	. = ..()
	if(!ishuman(tongue_owner))
		return
	var/mob/living/carbon/human/human_receiver = tongue_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(tongue_owner, initial(rec_species.no_equip_flags))
	var/obj/item/bodypart/head/head = human_receiver.get_bodypart(BODY_ZONE_HEAD)
	head.unarmed_damage_low = initial(head.unarmed_damage_low)
	head.unarmed_damage_high = initial(head.unarmed_damage_high)
	head.unarmed_stun_threshold = initial(head.unarmed_stun_threshold)

/obj/item/organ/internal/tongue/carp/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(owner.stat != CONSCIOUS || !prob(0.1))
		return
	owner.emote("cough")
	var/turf/tooth_fairy = get_turf(owner)
	if(tooth_fairy)
		new /obj/item/knife/carp(tooth_fairy)

/obj/item/knife/carp
	name = "зуб карпа"
	desc = "Выглядят как клыки. Достаточно острые, чтобы выколоть глаз."
	icon_state = "carptooth"

///carp brain. you need to occasionally go to a new zlevel. think of it as... walking your dog!
/obj/item/organ/internal/brain/carp
	name = "мозг карпа"
	desc = "ДНК карпа внедрена в то, что когда-то был нормальным мозгом."

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "brain"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

	///Timer counting down. When finished, the owner gets a bad moodlet.
	var/cooldown_timer
	///how much time the timer is given
	var/cooldown_time = 10 MINUTES

/obj/item/organ/internal/brain/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)
	AddElement(/datum/element/noticable_organ, "не может устоять на месте.")

/obj/item/organ/internal/brain/carp/on_insert(mob/living/carbon/brain_owner)
	. = ..()
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(unsatisfied_nomad)), cooldown_time, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE)
	RegisterSignal(brain_owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(satisfied_nomad))

//technically you could get around the mood issue by extracting and reimplanting the brain but it will be far easier to just go one z there and back
/obj/item/organ/internal/brain/carp/on_remove(mob/living/carbon/brain_owner)
	. = ..()
	UnregisterSignal(brain_owner, COMSIG_MOVABLE_Z_CHANGED)
	deltimer(cooldown_timer)

/obj/item/organ/internal/brain/carp/get_attacking_limb(mob/living/carbon/human/target)
	return owner.get_bodypart(BODY_ZONE_HEAD)

/obj/item/organ/internal/brain/carp/proc/unsatisfied_nomad()
	owner.add_mood_event("nomad", /datum/mood_event/unsatisfied_nomad)

/obj/item/organ/internal/brain/carp/proc/satisfied_nomad()
	SIGNAL_HANDLER
	owner.clear_mood_event("nomad")
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(unsatisfied_nomad)), cooldown_time, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE)

/// makes you cold resistant, but heat-weak.
/obj/item/organ/internal/heart/carp
	name = "сердце карпа"
	desc = "ДНК карпа внедрена в то, что когда-то было нормальным сердцем."

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

	organ_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTLOWPRESSURE)

/obj/item/organ/internal/heart/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "кожа покрыта небольшой чешуёй.", BODY_ZONE_CHEST)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)

#undef CARP_ORGAN_COLOR
#undef CARP_SCLERA_COLOR
#undef CARP_PUPIL_COLOR
#undef CARP_COLORS
