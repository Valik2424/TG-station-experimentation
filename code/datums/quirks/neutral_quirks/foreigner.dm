/datum/quirk/foreigner
	name = "Мигрант"
	desc = "Не знаю галактический язык."
	icon = FA_ICON_LANGUAGE
	value = 0
	gain_text = span_notice("Не понимаю ни слова.")
	lose_text = span_notice("Удалось начать понимать основной галактический язык.")
	medical_record_text = "Пациент не разговаривает на основном галактическом языке."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.grant_language(/datum/language/uncommon, source = LANGUAGE_QUIRK)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.remove_language(/datum/language/uncommon)
