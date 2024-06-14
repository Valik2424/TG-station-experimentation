/datum/action/item_action/zipper
	name = "Открыть вещмешок"
	desc = "Открыть вещмешок, чтобы получить доступ к его содержимому."

/datum/action/item_action/zipper/New(Target)
	. = ..()
	RegisterSignal(target, COMSIG_DUFFEL_ZIP_CHANGE, PROC_REF(on_zip_change))
	var/obj/item/storage/backpack/duffelbag/duffle_target = target
	on_zip_change(target, duffle_target.zipped_up)

/datum/action/item_action/zipper/proc/on_zip_change(datum/source, new_zip)
	SIGNAL_HANDLER
	if(new_zip)
		name = "Открыть"
		desc = "Открыть вещмешок, чтобы получить доступ к его содержимому."
	else
		name = "Закрыть"
		desc = "Закрыть вещмешок, чтобы перемещаться быстрее."
	build_all_button_icons(UPDATE_BUTTON_NAME)
