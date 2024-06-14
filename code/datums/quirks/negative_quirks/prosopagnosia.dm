/datum/quirk/prosopagnosia
	name = "Прозопагнозия"
	desc = "Я не смогу больше распознавать лица."
	icon = FA_ICON_USER_SECRET
	value = -4
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Пациент страдает от прозопагнозии и не может узнать лица."
	hardcore_value = 5
	mail_goodies = list(/obj/item/skillchip/appraiser) // bad at recognizing faces but good at recognizing IDs
