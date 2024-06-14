/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	ru_name = "плакать"
	key_third_person = "плачет"
	message = "плачет."
	message_mime = "беззвучно всхлипывает."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	stat_allowed = SOFT_CRIT

/datum/emote/living/carbon/human/cry/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	QDEL_IN(human_user.give_emote_overlay(/datum/bodypart_overlay/simple/emote/cry), 12.8 SECONDS)

/datum/emote/living/carbon/human/dap
	key = "dap"
	ru_name = "пожать руку"
	key_third_person = "daps"
	message = "озадаченно не может найти кому пожать руку и жмёт свою. Позорище."
	message_param = "приветственно жмёт руку братку %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	ru_name = "поднять бровь"
	message = "поднимает бровь."

/datum/emote/living/carbon/human/glasses
	key = "glasses"
	ru_name = "приподнять очки"
	key_third_person = "glasses"
	message = "приподнимает очки."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/glasses/can_run_emote(mob/user, status_check = TRUE, intentional)
	var/obj/eyes_slot = user.get_item_by_slot(ITEM_SLOT_EYES)
	if(istype(eyes_slot, /obj/item/clothing/glasses/regular) || istype(eyes_slot, /obj/item/clothing/glasses/sunglasses))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/glasses/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/image/emote_animation = image('icons/mob/human/emote_visuals.dmi', user, "glasses")
	flick_overlay_global(emote_animation, GLOB.clients, 1.6 SECONDS)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	ru_name = "ворчать"
	key_third_person = "ворчит"
	message = "ворчит!"
	message_mime = "беззвучно ворчит!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	ru_name = "пожать руку"
	message = "пожимает свои руки."
	message_param = "пожимает руку %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	ru_name = "обнять"
	key_third_person = "обнимает"
	message = "обнимает себя."
	message_param = "обнимает %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	ru_name = "бормотать"
	key_third_person = "бормочет"
	message = "бормочет!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	ru_name = "кричать"
	key_third_person = "кричит"
	message = "кричит!"
	message_mime = "делает вид, что кричит!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	only_forced_audio = TRUE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return

	return user.dna.species.get_scream_sound(user)

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	ru_name = "визжать"
	key_third_person = "screeches"
	message = "визжит."
	message_mime = "бесшумно визжит."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	vary = FALSE

/datum/emote/living/carbon/human/scream/screech/should_play_sound(mob/user, intentional)
	if(ismonkey(user))
		return TRUE
	return ..()

/datum/emote/living/carbon/human/pale
	key = "pale"
	ru_name = "побледнеть"
	message = "бледнеет на секунду."

/datum/emote/living/carbon/human/raise
	key = "raise"
	ru_name = "поднять руки"
	key_third_person = "raises"
	message = "бледнеет на секунду."
	hands_use_check = TRUE


/datum/emote/living/carbon/human/salute
	key = "salute"
	ru_name = "отдать честь"
	key_third_person = "salutes"
	message = "отдаёт честь."
	message_param = "отдаёт честь %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	ru_name = "пожать плечами"
	key_third_person = "shrugs"
	message = "пожимает плечами."

/datum/emote/living/carbon/human/wag
	key = "wag"
	ru_name = "вилять"
	key_third_person = "wags"
	message = "виляет хвостом."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/external/tail/oranges_accessory = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(oranges_accessory.wag_flags & WAG_WAGGING) //We verified the tail exists in can_run_emote()
		SEND_SIGNAL(user, COMSIG_ORGAN_WAG_TAIL, FALSE)
	else
		SEND_SIGNAL(user, COMSIG_ORGAN_WAG_TAIL, TRUE)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/obj/item/organ/external/tail/oranges_accessory = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(oranges_accessory.wag_flags & WAG_WAGGING)
		. = "прекращает вилять " + message
	else
		. = "виляет " + message

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check, intentional)
	var/obj/item/organ/external/tail/tail = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(tail?.wag_flags & WAG_ABLE)
		return ..()
	return FALSE

/datum/emote/living/carbon/human/wing
	key = "wing"
	ru_name = "крылья"
	key_third_person = "wings"
	message = "свои крылья."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/external/wings/functional/wings = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(isnull(wings))
		CRASH("[type] ran on a mob that has no wings!")
	if(wings.wings_open)
		wings.close_wings()
	else
		wings.open_wings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	var/obj/item/organ/external/wings/functional/wings = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	var/emote_verb = wings.wings_open ? "убирает" : "раскрывает"
	return "[emote_verb] [message]"

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!istype(user.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS), /obj/item/organ/external/wings/functional))
		return FALSE
	return ..()

/datum/emote/living/carbon/human/clear_throat
	key = "clear"
	ru_name = "прокашляться"
	key_third_person = "clears throat"
	message = "прокашливается."

///Snowflake emotes only for le epic chimp
/datum/emote/living/carbon/human/monkey

/datum/emote/living/carbon/human/monkey/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(ismonkey(user))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/monkey/gnarl
	key = "gnarl"
	ru_name = "рычать"
	key_third_person = "gnarls"
	message = "рычит и обнажает свои зубы..."
	message_mime = "молча скалится, обнажая зубы..."

/datum/emote/living/carbon/human/monkey/roll
	key = "roll"
	ru_name = "перекатываться"
	key_third_person = "rolls"
	message = "перекатывается."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/scratch
	key = "scratch"
	ru_name = "чесаться"
	key_third_person = "scratches"
	message = "чешется."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/screech/roar
	key = "roar"
	ru_name = "реветь"
	key_third_person = "roars"
	message = "ревёт."
	message_mime = "издаёт беззвучный рык."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/monkey/tail
	key = "tail"
	ru_name = "махать хвостом"
	message = "машет хвостом."

/datum/emote/living/carbon/human/monkey/sign
	key = "sign"
	ru_name = "петь"
	key_third_person = "signs"
	message_param = "поёт ноту %t."
	hands_use_check = TRUE
