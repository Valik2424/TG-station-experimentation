/datum/quirk/freerunning
	name = "Паркурист"
	desc = "Могу быстрее забираться на столы, а также буду получать сниженный урон от падения."
	icon = FA_ICON_RUNNING
	value = 8
	mob_trait = TRAIT_FREERUNNING
	gain_text = span_notice("Чувствую гибкость своих ног!")
	lose_text = span_danger("Чувствую себя неуклюжим.")
	medical_record_text = "Пациент набрал большое количество очков в кардио-тестах."
	mail_goodies = list(/obj/item/melee/skateboard, /obj/item/clothing/shoes/wheelys/rollerskates)
