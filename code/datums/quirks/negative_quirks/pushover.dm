/datum/quirk/pushover
	name = "Неуверенный"
	desc = "Мой первый инстинкт будет позволять людям толкать меня. Вырываться из захвата будет сложнее."
	icon = FA_ICON_HANDSHAKE
	value = -8
	mob_trait = TRAIT_GRABWEAKNESS
	gain_text = span_danger("Чувствую себя неуверенно.")
	lose_text = span_notice("Теперь-то я смогу защитить себя!")
	medical_record_text = "Пациент представляет собой неуверенную и наивную личность, и им легко манипулировать."
	hardcore_value = 4
	mail_goodies = list(/obj/item/clothing/gloves/cargo_gauntlet)
