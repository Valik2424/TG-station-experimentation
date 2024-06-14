/obj/effect/mob_spawn/ghost_role/human/durka
	name = "спящий больной"
	prompt_name = "спящий больной"
	desc = "Смотрит мне прямо в душу. Он что-то замышляет???"
	icon = 'white/master/icons/objects.dmi'
	icon_state = "shiz"
	move_resist = MOVE_FORCE_NORMAL
	flavour_text = "Местные врачи моя последняя надежда, ведь именно благодаря им я всё ещё могу дышать и хоть как-то мыслить. Однако, каждый может быть опасным для меня... Доверять можно только моему психологу, хотя тот в последнее время что-то недоговаривает..."
	you_are_text = "Хотелось бы вылечиться и начать новую жизнь!"
	outfit = /datum/outfit/durka

/datum/outfit/durka
	name = "Больной"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/jacket/straight_jacket
	back = null

/datum/outfit/durka/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	var/new_name = H.dna.species.random_name(H.gender, TRUE)
	H.fully_replace_character_name(H.real_name, new_name)
	H.regenerate_icons()
	H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
	if(prob(90))
		H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
		if(prob(50))
			H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)

/obj/effect/mob_spawn/ghost_role/human/durka/special(mob/living/new_spawn)
	. = ..()
	var/datum/antagonist/shizoid/shiz = new
	new_spawn.mind.add_antag_datum(shiz)
	shiz.greet()
	message_admins("[ADMIN_LOOKUPFLW(new_spawn)] стал шизом.")
	log_game("[key_name(new_spawn)] стал шизом.")

/datum/antagonist/shizoid
	name = "Шизоид"
	roundend_category = "Больной"
	silent = TRUE
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	antag_hud_name = "fugitive_hunter"
	var/datum/team/shizoid_team/shizoid_team
//	greentext_reward = 10  // no meta w_w

/datum/antagonist/shizoid/forge_objectives()
	var/datum/objective/escape/escape = new
	escape.owner = owner
	objectives += escape

/datum/antagonist/shizoid/on_gain()
	forge_objectives()
	. = ..()
