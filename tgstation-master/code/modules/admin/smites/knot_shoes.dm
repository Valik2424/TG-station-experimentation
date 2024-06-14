/// Ties the target's shoes
/datum/smite/knot_shoes
	name = "Knot Shoes"

/datum/smite/knot_shoes/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("Это можно использовать только на /mob/living/carbon."), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	var/obj/item/clothing/shoes/sick_kicks = dude.shoes
	if (!sick_kicks?.can_be_tied)
		to_chat(user, span_warning("У его обуви нет шнурков!"), confidential = TRUE)
		return
	sick_kicks.adjust_laces(SHOES_KNOTTED)
