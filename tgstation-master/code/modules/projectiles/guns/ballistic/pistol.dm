/obj/item/gun/ballistic/automatic/pistol
	name = "Пистолет Макарова"
	desc = "Небольшой пистолет калибра 9мм. На стволе есть резьба для глушителя."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m9mm
	can_suppress = TRUE
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	suppressed_sound = 'sound/weapons/gun/pistol/shot_suppressed.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 90
	bolt_wording = "передергивает затвор"
	suppressor_x_offset = 10
	suppressor_y_offset = -1

/obj/item/gun/ballistic/automatic/pistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/fire_mag
	spawn_magazine_type = /obj/item/ammo_box/magazine/m9mm/fire

/obj/item/gun/ballistic/automatic/pistol/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/item/gun/ballistic/automatic/pistol/clandestine
	name = "пистолет Ярыгина"
	desc = "Духовный наследник пистолета Макарова. Снаряжен 10мм патронами."
	icon_state = "pistol_evil"
	accepted_magazine_type = /obj/item/ammo_box/magazine/m10mm
	empty_indicator = TRUE
	suppressor_x_offset = 12

/obj/item/gun/ballistic/automatic/pistol/m1911
	name = "Кольт M1911"
	desc = "Классика галактического масштаба. Знаменит так же своим калибром .45 и небольшой вместимостью магазина."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m45
	can_suppress = FALSE
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'

/**
 * Weak 1911 for syndicate chimps. It comes in a 4 TC kit.
 * 15 damage every.. second? 7 shots to kill. Not fast.
 */
/obj/item/gun/ballistic/automatic/pistol/m1911/chimpgun
	name = "CH1M911"
	desc = "Для членов обезьян-мафиозо и приближенных к Семье. Использует патроны калибра .45 и слегка пахнет бананами."
	projectile_damage_multiplier = 0.5
	projectile_wound_bonus = -12
	pin = /obj/item/firing_pin/monkey


/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "Desert Eagle"
	desc = "Мощный пистолет .50 AE калибра."
	icon_state = "deagle"
	force = 14
	accepted_magazine_type = /obj/item/ammo_box/magazine/m50
	can_suppress = FALSE
	mag_display = TRUE
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/deagle/gold
	desc = "Позолоченный Desert Eagle созданный лучшими марсианскими оружейниками. Калибр .50 AE."
	icon_state = "deagleg"
	inhand_icon_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/camo
	desc = "Особый вид пистолетов для всех тактикульных операторов оперирующих операционно во время операций. Калибр 50 AE."
	icon_state = "deaglecamo"
	inhand_icon_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/regal
	name = "Regal Condor"
	desc = "В отличие от Desert Eagle, в этом пистолете используется особая внутренняя система стабилизации позволяющая значительно \
		уменьшить отдачу и увеличить точность, ценой использования меньшего калибра. \
		Это позволило стрелять быстрыми очередями по 2 выстрела за раз. Калибр 10мм."
	icon_state = "reagle"
	inhand_icon_state = "deagleg"
	burst_size = 2
	fire_delay = 1
	projectile_damage_multiplier = 1.25
	accepted_magazine_type = /obj/item/ammo_box/magazine/r10mm
	actions_types = list(/datum/action/item_action/toggle_firemode)
	obj_flags = UNIQUE_RENAME // if you did the sidequest, you get the customization

/obj/item/gun/ballistic/automatic/pistol/aps
	name = "Пистолет Стечкина"
	desc = "Старый советский пистолет. Высокая скорострельность ценой конской отдачи. Калибр 9мм. Ствол имеет резьбу для глушителей."
	icon_state = "aps"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m9mm_aps
	can_suppress = TRUE
	burst_size = 3
	fire_delay = 1
	spread = 10
	actions_types = list(/datum/action/item_action/toggle_firemode)
	suppressor_x_offset = 6

/obj/item/gun/ballistic/automatic/pistol/stickman
	name = "пистолетик"
	desc = "Плоский 2д пистолет...Что?"
	icon_state = "flatgun"
	mag_display = FALSE
	show_bolt_icon = FALSE

/obj/item/gun/ballistic/automatic/pistol/stickman/equipped(mob/user, slot)
	..()
	to_chat(user, span_notice("Пытаясь взять [src], упускаю его из рук..."))
	if(prob(50))
		to_chat(user, span_notice("..и теряю из виду! Куда, чёрт возьми, он запропастился?"))
		qdel(src)
		user.update_icons()
	else
		to_chat(user, span_notice("..и замечаю куда он упал. Фух, чуть не потерял."))
		user.dropItemToGround(src)
