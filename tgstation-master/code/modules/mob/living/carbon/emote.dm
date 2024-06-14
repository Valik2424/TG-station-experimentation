/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	ru_name = "играть на гитаре"
	message = "делает вид, что играет на гитаре."
	hands_use_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	ru_name = "моргнуть"
	key_third_person = "моргает"
	message = "моргает."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	ru_name = "быстро моргнуть"
	message = "быстро моргает."

/datum/emote/living/carbon/clap
	key = "clap"
	ru_name = "хлопать"
	key_third_person = "хлопает"
	message = "хлопает."
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	audio_cooldown = 5 SECONDS
	vary = TRUE

/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return pick('sound/misc/clap1.ogg',
							'sound/misc/clap2.ogg',
							'sound/misc/clap3.ogg',
							'sound/misc/clap4.ogg')

/datum/emote/living/carbon/crack
	key = "crack"
	ru_name = "хрустеть"
	key_third_person = "хрустит пальцами"
	message = "хрустит пальцами."
	sound = 'sound/misc/knuckles.ogg'
	cooldown = 6 SECONDS

/datum/emote/living/carbon/crack/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	if(!iscarbon(user) || user.usable_hands < 2)
		return FALSE
	return ..()

/datum/emote/living/carbon/circle
	key = "circle"
	ru_name = "рука-круг"
	key_third_person = "circles"
	hands_use_check = TRUE

/datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, span_warning("Да у меня и рук свободных нет."))
		return
	var/obj/item/hand_item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("Изображаю круг рукой."))

/datum/emote/living/carbon/moan
	key = "moan"
	ru_name = "стонать"
	key_third_person = "стонет"
	message = "стонет!"
	message_mime = "изображает стон!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/roll
	key = "roll"
	ru_name = "перекатываться"
	key_third_person = "перекатывается"
	message = "перекатывается."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	ru_name = "чесаться"
	key_third_person = "чешется"
	message = "чешется."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/sign
	key = "sign"
	ru_name = "петь"
	key_third_person = "напевает"
	message_param = "напевает ноту %t."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	ru_name = "сигнал"
	key_third_person = "поднимает палец"
	message_param = "поднимает %t палец."
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	hands_use_check = TRUE

/datum/emote/living/carbon/slap
	key = "slap"
	ru_name = "шлёпать"
	key_third_person = "шлёпает"
	hands_use_check = TRUE
	cooldown = 3 SECONDS // to prevent endless table slamming

/datum/emote/living/carbon/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/hand_item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("Готовлюсь шлёпнуть."))
	else
		qdel(N)
		to_chat(user, span_warning("Пока не могу шлёпать."))

/datum/emote/living/carbon/snap
	key = "snap"
	ru_name = "щёлкать"
	key_third_person = "щёлкает"
	message = "щёлкает пальцами."
	message_param = "щелкает пальцами в сторону %t."
	emote_type = EMOTE_AUDIBLE
	hands_use_check = TRUE
	muzzle_ignore = TRUE

/datum/emote/living/carbon/snap/get_sound(mob/living/user)
	if(ishuman(user))
		return pick('sound/misc/fingersnap1.ogg', 'sound/misc/fingersnap2.ogg')
	return null

/datum/emote/living/carbon/shoesteal
	key = "shoesteal"
	ru_name = "украсть обувь"
	key_third_person = "крадёт обувь"
	hands_use_check = TRUE
	cooldown = 3 SECONDS

/datum/emote/living/carbon/shoesteal/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if (!.)
		return
	var/obj/item/hand_item/stealer/stealing_hand = new(user)
	if (user.put_in_hands(stealing_hand))
		user.balloon_alert(user, "готовлюсь украсть обувь...")
	else
		qdel(stealing_hand)
		user.balloon_alert(user, "не могу!")

/datum/emote/living/carbon/tail
	key = "tail"
	ru_name = "махать"
	message = "машет хвостом."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	ru_name = "подмигнуть"
	key_third_person = "подмигивает"
	message = "подмигивает."
