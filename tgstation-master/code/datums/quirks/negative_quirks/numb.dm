/datum/quirk/numb
	name = "Гипозезия"
	desc = "Не чувствую боли."
	icon = FA_ICON_STAR_OF_LIFE
	value = -4
	gain_text = "Кажется, моё тело перестаёт чувствовать боль."
	lose_text = "Я снова чувствую боль."
	medical_record_text = "Пациент имеет врождённую гипозезию, что делает его нечувствительным к болевым стимулам."
	hardcore_value = 4

/datum/quirk/numb/add(client/client_source)
	quirk_holder.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/quirk/numb/remove(client/client_source)
	quirk_holder.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
