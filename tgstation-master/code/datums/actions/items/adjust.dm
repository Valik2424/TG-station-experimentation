/datum/action/item_action/adjust
	name = "Поправить"

/datum/action/item_action/adjust/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Поправить [item_target.name]"
