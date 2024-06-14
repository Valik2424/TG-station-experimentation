/datum/emote/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	mob_type_blacklist_typecache = list()
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	var/mob/living/brain/B = user
	if(!istype(B) || (!(B.container && istype(B.container, /obj/item/mmi))))
		return FALSE

/datum/emote/brain/alarm
	key = "alarm"
	ru_name = "тревога"
	message = "издаёт тревожный сигнал."

/datum/emote/brain/alert
	key = "alert"
	ru_name = "опасность"
	message = "выпискивает сигнал опасности."

/datum/emote/brain/flash
	key = "flash"
	ru_name = "фонарик"
	message = "моргает своими фонариками."
	emote_type = EMOTE_VISIBLE

/datum/emote/brain/notice
	key = "notice"
	ru_name = "сигнал"
	message = "проигрывает громкий звук."

/datum/emote/brain/whistle
	key = "whistle"
	ru_name = "свисток"
	key_third_person = "свистит"
	message = "свистит."

