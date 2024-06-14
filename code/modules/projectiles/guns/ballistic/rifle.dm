/obj/item/gun/ballistic/rifle
	name = "Винтовка"
	desc = "Разновидность винтовок с продольно-скользящим затвором. Возникает чувство, что у меня не должно её быть."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "sakhno"
	w_class = WEIGHT_CLASS_BULKY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'sound/weapons/gun/rifle/shot_heavy.ogg'
	fire_sound_volume = 90
	rack_sound = 'sound/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/weapons/gun/rifle/bolt_in.ogg'
	tac_reloads = FALSE

/obj/item/gun/ballistic/rifle/rack(mob/user = null)
	if (bolt_locked == FALSE)
		balloon_alert(user, "затвор открыт")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_appearance()
		return
	drop_bolt(user)

/obj/item/gun/ballistic/rifle/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/examine(mob/user)
	. = ..()
	. += "Затвор [bolt_locked ? "открыт" : "закрыт"]."

///////////////////////
// BOLT ACTION RIFLE //
///////////////////////

/obj/item/gun/ballistic/rifle/boltaction
	name = "Винтовка Сахно"
	desc = "Винтовка Сахно с продольно-скользящим затвором была (и по прежнему остаётся) популярной у \
		колонистов, каргонцев, частных охранных организаций, первооткрывателей, и других неблагонадежных типов. Эта конкретная \
		модель винтовки была разработана около 2440-х годов."
	sawn_desc = "Винтовка Сахно с обрезанным стволом, наиболее известная как \"Обрез\". \
		Очевидно была причина по которой винтовка не выпускалась с настолько коротким стволом. \
		Невзирая на ужасную природу данной модификации это оружие находится в безупречном состоянии."

	icon_state = "sakhno"
	inhand_icon_state = "sakhno"
	worn_icon_state = "sakhno"

	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	can_bayonet = TRUE
	knife_x_offset = 42
	knife_y_offset = 12
	can_be_sawn_off = TRUE
	weapon_weight = WEAPON_HEAVY
	var/jamming_chance = 20
	var/unjam_chance = 10
	var/jamming_increment = 5
	var/jammed = FALSE
	var/can_jam = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/boltaction/sawoff(mob/user)
	. = ..()
	if(.)
		spread = 36
		can_bayonet = FALSE
		SET_BASE_PIXEL(0, 0)
		update_appearance()

/obj/item/gun/ballistic/rifle/boltaction/attack_self(mob/user)
	if(can_jam)
		if(jammed)
			if(prob(unjam_chance))
				jammed = FALSE
				unjam_chance = 10
			else
				unjam_chance += 10
				balloon_alert(user, "заклинило!")
				playsound(user,'sound/weapons/jammed.ogg', 75, TRUE)
				return FALSE
	..()

/obj/item/gun/ballistic/rifle/boltaction/process_fire(mob/user)
	if(can_jam)
		if(chambered.loaded_projectile)
			if(prob(jamming_chance))
				jammed = TRUE
			jamming_chance += jamming_increment
			jamming_chance = clamp (jamming_chance, 0, 100)
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/attackby(obj/item/item, mob/user, params)
	if(!bolt_locked && !istype(item, /obj/item/knife))
		balloon_alert(user, "затвор закрыт!")
		return

	. = ..()

	if(istype(item, /obj/item/gun_maintenance_supplies))
		if(!can_jam)
			balloon_alert(user, "не могу расклинить!")
			return
		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_notice("[user] заканчивает починку [src]."))
			jamming_chance = initial(jamming_chance)
			qdel(item)

/obj/item/gun/ballistic/rifle/boltaction/blow_up(mob/user)
	. = FALSE
	if(chambered?.loaded_projectile)
		process_fire(user, user, FALSE)
		. = TRUE

/obj/item/gun/ballistic/rifle/boltaction/harpoon
	name = "Гарпунная пушка"
	desc = "Настолько любимое оружие охотников на карпов, насколько позорно используемое агентами Ассоциации по Защите Прав Животных. Какая ирония."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "speargun"
	inhand_icon_state = "speargun"
	worn_icon_state = "speargun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/harpoon
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/surplus
	name = "Сахно M2442"
	desc = "Модификация высокоточной винтовки Сахно. \ Надпись - Сахно М2442 - выбита на боковой поверхности. \
		Неизвестно, для какой армии была создана эта винтовка и использовалась ли она вообще.\
		Однако можно сделать вывод, что предыдущий владелец обращался с оружием не лучшим образом. \
		По какой-то причине на внутренних деталях винтовки присутствует влага.."
	sawn_desc = "Винтовка Сахно с обрезанным стволом, наиболее известная как \"Обрез\". \
		Очевидно была причина по которой винтовка не выпускалась с настолько коротким стволом. \
		Невзирая на ужасную природу данной модификации это оружие находится в безупречном состоянии."
	icon_state = "sakhno_tactifucked"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/surplus
	can_jam = TRUE

/obj/item/gun/ballistic/rifle/boltaction/prime
	name = "Спортивная винтовка Сахно-Жинхао"
	desc = "Обновление и модернизация оригинальной винтовки Сахно, выполненное с использованием таких чудес оружейной промышленности как: современные материалы, тщательная подгонка деталей, \
		высококлассный оптический прицел, в общем, всё, что, по правде говоря, уже существовало на момент создания оригинального оружия в 2440. Удивительно, но для винтовки такого типа \
		прицел действительно необходим."
	icon_state = "zhihao"
	inhand_icon_state = "zhihao"
	worn_icon_state = "zhihao"
	can_be_sawn_off = TRUE
	sawn_desc = "Обрез Сахно-Жинхао...Неизвестно у кого поднялась рука сделать это, надеюсь, он был рад. \
		Возможно я единственный человек во вселенной который когда-либо держал в руках \"Обрез Жинхао\".\
		Взять шестигранный ключ и открутить ствол - всё, что требовалось, чтобы укоротить ствол, но нет \
		ты взял пилу."

/obj/item/gun/ballistic/rifle/boltaction/prime/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/gun/ballistic/rifle/boltaction/prime/sawoff(mob/user)
	. = ..()
	if(.)
		name = "\improper Obrez Moderna" // wear it loud and proud

/obj/item/gun/ballistic/rifle/boltaction/pipegun
	name = "самодельная винтовка"
	desc = "Великолепное оружие для выкуривания туннельных крыс и вражеских ассистентов, но его прицельная дальность оставляет желать лучшего."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "musket"
	inhand_icon_state = "musket"
	worn_icon_state = "musket"
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun
	initial_caliber = CALIBER_SHOTGUN
	alternative_caliber = CALIBER_STRILKA310
	initial_fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	alternative_fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	can_modify_ammo = TRUE
	can_bayonet = TRUE
	knife_y_offset = 11
	can_be_sawn_off = FALSE
	projectile_damage_multiplier = 0.75

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/handle_chamber()
	. = ..()
	do_sparks(1, TRUE, src)
///Контекст не сохранить, перевёл как можно лучше сохранив смысл///
/obj/item/gun/ballistic/rifle/boltaction/pipegun/prime
	name = "улучшенная самодельная винтовка"
	desc = "С такой и на Древнего Ассистента не страшно пойти."
	icon_state = "musket_prime"
	inhand_icon_state = "musket_prime"
	worn_icon_state = "musket_prime"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun/prime
	projectile_damage_multiplier = 1

/// MAGICAL BOLT ACTIONS + ARCANE BARRAGE? ///

/obj/item/gun/ballistic/rifle/enchanted
	name = "зачарованная винтовка с продольно-скользящим затвором"
	desc = "Не теряй головы!"
	icon_state = "enchanted_rifle"
	inhand_icon_state = "enchanted_rifle"
	worn_icon_state = "enchanted_rifle"
	slot_flags = ITEM_SLOT_BACK
	var/guns_left = 30
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/enchanted
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/enchanted/dropped()
	. = ..()
	guns_left = 0
	magazine = null
	chambered = null

/obj/item/gun/ballistic/rifle/enchanted/proc/discard_gun(mob/living/user)
	user.throw_item(pick(oview(7,get_turf(user))))

/obj/item/gun/ballistic/rifle/enchanted/attack_self()
	return

/obj/item/gun/ballistic/rifle/enchanted/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	if(guns_left)
		var/obj/item/gun/ballistic/rifle/enchanted/gun = new type
		gun.guns_left = guns_left - 1
		discard_gun(user)
		user.swap_hand()
		user.put_in_hands(gun)
	else
		user.dropItemToGround(src, TRUE)

// SNIPER //

/obj/item/gun/ballistic/rifle/sniper_rifle
	name = "anti-materiel sniper rifle"
	desc = "Противотанковая винтовка, использующая патроны .50 BMG. Технически устаревшая на современном рынке вооружений, она до сих пор прекрасно работает в качестве \
		противопехотной винтовки. В частности, с появлением на вооружении современных МОДсьютов с усовершенствованной бронезащитой это оружие получило новое место на поле боя. \
		К винтовке можно прикрутить глушитель."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "sniper"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	inhand_icon_state = "sniper"
	worn_icon_state = null
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	load_sound = 'sound/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	accepted_magazine_type = /obj/item/ammo_box/magazine/sniper_rounds
	internal_magazine = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	mag_display = TRUE
	tac_reloads = TRUE
	rack_delay = 1 SECONDS
	can_suppress = TRUE
	can_unsuppress = TRUE
	suppressor_x_offset = 3
	suppressor_y_offset = 3

/obj/item/gun/ballistic/rifle/sniper_rifle/examine(mob/user)
	. = ..()
	. += span_warning("<b>Похоже, тут есть надпись:</b> НИ ПРИ КАКИХ обстоятельствах не выполняйте 'quickscope' с этой винтовкой.")

/obj/item/gun/ballistic/rifle/sniper_rifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4) //enough range to at least make extremely good use of the penetrator rounds

/obj/item/gun/ballistic/rifle/sniper_rifle/reset_semicd()
	. = ..()
	if(suppressed)
		playsound(src, 'sound/machines/eject.ogg', 25, TRUE, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(src, 'sound/machines/eject.ogg', 50, TRUE)

/obj/item/gun/ballistic/rifle/sniper_rifle/syndicate
	desc = "Противотанковая винтовка, использующая патроны .50 BMG. Технически устаревшая на современном рынке вооружений, она до сих пор прекрасно работает в качестве \
		противопехотной винтовки. В частности, с появлением на вооружении современных МОДсьютов с усовершенствованной бронезащитой это оружие получило новое место на поле боя. \
		К винтовке можно прикрутить глушитель.\ Кажется, на винтовке нарисован человек в кроваво-красном МОДсьюте, указывающий на зеленую дискету. \
		Кто знает, что это может означать?"
	pin = /obj/item/firing_pin/implant/pindicate
