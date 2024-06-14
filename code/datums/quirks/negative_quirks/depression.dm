/datum/quirk/depression
	name = "Депрессивный"
	desc = "Иногда я просто буду ненавидеть свою жизнь."
	icon = FA_ICON_FROWN
	mob_trait = TRAIT_DEPRESSION
	value = -3
	gain_text = span_danger("Чувствую себя депрессивным.")
	lose_text = span_notice("Больше не чувствую себя депрессивным.")  // если один это было так легко!
	medical_record_text = "Пациент имеет серьёзное психическое заболевание, в результате чего у него возникают острые эпизоды депрессии."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	hardcore_value = 2
	mail_goodies = list(/obj/item/storage/pill_bottle/happinesspsych)
