/datum/quirk/item_quirk/tagger
	name = "Граффер"
	desc = "В прошлом, довольно часто доводилось заниматься рисованием граффити. Буду экономно расходовать количество использований баллончика."
	icon = FA_ICON_SPRAY_CAN
	value = 4
	mob_trait = TRAIT_TAGGER
	gain_text = span_notice("Знаю, как эффективно расходовать баллончик.")
	lose_text = span_danger("Забываю, как правильно расходовать баллончик.")
	medical_record_text = "Пациент был недавно замечен за рисованием граффити на стене."
	mail_goodies = list(
		/obj/item/toy/crayon/spraycan,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_twentythree
	)

/datum/quirk/item_quirk/tagger/add_unique(client/client_source)
	var/obj/item/toy/crayon/spraycan/can = new
	can.set_painting_tool_color(client_source?.prefs.read_preference(/datum/preference/color/paint_color))
	give_item_to_holder(can, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
