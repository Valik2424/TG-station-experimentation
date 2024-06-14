/datum/quirk/item_quirk/clown_enjoyer
	name = "Фанат клоунов"
	desc = "Меня веселят клоуны. Моё настроение повышается, если я ношу на груди значок с их изображением."
	icon = FA_ICON_MAP_PIN
	value = 2
	mob_trait = TRAIT_CLOWN_ENJOYER
	gain_text = span_notice("Теперь я большой фанат клоунов.")
	lose_text = span_danger("Мне кажется, что клоуны-то не особо смешны...")
	medical_record_text = "Пациент утверждает, что он является фанатом клоунов."
	mail_goodies = list(
		/obj/item/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/megaphone/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/bedsheet/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/storage/backpack/clown,
		/obj/item/storage/backpack/duffelbag/clown,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/figure/clown,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/bz,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/helium,
	)

/datum/quirk/item_quirk/clown_enjoyer/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/clown_enjoyer_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/clown_enjoyer/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)
