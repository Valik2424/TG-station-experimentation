#define STRONG_PUNCH_COMBO "HH"
#define LAUNCH_KICK_COMBO "HD"
#define DROP_KICK_COMBO "HG"

/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"
	id = MARTIALART_SLEEPINGCARP
	allow_temp_override = FALSE
	help_verb = /mob/living/proc/sleeping_carp_help
	display_combos = TRUE

/datum/martial_art/the_sleeping_carp/teach(mob/living/H, make_temporary = FALSE)
	. = ..()
	if(!.)
		return
	H.add_traits(list(TRAIT_NOGUNS, TRAIT_HARDLY_WOUNDED, TRAIT_NODISMEMBER), SLEEPING_CARP_TRAIT)
	RegisterSignal(H, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(H, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(hit_by_projectile))
	H.faction |= FACTION_CARP //:D

/datum/martial_art/the_sleeping_carp/on_remove(mob/living/H)
	H.remove_traits(list(TRAIT_NOGUNS, TRAIT_HARDLY_WOUNDED, TRAIT_NODISMEMBER), SLEEPING_CARP_TRAIT)
	UnregisterSignal(H, COMSIG_ATOM_ATTACKBY)
	UnregisterSignal(H, COMSIG_ATOM_PRE_BULLET_ACT)
	H.faction -= FACTION_CARP //:(
	. = ..()

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/A, mob/living/D)
	if(findtext(streak,STRONG_PUNCH_COMBO))
		reset_streak()
		strongPunch(A, D)
		return TRUE
	if(findtext(streak,LAUNCH_KICK_COMBO))
		reset_streak()
		launchKick(A, D)
		return TRUE
	if(findtext(streak,DROP_KICK_COMBO))
		reset_streak()
		dropKick(A, D)
		return TRUE
	return FALSE

///Gnashing Teeth: Harm Harm, consistent 20 force punch on every second harm punch
/datum/martial_art/the_sleeping_carp/proc/strongPunch(mob/living/A, mob/living/D)
	///this var is so that the strong punch is always aiming for the body part the user is Hing and not trying to apply to the chest before deviating
	var/obj/item/bodypart/affecting = D.get_bodypart(D.get_random_valid_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("пинает", "бьёт", "прикладывает")
	D.visible_message(span_danger("<b>[A]</b> [atk_verb] <b>[D]</b>!") , \
					  span_userdanger("<b>[A]</b> [atk_verb] меня!") , null, null, A)
	to_chat(A, span_danger("Моя атака [atk_verb] [D]!"))
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, TRUE, -1)
	log_combat(A, D, "strong punched (Sleeping Carp)")
	D.apply_damage(20, A.get_attack_type(), affecting)
	return

///Crashing Wave Kick: Punch Shove combo, throws people seven tiles backwards
/datum/martial_art/the_sleeping_carp/proc/launchKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	D.visible_message(span_warning("<b>[A]</b> пинает <b>[D]</b> прямо в грудь, отталкивая жертву!") , \
					span_userdanger("Меня пинает <b>[A]</b> прямо в грудь. Теперь я лечу!") , span_hear("Слышу сильный удар по телу!") , COMBAT_MESSAGE_RANGE, A)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	var/atom/throw_H = get_edge_target_turf(D, A.dir)
	D.throw_at(throw_H, 7, 4, A)
	D.apply_damage(15, A.get_attack_type(), BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	log_combat(A, D, "launchkicked (Sleeping Carp)")
	return

///Keelhaul: Harm Grab combo, knocks people down, deals stamina damage while they're on the floor
/datum/martial_art/the_sleeping_carp/proc/dropKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	if(D.body_position == STANDING_UP)
		D.apply_damage(10, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(40, STAMINA, BODY_ZONE_HEAD)
		D.Knockdown(4 SECONDS)
		D.visible_message(span_warning("<b>[A]</b> пинает <b>[D]</b> в голову!") , \
					span_userdanger("<b>[A]</b> пинает меня прямо в лицо и я падаю!") , span_hear("Слышу сильный удар по телу!") , COMBAT_MESSAGE_RANGE, A)
	else
		D.apply_damage(5, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(40, STAMINA, BODY_ZONE_HEAD)
		D.drop_all_held_items()
		D.visible_message(span_warning("<b>[A]</b> пинает <b>[D]</b> в голову!") , \
					span_userdanger("<b>[A]</b> пинает меня в лицо!") , span_hear("м!") , COMBAT_MESSAGE_RANGE, A)
	log_combat(A, D, "dropkicked (Sleeping Carp)")
	return

/datum/martial_art/the_sleeping_carp/grab_act(mob/living/A, mob/living/D)
	add_to_streak("G", D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "grabbed (Sleeping Carp)")
	return ..()

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/A, mob/living/D)
	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	var/obj/item/bodypart/affecting = D.get_bodypart(D.get_random_valid_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("бьёт", "пинает", "избивает", "выбивает")
	D.visible_message(span_danger("<b>[A]</b> [atk_verb] <b>[D]</b>!") , \
					  span_userdanger("<b>[A]</b> [atk_verb] меня!") , null, null, A)
	to_chat(A, span_danger("Моя атака [atk_verb] [D]!"))
	D.apply_damage(rand(10,15), BRUTE, affecting, wound_bonus = CANT_WOUND)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, TRUE, -1)
	log_combat(A, D, "punched (Sleeping Carp)")
	return TRUE

/datum/martial_art/the_sleeping_carp/disarm_act(mob/living/A, mob/living/D)
	add_to_streak("D", D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "disarmed (Sleeping Carp)")
	return ..()

/datum/martial_art/the_sleeping_carp/proc/can_deflect(mob/living/carp_user)
	if(!can_use(carp_user) || !carp_user.throw_mode)
		return FALSE
	if(carp_user.incapacitated(IGNORE_GRAB)) //NO STUN
		return FALSE
	if(!(carp_user.mobility_flags & MOBILITY_USE)) //NO UNABLE TO USE
		return FALSE
	var/datum/dna/dna = carp_user.has_dna()
	if(dna?.check_mutation(/datum/mutation/human/hulk)) //NO HULK
		return FALSE
	if(!isturf(carp_user.loc)) //NO MOTHERFLIPPIN MECHS!
		return FALSE
	return TRUE

/datum/martial_art/the_sleeping_carp/proc/hit_by_projectile(mob/living/carp_user, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER

	if(!can_deflect(carp_user))
		return NONE

	carp_user.visible_message(
		span_danger("[carp_user] effortlessly swats [hitting_projectile] aside! [carp_user.p_They()] can block bullets with [carp_user.p_their()] bare hands!"),
		span_userdanger("You deflect [hitting_projectile]!"),
	)
	playsound(carp_user, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
	hitting_projectile.firer = carp_user
	hitting_projectile.set_angle(rand(0, 360))//SHING
	return COMPONENT_BULLET_PIERCED

///Signal from getting attacked with an item, for a special interaction with touch spells
/datum/martial_art/the_sleeping_carp/proc/on_attackby(mob/living/carp_user, obj/item/attack_weapon, mob/A, params)
	SIGNAL_HANDLER

	if(!istype(attack_weapon, /obj/item/melee/touch_attack))
		return
	if(!can_deflect(carp_user))
		return
	var/obj/item/melee/touch_attack/touch_weapon = attack_weapon
	carp_user.visible_message(
		span_danger("[carp_user] carefully dodges [A]'s [touch_weapon]!"),
		span_userdanger("You take great care to remain untouched by [A]'s [touch_weapon]!"),
	)
	return COMPONENT_NO_AFTERATTACK

/// Verb added to humans who learn the art of the sleeping carp.
/mob/living/proc/sleeping_carp_help()
	set name = "Вспомните учения"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>\n\
	[span_notice("Gnashing Teeth")]: Punch Punch. Deal additional damage every second (consecutive) punch!\n\
	[span_notice("Crashing Wave Kick")]: Punch Shove. Launch your opponent away from you with incredible force!\n\
	[span_notice("Keelhaul")]: Punch Grab. Kick an opponent to the floor, knocking them down! If your opponent is already prone, this move will disarm them and deal additional stamina damage to them.\n\
	<span class='notice'>While in throw mode (and not stunned, not a hulk, and not in a mech), you can reflect all projectiles that come your way, sending them back at the people who fired them! \
	Also, you are more resilient against suffering wounds in combat, and your limbs cannot be dismembered. This grants you extra staying power during extended combat, especially against slashing and other bleeding weapons. \
	You are not invincible, however- while you may not suffer debilitating wounds often, you must still watch your health and should have appropriate medical supplies for use during downtime. \
	In addition, your training has imbued you with a loathing of guns, and you can no longer use them.</span>")


/obj/item/staff/bostaff
	name = "bo staff"
	desc = "A long, tall staff made of polished wood. Traditionally used in ancient old-Earth martial arts. Can be wielded to both kill and incapacitate."
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 2
	attack_verb_continuous = list("smashes", "slams", "whacks", "thwacks")
	attack_verb_simple = list("smash", "slam", "whack", "thwack")
	icon = 'icons/obj/weapons/staff.dmi'
	icon_state = "bostaff0"
	base_icon_state = "bostaff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	block_chance = 50

/obj/item/staff/bostaff/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_unwielded = 10, \
		force_wielded = 24, \
		icon_wielded = "[base_icon_state]1", \
	)

/obj/item/staff/bostaff/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/staff/bostaff/attack(mob/target, mob/living/user, params)
	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, span_warning("You club yourself over the head with [src]."))
		user.Paralyze(6 SECONDS)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		return ..()
	if(!isliving(target))
		return ..()
	var/mob/living/carbon/C = target
	if(C.stat)
		to_chat(user, span_warning("It would be dishonorable to attack a foe while they cannot retaliate."))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(!HAS_TRAIT(src, TRAIT_WIELDED))
			return ..()
		if(!ishuman(target))
			return ..()
		var/mob/living/carbon/human/H = target
		var/list/fluffmessages = list("club", "smack", "broadside", "beat", "slam")
		H.visible_message(span_warning("[user] [pick(fluffmessages)]s [H] with [src]!"), \
						span_userdanger("[user] [pick(fluffmessages)]s you with [src]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, user)
		to_chat(user, span_danger("You [pick(fluffmessages)] [H] with [src]!"))
		playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, TRUE, -1)
		H.adjustStaminaLoss(rand(13,20))
		if(prob(10))
			H.visible_message(span_warning("[H] collapses!"), \
							span_userdanger("Your legs give out!"))
			H.Paralyze(8 SECONDS)
		if(H.staminaloss && !H.IsSleeping())
			var/total_health = (H.health - H.staminaloss)
			if(total_health <= HEALTH_THRESHOLD_CRIT && !H.stat)
				H.visible_message(span_warning("[user] delivers a heavy hit to [H]'s head, knocking [H.p_them()] out cold!"), \
								span_userdanger("You're knocked unconscious by [user]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, user)
				to_chat(user, span_danger("You deliver a heavy hit to [H]'s head, knocking [H.p_them()] out cold!"))
				H.SetSleeping(60 SECONDS)
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 150)
	else
		return ..()

/obj/item/staff/bostaff/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return ..()
	return FALSE

#undef STRONG_PUNCH_COMBO
#undef LAUNCH_KICK_COMBO
#undef DROP_KICK_COMBO
