/datum/quirk/bilingual
	name = "Двуязычный"
	desc = "За столько лет я выучил новый язык!"
	icon = FA_ICON_GLOBE
	value = 4
	gain_text = span_notice("Некоторые слова людей вокруг вас определенно необычные. Хорошо, что я могу их понимать.")
	lose_text = span_notice("Похоже, я забыл свой второй язык.")
	medical_record_text = "Пациент говорит на нескольких языках."
	mail_goodies = list(/obj/item/taperecorder, /obj/item/clothing/head/frenchberet, /obj/item/clothing/mask/fakemoustache/italian)

/datum/quirk/bilingual/add_unique(client/client_source)
	var/wanted_language = client_source?.prefs.read_preference(/datum/preference/choiced/language)
	var/datum/language/language_type
	if(wanted_language == "Random")
		language_type = pick(GLOB.uncommon_roundstart_languages)
	else
		language_type = GLOB.language_types_by_name[wanted_language]
	if(quirk_holder.has_language(language_type))
		language_type = /datum/language/uncommon
		if(quirk_holder.has_language(language_type))
			to_chat(quirk_holder, span_boldnotice("Я уже знаю этот язык."))
			return
		to_chat(quirk_holder, span_boldnotice("Уже знаю этот язык, поэтому учу Галактический Необычный."))
	quirk_holder.grant_language(language_type, source = LANGUAGE_QUIRK)
