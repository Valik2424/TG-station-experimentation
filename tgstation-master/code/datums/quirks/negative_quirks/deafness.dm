/datum/quirk/item_quirk/deafness
	name = "Глухонемой"
	desc = "Я перестану слышать какие-либо звуки."
	icon = FA_ICON_DEAF
	value = -8
	mob_trait = TRAIT_DEAF
	gain_text = span_danger("Не могу слышать.")
	lose_text = span_notice("Теперь я снова слышу!")
	medical_record_text = "Ушная улитка пациента повреждена и не подвергается лечению."
	hardcore_value = 12
	mail_goodies = list(/obj/item/clothing/mask/whistle)

/datum/quirk/item_quirk/deafness/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/deaf_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
