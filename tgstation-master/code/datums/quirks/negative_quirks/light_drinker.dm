/datum/quirk/light_drinker
	name = "Трезвенник"
	desc = "Я трезвенник. Влияние на меня от алкоголя будет увеличено."
	icon = FA_ICON_COCKTAIL
	value = -2
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = span_notice("Даже мысль об алкоголе заставляет вашу голову кружиться.")
	lose_text = span_danger("Чувствую себя более устойчивее к алкоголю.")
	medical_record_text = "Пациент демонстрирует низкую устойчивость к алкоголю."
	hardcore_value = 3
	mail_goodies = list(/obj/item/reagent_containers/cup/glass/waterbottle)
