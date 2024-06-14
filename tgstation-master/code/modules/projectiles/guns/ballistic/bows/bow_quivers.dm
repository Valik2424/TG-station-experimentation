
/obj/item/storage/bag/quiver
	name = "колчан"
	desc = "Хранит стрелы для моего лука. Это очень удобно, хотя стрелы можно рассовать и по карманам, но не уверен что их будет комфортно носить при этом."
	icon = 'icons/obj/weapons/bows/quivers.dmi'
	icon_state = "quiver"
	inhand_icon_state = null
	worn_icon_state = "harpoon_quiver"
	/// type of arrow the quivel should hold
	var/arrow_path = /obj/item/ammo_casing/arrow

/obj/item/storage/bag/quiver/Initialize(mapload)
	. = ..()
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.max_slots = 40
	atom_storage.max_total_storage = 100
	atom_storage.set_holdable(list(
		/obj/item/ammo_casing/arrow,
	))

/obj/item/storage/bag/quiver/PopulateContents()
	. = ..()
	for(var/i in 1 to 10)
		new arrow_path(src)

/obj/item/storage/bag/quiver/holy
	name = "божественный колчан"
	desc = "Хранит стрелы для моего божественного лука, где они смогут дождаться подходящего времени чтобы сразить свою цель."
	icon_state = "holyquiver"
	inhand_icon_state = "holyquiver"
	worn_icon_state = "holyquiver"
	arrow_path = /obj/item/ammo_casing/arrow/holy
