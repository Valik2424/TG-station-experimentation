/datum/quirk/friendly
	name = "Дружелюбный"
	desc = "Я умею обниматься, особенно это будет заметно при повышенном настроении."
	icon = FA_ICON_HANDS_HELPING
	value = 2
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("Хочу кого-нибудь обнять.")
	lose_text = span_danger("Больше не чувствую необходимость обнимать кого-то.")
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациент демонстрирует довольно низкие ограничения физического контакта."
	mail_goodies = list(/obj/item/storage/box/hug)
