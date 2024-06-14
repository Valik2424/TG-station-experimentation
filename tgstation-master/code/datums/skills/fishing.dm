/**
 * skill associated with the fishing feature. It modifies the fishing minigame difficulty
 * and is gained each time one is completed.
 */
/datum/skill/fishing
	name = "Рыбалка"
	title = "Рыбак"
	desc = "Как пусто и одиноко на этой бесплодной Земле."
	modifiers = list(SKILL_VALUE_MODIFIER = list(1, 1, 0, -1, -2, -4, -6))
	skill_item_path = /obj/item/clothing/head/soft/fishing_hat

/datum/skill/fishing/New()
	. = ..()
	levelUpMessages[SKILL_LEVEL_MASTER] = span_nicegreen("После долгих практик я начал понимать насколько глубоки воды. Как мастер рыбалки, теперь я могу понимать что пытаюсь поймать.")

/datum/skill/fishing/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_MASTER && old_level < SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)

/datum/skill/fishing/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_MASTER && new_level < SKILL_LEVEL_MASTER)
		REMOVE_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)
