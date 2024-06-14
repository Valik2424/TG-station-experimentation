/datum/mutation/human/self_amputation
	name = "Аутотомия"
	desc = "Позволяет существу добровольно сбросить выбранную часть тела по своему желанию."
	quality = POSITIVE
	text_gain_indication = span_notice("У меня такое ощущение что моя рука вот-вот отвалится...")
	instability = 30
	power_path = /datum/action/cooldown/spell/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/self_amputation
	name = "Сброс конечности"
	desc = "Благодаря геному ящера и позволяет сбросить конечность в случае опасности, а также вырастить новую."
	button_icon_state = "autotomy"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/self_amputation/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/self_amputation/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice("Сосредотачиваюсь, но ничего не происходит."))
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/to_remove as anything in cast_on.bodyparts)
		if(to_remove.body_zone == BODY_ZONE_HEAD || to_remove.body_zone == BODY_ZONE_CHEST)
			continue
		if(to_remove.bodypart_flags & BODYPART_UNREMOVABLE)
			continue
		parts += to_remove

	if(!length(parts))
		to_chat(cast_on, span_notice("Я не могу сбросить больше конечностей!"))
		return

	var/obj/item/bodypart/to_remove = pick(parts)
	to_remove.dismember()
