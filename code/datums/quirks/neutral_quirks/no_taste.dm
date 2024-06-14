/datum/quirk/no_taste
	name = "Агевзия"
	desc = "Теряю свои вкусовые рецепторы и больше не смогу ощущать вкус еды. Токсичная пища всё ещё будет отравлять меня."
	icon = FA_ICON_MEH_BLANK
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = span_notice("Больше не чувствую вкус еды!")
	lose_text = span_notice("Теперь можно почувствовать вкус еды!")
	medical_record_text = "Пациент страдает от агавзии и неспособен чувствовать вкус еды или жидкости."
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/condiment) // but can you taste the salt? CAN YOU?!
