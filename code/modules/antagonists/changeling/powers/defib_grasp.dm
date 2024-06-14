/datum/action/changeling/defib_grasp
	name = "Захват дефибриллятора"
	desc = "Мы готовимся, находясь в стазисе. Если один из наших врагов попытается дефибрилировать нас, \
		мы оторвем у него руки и мгновенно выйдем из стазиса."
	helptext = "Эта способность пассивна и сработает, когда дефибриллятор будет применен к нашей груди, \
		когда мы мертвы или в стазисе. Также на мгновение оглушит киборгов."
	owner_has_control = FALSE
	dna_cost = 0

	/// Flags to pass to fully heal when we get zapped
	var/heal_flags = HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS

/datum/action/changeling/defib_grasp/on_purchase(mob/user, is_respec)
	. = ..()
	RegisterSignal(user, COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP, PROC_REF(on_defibbed))

/// Signal proc for [COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP].
/datum/action/changeling/defib_grasp/proc/on_defibbed(mob/living/carbon/source, mob/living/defibber, obj/item/shockpaddles/defib)
	SIGNAL_HANDLER

	if(source.stat != DEAD && !HAS_TRAIT_FROM(source, TRAIT_FAKEDEATH, CHANGELING_TRAIT))
		return

	INVOKE_ASYNC(src, PROC_REF(execute_defib), source, defibber, defib)
	return COMPONENT_DEFIB_STOP

/// Executes the defib action, causing the changeling to fully heal and get up.
/datum/action/changeling/defib_grasp/proc/execute_defib(mob/living/carbon/changeling, mob/living/defibber, obj/item/shockpaddles/defib)
	remove_arms(changeling, defibber, defib)

	if(changeling.stat == DEAD)
		changeling.revive(heal_flags)
	else
		changeling.fully_heal(heal_flags)

	changeling.buckled?.unbuckle_mob(changeling) // get us off of stasis beds please
	changeling.set_resting(FALSE)
	changeling.adjust_jitter(20 SECONDS)
	changeling.emote("scream")
	playsound(changeling, 'sound/magic/demon_consume.ogg', 50, TRUE)

	// Mimics some real defib stuff (wish this was more generalized)
	playsound(defib, SFX_BODYFALL, 50, TRUE)
	playsound(defib, 'sound/machines/defib_zap.ogg', 75, TRUE, -1)
	playsound(defib, 'sound/machines/defib_success.ogg', 50, FALSE) // I guess
	defib.shock_pulling(30, changeling)

/// Removes the arms of the defibber if they're a carbon, and stuns them for a bit.
/// If they're a cyborg, they'll just get stunned instead.
/datum/action/changeling/defib_grasp/proc/remove_arms(mob/living/carbon/changeling, mob/living/defibber, obj/item/shockpaddles/defib)

	if(iscyborg(defibber))
		if(defibber.flash_act(affect_silicon = TRUE))
			to_chat(defibber, span_userdanger("Внезапно [changeling] поднимается, перегружая ваши сенсоры!"))
			// run default visible message regardless, no overt indication of the cyborg being overloaded to watchers

	else
		defibber.Stun(4 SECONDS) // stuck defibbing

		if(iscarbon(defibber))
			var/removed_arms = 0
			var/mob/living/carbon/carbon_defibber = defibber
			for(var/obj/item/bodypart/arm/limb in carbon_defibber.bodyparts)
				if(limb.dismember(silent = FALSE))
					removed_arms++
					qdel(limb)

			if(removed_arms)
				// OH GOOD HEAVENS
				defibber.adjust_jitter(3 MINUTES)
				defibber.adjust_dizzy(1 MINUTES)
				defibber.adjust_stutter(1 MINUTES)
				defibber.adjust_eye_blur(10 SECONDS)
				defibber.emote("scream")

				changeling.visible_message(
					span_bolddanger("[changeling] внезапно поднимается, вырывая [defib] из рук [defibber] и отрывая [removed_arms >= 2 ? "[defibber.ru_ego()] руки" : "одну из [defibber.ru_ego()] рук"]!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
					ignored_mobs = list(changeling, defibber),
				)
				to_chat(changeling, span_changeling("Ток [defib] пронизывает нас, оживляя нас из стазиса! \
					Мы резко отрываем [removed_arms >= 2 ? "руки " : "одну из рук"] [defibber]!"))
				to_chat(defibber, span_userdanger("[changeling] внезапно поднимается, вырывая [defib] из моих рук и отрывая [removed_arms >= 2 ? "мои руки" : "одну из моих рук"]!"))
				return // no default message if we got an arm

	changeling.visible_message(
		span_bolddanger("[changeling] внезапно поднимается!"),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = changeling,
	)
	to_chat(changeling, span_changeling("Ток [defib] пронизывает нас, оживляя нас из стазиса!"))
