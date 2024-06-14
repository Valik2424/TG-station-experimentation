/datum/action/changeling/regenerate
	name = "Регенерация"
	desc = "Позволяет нам вырастить и восстановить недостающие внешние конечности и жизненно важные внутренние органы, а также удалить осколки и восстановить объем крови. Стоит 10 химикатов."
	helptext = "Оповестит ближайший экипаж, если какие-либо внешние конечности будут восстановлены. Может использоваться в бессознательном состоянии."
	button_icon_state = "regenerate"
	chemical_cost = 10
	dna_cost = CHANGELING_POWER_INNATE
	req_stat = HARD_CRIT

/datum/action/changeling/regenerate/sting_action(mob/living/user)
	if(!iscarbon(user))
		user.balloon_alert(user, "все и ограны на месте!")
		return FALSE

	..()
	to_chat(user, span_notice("Чувствуем зуд, как внутри, так и снаружи, ведь наши ткани пересвязываются."))
	var/mob/living/carbon/carbon_user = user
	var/got_limbs_back = length(carbon_user.get_missing_limbs()) >= 1
	carbon_user.fully_heal(HEAL_BODY)
	// Occurs after fully heal so the ling themselves can hear the sound effects (if deaf prior)
	if(got_limbs_back)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
		carbon_user.visible_message(
			span_warning("<b>[user]</b> отращивает недостающие конечности, издавая громкие, гротескные звуки!") ,
			span_userdanger("Наши конечности вырастают, издают громкие хрустящие звуки и причиняют нам сильную боль!") ,
			span_hear("Слышу как что-то органическое разрывается!")
		)
		carbon_user.emote("scream")

	return TRUE
