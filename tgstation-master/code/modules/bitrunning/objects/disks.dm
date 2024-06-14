/**
 * Bitrunning tech disks which let you load items or programs into the vdom on first avatar generation.
 * For the record: Balance shouldn't be a primary concern.
 * You can make the custom cheese spells you've always wanted.
 * Just make it fun and engaging, it's PvE content.
 */
/obj/item/bitrunning_disk
	name = "стандартная битраннерская программа"
	desc = "Диск, содержащий исходный код."
	icon = 'icons/obj/assemblies/module.dmi'
	base_icon_state = "datadisk"
	icon_state = "datadisk0"
	/// Name of the choice made
	var/choice_made

/obj/item/bitrunning_disk/Initialize(mapload)
	. = ..()

	icon_state = "[base_icon_state][rand(0, 7)]"
	update_icon()
	RegisterSignal(src, COMSIG_ATOM_EXAMINE, PROC_REF(on_examined))

/obj/item/bitrunning_disk/proc/on_examined(datum/source, mob/examiner, list/examine_text)
	SIGNAL_HANDLER

	examine_text += span_infoplain("Диск должен быть у пользователя перед заходом в сетевой под для получения снаряжения.")

	if(isnull(choice_made))
		examine_text += span_notice("Для выбора используйте диск в руке.")
		return

	examine_text += span_info("Он был использован чтобы получить: <b>[choice_made]</b>.")
	examine_text += span_notice("Он не может сделать другой выбор.")

/obj/item/bitrunning_disk/ability
	desc = "Диск, содержащий исходный код. Он может быть использован чтобы загрузить способности в виртуальный домен."
	/// The selected ability that this grants
	var/datum/action/granted_action
	/// The list of actions that this can grant
	var/list/datum/action/selectable_actions = list()

/obj/item/bitrunning_disk/ability/attack_self(mob/user, modifiers)
	. = ..()

	if(choice_made)
		return

	var/names = list()
	for(var/datum/action/thing as anything in selectable_actions)
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "Выбери способность",  title = "Битраннерская программа", items = names)
	if(isnull(choice))
		return

	for(var/datum/action/thing as anything in selectable_actions)
		if(initial(thing.name) == choice)
			granted_action = thing

	if(isnull(granted_action))
		return

	balloon_alert(user, "выбрано")
	playsound(user, 'sound/items/click.ogg', 50, TRUE)
	choice_made = choice

/// Tier 1 programs. Simple, funny, or helpful.
/obj/item/bitrunning_disk/ability/tier1
	name = "битраннерская программа: обычная"
	selectable_actions = list(
		/datum/action/cooldown/spell/conjure/cheese,
		/datum/action/cooldown/spell/basic_heal,
	)

/// Tier 2 programs. More complex, powerful, or useful.
/obj/item/bitrunning_disk/ability/tier2
	name = "битраннерская программа: сложная"
	selectable_actions = list(
		/datum/action/cooldown/spell/pointed/projectile/fireball,
		/datum/action/cooldown/spell/pointed/projectile/lightningbolt,
		/datum/action/cooldown/spell/forcewall,
	)

/// Tier 3 abilities. Very powerful, game breaking.
/obj/item/bitrunning_disk/ability/tier3
	name = "битраннерская программа: элитная"
	selectable_actions = list(
		/datum/action/cooldown/spell/shapeshift/dragon,
		/datum/action/cooldown/spell/shapeshift/polar_bear,
	)

/obj/item/bitrunning_disk/item
	desc = "Диск, содержащий исходный код. Он может быть использован чтобы загрузить предметы в виртуальный домен."
	/// The selected item that this grants
	var/obj/granted_item
	/// The list of actions that this can grant
	var/list/obj/selectable_items = list()

/obj/item/bitrunning_disk/item/attack_self(mob/user, modifiers)
	. = ..()

	if(choice_made)
		return

	var/names = list()
	for(var/obj/thing as anything in selectable_items)
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "Выбери способность",  title = "Битраннерская программа", items = names)
	if(isnull(choice))
		return

	for(var/obj/thing as anything in selectable_items)
		if(initial(thing.name) == choice)
			granted_item = thing

	balloon_alert(user, "выбрана")
	playsound(user, 'sound/items/click.ogg', 50, TRUE)
	choice_made = choice

/// Tier 1 items. Simple, funny, or helpful.
/obj/item/bitrunning_disk/item/tier1
	name = "битраннерское снаряжение: простое"
	selectable_items = list(
		/obj/item/pizzabox/infinite,
		/obj/item/gun/medbeam,
		/obj/item/grenade/c4,
	)

/// Tier 2 items. More complex, powerful, or useful.
/obj/item/bitrunning_disk/item/tier2
	name = "битраннерское снаряжение: сложное"
	selectable_items = list(
		/obj/item/chainsaw,
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/melee/energy/blade/hardlight,
	)

/// Tier 3 items. Very powerful, game breaking.
/obj/item/bitrunning_disk/item/tier3
	name = "битраннерское снаряжение: элитное"
	selectable_items = list(
		/obj/item/gun/energy/tesla_cannon,
		/obj/item/dualsaber/green,
		/obj/item/melee/beesword,
	)