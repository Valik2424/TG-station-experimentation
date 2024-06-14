#define USE_GENDER "Use gender"

/datum/preference/choiced/body_type
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	savefile_key = "body_type"
	savefile_identifier = PREFERENCE_CHARACTER

	var/list/friendly_genders = list(USE_GENDER, "Мужской", "Женский")

/datum/preference/choiced/body_type/init_possible_values()
	return friendly_genders

/datum/preference/choiced/body_type/create_default_value()
	return USE_GENDER

/datum/preference/choiced/body_type/apply_to_human(mob/living/carbon/human/target, value)
	if (value == USE_GENDER)
		target.physique = target.gender
	else
		target.physique = value == friendly_genders[2] ? MALE : FEMALE

/datum/preference/choiced/body_type/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	return initial(species.sexes)

#undef USE_GENDER
