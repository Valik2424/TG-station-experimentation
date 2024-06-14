/datum/quirk/item_quirk/musician
	name = "Музыкант"
	desc = "Смогу настраивать музыкальные инструменты таким образом, что мелодия будет снимать определенные негативные эффекты у окружающих и успокаивать душу."
	icon = FA_ICON_GUITAR
	value = 2
	mob_trait = TRAIT_MUSICIAN
	gain_text = span_notice("Знаю всё о музыкальных инструментах.")
	lose_text = span_danger("Забываю, как работают музыкальные инструменты.")
	medical_record_text = "Сканирование мозга пациента показывает высокоразвитые слуховые мышцы."
	mail_goodies = list(/obj/effect/spawner/random/entertainment/musical_instrument, /obj/item/instrument/piano_synth/headphones)

/datum/quirk/item_quirk/musician/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/music, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
