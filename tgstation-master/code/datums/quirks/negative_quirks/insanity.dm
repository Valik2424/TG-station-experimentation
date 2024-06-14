/datum/quirk/insanity
	name = "Синдром Диссоциации Реальности"
	desc = "Страдаете от серьёзного психического расстройства, которое вызывает очень сильные галлюцинации. Вещество \"Майндбрейкер\" поможет мне подавить эти эффекты. <b>Это не является лицензией на убийство</b>"
	icon = FA_ICON_GRIN_TONGUE_WINK
	value = -8
	gain_text = span_userdanger("...")
	lose_text = span_notice("Чувствую себя нормальным..")
	medical_record_text = "Пациент страдает от Синдрома Диссоциации Реальности, вызывающее у него тяжелые галлюцинации."
	hardcore_value = 6
	mail_goodies = list(/obj/item/storage/pill_bottle/lsdpsych)
	/// Weakref to the trauma we give out
	var/datum/weakref/added_trama_ref

/datum/quirk/insanity/add(client/client_source)
	if(!iscarbon(quirk_holder))
		return
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder

	// Setup our special RDS mild hallucination.
	// Not a unique subtype so not to plague subtypesof,
	// also as we inherit the names and values from our quirk.
	var/datum/brain_trauma/mild/hallucinations/added_trauma = new()
	added_trauma.resilience = TRAUMA_RESILIENCE_ABSOLUTE
	added_trauma.name = name
	added_trauma.desc = medical_record_text
	added_trauma.scan_desc = lowertext(name)
	added_trauma.gain_text = null
	added_trauma.lose_text = null

	carbon_quirk_holder.gain_trauma(added_trauma)
	added_trama_ref = WEAKREF(added_trauma)

/datum/quirk/insanity/post_add()
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Учтите, что ваш синдром диссоциации НЕ даёт права нападать на других людей, или каким-нибудь образом портить раунд окружающим. \
Вы не антагонист, и правила игры все еще действуют на вас, как на остальных игроков.</span>")

/datum/quirk/insanity/remove()
	QDEL_NULL(added_trama_ref)
