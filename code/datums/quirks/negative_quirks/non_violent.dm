/datum/quirk/nonviolent
	name = "Пацифист"
	desc = "Мысль о насилии будет заставлять меня чувствовать себя неприятно. Настолько, что не смогу нанести вред окружающим."
	icon = FA_ICON_PEACE
	value = -8
	mob_trait = TRAIT_PACIFISM
	gain_text = span_danger("Чувствую себя жутко, подумав о насилии!")
	lose_text = span_notice("Чувствую, что можно защитить себя вновь.")
	medical_record_text = "Пациент является пацифистом и не может заставить себя причинить вред кому-либо."
	hardcore_value = 6
	mail_goodies = list(/obj/effect/spawner/random/decoration/flower, /obj/effect/spawner/random/contraband/cannabis) // flower power
