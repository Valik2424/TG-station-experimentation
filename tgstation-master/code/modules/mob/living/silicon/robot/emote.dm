/datum/emote/silicon
	mob_type_allowed_typecache = list(/mob/living/silicon, /mob/living/simple_animal/bot)
	emote_type = EMOTE_AUDIBLE

/datum/emote/silicon/boop
	key = "boop"
	ru_name = "бупать"
	key_third_person = "boops"
	message = "бупает."

/datum/emote/silicon/buzz
	key = "buzz"
	ru_name = "гудеть"
	key_third_person = "buzzes"
	message = "гудит."
	message_param = "гудит на %t."
	emote_type = EMOTE_AUDIBLE
	sound = 'white/valtos/sound/error1.ogg'


/datum/emote/silicon/buzz2
	key = "buzz2"
	ru_name = "гудеть дважды"
	message = "гудит дважды."
	emote_type = EMOTE_AUDIBLE
	sound = 'white/valtos/sound/error2.ogg'

/datum/emote/silicon/chime
	key = "chime"
	ru_name = "звонить"
	key_third_person = "chimes"
	message = "звонит."
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/machines/chime.ogg'

/datum/emote/silicon/honk
	key = "honk"
	ru_name = "хонкать"
	key_third_person = "honks"
	message = "хонкает."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/items/bikehorn.ogg'

/datum/emote/silicon/ping
	key = "ping"
	ru_name = "пинговать"
	key_third_person = "pings"
	message = "пингует."
	message_param = "пингует %t."
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/machines/ping.ogg'

/datum/emote/silicon/sad
	key = "sad"
	ru_name = "грустить"
	message = "проигрывает грустную мелодию..."
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/misc/sadtrombone.ogg'

/datum/emote/silicon/warn
	key = "warn"
	ru_name = "тревога"
	message = "издаёт тревожный сигнал."
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/machines/warning-buzzer.ogg'

/datum/emote/silicon/slowclap
	key = "slowclap"
	ru_name = "похлопать"
	message = "начинает медленно хлопать"
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/machines/slowclap.ogg'
