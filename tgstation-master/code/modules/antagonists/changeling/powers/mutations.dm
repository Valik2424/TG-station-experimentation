/*
	Changeling Mutations! ~By Miauw (ALL OF IT :V)
	Contains:
		Arm Blade
		Space Suit
		Shield
		Armor
		Tentacles
*/


//Parent to shields and blades because muh copypasted code.
/datum/action/changeling/weapon
	name = "Organic Weapon"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/silent = FALSE
	var/weapon_type
	var/weapon_name_simple

/datum/action/changeling/weapon/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/weapon/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	unequip_held(remove_from)
	return ..()

/// Remove weapons if we become a monkey
/datum/action/changeling/weapon/proc/became_monkey(mob/source)
	SIGNAL_HANDLER
	unequip_held(source)

/// Removes weapon if it exists, returns true if we removed something
/datum/action/changeling/weapon/proc/unequip_held(mob/user)
	var/found_weapon = FALSE
	for(var/obj/item/held in user.held_items)
		found_weapon = check_weapon(user, held) || found_weapon
	return found_weapon

/datum/action/changeling/weapon/try_to_sting(mob/user, mob/target)
	if (unequip_held(user))
		return
	..(user, target)

/datum/action/changeling/weapon/proc/check_weapon(mob/user, obj/item/hand_item)
	if(istype(hand_item, weapon_type))
		user.temporarilyRemoveItemFromInventory(hand_item, TRUE) //DROPDEL will delete the item
		if(!silent)
			playsound(user, 'sound/effects/blobattack.ogg', 30, TRUE)
			user.visible_message(span_warning("С отвратительным хрустом, <b>[user]</b> формирует [weapon_name_simple] обратно в руку!") , span_notice("Мы возвращаем [weapon_name_simple] обратно в наше тело.") , "<span class='italics>Слышу как что-то органическое разрывается!</span>")
		user.update_held_items()
		return TRUE

/datum/action/changeling/weapon/sting_action(mob/living/carbon/user)
	var/obj/item/held = user.get_active_held_item()
	if(held && !user.dropItemToGround(held))
		user.balloon_alert(user, "рука занята!")
		return
	if(!istype(user))
		user.balloon_alert(user, "wrong shape!")
		return
	..()
	var/limb_regen = 0
	if(user.active_hand_index % 2 == 0) //we regen the arm before changing it into the weapon
		limb_regen = user.regenerate_limb(BODY_ZONE_R_ARM, 1)
	else
		limb_regen = user.regenerate_limb(BODY_ZONE_L_ARM, 1)
	if(limb_regen)
		user.visible_message(
			span_warning("Рука <b>[user]</b> трансформируется издавая громкий и неприятный звук!") ,
			span_userdanger("Моя рука отрастает, издает громкий хрустящий звук и причиняет мне сильную боль!") ,
			span_hear("Слышу как что-то органическое разрывается!")
		)
		user.emote("scream")
	var/obj/item/W = new weapon_type(user, silent)
	user.put_in_hands(W)
	if(!silent)
		playsound(user, 'sound/effects/blobattack.ogg', 30, TRUE)
	return W


//Parent to space suits and armor.
/datum/action/changeling/suit
	name = "Organic Suit"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/helmet_type = /obj/item
	var/suit_type = /obj/item
	var/suit_name_simple = "    "
	var/helmet_name_simple = "     "
	var/recharge_slowdown = 0
	var/blood_on_castoff = 0

/datum/action/changeling/suit/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/suit/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	check_suit(remove_from)
	return ..()

/// Remove suit if we become a monkey
/datum/action/changeling/suit/proc/became_monkey()
	SIGNAL_HANDLER
	check_suit(owner)

/datum/action/changeling/suit/try_to_sting(mob/user, mob/target)
	if(check_suit(user))
		return
	var/mob/living/carbon/human/H = user
	..(H, target)

//checks if we already have an organic suit and casts it off.
/datum/action/changeling/suit/proc/check_suit(mob/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!ishuman(user) || !changeling)
		return 1
	var/mob/living/carbon/human/H = user
	if(istype(H.wear_suit, suit_type) || istype(H.head, helmet_type))
		H.visible_message(span_warning("<b>[H]</b> сбрасывает с себя [suit_name_simple]!") , span_warning("Мы сбрасываем [suit_name_simple].") , span_hear("Слышу как что-то органическое разрывается!"))
		H.temporarilyRemoveItemFromInventory(H.head, TRUE) //The qdel on dropped() takes care of it
		H.temporarilyRemoveItemFromInventory(H.wear_suit, TRUE)
		H.update_worn_oversuit()
		H.update_worn_head()
		H.update_body_parts()

		if(blood_on_castoff)
			H.add_splatter_floor()
			playsound(H.loc, 'sound/effects/splat.ogg', 50, TRUE) //So real sounds

		changeling.chem_recharge_slowdown -= recharge_slowdown
		return 1

/datum/action/changeling/suit/sting_action(mob/living/carbon/human/user)
	if(!user.canUnEquip(user.wear_suit))
		to_chat(user, span_warning("[capitalize(user.wear_suit)] крепко сидит на моём теле, не получится вырастить [suit_name_simple] поверх этого!"))
		return
	if(!user.canUnEquip(user.head))
		to_chat(user, span_warning("[capitalize(user.head)] крепко сидит на моей голове, не получится вырастить [helmet_name_simple] поверх этого!"))
		return
	..()
	user.dropItemToGround(user.head)
	user.dropItemToGround(user.wear_suit)

	user.equip_to_slot_if_possible(new suit_type(user), ITEM_SLOT_OCLOTHING, 1, 1, 1)
	user.equip_to_slot_if_possible(new helmet_type(user), ITEM_SLOT_HEAD, 1, 1, 1)

	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chem_recharge_slowdown += recharge_slowdown
	return TRUE


//fancy headers yo
/***************************************\
|***************ARM BLADE***************|
\***************************************/
/datum/action/changeling/weapon/arm_blade
	name = "Рука-лезвие"
	desc = "Мы превращаем одну из наших рук в смертельный клинок. Стоит 20 химикатов."
	helptext = "Мы можем втягивать наш клинок так же, как мы его формируем. Не может быть использовано в меньшей форме."
	button_icon_state = "armblade"
	chemical_cost = 20
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/melee/arm_blade
	weapon_name_simple = "лезвие"

/obj/item/melee/arm_blade
	name = "рука-лезвие"
	desc = "Гротескный клинок из кости и плоти, который пронзает людей, как горячий нож сквозь масло."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 25
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	sharpness = SHARP_EDGED
	wound_bonus = 10
	bare_wound_bonus = 10
	armour_penetration = 35
	var/can_drop = FALSE
	var/fake = FALSE

/obj/item/melee/arm_blade/Initialize(mapload,silent,synthetic)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc) && !silent)
		loc.visible_message(span_warning("Гротескный клинок формируется из руки <b>[loc.name]</b>!") , span_warning("Наша рука крутится и мутирует, превращаясь в смертельный клинок.") , span_hear("Слышу как что-то органическое разрывается!"))
	if(synthetic)
		can_drop = TRUE
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	effectiveness = 80, \
	)

/obj/item/melee/arm_blade/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(target, /obj/structure/table))
		var/obj/structure/table/T = target
		T.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		var/obj/machinery/computer/C = target
		C.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/opening = target

		if((!opening.requiresID() || opening.allowed(user)) && opening.hasPower()) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message, power requirement is so this doesn't stop unpowered doors from being pried open if you have access
			return
		if(opening.locked)
			opening.balloon_alert(user, "заболтирован!")
			return

		if(opening.hasPower())
			user.visible_message(span_warning("<b>[user]</b> втискивает <b>руку-лезвие</b> в шлюз и начинает открывать его!") , span_warning("Мы начинаем открывать [opening].") , \
			span_hear("Слышу металлический лязг."))
			playsound(opening, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)
			if(!do_after(user, 10 SECONDS, target = opening))
				return
		//user.say("Heeeeeeeeeerrre's Johnny!")
		user.visible_message(span_warning("<b>[user]</b> заставляет шлюз открыться под силой <b>руки-лезвия</b>!") , span_warning("Мы заставляем [opening] открыться.") , \
		span_hear("Слышу металлический лязг."))
		opening.open(BYPASS_DOOR_CHECKS)

/obj/item/melee/arm_blade/dropped(mob/user)
	..()
	if(can_drop)
		new /obj/item/melee/synthetic_arm_blade(get_turf(user))

/***************************************\
|***********COMBAT TENTACLES*************|
\***************************************/

/datum/action/changeling/weapon/tentacle
	name = "Щупальце"
	desc = "Мы готовим щупальце, способное захватывать предметы или живых существ. Стоит 10 химикатов."
	helptext = "Мы можем использовать его один раз, чтобы получить отдаленный предмет. При использовании на живых существ, эффект зависит от намерения: \
	Помощь просто притянет их ближе, Разоружение захватит все, что они держат вместо них, Захват поместит жертву в нашу хватку после того, как поймает ее, \
	и Вред втянет его и нанесет удар, если у нас тоже острое оружие. Не может быть использовано в меньшей форме."
	button_icon_state = "tentacle"
	chemical_cost = 10
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/gun/magic/tentacle
	weapon_name_simple = "щупальце"
	silent = TRUE

/obj/item/gun/magic/tentacle
	name = "щупальце"
	desc = "Мясистое щупальце, которое может вытянуться и захватить вещи или людей."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "tentacle"
	inhand_icon_state = "tentacle"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	antimagic_flags = NONE
	pinless = TRUE
	ammo_type = /obj/item/ammo_casing/magic/tentacle
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_hold_up = FALSE

/obj/item/gun/magic/tentacle/Initialize(mapload, silent)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		if(!silent)
			loc.visible_message(span_warning("Рука <b>[loc.name]</b> начинает странно растягиваться!") , span_warning("Наша рука изгибается и мутирует, превращая ее в щупальце.") , span_hear("Слышу как что-то органическое разрывается!"))
		else
			to_chat(loc, span_notice("Мы готовимся вытянуть щупальце."))


/obj/item/gun/magic/tentacle/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user.balloon_alert(user, "щупальце не готово!")

/obj/item/gun/magic/tentacle/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	var/obj/projectile/tentacle/tentacle_shot = chambered.loaded_projectile //Gets the actual projectile we will fire
	tentacle_shot.fire_modifiers = params2list(params)
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/item/gun/magic/tentacle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] coils [src] tightly around [user.p_their()] neck! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS

/obj/item/ammo_casing/magic/tentacle
	name = "щупальце"
	desc = "Прикол."
	projectile_type = /obj/projectile/tentacle
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	var/obj/item/gun/magic/tentacle/gun //the item that shot it

/obj/item/ammo_casing/magic/tentacle/Initialize(mapload)
	gun = loc
	. = ..()

/obj/item/ammo_casing/magic/tentacle/Destroy()
	gun = null
	return ..()

/obj/projectile/tentacle
	name = "щупальце"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain
	var/obj/item/ammo_casing/magic/tentacle/source //the item that shot it
	///Click params that were used to fire the tentacle shot
	var/list/fire_modifiers

/obj/projectile/tentacle/Initialize(mapload)
	source = loc
	. = ..()

/obj/projectile/tentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle", emissive = FALSE)
	..()

/obj/projectile/tentacle/proc/reset_throw(mob/living/carbon/human/H)
	if(H.throw_mode)
		H.throw_mode_off(THROW_MODE_TOGGLE) //Don't annoy the changeling if he doesn't catch the item

/obj/projectile/tentacle/proc/tentacle_grab(mob/living/carbon/human/H, mob/living/carbon/C)
	if(H.Adjacent(C))
		if(H.get_active_held_item() && !H.get_inactive_held_item())
			H.swap_hand()
		if(H.get_active_held_item())
			return
		C.grabbedby(H)
		C.grippedby(H, instant = TRUE) //instant aggro grab
		for(var/obj/item/I in H.held_items)
			if(I.get_sharpness())
				C.visible_message(span_danger("<b>[H]</b> пронзает <b>[C]</b> своим [I.name]!") , span_userdanger("<b>[H]</b> пронзает меня своим [I.name]!"))
				C.apply_damage(I.force, BRUTE, BODY_ZONE_CHEST, attacking_item = I)
				H.do_item_attack_animation(C, used_item = I)
				H.add_mob_blood(C)
				playsound(get_turf(H),I.hitsound,75,TRUE)
				return

/obj/projectile/tentacle/on_hit(atom/movable/target, blocked = 0, pierce_hit)
	if(!isliving(firer) || !ismovable(target))
		return ..()

	if(blocked >= 100)
		return BULLET_ACT_BLOCK

	var/mob/living/ling = firer
	if(isitem(target) && iscarbon(ling))
		var/obj/item/catching = target
		if(catching.anchored)
			return BULLET_ACT_BLOCK

		var/mob/living/carbon/carbon_ling = ling
		to_chat(carbon_ling, span_notice("Притягиваю [catching] к себе."))
		carbon_ling.throw_mode_on(THROW_MODE_TOGGLE)
		catching.throw_at(
			target = carbon_ling,
			range = 10,
			speed = 2,
			thrower = carbon_ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(reset_throw), carbon_ling),
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .
	var/mob/living/victim = target
	if(!isliving(victim) || target.anchored || victim.throwing)
		return BULLET_ACT_BLOCK

	if(!iscarbon(victim) || !ishuman(ling) || !ling.combat_mode)
		victim.visible_message(
			span_danger("<b>[victim]</b> утягивается щупальцем <b>[ling]</b>!"),
			span_userdanger("Щупальце хватает меня и тянет к <b>[ling]</b>!"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	if(LAZYACCESS(fire_modifiers, RIGHT_CLICK))
		var/obj/item/stealing = victim.get_active_held_item()
		if(!isnull(stealing))
			if(victim.dropItemToGround(stealing))
				victim.visible_message(
					span_danger("<b>[stealing]</b> вытягивается из руки <b>[victim]</b> щупальцем!"),
					span_userdanger("Щупальце <b>[stealing]</b> из моей руки!"),
				)
				return on_hit(stealing) //grab the item as if you had hit it directly with the tentacle

			to_chat(ling, span_warning("У нас не вышло вырвать <b>[stealing]</b> из рук <b>[victim]</b>!"))
			return BULLET_ACT_BLOCK

		to_chat(ling, span_danger("<b>[victim]</b> ничего в руках и не держит!"))
		return BULLET_ACT_HIT

	if(ling.combat_mode)
		victim.visible_message(
			span_danger("</b>[victim]</b> быстро улетает в сторону <b>[ling]</b> силой щупальца!"),
			span_userdanger("Щупальце хватает меня и тянет к <b>[ling]</b>!"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range  = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(tentacle_grab), ling, victim),
			gentle = TRUE,
		)

	return BULLET_ACT_HIT

/obj/projectile/tentacle/Destroy()
	qdel(chain)
	source = null
	return ..()


/***************************************\
|****************SHIELD*****************|
\***************************************/
/datum/action/changeling/weapon/shield
	name = "Органический щит"
	desc = "Мы превращаем одну из наших рук в жесткий щит. Стоит 20 химикатов."
	helptext = "Органическая ткань не может противостоять повреждениям всегда; щит сломается после того, как его ударили слишком сильно. Чем больше геномов мы поглощаем, тем он сильнее. Не может быть использовано в меньшей форме."
	button_icon_state = "organic_shield"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

	weapon_type = /obj/item/shield/changeling
	weapon_name_simple = "shield"

/datum/action/changeling/weapon/shield/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling) //So we can read the absorbed_count.
	if(!changeling)
		return

	var/obj/item/shield/changeling/S = ..(user)
	S.remaining_uses = round(changeling.absorbed_count * 3)
	return TRUE

/obj/item/shield/changeling
	name = "щитообразная масса"
	desc = "Масса жесткой костной ткани. Мы все еще можем видеть пальцы в виде скрученного рисунка на щите."
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "ling_shield"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	block_chance = 50

	var/remaining_uses //Set by the changeling ability.

/obj/item/shield/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("Конец руки [loc.name] быстро расширяется формируя щитообразное месиво!") , span_warning("Мы раздуваем нашу руку в сильный щит.") , span_hear("Слышу как что-то органическое разрывается!"))

/obj/item/shield/changeling/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(remaining_uses < 1)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.visible_message(span_warning("С отвратительным хрустом, <b>[H]</b> превращает щит в руку!") , span_notice("Мы возвращаем щит обратно в наше тело.") , "<span class='italics>Слышу как что-то органическое разрывается!</span>")
		qdel(src)
		return 0
	else
		remaining_uses--
		return ..()

/***************************************\
|*****************ARMOR*****************|
\***************************************/
/datum/action/changeling/suit/armor
	name = "Органический скафандр"
	desc = "Мы выращиваем органический костюм, чтобы защитить себя от воздействия космоса. Стоит 20 химикатов."
	helptext = "Мы должны постоянно ремонтировать нашу форму, чтобы сделать ее космической, сокращая химическое производство, пока мы защищены. Не может использоваться в меньшей форме."
	button_icon_state = "chitinous_armor"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE
	recharge_slowdown = 0.125

	suit_type = /obj/item/clothing/suit/armor/changeling
	helmet_type = /obj/item/clothing/head/helmet/changeling
	suit_name_simple = "костюм из плоти"
	helmet_name_simple = "шлем из плоти"

/obj/item/clothing/suit/armor/changeling
	name = "плоть"
	desc = "Огромная, громоздкая масса, устойчивая к давлению и температуре, эволюционировала для облегчения космических путешествий."
	icon_state = "lingarmor"
	inhand_icon_state = null
	item_flags = DROPDEL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_changeling
	flags_inv = HIDEJUMPSUIT
	cold_protection = 0
	heat_protection = 0

/datum/armor/armor_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("Плоть <b>[loc.name]</b> быстро надувается, образуя вздутую массу вокруг тела!") , span_warning("Мы раздуваем нашу плоть, создавая космический костюм!") , span_hear("Слышу как что-то органическое разрывается!"))

/obj/item/clothing/head/helmet/changeling
	name = "плоть"
	desc = "Покрытие из термостойкой органической ткани со стекловидным хитиновым покрытием."
	icon_state = "lingarmorhelmet"
	inhand_icon_state = null
	item_flags = DROPDEL
	armor_type = /datum/armor/helmet_changeling
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT

/datum/armor/helmet_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
