/datum/martial_art/krav_maga
	name = "Krav Maga"
	id = MARTIALART_KRAVMAGA
	var/datum/action/neck_chop/neckchop = new/datum/action/neck_chop()
	var/datum/action/leg_sweep/legsweep = new/datum/action/leg_sweep()
	var/datum/action/lung_punch/lungpunch = new/datum/action/lung_punch()

/datum/action/neck_chop
	name = "Удар по шее — повреждает шею, на некоторое время лишая жертву возможности говорить."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "neckchop"

/datum/action/neck_chop/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "neck_chop")
		owner.visible_message(span_danger("<b>[owner]</b> становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("<b>[owner]</b> принимает стойку удара по шее!"), "<b><i>Cледующей атакой будет <b>Удар по шее</b>.</i></b>")
		owner.mind.martial_art.streak = "neck_chop"

/datum/action/leg_sweep
	name = "Взмах ногой — сбивает жертву с ног на короткое время."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"

/datum/action/leg_sweep/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "leg_sweep")
		owner.visible_message(span_danger("<b>[owner]</b> становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("<b>[owner]</b> принимает стойку маха ногой!"), "<b><i>Cледующей атакой будет <b>Взмах ногой</b>.</i></b>")
		owner.mind.martial_art.streak = "leg_sweep"

/datum/action/lung_punch//referred to internally as 'quick choke'
	name = "Удар в легкие — наносит сильный удар чуть выше живота жертвы, сдавливая легкие. Пострадавший на короткое время не сможет дышать."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "lungpunch"

/datum/action/lung_punch/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "quick_choke")
		owner.visible_message(span_danger("[owner] становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] принимает стойку удара в лёгкие!"), "<b><i>Cледующей атакой будет <b>Удар в легкие</b>.</i></b>")
		owner.mind.martial_art.streak = "quick_choke"//internal name for lung punch

/datum/martial_art/krav_maga/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_userdanger("Теперь я знаю искусство [name]!"))
		to_chat(owner, span_danger("Наведитесь курсором на иконку приёма, чтобы узнать о нём подробнее."))
		neckchop.Grant(owner)
		legsweep.Grant(owner)
		lungpunch.Grant(owner)

/datum/martial_art/krav_maga/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("Внезапно забываю искусство [name]..."))
	neckchop.Remove(owner)
	legsweep.Remove(owner)
	lungpunch.Remove(owner)

/datum/martial_art/krav_maga/proc/check_streak(mob/living/A, mob/living/D)
	switch(streak)
		if("neck_chop")
			streak = ""
			neck_chop(A, D)
			return TRUE
		if("leg_sweep")
			streak = ""
			leg_sweep(A, D)
			return TRUE
		if("quick_choke")//is actually lung punch
			streak = ""
			quick_choke(A, D)
			return TRUE
	return FALSE

/datum/martial_art/krav_maga/proc/leg_sweep(mob/living/A, mob/living/D)
	if(D.stat || D.IsParalyzed())
		return FALSE
	D.visible_message(span_warning("<b>[A]</b> сбивает с ног <b>[D]</b>!") , \
					span_userdanger("<b>[A]</b> сметает меня с ног!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
	to_chat(A, span_danger("Сбиваю <b>[D]</b> с ног!"))
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	D.apply_damage(5, BRUTE, BODY_ZONE_CHEST)
	D.Knockdown(6 SECONDS)
	log_combat(A, D, "leg sweeped")
	return TRUE

/datum/martial_art/krav_maga/proc/quick_choke(mob/living/A, mob/living/D)//is actually lung punch
	D.visible_message(span_warning("<b>[A]</b> долбит в грудь <b>[D]</b>!") , \
					span_userdanger("<b>[A]</b> ударяет меня в грудь! Не могу дышать!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью в грудь <b>[D]</b>!"))
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	if(D.losebreath <= 10)
		D.losebreath = clamp(D.losebreath + 5, 0, 10)
	D.adjustOxyLoss(10)
	log_combat(A, D, "quickchoked")
	return TRUE

/datum/martial_art/krav_maga/proc/neck_chop(mob/living/A, mob/living/D)
	D.visible_message(span_warning("<b>[A]</b> лупит шею <b>[D]</b> в стиле каратэ!") , \
					span_userdanger("<b>[A]</b> лупит меня в шею в стиле каратэ! Говорить не могу!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью шею <b>[D]</b> в стиле каратэ, заставляя [D.ru_ego()] замолчать!"))
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	D.apply_damage(10, A.get_attack_type(), BODY_ZONE_HEAD)
	D.adjust_silence_up_to(20 SECONDS, 20 SECONDS)
	log_combat(A, D, "neck chopped")
	return TRUE

/datum/martial_art/krav_maga/grab_act(mob/living/A, mob/living/D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "grabbed (Krav Maga)")
	..()

/datum/martial_art/krav_maga/harm_act(mob/living/A, mob/living/D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "punched")
	var/obj/item/bodypart/affecting = D.get_bodypart(D.get_random_valid_zone(A.zone_selected))
	var/picked_hit_type = pick("бьёт", "пинает")
	var/bonus_damage = 0
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "втаптывает"
	D.apply_damage(10 + bonus_damage, A.get_attack_type(), affecting)
	if(picked_hit_type == "пинает" || picked_hit_type == "втаптывает")
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		playsound(get_turf(D), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	D.visible_message(span_danger("<b>[A]</b> [picked_hit_type] <b>[D]</b>!"), \
					span_userdanger("<b>[A]</b> [picked_hit_type] меня!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Моя атака [picked_hit_type] <b>[D]</b>!"))
	log_combat(A, D, "[picked_hit_type] with [name]")
	return TRUE

/datum/martial_art/krav_maga/disarm_act(mob/living/A, mob/living/D)
	if(check_streak(A, D))
		return TRUE
	var/obj/item/stuff_in_hand = null
	stuff_in_hand = D.get_active_held_item()
	if(prob(60) && stuff_in_hand)
		if(D.temporarilyRemoveItemFromInventory(stuff_in_hand))
			A.put_in_hands(stuff_in_hand)
			D.visible_message(span_danger("<b>[A]</b> утихомиривает <b>[D]</b>!"), \
					span_userdanger("<b>[A]</b> вершит насилие надо мной!"), span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, A)
			to_chat(A, span_danger("Втаптываю <b>[D]</b> поучительно!"))
			playsound(D, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	log_combat(A, D, "shoved (Krav Maga)", "[stuff_in_hand ? " removing  [stuff_in_hand]" : ""]")
	return FALSE

//Krav Maga Gloves

/obj/item/clothing/gloves/krav_maga
	var/datum/martial_art/krav_maga/style = new

/obj/item/clothing/gloves/krav_maga/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_GLOVES)
		style.teach(user, TRUE)

/obj/item/clothing/gloves/krav_maga/dropped(mob/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		style.remove(user)

/obj/item/clothing/gloves/krav_maga/sec//more obviously named, given to sec
	name = "перчатки krav maga"
	desc = "Эти перчатки могут научить выполнять приёмы krav maga с помощью наночипов."
	icon_state = "fightgloves"
	greyscale_colors = "#c41e0d"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/krav_maga/combatglovesplus
	name = "боевые перчатки плюс"
	desc = "Эти тактические перчатки огнеупорны и электрически изолированы, а благодаря использованию технологии наночипов научат боевому искусству krav maga."
	icon_state = "black"
	greyscale_colors = "#2f2e31"
	siemens_coefficient = 0
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/krav_maga_combatglovesplus

/datum/armor/krav_maga_combatglovesplus
	bio = 90
	fire = 80
	acid = 50
