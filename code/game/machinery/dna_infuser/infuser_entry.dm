/// A list of all infuser entries
GLOBAL_LIST_INIT(infuser_entries, prepare_infuser_entries())

/// Global proc that sets up each [/datum/infuser_entry] sub-type as singleton instances in a list, and returns it.
/proc/prepare_infuser_entries()
	var/list/entries = list()
	// Regardless of names, we want the fly/failed mutant case to show first.
	var/prepended
	for(var/datum/infuser_entry/entry_type as anything in subtypesof(/datum/infuser_entry))
		var/datum/infuser_entry/entry = new entry_type()
		if(entry.type == /datum/infuser_entry/fly)
			prepended = entry
			continue
		entries += entry
	var/list/sorted = sort_names(entries)
	sorted.Insert(1, prepended)
	return sorted

/datum/infuser_entry
	//-- Vars for DNA Infusion Book --//
	/// name of the mutant you become
	var/name = "Мутант"
	/// what you have to infuse to become it
	var/infuse_mob_name = "какой-то мутант"
	/// general desc
	var/desc = "Другие называют меня мутантом. Я предпочитаю думать о мутантах как о будущем человечества! Я могу им понадобиться."
	/// desc of what passing the threshold gets you. if this is empty, there is no threshold, so this is also really a tally of whether this is a "meme" mutant or not
	var/threshold_desc = "Моя ДНК слишком сильно мутировала. Теперь я чудовище!"
	/// List of personal attributes added by the mutation.
	var/list/qualities = list(
		"любит пиццу с ананасами",
		"вдохновляет на применение контрацептивов",
		"просто странный парень",
	)
	/// status effect type of the corresponding bonus, if it has one. tier zero won't ever set this.
	var/status_effect_type
	/// essentially how difficult it is to get this infusion, and if it will be locked behind some progression. see defines for more info
	/// ...overwrite this, please
	var/tier = DNA_MUTANT_UNOBTAINABLE

	//-- Vars for DNA Infuser Machine --//
	/// List of objects, mobs, and/or items, the machine will infuse to make output organs.
	/// Rejected creatures, of course, are anything not covered by other recipes. This is a special case
	var/list/input_obj_or_mob
	/// List of organs that the machine could spit out in relation
	var/list/output_organs
	///message the target gets while being infused
	var/infusion_desc = "mutant-like"
