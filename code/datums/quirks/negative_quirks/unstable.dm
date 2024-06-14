/datum/quirk/unstable
	name = "Неуравновешенный"
	desc = "Больше не сможете вернуть свою психику, если каким-то образом поврежу её. Надо быть очень осторожным и поддерживать свое настроение выше нормы!"
	icon = FA_ICON_ANGRY
	value = -10
	mob_trait = TRAIT_UNSTABLE
	gain_text = span_danger("Столько вещей сейчас в голове...")
	lose_text = span_notice("Чувствую себя гораздо спокойнее.")
	medical_record_text = "Психика пациента находится в уязвимом состоянии и не сможет больше оправиться после травмы."
	hardcore_value = 9
	mail_goodies = list(/obj/effect/spawner/random/entertainment/plushie)
