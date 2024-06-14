/obj/item/gun/ballistic/automatic/toy
	name = "игрушечный пистолет-пулемет"
	desc = "Пистолет-пулемет стреляющий трехзарядными очередями. Для детей от 8 лет."
	icon_state = "saber"
	selector_switch_icon = TRUE
	inhand_icon_state = "gun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/items/syringeproj.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = TRUE
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/pistol/toy
	name = "игрушечный пистолет"
	desc = "Маленький игрушечный пистолетик. Для детей от 8 лет."
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/items/syringeproj.ogg'
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/automatic/pistol/toy/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/gun/ballistic/automatic/pistol/riot/Initialize(mapload)
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	return ..()

/obj/item/gun/ballistic/shotgun/toy
	name = "игрушечный дробовик"
	desc = "Игрушечный дробовик с деревянным прикладом и цевьем. Вмещает в себя 4 пенных дротика. Для детей от 8 лет."
	force = 0
	throwforce = 0
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	casing_ejector = FALSE
	can_suppress = FALSE
	weapon_weight = WEAPON_LIGHT
	pb_knockback = 0
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/shotgun/toy/handle_chamber()
	. = ..()
	if(chambered && !chambered.loaded_projectile)
		qdel(chambered)

/obj/item/gun/ballistic/shotgun/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/shotgun/toy/crossbow
	name = "игрушечный арбалет"
	desc = "Любимое оружие всех гиперактивных детей. Для детей от 8 и старше."
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "foamcrossbow"
	inhand_icon_state = "crossbow"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	worn_icon = null
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	gun_flags = NONE

/obj/item/gun/ballistic/automatic/c20r/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "игрушечный C-20r"
	desc = "Игрушечный пистолет-пулемет с трехзарядной очередью булл-пап, получивший обозначение C-20r. Для детей от 8 и старше."
	can_suppress = TRUE
	item_flags = NONE
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45/riot

/obj/item/gun/ballistic/automatic/l6_saw/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "игрушечный пулемет L6"
	desc = "Очень прокачанный игрушечный пулемет'L6 SAW'. Для детей от 8 и старше."
	fire_sound = 'sound/items/syringeproj.ogg'
	can_suppress = FALSE
	item_flags = NONE
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/m762
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762/riot
