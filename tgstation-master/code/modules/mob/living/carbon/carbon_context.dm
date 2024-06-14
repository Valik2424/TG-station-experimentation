/mob/living/carbon/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if (!isnull(held_item))
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Дать предмет"
		return CONTEXTUAL_SCREENTIP_SET

	if (!ishuman(user))
		return .

	var/mob/living/carbon/human/human_user = user

	if (human_user.combat_mode)
		context[SCREENTIP_CONTEXT_LMB] = "Ударить"
	else if (human_user == src)
		context[SCREENTIP_CONTEXT_LMB] = "Проверить раны"

		if (get_bodypart(human_user.zone_selected)?.get_modified_bleed_rate())
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Взять конечность"

	if (human_user != src)
		context[SCREENTIP_CONTEXT_RMB] = "Толкнуть"

		if (!human_user.combat_mode)
			if (body_position == STANDING_UP)
				if(check_zone(user.zone_selected) == BODY_ZONE_HEAD && get_bodypart(BODY_ZONE_HEAD))
					context[SCREENTIP_CONTEXT_LMB] = "Погладить по голове"
				else if(user.zone_selected == BODY_ZONE_PRECISE_GROIN && !isnull(get_organ_by_type(/obj/item/organ/external/tail)))
					context[SCREENTIP_CONTEXT_LMB] = "Потянуть за хвост"
				else
					context[SCREENTIP_CONTEXT_LMB] = "Обнять"
			else if (health >= 0 && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
				context[SCREENTIP_CONTEXT_LMB] = "Поднять"
			else
				context[SCREENTIP_CONTEXT_LMB] = "СЛР"

	return CONTEXTUAL_SCREENTIP_SET
