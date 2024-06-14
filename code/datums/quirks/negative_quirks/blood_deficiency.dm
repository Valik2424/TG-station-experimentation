/datum/quirk/blooddeficiency
	name = "Дефицит крови"
	desc = "Мой организм не будет производить достаточно крови для нормального функционирования."
	icon = FA_ICON_TINT
	value = -8
	mob_trait = TRAIT_BLOOD_DEFICIENCY
	gain_text = span_danger("Чувствую онемение.")
	lose_text = span_notice("Чувствую себя бодрым!")
	medical_record_text = " Пациенту необходима дополнительная помощь для переливания крови из-за её дефицита в организме."
	hardcore_value = 8
	mail_goodies = list(/obj/item/reagent_containers/blood/o_minus) // universal blood type that is safe for all
	var/min_blood = BLOOD_VOLUME_SAFE - 25 // just barely survivable without treatment

/datum/quirk/blooddeficiency/post_add()
	if(!ishuman(quirk_holder))
		return

	// for making sure the roundstart species has the right blood pack sent to them
	var/mob/living/carbon/human/carbon_target = quirk_holder
	carbon_target.dna.species.update_quirk_mail_goodies(carbon_target, src)

/**
 * Makes the mob lose blood from having the blood deficiency quirk, if possible
 *
 * Arguments:
 * * seconds_per_tick
 */
/datum/quirk/blooddeficiency/proc/lose_blood(seconds_per_tick)
	if(quirk_holder.stat == DEAD)
		return

	var/mob/living/carbon/human/carbon_target = quirk_holder
	if(HAS_TRAIT(carbon_target, TRAIT_NOBLOOD) && isnull(carbon_target.dna.species.exotic_blood)) //can't lose blood if your species doesn't have any
		return

	if (carbon_target.blood_volume <= min_blood)
		return
	// Ensures that we don't reduce total blood volume below min_blood.
	carbon_target.blood_volume = max(min_blood, carbon_target.blood_volume - carbon_target.dna.species.blood_deficiency_drain_rate * seconds_per_tick)
