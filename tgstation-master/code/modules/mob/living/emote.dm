
/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/blush
	key = "blush"
	ru_name = "краснеть"
	key_third_person = "краснеет"
	message = "краснеет."

/datum/emote/living/blush/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	QDEL_IN(human_user.give_emote_overlay(/datum/bodypart_overlay/simple/emote/blush), 5.2 SECONDS)

/datum/emote/living/sing_tune
	key = "tunesing"
	ru_name = "напевать мелодию"
	key_third_person = "напевает мелодию"
	message = "напевает мелодию."

/datum/emote/living/bow
	key = "bow"
	ru_name = "поклониться"
	key_third_person = "кланяется"
	message = "кланяется."
	message_param = "кланяется %t."
	hands_use_check = TRUE

/datum/emote/living/burp
	key = "burp"
	ru_name = "отрыгивать"
	key_third_person = "отрыгивает"
	message = "отрыгивает."
	message_mime = "изображает отрыжку."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/choke
	key = "choke"
	ru_name = "задыхаться"
	key_third_person = "задыхается"
	message = "задыхается!"
	message_mime = "бесшумно задыхается!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/cross
	key = "cross"
	ru_name = "скрестить руки"
	key_third_person = "скрещивает свои руки"
	message = "скрещивает свои руки."
	hands_use_check = TRUE

/datum/emote/living/chuckle
	key = "chuckle"
	ru_name = "посмеиваться"
	key_third_person = "посмеивается"
	message = "посмеивается."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/collapse
	key = "collapse"
	ru_name = "упасть"
	key_third_person = "падает"
	message = "изнурённо падает!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/cough
	key = "cough"
	ru_name = "кашлять"
	key_third_person = "кашляет"
	message_mime = "изображает кашель!"
	message = "кашляет!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/cough/can_run_emote(mob/user, status_check = TRUE , intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOOTHED_THROAT))
		return FALSE

/datum/emote/living/dance
	key = "dance"
	ru_name = "танцевать"
	key_third_person = "танцует"
	message = "радостно пританцовывает."
	hands_use_check = TRUE

/datum/emote/living/deathgasp
	key = "deathgasp"
	ru_name = "имитировать смерть"
	key_third_person = "deathgasps"
	message = "содрогается в последний раз, безжизненный взгляд застывает..."
	message_robot = "сильно дрожит на мгновение, прежде чем замереть неподвижно, глаза медленно темнеют."
	message_AI = "выбрасывает шквал искр, его экран мерцает, когда его системы медленно останавливаются."
	message_alien = "издаёт ослабевающий гортанный визг, зеленая кровь течёт из пасти...."
	message_larva = "издаёт болезненное шипение и вяло падает на пол...."
	message_monkey = "издаёт слабый стон, затем падает и перестаёт двигаться...."
	message_animal_or_basic =  "перестаёт двигаться..."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE | EMOTE_IMPORTANT
	cooldown = (15 SECONDS)
	stat_allowed = HARD_CRIT

/datum/emote/living/deathgasp/run_emote(mob/living/user, params, type_override, intentional)
	if(!is_type_in_typecache(user, mob_type_allowed_typecache))
		return
	var/custom_message = user.death_message
	if(custom_message)
		message_animal_or_basic = custom_message
	. = ..()
	message_animal_or_basic = initial(message_animal_or_basic)
	if(!. && !user.can_speak() || user.getOxyLoss() >= 50)
		return //stop the sound if oxyloss too high/cant speak
	var/mob/living/carbon/carbon_user = user
	// For masks that give unique death sounds
	if(istype(carbon_user) && isclothing(carbon_user.wear_mask) && carbon_user.wear_mask.unique_death)
		playsound(carbon_user, carbon_user.wear_mask.unique_death, 200, TRUE, TRUE)
		return
	if(user.death_sound)
		playsound(user, user.death_sound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	ru_name = "пускать слюни"
	key_third_person = "пускает слюни"
	message = "пускает слюни."

/datum/emote/living/faint
	key = "faint"
	ru_name = "обморок"
	key_third_person = "падает в обморок"
	message = "падает в обморок."

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.SetSleeping(200)

/datum/emote/living/flap
	key = "flap"
	ru_name = "хлопать крыльями"
	key_third_person = "хлопает крыльями"
	message = "хлопает крыльями."
	hands_use_check = TRUE
	var/wing_time = 20

/datum/emote/living/flap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/open = FALSE
		var/obj/item/organ/external/wings/functional/wings = H.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)

		// open/close functional wings
		if(istype(wings))
			if(wings.wings_open)
				open = TRUE
				wings.close_wings()
			else
				wings.open_wings()
			addtimer(CALLBACK(wings,  open ? TYPE_PROC_REF(/obj/item/organ/external/wings/functional, open_wings) : TYPE_PROC_REF(/obj/item/organ/external/wings/functional, close_wings)), wing_time)

		// play moth flutter noise if moth wing
		if(istype(wings, /obj/item/organ/external/wings/moth))
			playsound(H, 'sound/voice/moth/moth_flutter.ogg', 50, TRUE)

/datum/emote/living/flap/aflap
	key = "aflap"
	ru_name = "яростно хлопать крыльями"
	key_third_person = "яростно хлопает крыльями"
	message = "яростно хлопает крыльями!"
	hands_use_check = TRUE
	wing_time = 10

/datum/emote/living/frown
	key = "frown"
	ru_name = "хмуриться"
	key_third_person = "хмурится"
	message = "хмурится."

/datum/emote/living/gag
	key = "gag"
	ru_name = "давиться"
	key_third_person = "давится"
	message = "давится."
	message_mime = "давится бесшумно."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/gasp
	key = "gasp"
	ru_name = "задыхаться"
	key_third_person = "задыхается"
	message = "задыхается!"
	message_mime = "задыхается бесшумно!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = HARD_CRIT

/datum/emote/living/gasp_shock
	key = "gaspshock"
	ru_name = "шокированный вздох"
	key_third_person = "шокированно вздыхает"
	message = "шокированно вздыхает!"
	message_mime = "шокированно безвучно вздыхает!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = SOFT_CRIT

/datum/emote/living/gasp_shock/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(human_user.dna.species.id == SPECIES_HUMAN && !HAS_MIND_TRAIT(human_user, TRAIT_MIMING))
		if(human_user.physique == FEMALE)
			return pick('sound/voice/human/gasp_female1.ogg', 'sound/voice/human/gasp_female2.ogg', 'sound/voice/human/gasp_female3.ogg')
		else
			return pick('sound/voice/human/gasp_male1.ogg', 'sound/voice/human/gasp_male2.ogg')

/datum/emote/living/giggle
	key = "giggle"
	ru_name = "хихикать"
	key_third_person = "хихикает"
	message = "хихикает."
	message_mime = "тихо хихикает!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/glare
	key = "glare"
	ru_name = "глазеть"
	key_third_person = "глазеет"
	message = "глазеет."
	message_param = "глазеет на %t."

/datum/emote/living/grin
	key = "grin"
	ru_name = "ухмыляться"
	key_third_person = "ухмыляется"
	message = "ухмыляется."

/datum/emote/living/groan
	key = "groan"
	ru_name = "стонать"
	key_third_person = "стонет"
	message = "стонет!"
	message_mime = "изображает стон!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/grimace
	key = "grimace"
	ru_name = "морщиться"
	key_third_person = "grimaces"
	message = "морщится."

/datum/emote/living/jump
	key = "jump"
	ru_name = "подпрыгивать"
	key_third_person = "подпрыгивает"
	message = "подпрыгивает!"
	hands_use_check = TRUE

/datum/emote/living/jump/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_y = user.pixel_y + 4, time = 0.1 SECONDS)
	animate(pixel_y = user.pixel_y - 4, time = 0.1 SECONDS)

/datum/emote/living/jump/get_sound(mob/living/user)
	return 'sound/weapons/thudswoosh.ogg'

/datum/emote/living/kiss
	key = "kiss"
	ru_name = "поцеловать"
	key_third_person = "целует"
	cooldown = 3 SECONDS

/datum/emote/living/kiss/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/kiss_type = /obj/item/hand_item/kisser

	if(HAS_TRAIT(user, TRAIT_KISS_OF_DEATH))
		kiss_type = /obj/item/hand_item/kisser/death

	var/obj/item/kiss_blower = new kiss_type(user)
	if(user.put_in_hands(kiss_blower))
		to_chat(user, span_notice("Готовлю свою руку для воздушного поцелуя."))
	else
		qdel(kiss_blower)
		to_chat(user, span_warning("Пока что не могу послать воздушный поцелуй!"))

/datum/emote/living/laugh
	key = "laugh"
	ru_name = "смеяться"
	key_third_person = "смеётся"
	message = "смеётся."
	message_mime = "тихо смеётся!"
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	return ..() && user.can_speak(allow_mimes = TRUE)

/datum/emote/living/laugh/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(human_user.dna.species.id == SPECIES_HUMAN && !HAS_MIND_TRAIT(human_user, TRAIT_MIMING))
		if(human_user.gender == FEMALE)
			return 'sound/voice/human/womanlaugh.ogg'
		else
			return pick('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg')

/datum/emote/living/look
	key = "look"
	ru_name = "смотреть"
	key_third_person = "смотрит"
	message = "смотрит."
	message_param = "смотрит на %t."

/datum/emote/living/nod
	key = "nod"
	ru_name = "кивать"
	key_third_person = "кивает"
	message = "кивает."
	message_param = "кивает %t."

/datum/emote/living/point
	key = "point"
	ru_name = "показать на"
	key_third_person = "показывает"
	message = "показывает."
	message_param = "показывает на %t."
	hands_use_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.usable_hands == 0)
			if(H.usable_legs != 0)
				message_param = "пытается показать на %t своей ногой, [span_userdanger("но падает на пол")] в процессе!"
				H.Paralyze(20)
			else
				message_param = "[span_userdanger("бьётся своей головой о землю")] пытаясь показать на %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	return ..()

/datum/emote/living/pout
	key = "pout"
	ru_name = "дуть"
	key_third_person = "дует"
	message = "дует."
	message_mime = "дует бесшумно."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scream
	key = "scream"
	ru_name = "кричать"
	key_third_person = "кричит"
	message = "кричит!"
	message_mime = "изображает крик!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	mob_type_blacklist_typecache = list(/mob/living/carbon/human) //Humans get specialized scream.

/datum/emote/living/scream/select_message_type(mob/user, message, intentional)
	. = ..()
	if(!intentional && isanimal_or_basicmob(user))
		return "издает громкий и страдальческий крик."

/datum/emote/living/scowl
	key = "scowl"
	ru_name = "хмуриться"
	key_third_person = "хмурится"
	message = "хмурится."

/datum/emote/living/shake
	key = "shake"
	ru_name = "качать головой"
	key_third_person = "качает головой"
	message = "качает головой."

/datum/emote/living/shiver
	key = "shiver"
	ru_name = "дрожать"
	key_third_person = "дрожит"
	message = "дрожит."

#define SHIVER_LOOP_DURATION (1 SECONDS)
/datum/emote/living/shiver/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	for(var/i in 1 to SHIVER_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
		animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
#undef SHIVER_LOOP_DURATION

/datum/emote/living/sigh
	key = "sigh"
	ru_name = "вздыхать"
	key_third_person = "вздыхает"
	message = "вздыхает."
	message_mime = "изображает тяжкий вздох."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/sigh/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!ishuman(user))
		return
	var/image/emote_animation = image('icons/mob/human/emote_visuals.dmi', user, "sigh")
	flick_overlay_global(emote_animation, GLOB.clients, 2.0 SECONDS)

/datum/emote/living/sit
	key = "sit"
	ru_name = "сесть"
	key_third_person = "садится"
	message = "садится."

/datum/emote/living/smile
	key = "smile"
	ru_name = "улыбаться"
	key_third_person = "улыбается"
	message = "улыбается."

/datum/emote/living/sneeze
	key = "sneeze"
	ru_name = "чихать"
	key_third_person = "чихает"
	message = "чихает."
	message_mime = "изображает бесшумный чих."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/smug
	key = "smug"
	ru_name = "ухмыляться"
	key_third_person = "ухмыляется"
	message = "самодовольно ухмыляеться."

/datum/emote/living/sniff
	key = "sniff"
	ru_name = "сопеть"
	key_third_person = "сопит"
	message = "сопит."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/snore
	key = "snore"
	ru_name = "храпеть"
	key_third_person = "храпит"
	message = "храпит."
	message_mime = "громко храпит."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/stare
	key = "stare"
	ru_name = "пялиться"
	key_third_person = "пялится"
	message = "пялится."
	message_param = "пялится на %t."

/datum/emote/living/strech
	key = "stretch"
	ru_name = "протянуть руки"
	key_third_person = "протягивает руки"
	message = "протягивает руки."

/datum/emote/living/sulk
	key = "sulk"
	ru_name = "дуться"
	key_third_person = "дуется"
	message = "грустно дуется."

/datum/emote/living/surrender
	key = "surrender"
	ru_name = "сдаться"
	key_third_person = "сдаётся"
	message = "кладёт свои руки за голову, падает на пол и сдаётся!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/surrender/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Paralyze(200)
		L.remove_status_effect(/datum/status_effect/grouped/surrender)

/datum/emote/living/sway
	key = "sway"
	ru_name = "качаться"
	key_third_person = "качается"
	message = "головокружительно качается вокруг."

/datum/emote/living/sway/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 2, time = 0.5 SECONDS)
	for(var/i in 1 to 2)
		animate(pixel_x = user.pixel_x - 4, time = 1.0 SECONDS)
		animate(pixel_x = user.pixel_x + 4, time = 1.0 SECONDS)
	animate(pixel_x = user.pixel_x - 2, time = 0.5 SECONDS)

/datum/emote/living/tilt
	key = "tilt"
	ru_name = "наклонить голову"
	key_third_person = "наклоняет голову"
	message = "наклоняет голову в сторону."

/datum/emote/living/tremble
	key = "tremble"
	ru_name = "бояться"
	key_third_person = "дрожит"
	message = "дрожит от страха!"

#define TREMBLE_LOOP_DURATION (4.4 SECONDS)
/datum/emote/living/tremble/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 2, time = 0.2 SECONDS)
	for(var/i in 1 to TREMBLE_LOOP_DURATION / (0.4 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_x = user.pixel_x - 2, time = 0.2 SECONDS)
		animate(pixel_x = user.pixel_x + 2, time = 0.2 SECONDS)
	animate(pixel_x = user.pixel_x - 2, time = 0.2 SECONDS)
#undef TREMBLE_LOOP_DURATION

/datum/emote/living/twitch
	key = "twitch"
	ru_name = "дёрнуться"
	key_third_person = "резко дёргается"
	message = "резко дёргается."

/datum/emote/living/twitch/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	animate(time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)

/datum/emote/living/twitch_s
	key = "twitch_s"
	ru_name = "слабо дёрнуться"
	message = "дёргается."

/datum/emote/living/twitch_s/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)

/datum/emote/living/wave
	key = "wave"
	ru_name = "махать"
	key_third_person = "машет"
	message = "машет."

/datum/emote/living/whimper
	key = "whimper"
	ru_name = "хныкать"
	key_third_person = "хнычет"
	message = "хнычет."
	message_mime = "изображает обиду."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/wsmile
	key = "wsmile"
	ru_name = "слабо улыбаться"
	key_third_person = "слегка улыбается"
	message = "слабо улыбается."

/// The base chance for your yawn to propagate to someone else if they're on the same tile as you
#define YAWN_PROPAGATE_CHANCE_BASE 40
/// The base chance for your yawn to propagate to someone else if they're on the same tile as you
#define YAWN_PROPAGATE_CHANCE_DECAY 8

/datum/emote/living/yawn
	key = "yawn"
	ru_name = "зевать"
	key_third_person = "зевает"
	message = "зевает."
	message_mime = "изображает наигранный молчаливый зевок."
	message_robot = "мелодично зевает."
	message_AI = "мелодично зевает."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	cooldown = 5 SECONDS

/datum/emote/living/yawn/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!isliving(user))
		return

	if(TIMER_COOLDOWN_FINISHED(user, COOLDOWN_YAWN_PROPAGATION))
		TIMER_COOLDOWN_START(user, COOLDOWN_YAWN_PROPAGATION, cooldown * 3)

	var/mob/living/carbon/carbon_user = user
	if(istype(carbon_user) && ((carbon_user.wear_mask?.flags_inv & HIDEFACE) || carbon_user.head?.flags_inv & HIDEFACE))
		return // if your face is obscured, skip propagation

	var/propagation_distance = user.client ? 5 : 2 // mindless mobs are less able to spread yawns

	for(var/mob/living/iter_living in view(user, propagation_distance))
		if(IS_DEAD_OR_INCAP(iter_living) || TIMER_COOLDOWN_RUNNING(iter_living, COOLDOWN_YAWN_PROPAGATION))
			continue

		var/dist_between = get_dist(user, iter_living)
		var/recently_examined = FALSE // if you yawn just after someone looks at you, it forces them to yawn as well. Tradecraft!

		if(iter_living.client)
			var/examine_time = LAZYACCESS(iter_living.client?.recent_examines, user)
			if(examine_time && (world.time - examine_time < YAWN_PROPAGATION_EXAMINE_WINDOW))
				recently_examined = TRUE

		if(!recently_examined && !prob(YAWN_PROPAGATE_CHANCE_BASE - (YAWN_PROPAGATE_CHANCE_DECAY * dist_between)))
			continue

		var/yawn_delay = rand(0.2 SECONDS, 0.7 SECONDS) * dist_between
		addtimer(CALLBACK(src, PROC_REF(propagate_yawn), iter_living), yawn_delay)

/// This yawn has been triggered by someone else yawning specifically, likely after a delay. Check again if they don't have the yawned recently trait
/datum/emote/living/yawn/proc/propagate_yawn(mob/user)
	if(!istype(user) || TIMER_COOLDOWN_RUNNING(user, COOLDOWN_YAWN_PROPAGATION))
		return
	user.emote("yawn")

#undef YAWN_PROPAGATE_CHANCE_BASE
#undef YAWN_PROPAGATE_CHANCE_DECAY

/datum/emote/living/gurgle
	key = "gurgle"
	ru_name = "булькать"
	key_third_person = "булькает"
	message = "издает неприятное бульканье."
	message_mime = "издает тихое, неприятное бульканье."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	message = null

/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/emote_is_valid(mob/user, input)
	// We're assuming clientless mobs custom emoting is something codebase-driven and not player-driven.
	// If players ever get the ability to force clientless mobs to emote, we'd need to reconsider this.
	if(!user.client)
		return TRUE

	if(CAN_BYPASS_FILTER(user))
		return TRUE

	var/static/regex/stop_bad_mime = regex(@"говорит|восклицает|кричит|спрашивает")
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, span_danger("Не знаю что делать."))
		return FALSE

	var/list/filter_result = is_ic_filtered(input)

	if(filter_result)
		to_chat(user, span_warning("Возможно мне не стоит это изображать."))
		to_chat(user, span_warning("\"[input]\""))
		REPORT_CHAT_FILTER_TO_USER(user, filter_result)
		log_filter("IC Emote", input, filter_result)
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return FALSE

	filter_result = is_soft_ic_filtered(input)

	if(filter_result)
		if(tgui_alert(user,"Не думаю что изображать \"[filter_result[CHAT_FILTER_INDEX_WORD]]\" хорошая идея. \"[filter_result[CHAT_FILTER_INDEX_REASON]]\", Продолжить?", "Заблокированное слово", list("Да", "Нет")) != "Да")
			SSblackbox.record_feedback("tally", "soft_ic_blocked_words", 1, lowertext(config.soft_ic_filter_regex.match))
			log_filter("Soft IC Emote", input, filter_result)
			return FALSE

		message_admins("[ADMIN_LOOKUPFLW(user)] has passed the soft filter for emote \"[filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Emote: \"[input]\"")
		log_admin_private("[key_name(user)] has passed the soft filter for emote \"[filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Emote: \"[input]\"")
		SSblackbox.record_feedback("tally", "passed_soft_ic_blocked_words", 1, lowertext(config.soft_ic_filter_regex.match))
		log_filter("Soft IC Emote (Passed)", input, filter_result)

	return TRUE

/datum/emote/living/custom/proc/get_custom_emote_from_user()
	return copytext(sanitize(input("Выберите эмоцию.") as text|null), 1, MAX_MESSAGE_LEN)

/datum/emote/living/custom/proc/get_custom_emote_type_from_user()
	var/type = input("Это визуальная или слышимая эмоция?") as null|anything in list("Визуальная", "Слышимая")

	switch(type)
		if("Visible")
			return EMOTE_VISIBLE
		if("Hearable")
			return EMOTE_AUDIBLE
		else
			tgui_alert(usr,"Не могу использовать, нужно выбрать слышимая или видимая она.")
			return FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE

	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("Не могу использовать эмоции (НАКАЗАН)."))
		return FALSE

	if(QDELETED(user))
		return FALSE

	if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("Вы не можете отправлять сообщения в IC (мут)."))
		return FALSE

	message = params ? params : get_custom_emote_from_user()

	if(!emote_is_valid(user, message))
		message = null
		return FALSE

	if(!params)
		var/user_emote_type = get_custom_emote_type_from_user()

		if(!user_emote_type)
			return FALSE

		emote_type = user_emote_type
	else if(type_override)
		emote_type = type_override

	. = ..()

	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/beep
	key = "beep"
	ru_name = "бипать"
	key_third_person = "бипает"
	message = "пищит."
	message_param = "пищит на %t."
	sound = 'sound/machines/twobeep.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/inhale
	key = "inhale"
	ru_name = "вдохнуть"
	key_third_person = "делает вдох"
	message = "делает вдох."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/exhale
	key = "exhale"
	ru_name = "выдохнуть"
	key_third_person = "делает выдох"
	message = "делает выдох."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/swear
	key = "swear"
	ru_name = "ругаться"
	key_third_person = "ругается"
	message = "ругается!"
	message_mime = "делает грубый жест!"
	emote_type = EMOTE_AUDIBLE
