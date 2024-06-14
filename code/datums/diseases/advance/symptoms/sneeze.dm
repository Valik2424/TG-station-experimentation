/*Sneezing
 * Reduces stealth
 * Greatly increases resistance
 * No effect to stage speed
 * Increases transmission tremendously
 * Low level
 * Bonus: Forces a spread type of AIRBORNE with extra range!
*/
/datum/symptom/sneeze
	name = "Чихание"
	desc = "Вирус вызывает раздражение носовой полости, иногда заставляя хозяина чихать. Чихание, вызванное этим симптомом, будет распространять вирус в конусе длиной 4 метра перед носителем."
	illness = "Bard Flu"
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmittable = 4
	level = 1
	severity = 1
	symptom_delay_min = 5
	symptom_delay_max = 35
	required_organ = ORGAN_SLOT_LUNGS
	threshold_descs = list(
		"Передача 9" = "Увеличивает дальность чихания, распространяя вирус по конусу длиной 6 метров вместо конуса длиной 4 метра.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным.",
		"Скорость 17" = "Сила каждого чихания отбрасывает носителя назад, потенциально оглушая его и слегка повреждая его, если он ударится о стену или другого человека в полете."
	)
	///Emote cooldowns
	COOLDOWN_DECLARE(sneeze_cooldown)
	var/spread_range = 4
	var/cartoon_sneezing = FALSE //ah, ah, AH, AH-CHOO!!
	///if FALSE, there is a percentage chance that the mob will emote sneezing while sneeze_cooldown is on cooldown. If TRUE, won't emote again until after the off cooldown sneeze occurs.
	var/off_cooldown_sneezed = FALSE

/datum/symptom/sneeze/Start(datum/disease/advance/active_disease)
	. = ..()
	if(!.)
		return
	if(active_disease.totalTransmittable() >= 9) //longer spread range
		spread_range = 6
	if(active_disease.totalStealth() >= 4)
		suppress_warning = TRUE
	if(active_disease.totalStageSpeed() >= 17) //Yep, stage speed 17, not stage speed 7. This is a big boy threshold (effect), like the language-scrambling transmission one for the voice change symptom.
		cartoon_sneezing = TRUE //for a really fun time, distribute a disease with this threshold met while the gravity generator is down

/datum/symptom/sneeze/Activate(datum/disease/advance/active_disease)
	. = ..()
	if(!.)
		return
	var/mob/living/affected_mob = active_disease.affected_mob
	switch(active_disease.stage)
		if(1, 2, 3)
			if(!suppress_warning)
				affected_mob.emote("sniff")
		else
			if(affected_mob.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
				for(var/mob/living/exposed_mob in oview(spread_range, affected_mob))
					if(is_source_facing_target(affected_mob, exposed_mob) && disease_air_spread_walk(get_turf(affected_mob), get_turf(exposed_mob)))
						exposed_mob.AirborneContractDisease(active_disease, TRUE)
			if(cartoon_sneezing) //Yeah, this can fling you around even if you have a space suit helmet on. It's, uh, bluespace snot, yeah.
				affected_mob.emote("sneeze")
				to_chat(affected_mob, span_userdanger("Так сильно чихнул, что меня отбросило назад!"))
				var/sneeze_distance = rand(2,4) //twice as far as a normal baseball bat strike will fling you
				var/turf/target = get_ranged_target_turf(affected_mob, REVERSE_DIR(affected_mob.dir), sneeze_distance)
				affected_mob.throw_at(target, sneeze_distance, rand(1,4)) //with the wounds update, sneezing at 7 speed was causing peoples bones to spontaneously explode, turning cartoonish sneezing into a nightmarishly lethal GBS 2.0 outbreak
			else if(COOLDOWN_FINISHED(src, sneeze_cooldown) || !COOLDOWN_FINISHED(src, sneeze_cooldown) && prob(60) && !off_cooldown_sneezed)
				affected_mob.emote("sneeze")
				COOLDOWN_START(src, sneeze_cooldown, 5 SECONDS)
				if(!off_cooldown_sneezed && !COOLDOWN_FINISHED(src, sneeze_cooldown))
					off_cooldown_sneezed = TRUE
				else
					off_cooldown_sneezed = FALSE
