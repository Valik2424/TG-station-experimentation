/datum/quirk/frail
	name = "Хилый"
	desc = "Мои кости очень хрупкие! Мои конечности не смогут выдержать слишком много повреждений."
	icon = FA_ICON_SKULL
	value = -6
	mob_trait = TRAIT_EASILY_WOUNDED
	gain_text = span_danger("Чувствую себя слабым.")
	lose_text = span_notice("Вновь чувствую себя крепким!")
	medical_record_text = "Пациент имеет очень слабые кости, рекомендуется кальцевая диета."
	hardcore_value = 4
	mail_goodies = list(/obj/effect/spawner/random/medical/minor_healing)
