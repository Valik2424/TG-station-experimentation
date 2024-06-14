
///basic bow, used for medieval sim
/obj/item/gun/ballistic/bow/longbow
	name = "длинный лук"
	desc = "Великолепно изготовленный лук мог бы стать предметом гордости владельца лет так 1000 назад. В наше время стоит найти что-то получше."

///chaplain's divine archer bow
/obj/item/gun/ballistic/bow/divine
	name = "божественный лук"
	desc = "Святое оружие для уничтожения душ грешников."
	icon_state = "holybow"
	inhand_icon_state = "holybow"
	base_icon_state = "holybow"
	worn_icon_state = "holybow"
	slot_flags = ITEM_SLOT_BACK
	obj_flags = UNIQUE_RENAME
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/bow/holy

/obj/item/ammo_box/magazine/internal/bow/holy
	name = "божественная тетива"
	ammo_type = /obj/item/ammo_casing/arrow/holy

/obj/item/gun/ballistic/bow/divine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY)
	AddComponent(/datum/component/effect_remover, \
		success_feedback = "Вы разрушаете магию %THEEFFECT из %THEWEAPON.", \
		success_forcesay = "ТЫ НЕ ПРОЙДЕШЬ!!", \
		tip_text = "Очистить руну", \
		on_clear_callback = CALLBACK(src, PROC_REF(on_cult_rune_removed)), \
		effects_we_clear = list(/obj/effect/rune, /obj/effect/heretic_rune) \
	)
	AddElement(/datum/element/bane, target_type = /mob/living/basic/revenant, damage_multiplier = 0, added_damage = 25, requires_combat_mode = FALSE)

/obj/item/gun/ballistic/bow/divine/proc/on_cult_rune_removed(obj/effect/target, mob/living/user)
	SIGNAL_HANDLER
	if(!istype(target, /obj/effect/rune))
		return

	var/obj/effect/rune/target_rune = target
	if(target_rune.log_when_erased)
		user.log_message("стёр [target_rune.cultist_name] руну с помощью [src]", LOG_GAME)
	SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_NARNAR] = TRUE

/obj/item/gun/ballistic/bow/divine/with_quiver/Initialize(mapload)
	. = ..()
	new /obj/item/storage/bag/quiver/holy(loc)
