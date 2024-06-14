/datum/quirk/alcohol_tolerance
	name = "Устойчивость к алкоголю"
	desc = "Пьянею медленнее и на меня меньше действует алкоголь."
	icon = FA_ICON_BEER
	value = 4
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = span_notice("Чувствую, что с лёгкостью могу выпить целую бутылку!")
	lose_text = span_danger("Больше не чувствую свою стойкость к алкоголю. Как-то.")
	medical_record_text = "Пациент демонстрирует сильную устойчивость к алкоголю."
	mail_goodies = list(/obj/item/skillchip/wine_taster)
