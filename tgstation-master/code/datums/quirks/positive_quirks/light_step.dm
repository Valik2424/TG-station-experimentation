/datum/quirk/light_step
	name = "Легкий шаг"
	desc = "Буду ходить аккуратно; буду нежнее наступать на осколки, а наносимый урон от этого будет меньше. Также не оставляю после себя следов."
	icon = FA_ICON_SHOE_PRINTS
	value = 4
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = span_notice("Хожу с немного большей гибкостью.")
	lose_text = span_danger("Начинаю делать такие шаги, словно какой-то варвар.")
	medical_record_text = "Пациент демонстрирует хорошо развитые стопы."
	mail_goodies = list(/obj/item/clothing/shoes/sandal)
