/datum/quirk/item_quirk/colorist
	name = "Колорист"
	desc = "Обожаю перекрашивать свои и чужие волосы, поэтому ношу с собой краску и делаю это быстро!"
	icon = FA_ICON_FILL_DRIP
	value = 0
	medical_record_text = "Пациенту нравится перекрашивать свою причёску в разные цвета."
	mail_goodies = list(/obj/item/dyespray)

/datum/quirk/item_quirk/colorist/add_unique(client/client_source)
	give_item_to_holder(/obj/item/dyespray, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
