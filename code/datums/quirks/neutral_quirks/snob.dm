/datum/quirk/snob
	name = "Сноб"
	desc = "Меня заботит чистый вид помещений. Если комната выглядит не такой уж и красивой, стоит ли это того?"
	icon = FA_ICON_USER_TIE
	value = 0
	gain_text = span_notice("Чуствую, как-будто знаю, как по-настоящему должны выглядеть комнаты.")
	lose_text = span_notice("Ну. Кого вообще заботят какие-то декорации?")
	medical_record_text = "Пациент демонстрирует напористость."
	mob_trait = TRAIT_SNOB
	mail_goodies = list(/obj/item/chisel, /obj/item/paint_palette)
