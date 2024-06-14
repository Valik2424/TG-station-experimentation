/obj/item/gun/ballistic/shotgun
	name = "дробовик"
	desc = "Классический дробовик с деревянными элементами и четырехзарядным трубчатым магазином."
	icon_state = "shotgun"
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_icon_state = "shotgun"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	fire_sound_volume = 90
	rack_sound = 'sound/weapons/gun/shotgun/rack.ogg'
	load_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot
	semi_auto = FALSE
	internal_magazine = TRUE
	casing_ejector = FALSE
	bolt_wording = "pump"
	cartridge_wording = "shell"
	tac_reloads = FALSE
	weapon_weight = WEAPON_HEAVY

	pb_knockback = 2

/obj/item/gun/ballistic/shotgun/blow_up(mob/user)
	. = 0
	if(chambered?.loaded_projectile)
		process_fire(user, user, FALSE)
		. = 1

/obj/item/gun/ballistic/shotgun/lethal
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/lethal

// RIOT SHOTGUN //

/obj/item/gun/ballistic/shotgun/riot //for spawn in the armory
	name = "дробовик охраны"
	desc = "Прочный дробовик с удлиненным магазином и фиксированным тактическим прикладом, предназначенный для нелетального усмирения толпы."
	icon_state = "riotshotgun"
	inhand_icon_state = "shotgun"
	fire_delay = 8
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/riot
	sawn_desc = "Иди со мной если хочешь жить."
	can_be_sawn_off = TRUE

// Automatic Shotguns//

/obj/item/gun/ballistic/shotgun/automatic/shoot_live_shot(mob/living/user)
	..()
	rack()

/obj/item/gun/ballistic/shotgun/automatic/combat
	name = "боевой дробовик"
	desc = "Полуавтоматический дробовик с местом для крепления фонаря. Шестизарядный трубчатый магазин."
	icon_state = "cshotgun"
	inhand_icon_state = "shotgun_combat"
	fire_delay = 5
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/com
	w_class = WEIGHT_CLASS_HUGE

/obj/item/gun/ballistic/shotgun/automatic/combat/compact
	name = "боевой дробовик"
	desc = "Компактная версия боевого дробовика. Для применения в замкнутых пространствах на коротких дистанциях."
	icon_state = "cshotgunc"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/com/compact
	w_class = WEIGHT_CLASS_BULKY

//Dual Feed Shotgun

/obj/item/gun/ballistic/shotgun/automatic/dual_tube
	name = "двухрядный дробовик"
	desc = "Продвинутый дробовик с двумя отдельными трубчатыми магазинами, позволяющими мгновенно переключаться между заряженными типами боеприпасов."
	icon_state = "cycler"
	inhand_icon_state = "bulldog"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "cshotgun"
	w_class = WEIGHT_CLASS_HUGE
	semi_auto = TRUE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/tube
	/// If defined, the secondary tube is this type, if you want different shell loads
	var/alt_mag_type
	/// If TRUE, we're drawing from the alternate_magazine
	var/toggled = FALSE
	/// The B tube
	var/obj/item/ammo_box/magazine/internal/shot/alternate_magazine

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/bounty
	name = "двухрядный дробовик охотника за головами"
	desc = "Продвинутый дробовик с двумя отдельными трубчатыми магазинами. Этот, кажется, подходит для охоты за головами, что видно из его боеприпасов: резиновые пули и боевая дробь."
	alt_mag_type = /obj/item/ammo_box/magazine/internal/shot/tube/fire

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/examine(mob/user)
	. = ..()
	. += span_notice("Alt-клик чтобы передёрнуть затвор.")

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/Initialize(mapload)
	. = ..()
	alt_mag_type = alt_mag_type || spawn_magazine_type
	alternate_magazine = new alt_mag_type(src)

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/Destroy()
	QDEL_NULL(alternate_magazine)
	return ..()

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/attack_self(mob/living/user)
	if(!chambered && magazine.contents.len)
		rack()
	else
		toggle_tube(user)

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/proc/toggle_tube(mob/living/user)
	var/current_mag = magazine
	var/alt_mag = alternate_magazine
	magazine = alt_mag
	alternate_magazine = current_mag
	toggled = !toggled
	if(toggled)
		balloon_alert(user, "переключил на магазин Б")
	else
		balloon_alert(user, "переключил на магазин А")

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/AltClick(mob/living/user)
	if(!user.can_perform_action(src, NEED_DEXTERITY|NEED_HANDS))
		return
	rack()

// Bulldog shotgun //

/obj/item/gun/ballistic/shotgun/bulldog
	name = "Дробовик Бульдог"
	desc = "Полуавтоматический магазинный дробовик для схваток в помещениях станции, прозванный 'Бульдог' за свой мощный нрав. Совместим только со специальными 8 зарядными барабанными магазинами.\
	К системе быстрого переключения дробовика может быть подключен второй магазин для мгновенной смены боеприпасов, или для удвоения боекомплекта."
	icon_state = "bulldog"
	inhand_icon_state = "bulldog"
	worn_icon_state = "cshotgun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	projectile_damage_multiplier = 1.2
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/m12g
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0
	pin = /obj/item/firing_pin/implant/pindicate
	fire_sound = 'sound/weapons/gun/shotgun/shot_alt.ogg'
	actions_types = list()
	mag_display = TRUE
	empty_indicator = TRUE
	empty_alarm = TRUE
	special_mags = TRUE
	mag_display_ammo = TRUE
	semi_auto = TRUE
	internal_magazine = FALSE
	tac_reloads = TRUE
	///the type of secondary magazine for the bulldog
	var/secondary_magazine_type
	///the secondary magazine
	var/obj/item/ammo_box/magazine/secondary_magazine

/obj/item/gun/ballistic/shotgun/bulldog/Initialize(mapload)
	. = ..()
	secondary_magazine_type = secondary_magazine_type || spawn_magazine_type
	secondary_magazine = new secondary_magazine_type(src)
	update_appearance()

/obj/item/gun/ballistic/shotgun/bulldog/Destroy()
	QDEL_NULL(secondary_magazine)
	return ..()

/obj/item/gun/ballistic/shotgun/bulldog/examine(mob/user)
	. = ..()
	if(secondary_magazine)
		var/secondary_ammo_count = secondary_magazine.ammo_count()
		. += "Вставлен второй магазин."
		. += "Осталось зарядов: [secondary_ammo_count]."
		. += "ПКМ чтобы совершить выстрел переключившись между боекомплектом."
		. += "Если магазин пустой, [src] автоматически переключится на второй магазин."
	. += "Можно установить второй магазин с помощью ПКМ по [src] с магазином в свободной руке."
	. += "Вытащить второй магазин можно с помощью alt-ПКМ пустой рукой по [src]."
	. += "ПКМ пустой рукой чтобы переключить магазин во вторую позицию и наоборот."

/obj/item/gun/ballistic/shotgun/bulldog/update_overlays()
	. = ..()
	if(secondary_magazine)
		. += "[icon_state]_secondary_mag_[initial(secondary_magazine.icon_state)]"
		if(!secondary_magazine.ammo_count())
			. += "[icon_state]_secondary_mag_empty"
	else
		. += "[icon_state]_no_secondary_mag"

/obj/item/gun/ballistic/shotgun/bulldog/handle_chamber()
	if(!secondary_magazine)
		return ..()
	var/secondary_shells_left = LAZYLEN(secondary_magazine.stored_ammo)
	if(magazine)
		var/shells_left = LAZYLEN(magazine.stored_ammo)
		if(shells_left <= 0 && secondary_shells_left >= 1)
			toggle_magazine()
	else
		toggle_magazine()
	return ..()

/obj/item/gun/ballistic/shotgun/bulldog/attack_self_secondary(mob/user, modifiers)
	toggle_magazine()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/shotgun/bulldog/afterattack_secondary(mob/living/victim, mob/living/user, proximity_flag, click_parameters)
	if(secondary_magazine)
		toggle_magazine()
	return SECONDARY_ATTACK_CALL_NORMAL

/obj/item/gun/ballistic/shotgun/bulldog/attackby_secondary(obj/item/weapon, mob/user, params)
	if(!istype(weapon, secondary_magazine_type))
		balloon_alert(user, "[weapon.name] не помещается!")
		return SECONDARY_ATTACK_CALL_NORMAL
	if(!user.transferItemToLoc(weapon, src))
		to_chat(user, span_warning("Похоже я не могу выбросить [src] из рук!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/obj/item/ammo_box/magazine/old_mag = secondary_magazine
	secondary_magazine = weapon
	if(old_mag)
		user.put_in_hands(old_mag)
	balloon_alert(user, "второй [magazine_wording] установлен")
	playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/shotgun/bulldog/alt_click_secondary(mob/user)
	if(secondary_magazine)
		var/obj/item/ammo_box/magazine/old_mag = secondary_magazine
		secondary_magazine = null
		user.put_in_hands(old_mag)
		update_appearance()
		playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/shotgun/bulldog/proc/toggle_magazine()
	var/primary_magazine = magazine
	var/alternative_magazine = secondary_magazine
	magazine = alternative_magazine
	secondary_magazine = primary_magazine
	playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	update_appearance()

/obj/item/gun/ballistic/shotgun/bulldog/unrestricted
	pin = /obj/item/firing_pin
/////////////////////////////
// DOUBLE BARRELED SHOTGUN //
/////////////////////////////

/obj/item/gun/ballistic/shotgun/doublebarrel
	name = "двустволка"
	desc = "Настоящая классика."
	icon_state = "dshotgun"
	inhand_icon_state = "shotgun_db"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/dual
	sawn_desc = "Omar's coming!"
	obj_flags = UNIQUE_RENAME
	rack_sound_volume = 0
	unique_reskin = list("Default" = "dshotgun",
						"Dark Red Finish" = "dshotgun_d",
						"Ash" = "dshotgun_f",
						"Faded Grey" = "dshotgun_g",
						"Maple" = "dshotgun_l",
						"Rosewood" = "dshotgun_p"
						)
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	can_be_sawn_off = TRUE
	pb_knockback = 3 // it's a super shotgun!

/obj/item/gun/ballistic/shotgun/doublebarrel/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.can_perform_action(src, NEED_DEXTERITY))
		reskin_obj(user)

/obj/item/gun/ballistic/shotgun/doublebarrel/sawoff(mob/user)
	. = ..()
	if(.)
		weapon_weight = WEAPON_MEDIUM

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised
	name = "кустарный дробовик"
	desc = "Труба, сделанная под дробовик."
	icon_state = "ishotgun"
	inhand_icon_state = "ishotgun"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	slot_flags = null
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	sawn_desc = "Я приехал ради бензина."
	unique_reskin = null
	var/slung = FALSE

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn_off)
		var/obj/item/stack/cable_coil/C = A
		if(C.use(10))
			slot_flags = ITEM_SLOT_BACK
			to_chat(user, span_notice("Привязываю кабель к дробовику, теперь можно носить дробовик на спине."))
			slung = TRUE
			update_icon()
		else
			to_chat(user, span_warning("Требуется минимум десять длин кабеля, если мне нужно сделать стропу!"))

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/update_icon_state()
	. = ..()
	if(slung)
		inhand_icon_state = "ishotgunsling"
	if(sawn_off)
		inhand_icon_state = "ishotgun_sawn"

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/update_overlays()
	. = ..()
	if(slung)
		. += "ishotgunsling"
	if(sawn_off)
		. += "ishotgun_sawn"

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/sawoff(mob/user)
	. = ..()
	if(. && slung) //sawing off the gun removes the sling
		new /obj/item/stack/cable_coil(get_turf(src), 10)
		slung = FALSE
		update_icon()
		lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
		righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/sawn
	name = "импровизированный обрез"
	desc = "Делает одиночный выстрел. Не промахнись."
	icon_state = "ishotgun_sawn"
	inhand_icon_state = "ishotgun_sawn"
	worn_icon_state = "gun"
	worn_icon = null
	w_class = WEIGHT_CLASS_NORMAL
	sawn_off = TRUE
	slot_flags = ITEM_SLOT_BELT


/obj/item/gun/ballistic/shotgun/doublebarrel/slugs
	name = "охотничий дробовик"
	desc = "Охотничье ружье, используемое богачами для \"охоты\"."
	sawn_desc = "Обрез охотничьего ружья. В новом состоянии оно заметно менее эффективно для охоты...На все."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/dual/slugs

/obj/item/gun/ballistic/shotgun/doublebarrel/breacherslug
	name = "пробивное ружье"
	desc = "Обычное двуствольное ружье, переоборудованное под пробивные снаряды. Полезен для взлома шлюзов и окон, не более того."
	sawn_desc = "Обрез пробивного ружья в более компактной конфигурации, сохраняющий при этом те же возможности, что и раньше."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/dual/breacherslug

/obj/item/gun/ballistic/shotgun/hook
	name = "модифицированный обрез с крюком"
	desc = "Расстояние больше не является проблемой, если вы можете притянуть жертву к себе."
	icon_state = "hookshotgun"
	inhand_icon_state = "hookshotgun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/bounty
	weapon_weight = WEAPON_MEDIUM
	semi_auto = TRUE
	flags_1 = CONDUCT_1
	force = 18 //it has a hook on it
	sharpness = SHARP_POINTY //it does in fact, have a hook on it
	attack_verb_continuous = list("режет", "цепляет", "прокалывает")
	attack_verb_simple = list("режет", "цепляет", "колет")
	hitsound = 'sound/weapons/bladeslice.ogg'
	//our hook gun!
	var/obj/item/gun/magic/hook/bounty/hook

/obj/item/gun/ballistic/shotgun/hook/Initialize(mapload)
	. = ..()
	hook = new /obj/item/gun/magic/hook/bounty(src)

/obj/item/gun/ballistic/shotgun/hook/Destroy()
	QDEL_NULL(hook)
	return ..()

/obj/item/gun/ballistic/shotgun/hook/examine(mob/user)
	. = ..()
	. += span_notice("ПКМ для выстрела крюком.")

/obj/item/gun/ballistic/shotgun/hook/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	hook.afterattack(target, user, proximity_flag, click_parameters)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

