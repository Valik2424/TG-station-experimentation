/datum/quirk/heavy_sleeper
	name = "Крепкий сон"
	desc = "Буду крепко спать. Время на пробуждение будет слегка увеличено."
	icon = FA_ICON_BED
	value = -2
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = span_danger("Чувствую себя вялым.")
	lose_text = span_notice("Вновь чувствую себя бодрым!")
	medical_record_text = "Пациент имеет отрицательные результаты качества сна и его трудно разбудить."
	hardcore_value = 2
	mail_goodies = list(
		/obj/item/clothing/glasses/blindfold,
		/obj/item/bedsheet/random,
		/obj/item/clothing/under/misc/pj/red,
		/obj/item/clothing/head/costume/nightcap/red,
		/obj/item/clothing/under/misc/pj/blue,
		/obj/item/clothing/head/costume/nightcap/blue,
		/obj/item/pillow/random,
	)
