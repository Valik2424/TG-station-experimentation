/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isbodypart(def_zone))
			var/obj/item/bodypart/bp = def_zone
			if(bp)
				return check_armor(def_zone, type)
		var/obj/item/bodypart/affecting = get_bodypart(check_zone(def_zone))
		if(affecting)
			return check_armor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		armorval += check_armor(BP, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/check_armor(obj/item/bodypart/def_zone, damage_type)
	if(!damage_type)
		return 0
	var/protection = 100
	var/list/covering_clothing = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/obj/item/clothing/clothing_item in covering_clothing)
		if(clothing_item.body_parts_covered & def_zone.body_part)
			protection *= (100 - min(clothing_item.get_armor_rating(damage_type), 100)) * 0.01
	protection *= (100 - min(physiology.armor.get_rating(damage_type), 100)) * 0.01
	return 100 - protection

///Get all the clothing on a specific body part
/mob/living/carbon/human/proc/get_clothing_on_part(obj/item/bodypart/def_zone)
	var/list/covering_part = list()
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				covering_part += C
	return covering_part

/mob/living/carbon/human/bullet_act(obj/projectile/bullet, def_zone, piercing_hit = FALSE)

	if(bullet.firer == src && bullet.original == src) //can't block or reflect when shooting yourself
		return ..()

	if(bullet.reflectable & REFLECT_NORMAL)
		if(check_reflect(def_zone)) // Checks if you've passed a reflection% check
			visible_message(span_danger("[capitalize(src.name)] отражает [bullet.name]!") , \
							span_userdanger("[capitalize(src.name)] отражает [bullet.name]!"))
			// Finds and plays the block_sound of item which reflected
			for(var/obj/item/held_item in held_items)
				if(held_item.IsReflect(def_zone))
					playsound(src, held_item.block_sound, BLOCK_SOUND_VOLUME, TRUE)
			// Find a turf near or on the original location to bounce to
			if(!isturf(loc)) //Open canopy mech (ripley) check. if we're inside something and still got hit
				bullet.force_hit = TRUE //The thing we're in passed the bullet to us. Pass it back, and tell it to take the damage.
				loc.bullet_act(bullet, def_zone, piercing_hit)
				return BULLET_ACT_HIT
			bullet.reflect(src)

			return BULLET_ACT_FORCE_PIERCE // complete projectile permutation

	if(check_shields(bullet, bullet.damage, "[bullet.name]", PROJECTILE_ATTACK, bullet.armour_penetration, bullet.damage_type))
		bullet.on_hit(src, 100, def_zone, piercing_hit)
		return BULLET_ACT_HIT

	return ..()

///Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
/mob/living/carbon/human/proc/check_reflect(def_zone)
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone))
			return TRUE
	if(head)
		if(head.IsReflect(def_zone))
			return TRUE
	for(var/obj/item/I in held_items)
		if(I.IsReflect(def_zone))
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/check_shields(atom/AM, damage, attack_text = "атака", attack_type = MELEE_ATTACK, armour_penetration = 0, damage_type = BRUTE)
	var/block_chance_modifier = round(damage / -3)

	for(var/obj/item/I in held_items)
		if(!isclothing(I))
			var/final_block_chance = I.block_chance - (clamp((armour_penetration-I.armour_penetration)/2,0,100)) + block_chance_modifier //So armour piercing blades can still be parried by other blades, for example
			if(I.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type, damage_type))
				return TRUE
	if(wear_suit)
		var/final_block_chance = wear_suit.block_chance - (clamp((armour_penetration-wear_suit.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_suit.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type, damage_type))
			return TRUE
	if(w_uniform)
		var/final_block_chance = w_uniform.block_chance - (clamp((armour_penetration-w_uniform.armour_penetration)/2,0,100)) + block_chance_modifier
		if(w_uniform.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type, damage_type))
			return TRUE
	if(wear_neck)
		var/final_block_chance = wear_neck.block_chance - (clamp((armour_penetration-wear_neck.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_neck.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type, damage_type))
			return TRUE
	if(head)
		var/final_block_chance = head.block_chance - (clamp((armour_penetration-head.armour_penetration)/2,0,100)) + block_chance_modifier
		if(head.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type, damage_type))
			return TRUE
	if(SEND_SIGNAL(src, COMSIG_HUMAN_CHECK_SHIELDS, AM, damage, attack_text, attack_type, armour_penetration, damage_type) & SHIELD_BLOCK)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/check_block()
	if(mind)
		if(mind.martial_art && prob(mind.martial_art.block_chance) && mind.martial_art.can_use(src) && throw_mode && !incapacitated(IGNORE_GRAB))
			return TRUE
	return FALSE

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	var/obj/item/I
	var/damage_type = BRUTE
	var/throwpower = 30
	if(isitem(AM))
		I = AM
		if(I.thrownby == WEAKREF(src)) //No throwing stuff at yourself to trigger hit reactions
			return ..()
		throwpower = I.throwforce
		damage_type = I.damtype
	if(check_shields(AM, throwpower, " [AM.name]", THROWN_PROJECTILE_ATTACK, 0, damage_type))
		hitpush = FALSE
		skipcatch = TRUE
		blocked = TRUE

	return ..()

/mob/living/carbon/human/grippedby(mob/living/user, instant = FALSE)
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()


/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user)
	if(!I || !user)
		return FALSE

	var/obj/item/bodypart/affecting
	if(user == src)
		affecting = get_bodypart(check_zone(user.zone_selected)) //stabbing yourself always hits the right target
	else
		var/zone_hit_chance = 80
		if(body_position == LYING_DOWN) // half as likely to hit a different zone if they're on the ground
			zone_hit_chance += 10
		affecting = get_bodypart(get_random_valid_zone(user.zone_selected, zone_hit_chance))
	var/target_area = parse_zone(check_zone(user.zone_selected)) //our intended target

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)

	SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[I.force]", "[I.type]"))
	SSblackbox.record_feedback("tally", "zone_targeted", 1, target_area)

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I, user, affecting, src)


/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	var/hulk_verb = pick("ломает","крушит")
	if(check_shields(user, 15, "the [hulk_verb]ing", attack_type = UNARMED_ATTACK))
		return
	if(check_block()) //everybody is kung fu fighting
		return
	var/obj/item/bodypart/arm/active_arm = user.get_active_hand()
	playsound(loc, active_arm.unarmed_attack_sound, 25, TRUE, -1)
	visible_message(span_danger("<b>[user]</b> [hulk_verb] <b>[src]</b>!") , \
					span_userdanger("<b>[user]</b> [hulk_verb] <b>[src]</b>!") , span_hear("Слышу как что-то сильно бьёт по плоти!") , null, user)
	to_chat(user, span_danger("Мой удар [hulk_verb] <b>[src]</b>!"))
	apply_damage(15, BRUTE, wound_bonus=10)

/mob/living/carbon/human/attack_hand(mob/user, list/modifiers)
	if(..()) //to allow surgery to return properly.
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		dna.species.spec_attack_hand(H, src, null, modifiers)

/mob/living/carbon/human/attack_paw(mob/living/carbon/human/user, list/modifiers)
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(dam_zone))

	var/martial_result = user.apply_martial_art(src, modifiers)
	if (martial_result != MARTIAL_ATTACK_INVALID)
		return martial_result

	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //Always drop item in hand, if no item, get stunned instead.
		var/obj/item/I = get_active_held_item()
		if(I && !(I.item_flags & ABSTRACT) && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message(span_danger("[user] обезоруживает [src]!"), \
							span_userdanger("[user] обезоруживает меня!"), span_hear("Слышу агрессивную потасовку!"), null, user)
			to_chat(user, span_danger("Обезоруживаю [src]!"))
		else if(!user.client || prob(5)) // only natural monkeys get to stun reliably, (they only do it occasionaly)
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			if (src.IsKnockdown() && !src.IsParalyzed())
				Paralyze(40)
				log_combat(user, src, "pinned")
				visible_message(span_danger("[user] прижимает [src] к полу!"), \
								span_userdanger("[user] прижимает меня к полу!"), span_hear("Слышу агрессивную потасовку!"), null, user)
				to_chat(user, span_danger("Прижимаю [src] к полу!"))
			else
				Knockdown(30)
				log_combat(user, src, "tackled")
				visible_message(span_danger("[user] сбивает [src] с ног!"), \
								span_userdanger("[user] сбивает меня с ног!"), span_hear("Слышу агрессивную потасовку и громкий стук!"), null, user)
				to_chat(user, span_danger("Сбиваю [src] с ног!"))
		return TRUE

	if(!user.combat_mode)
		..() //shaking
		return FALSE

	if(user.limb_destroyer)
		dismembering_strike(user, affecting.body_zone)

	if(try_inject(user, affecting, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))//Thick suits can stop monkey bites.
		if(..()) //successful monkey bite, this handles disease contraction.
			var/obj/item/bodypart/head/monkey_mouth = user.get_bodypart(BODY_ZONE_HEAD)
			var/damage = HAS_TRAIT(user, TRAIT_PERFECT_ATTACKER) ? monkey_mouth.unarmed_damage_high : rand(monkey_mouth.unarmed_damage_low, monkey_mouth.unarmed_damage_high)
			if(!damage)
				return FALSE
			if(check_shields(user, damage, "the [user.name]"))
				return FALSE
			apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, MELEE))
		return TRUE

/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if(check_shields(user, 0, "the [user.name]"))
		visible_message(span_danger("[user] пытается дотронуться до [src]!") , \
						span_danger("[user] пытается дотронуться до меня!") , span_hear("Слышу взмах!") , null, user)
		to_chat(user, span_warning("Пытаюсь дотронуться до [src]!"))
		return FALSE
	. = ..()
	if(!.)
		return

	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //Always drop item in hand if there is one. If there's no item, shove the target. If the target is incapacitated, slam them into the ground to stun them.
		var/obj/item/I = get_active_held_item()
		if(I && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message(span_danger("[user] машет когтями в сторону [src]!") , \
							span_userdanger("[user] машет когтями в мою сторону!") , span_hear("Слышу взмах!") , null, user)
			to_chat(user, span_danger("Пытаюсь поцарапать [src]!"))
		else if(!HAS_TRAIT(src, TRAIT_INCAPACITATED))
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			var/shovetarget = get_edge_target_turf(user, get_dir(user, get_step_away(src, user)))
			adjustStaminaLoss(35)
			throw_at(shovetarget, 4, 2, user, force = MOVE_FORCE_OVERPOWERING)
			log_combat(user, src, "shoved")
			visible_message(span_danger("[user] толкает [src]!") , \
						span_userdanger("[user] толкает меня!") , span_hear("Слышу агрессивную потасовку!") , null, user)
			to_chat(user, span_danger("Толкаю [src]!"))
		else
			Paralyze(5 SECONDS)
			playsound(loc, 'sound/weapons/punch3.ogg', 25, TRUE, -1)
			visible_message("<span class='danger'>[user] впечатывает [src] в пол!</span>", \
							"<span class='userdanger'>[user] впечатывает меня в пол!</span>", "<span class='hear'>Слышу как что-то громко шлепнулось на пол!</span>", null, user)
			to_chat(user, "<span class='danger'>Падаю [src] на пол!</span>")
			log_combat(user, src, "slammed into the ground")
		return TRUE

	if(user.combat_mode)
		if (w_uniform)
			w_uniform.add_fingerprint(user)
		var/damage = prob(90) ? rand(user.melee_damage_lower, user.melee_damage_upper) : 0
		if(!damage)
			playsound(loc, 'sound/weapons/slashmiss.ogg', 50, TRUE, -1)
			visible_message(span_danger("[user] lunges at [src]!"), \
							span_userdanger("[user] lunges at you!"), span_hear("You hear a swoosh!"), null, user)
			to_chat(user, span_danger("You lunge at [src]!"))
			return FALSE
		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(user.zone_selected))
		var/armor_block = run_armor_check(affecting, MELEE,"","",10)

		playsound(loc, 'sound/weapons/slice.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user] slashes at [src]!"), \
						span_userdanger("[user] slashes at you!"), span_hear("You hear a sickening sound of a slice!"), null, user)
		to_chat(user, span_danger("You slash at [src]!"))
		log_combat(user, src, "attacked")
		if(!dismembering_strike(user, user.zone_selected)) //Dismemberment successful
			return TRUE
		apply_damage(damage, BRUTE, affecting, armor_block)




/mob/living/carbon/human/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	. = ..()
	if(!.)
		return //successful larva bite.
	var/damage = rand(L.melee_damage_lower, L.melee_damage_upper)
	if(!damage)
		return
	if(check_shields(L, damage, "[L.name]"))
		return FALSE
	if(stat != DEAD)
		L.amount_grown = min(L.amount_grown + damage, L.max_grown)
		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(L.zone_selected))
		var/armor_block = run_armor_check(affecting, MELEE)
		apply_damage(damage, BRUTE, affecting, armor_block)

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	if(!.)
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	if(check_shields(user, damage, "[user.name]", MELEE_ATTACK, user.armour_penetration, user.melee_damage_type))
		return FALSE
	var/dam_zone = dismembering_strike(user, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return TRUE
	var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(dam_zone))
	var/armor = run_armor_check(affecting, MELEE, armour_penetration = user.armour_penetration)
	var/attack_direction = get_dir(user, src)
	apply_damage(damage, user.melee_damage_type, affecting, armor, wound_bonus = user.wound_bonus, bare_wound_bonus = user.bare_wound_bonus, sharpness = user.sharpness, attack_direction = attack_direction)


/mob/living/carbon/human/attack_slime(mob/living/simple_animal/slime/M, list/modifiers)
	. = ..()
	if(!.) // slime attack failed
		return
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	if(!damage)
		return
	var/wound_mod = -45 // 25^1.4=90, 90-45=45
	if(M.is_adult)
		damage += rand(5, 10)
		wound_mod = -90 // 35^1.4=145, 145-90=55

	if(check_shields(M, damage, "[M.name]"))
		return FALSE

	var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return TRUE

	var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, MELEE)
	apply_damage(damage, BRUTE, affecting, armor_block, wound_bonus=wound_mod)


/mob/living/carbon/human/ex_act(severity, target, origin)
	if(HAS_TRAIT(src, TRAIT_BOMBIMMUNE))
		return FALSE

	. = ..()
	if (!. || !severity || QDELETED(src))
		return FALSE
	var/brute_loss = 0
	var/burn_loss = 0
	var/bomb_armor = getarmor(null, BOMB)

//200 max knockdown for EXPLODE_HEAVY
//160 max knockdown for EXPLODE_LIGHT

	var/obj/item/organ/internal/ears/ears = get_organ_slot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(bomb_armor < EXPLODE_GIB_THRESHOLD) //gibs the mob if their bomb armor is lower than EXPLODE_GIB_THRESHOLD
				for(var/thing in contents)
					switch(severity)
						if(EXPLODE_DEVASTATE)
							SSexplosions.high_mov_atom += thing
						if(EXPLODE_HEAVY)
							SSexplosions.med_mov_atom += thing
						if(EXPLODE_LIGHT)
							SSexplosions.low_mov_atom += thing
				investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
				gib(DROP_ALL_REMAINS)
				return TRUE
			else
				brute_loss = 500
				var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(throw_target, 200, 4)
				damage_clothes(400 - bomb_armor, BRUTE, BOMB)

		if (EXPLODE_HEAVY)
			brute_loss = 60
			burn_loss = 60
			if(bomb_armor)
				brute_loss = 30*(2 - round(bomb_armor*0.01, 0.05))
				burn_loss = brute_loss //damage gets reduced from 120 to up to 60 combined brute+burn
			damage_clothes(200 - bomb_armor, BRUTE, BOMB)
			if (ears && !HAS_TRAIT_FROM_ONLY(src, TRAIT_DEAF, EAR_DAMAGE))
				ears.adjustEarDamage(30, 120)
			Unconscious(20) //short amount of time for follow up attacks against elusive enemies like wizards
			Knockdown(200 - (bomb_armor * 1.6)) //between ~4 and ~20 seconds of knockdown depending on bomb armor

		if(EXPLODE_LIGHT)
			brute_loss = 30
			if(bomb_armor)
				brute_loss = 15*(2 - round(bomb_armor*0.01, 0.05))
			damage_clothes(max(50 - bomb_armor, 0), BRUTE, BOMB)
			if (ears && !HAS_TRAIT_FROM_ONLY(src, TRAIT_DEAF, EAR_DAMAGE))
				ears.adjustEarDamage(15,60)
			Knockdown(160 - (bomb_armor * 1.6)) //100 bomb armor will prevent knockdown altogether

	take_overall_damage(brute_loss,burn_loss)

	//attempt to dismember bodyparts
	if(severity >= EXPLODE_HEAVY || !bomb_armor)
		var/max_limb_loss = 0
		var/probability = 0
		switch(severity)
			if(EXPLODE_NONE)
				max_limb_loss = 1
				probability = 20
			if(EXPLODE_LIGHT)
				max_limb_loss = 2
				probability = 30
			if(EXPLODE_HEAVY)
				max_limb_loss = 3
				probability = 40
			if(EXPLODE_DEVASTATE)
				max_limb_loss = 4
				probability = 50
		for(var/X in bodyparts)
			var/obj/item/bodypart/BP = X
			if(prob(probability) && !prob(getarmor(BP, BOMB)) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.receive_damage(INFINITY, wound_bonus = CANT_WOUND) //Capped by proc
				BP.dismember()
				max_limb_loss--
				if(!max_limb_loss)
					break

	return TRUE


/mob/living/carbon/human/blob_act(obj/structure/blob/B)
	if(stat == DEAD)
		return
	show_message(span_userdanger("The blob attacks you!"))
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(dam_zone))
	apply_damage(5, BRUTE, affecting, run_armor_check(affecting, MELEE))


///Calculates the siemens coeff based on clothing and species, can also restart hearts.
/mob/living/carbon/human/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE, jitter_time = 20 SECONDS, stutter_time = 4 SECONDS, stun_duration = 4 SECONDS)
	//Calculates the siemens coeff based on clothing. Completely ignores the arguments
	if(flags & SHOCK_TESLA) //I hate this entire block. This gets the siemens_coeff for tesla shocks
		if(gloves && gloves.siemens_coefficient <= 0)
			siemens_coeff -= 0.5
		if(wear_suit)
			if(wear_suit.siemens_coefficient == -1)
				siemens_coeff -= 1
			else if(wear_suit.siemens_coefficient <= 0)
				siemens_coeff -= 0.95
		siemens_coeff = max(siemens_coeff, 0)
	else if(!(flags & SHOCK_NOGLOVES)) //This gets the siemens_coeff for all non tesla shocks
		if(gloves)
			siemens_coeff *= gloves.siemens_coefficient
	siemens_coeff *= physiology.siemens_coeff
	siemens_coeff *= dna.species.siemens_coeff
	. = ..()
	//Don't go further if the shock was blocked/too weak.
	if(!.)
		return
	if(!(flags & SHOCK_ILLUSION))
		if(shock_damage * siemens_coeff >= 5)
			force_say()
		//Note we both check that the user is in cardiac arrest and can actually heartattack
		//If they can't, they're missing their heart and this would runtime
		if(undergoing_cardiac_arrest() && can_heartattack() && (shock_damage * siemens_coeff >= 1) && prob(25))
			var/obj/item/organ/internal/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
			if(heart.Restart() && stat == CONSCIOUS)
				to_chat(src, span_notice("Моё сердце бьётся снова!"))
	if (!(flags & SHOCK_NO_HUMAN_ANIM))
		electrocution_animation(4 SECONDS)

/mob/living/carbon/human/acid_act(acidpwr, acid_volume, bodyzone_hit) //todo: update this to utilize check_obscured_slots() //and make sure it's check_obscured_slots(TRUE) to stop aciding through visors etc
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = acidpwr * min(acid_volume*0.005, 0.1)
	//HEAD//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_HEAD) //only if we didn't specify a zone or if that zone is the head.
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			if(!(head_clothes.resistance_flags & UNACIDABLE))
				head_clothes.acid_act(acidpwr, acid_volume)
				update_worn_glasses()
				update_worn_mask()
				update_worn_neck()
				update_worn_head()
			else
				to_chat(src, span_userdanger("Ощущаю острую боль в области моей роботизированной конечности!"))
		else
			. = get_bodypart(BODY_ZONE_HEAD)
			if(.)
				damaged += .
			if(ears)
				inventory_items_to_kill += ears

	//CHEST//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			if(!(chest_clothes.resistance_flags & UNACIDABLE))
				chest_clothes.acid_act(acidpwr, acid_volume)
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [chest_clothes.name] protects your body from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_CHEST)
			if(.)
				damaged += .
			if(wear_id)
				inventory_items_to_kill += wear_id
			if(r_store)
				inventory_items_to_kill += r_store
			if(l_store)
				inventory_items_to_kill += l_store
			if(s_store)
				inventory_items_to_kill += s_store


	//ARMS & HANDS//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_ARM || bodyzone_hit == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit

		if(arm_clothes)
			if(!(arm_clothes.resistance_flags & UNACIDABLE))
				arm_clothes.acid_act(acidpwr, acid_volume)
				update_worn_gloves()
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [arm_clothes.name] protects your arms and hands from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_ARM)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_ARM)
			if(.)
				damaged += .


	//LEGS & FEET//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_LEG || bodyzone_hit == BODY_ZONE_R_LEG || bodyzone_hit == "feet")
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (w_uniform.body_parts_covered & LEGS))))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (wear_suit.body_parts_covered & LEGS))))
			leg_clothes = wear_suit
		if(leg_clothes)
			if(!(leg_clothes.resistance_flags & UNACIDABLE))
				leg_clothes.acid_act(acidpwr, acid_volume)
				update_worn_shoes()
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [leg_clothes.name] protects your legs and feet from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_LEG)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_LEG)
			if(.)
				damaged += .


	//DAMAGE//
	for(var/obj/item/bodypart/affecting in damaged)
		affecting.receive_damage(acidity, 2*acidity)

		if(affecting.name == BODY_ZONE_HEAD)
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.receive_damage(acidity, 2*acidity)
				emote("scream")
				set_facial_hairstyle("Shaved", update = FALSE)
				set_hairstyle("Bald", update = FALSE)
				update_body_parts()
				ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(!bodyzone_hit)
		if(back)
			inventory_items_to_kill += back
		if(belt)
			inventory_items_to_kill += belt

		inventory_items_to_kill += held_items

	for(var/obj/item/inventory_item in inventory_items_to_kill)
		inventory_item.acid_act(acidpwr, acid_volume)
	return TRUE

///Overrides the point value that the mob is worth
/mob/living/carbon/human/singularity_act()
	. = 20
	switch(mind?.assigned_role.type)
		if(/datum/job/chief_engineer, /datum/job/station_engineer)
			. = 100
		if(/datum/job/clown)
			. = rand(-1000, 1000)
	..() //Called afterwards because getting the mind after getting gibbed is sketchy

/mob/living/carbon/human/help_shake_act(mob/living/carbon/helper)
	if(!istype(helper))
		return

	if(wear_suit)
		wear_suit.add_fingerprint(helper)
	else if(w_uniform)
		w_uniform.add_fingerprint(helper)

	return ..()

/mob/living/carbon/human/check_self_for_injuries()
	if(stat >= UNCONSCIOUS)
		return
	var/list/combined_msg = list()

	visible_message(span_notice("<b>[capitalize(src)]</b> осматривает себя.") , null)

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	combined_msg += "<div class='examine_block'><span class='info'>Моё состояние примерно такое:</span><hr><table>"

	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		missing -= body_part.body_zone
		if(body_part.bodypart_flags & BODYPART_PSEUDOPART) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
			continue
		var/limb_max_damage = body_part.max_damage
		var/status = ""
		var/brutedamage = body_part.brute_dam
		var/burndamage = body_part.burn_dam

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			status = "ФИЗИЧЕСКИЙ: [brutedamage]</span>] И \[<span class='warning'>ОЖОГИ: [burndamage]"
			if(!brutedamage && !burndamage)
				status = "НЕТ УРОНА"
		else
			if(brutedamage > 0)
				status = body_part.light_brute_msg
			if(brutedamage > (limb_max_damage*0.4))
				status = body_part.medium_brute_msg
			if(brutedamage > (limb_max_damage*0.8))
				status = body_part.heavy_brute_msg
			if(brutedamage > 0 && burndamage > 0)
				status += "</span>] \[<span class='warning'>"

			if(burndamage > (limb_max_damage*0.8))
				status += body_part.heavy_burn_msg
			else if(burndamage > (limb_max_damage*0.2))
				status += body_part.medium_burn_msg
			else if(burndamage > 0)
				status += body_part.light_burn_msg

			if(status == "")
				status = "ЦЕЛАЯ"
		var/no_damage
		if(status == "ЦЕЛАЯ" || status == "НЕТ УРОНА")
			no_damage = TRUE
		var/isdisabled = ""
		if(body_part.bodypart_disabled)
			isdisabled = "\[ПАРАЛИЗОВАНА\]"
			if(no_damage)
				isdisabled += " но"
			else
				isdisabled += " и"
		var/partmsg = "<tr><td><b>[uppertext(body_part.name)]:</b></td><td>[isdisabled] \[<span class='[no_damage ? "info" : "red"]'>[uppertext(status)]</span>\] "

		for(var/thing in body_part.wounds)
			var/datum/wound/W = thing
			switch(W.severity)
				if(WOUND_SEVERITY_TRIVIAL)
					partmsg += "\[<span class='danger'>[uppertext(W.name)]</span>\] "
				if(WOUND_SEVERITY_MODERATE)
					partmsg += "\[<span class='red'>[uppertext(W.name)]</span>\] "
				if(WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_CRITICAL)
					partmsg += "\[<span class='red'><b>[uppertext(W.name)]</b></span>\] "

		if(body_part.get_modified_bleed_rate())
			partmsg += "\[<span class='red'>КРОВОТЕЧЕНИЕ</span>\] "

		for(var/obj/item/I in body_part.embedded_objects)
			if(I.isEmbedHarmless())
				partmsg += "\[<a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(body_part)]' class='info'>[uppertext(I.name)]</a>\]"
			else
				partmsg += "\[<a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(body_part)]' class='red'>[uppertext(I.name)]</a>\]"

		combined_msg += "[partmsg]</td></tr>"

	for(var/t in missing)
		combined_msg += "<tr><td><b>[uppertext(ru_exam_parse_zone(parse_zone(t)))]:</b></td><td>\[<span class='boldannounce'>ОТСУТСТВУЕТ</span>\]</td></tr>"

	combined_msg += "</table>"

	if(getStaminaLoss())
		if(getStaminaLoss() > 30)
			combined_msg += span_info("Совсем нет сил.")
		else
			combined_msg += span_info("Чувствую усталость.")
	if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
		if(toxloss)
			if(toxloss > 10)
				combined_msg += span_danger("Мне плохо.")
			else if(toxloss > 20)
				combined_msg += span_danger("Меня тошнит.")
			else if(toxloss > 40)
				combined_msg += span_danger("Меня сейчас вырвет!")
		if(oxyloss)
			if(oxyloss > 10)
				combined_msg += span_danger("Ощущаю головокружение.")
			else if(oxyloss > 20)
				combined_msg += span_danger("Всё такое мутное вдали.")
			else if(oxyloss > 30)
				combined_msg += span_danger("Задыхаюсь!")

	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		switch(nutrition)
			if(NUTRITION_LEVEL_FULL to INFINITY)
				combined_msg += span_info("Мне вообще не хочется есть!")
			if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
				combined_msg += span_info("Почти наелся!")
			if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
				combined_msg += span_info("Не голоден.")
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				combined_msg += span_info("Надо бы покушать.")
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				combined_msg += span_info("Еда?")
			if(0 to NUTRITION_LEVEL_STARVING)
				combined_msg += span_danger("Умираю от голода!")

	//Compiles then shows the list of damaged organs and broken organs
	var/list/broken = list()
	var/list/damaged = list()
	var/broken_message
	var/damaged_message
	var/broken_plural
	var/damaged_plural
	//Sets organs into their proper list
	for(var/obj/item/organ/organ as anything in organs)
		if(organ.organ_flags & ORGAN_FAILING)
			if(broken.len)
				broken += ", "
			broken += organ.name
		else if(organ.damage > organ.low_threshold)
			if(damaged.len)
				damaged += ", "
			damaged += organ.name
	//Checks to enforce proper grammar, inserts words as necessary into the list
	if(broken.len)
		if(broken.len > 1)
			broken.Insert(broken.len, "и ")
			broken_plural = TRUE
		else
			var/holder = broken[1]	//our one and only element
			if(holder[length(holder)] == "s")
				broken_plural = TRUE
		//Put the items in that list into a string of text
		for(var/B in broken)
			broken_message += B
		combined_msg += span_warning("<hr>Похоже, [broken_message] не [broken_plural ? "работает" : "работают"]!")
	if(damaged.len)
		if(damaged.len > 1)
			damaged.Insert(damaged.len, "и ")
			damaged_plural = TRUE
		else
			var/holder = damaged[1]
			if(holder[length(holder)] == "s")
				damaged_plural = TRUE
		for(var/D in damaged)
			damaged_message += D
		combined_msg += span_info("Похоже, [damaged_message] [damaged_plural ? "имеет" : "имеют"] повреждения.")

	if(quirks.len)
		combined_msg += span_info("<hr>Имею черты: [get_quirk_string(FALSE, CAT_QUIRK_ALL)].")

	to_chat(src, combined_msg.Join("\n"))

/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	var/list/torn_items = list()

	//HEAD//
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			torn_items += head_clothes
		else if(ears)
			torn_items += ears

	//CHEST//
	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			torn_items += chest_clothes

	//ARMS & HANDS//
	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit
		if(arm_clothes)
			torn_items |= arm_clothes

	//LEGS & FEET//
	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
			leg_clothes = wear_suit
		if(leg_clothes)
			torn_items |= leg_clothes

	for(var/obj/item/I in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)

/**
 * Used by fire code to damage worn items.
 *
 * Arguments:
 * - seconds_per_tick
 * - times_fired
 * - stacks: Current amount of firestacks
 *
 */

/mob/living/carbon/human/proc/burn_clothing(seconds_per_tick, stacks)
	var/list/burning_items = list()
	var/obscured = check_obscured_slots(TRUE)
	//HEAD//

	if(glasses && !(obscured & ITEM_SLOT_EYES))
		burning_items += glasses
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		burning_items += wear_mask
	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		burning_items += wear_neck
	if(ears && !(obscured & ITEM_SLOT_EARS))
		burning_items += ears
	if(head)
		burning_items += head

	//CHEST//
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING))
		burning_items += w_uniform
	if(wear_suit)
		burning_items += wear_suit

	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves && !(obscured & ITEM_SLOT_GLOVES))
		arm_clothes = gloves
	else if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
		arm_clothes = wear_suit
	else if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
		arm_clothes = w_uniform
	if(arm_clothes)
		burning_items |= arm_clothes

	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes && !(obscured & ITEM_SLOT_FEET))
		leg_clothes = shoes
	else if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
		leg_clothes = wear_suit
	else if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
		leg_clothes = w_uniform
	if(leg_clothes)
		burning_items |= leg_clothes

	for(var/obj/item/burning in burning_items)
		burning.fire_act((stacks * 25 * seconds_per_tick)) //damage taken is reduced to 2% of this value by fire_act()

/mob/living/carbon/human/on_fire_stack(seconds_per_tick, datum/status_effect/fire_handler/fire_stacks/fire_handler)
	SEND_SIGNAL(src, COMSIG_HUMAN_BURNING)
	burn_clothing(seconds_per_tick, fire_handler.stacks)
	var/no_protection = FALSE
	if(dna && dna.species)
		no_protection = dna.species.handle_fire(src, seconds_per_tick, no_protection)
	fire_handler.harm_human(seconds_per_tick, no_protection)
