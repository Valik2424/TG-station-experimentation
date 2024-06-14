/datum/quirk/apathetic
	name = "Апатичный"
	desc = "Влияние на ваше настроение будет слегка уменьшено."
	icon = FA_ICON_MEH
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациенту было назначено проверить свою Шкалу Оценки Апатии, но он даже не начинал её..."
	mail_goodies = list(/obj/item/hourglass)

/datum/quirk/apathetic/add(client/client_source)
	quirk_holder.mob_mood?.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	quirk_holder.mob_mood?.mood_modifier += 0.2
