/obj/item/firing_pin
	name = "электронный боек"
	desc = "Небольшое устройство аутентификации которое вживляется в обычный боек. Правила безопасности NT требуют, чтобы все виды стрелкового вооружения поставлялись с таким бойком."
	icon = 'icons/obj/device.dmi'
	icon_state = "firing_pin"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("тыкает")
	attack_verb_simple = list("тык")
	var/fail_message = "неавторизованный пользователь!"
	/// Explode when user check is failed.
	var/selfdestruct = FALSE
	/// Can forcefully replace other pins.
	var/force_replace = FALSE
	/// Can be replaced by any pin.
	var/pin_hot_swappable = FALSE
	///Can be removed from the gun using tools or replaced by a pin with force_replace
	var/pin_removable = TRUE
	var/obj/item/gun/gun

/obj/item/firing_pin/New(newloc)
	..()
	if(isgun(newloc))
		gun = newloc

/obj/item/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		if(isgun(target))
			. |= AFTERATTACK_PROCESSED_ITEM
			var/obj/item/gun/targetted_gun = target
			var/obj/item/firing_pin/old_pin = targetted_gun.pin
			if(old_pin?.pin_removable && (force_replace || old_pin.pin_hot_swappable))
				if(Adjacent(user))
					user.put_in_hands(old_pin)
				else
					old_pin.forceMove(targetted_gun.drop_location())
				old_pin.gun_remove(user)

			if(!targetted_gun.pin)
				if(!user.temporarilyRemoveItemFromInventory(src))
					return .
				if(gun_insert(user, targetted_gun))
					if(old_pin)
						balloon_alert(user, "поменял боек")
					else
						balloon_alert(user, "вставил боек")
			else
				to_chat(user, span_notice("Боек уже установлен внутри."))

			return .

/obj/item/firing_pin/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "проверки доступа перезаписаны")
	return TRUE

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	forceMove(gun)
	gun.pin = src
	return TRUE

/obj/item/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	return TRUE

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		balloon_alert(user, fail_message)
	if(selfdestruct)
		if(user)
			user.show_message("[span_danger("САМОУНИЧТОЖЕНИЕ...")]<br>", MSG_VISUAL)
			to_chat(user, span_userdanger("[gun] взрывается!"))
		explosion(src, devastation_range = -1, light_impact_range = 2, flash_range = 3)
		if(gun)
			qdel(gun)


/obj/item/firing_pin/magic
	name = "осколок магического кристалла"
	desc = "Маленький зачарованный осколок. С его помощью происходит выстрел во всех магических оружиях!"


// Test pin, works only near firing range.
/obj/item/firing_pin/test_range
	name = "тренировочный боек"
	desc = "Этот боек позволяет использовать стрелковое оружие только на стрельбище."
	fail_message = "вы не на стрельбище!"
	pin_hot_swappable = TRUE

/obj/item/firing_pin/test_range/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	if (istype(get_area(user), /area/station/security/range))
		return TRUE
	return FALSE


// Implant pin, checks for implant
/obj/item/firing_pin/implant
	name = "персональный боек"
	desc = "Этот боек позволяет использовать оружие только авторизованным соответстввующим образом пользователям."
	fail_message = "нет импланта!"
	var/obj/item/implant/req_implant = null

/obj/item/firing_pin/implant/pin_auth(mob/living/user)
	if(user)
		for(var/obj/item/implant/I in user.implants)
			if(req_implant && I.type == req_implant)
				return TRUE
	return FALSE

/obj/item/firing_pin/implant/mindshield
	name = "боек службы безопасности"
	desc = "Этот боек позволяет использовать оружие пользователям с установленным имплантом защиты разума."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

/obj/item/firing_pin/implant/pindicate
	name = "боек синдиката"
	icon_state = "firing_pin_pindi"
	req_implant = /obj/item/implant/weapons_auth



// Honk pin, clown's joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun!
/obj/item/firing_pin/clown
	name = "смешной боек"
	desc = "Продвинутые технологии клоунов могут преобразовать любое оружие в гораздо более полезную вещь."
	color = "#FFFF00"
	fail_message = "<b>ХОНК!</b>"
	force_replace = TRUE

/obj/item/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
	return FALSE

// Ultra-honk pin, clown's deadly joke item.
// A gun with ultra-honk pin is useful for clown and useless for everyone else.
/obj/item/firing_pin/clown/ultra
	name = "очень смешной боек"

/obj/item/firing_pin/clown/ultra/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, TRUE)
	if(QDELETED(user))  //how the hell...?
		stack_trace("/obj/item/firing_pin/clown/ultra/pin_auth called with a [isnull(user) ? "null" : "invalid"] user.")
		return TRUE
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clumsy
		return TRUE
	if(user.mind)
		if(is_clown_job(user.mind.assigned_role)) //traitor clowns can use this, even though they're technically not clumsy
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/clownop)) //clown ops aren't clumsy by default and technically don't have an assigned role of "Clown", but come on, they're basically clowns
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/leader/clownop)) //Wanna hear a funny joke?
			return TRUE //The clown op leader antag datum isn't a subtype of the normal clown op antag datum.
	return FALSE

/obj/item/firing_pin/clown/ultra/gun_insert(mob/living/user, obj/item/gun/G)
	..()
	G.clumsy_check = FALSE

/obj/item/firing_pin/clown/ultra/gun_remove(mob/living/user)
	gun.clumsy_check = initial(gun.clumsy_check)
	..()

// Now two times deadlier!
/obj/item/firing_pin/clown/ultra/selfdestruct
	name = "очень-очень смешной боек"
	desc = "Продвинутые технологии клоунов могут преобразовать любое оружие в гораздо более полезную вещь. Внутрь установлен небольшой заряд нитробананиума."
	selfdestruct = TRUE


// DNA-keyed pin.
// When you want to keep your toys for yourself.
/obj/item/firing_pin/dna
	name = "ДНК-блокируемый боек"
	desc = "Это боек, заблокированный ДНК, который разрешает использовать только одному пользователю. Прежде чем стрелять авторизуйте пользователя."
	icon_state = "firing_pin_dna"
	fail_message = "проверка ДНК провалена!"
	var/unique_enzymes = null

/obj/item/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			balloon_alert(user, "Блокировка ДНК установлена")

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			balloon_alert(user, "Блокировка ДНК установлена")
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "Это боек, заблокированный ДНК, который разрешает использовать только одному пользователю. Прежде чем стрелять авторизуйте пользователя. Внутрь установлена небольшая порция взрывчатки."
	selfdestruct = TRUE

// Paywall pin, brought to you by ARMA 3 DLC.
// Checks if the user has a valid bank account on an ID and if so attempts to extract a one-time payment to authorize use of the gun. Otherwise fails to shoot.
/obj/item/firing_pin/paywall
	name = "еврейский боек"
	desc = "Чтобы стрелять следует <b>ПЛОТИТЬ</b>."
	color = "#FFD700"
	fail_message = ""
	///list of account IDs which have accepted the license prompt. If this is the multi-payment pin, then this means they accepted the waiver that each shot will cost them money
	var/list/gun_owners = list()
	///how much gets paid out to license yourself to the gun
	var/payment_amount
	var/datum/bank_account/pin_owner
	///if true, user has to pay everytime they fire the gun
	var/multi_payment = FALSE
	var/owned = FALSE
	///purchase prompt to prevent spamming it, set to the user who opens to prompt to prevent locking the gun up for other users.
	var/active_prompt_user

/obj/item/firing_pin/paywall/attack_self(mob/user)
	multi_payment = !multi_payment
	to_chat(user, span_notice("Вы настраиваете боек чтобы [( multi_payment ) ? "платить за каждый выстрел " : "купить лицензию сразу"]."))

/obj/item/firing_pin/paywall/examine(mob/user)
	. = ..()
	if(pin_owner)
		. += span_notice("В данный момент боек расходует средства с аккаунта [pin_owner.account_holder].")

/obj/item/firing_pin/paywall/gun_insert(mob/living/user, obj/item/gun/G)
	if(!pin_owner)
		to_chat(user, span_warning("Ошибка! Пожалуйста, проведите по бойку ID-картой авторизованного члена экипажа"))
		user.put_in_hands(src)
		return FALSE
	gun = G
	forceMove(gun)
	gun.pin = src
	if(multi_payment)
		gun.desc += span_notice("Внутрь [gun.name] установлен еврейский боек с [payment_amount] кредитов[( payment_amount > 1 ) ? "s" : ""].")
		return TRUE
	gun.desc += span_notice(" Внутрь [gun.name] установлен еврейский боек  с безлимитной лицензией на стрельбу стоимостью [payment_amount] кредитов[( payment_amount > 1 ) ? "s" : ""].")
	return TRUE


/obj/item/firing_pin/paywall/gun_remove(mob/living/user)
	gun.desc = initial(desc)
	..()

/obj/item/firing_pin/paywall/attackby(obj/item/M, mob/living/user, params)
	if(isidcard(M))
		var/obj/item/card/id/id = M
		if(!id.registered_account)
			to_chat(user, span_warning("ОШИБКА: У данного ID отсутствует зарегистрированный банковский счет!"))
			return
		if(id.registered_account != pin_owner && owned)
			to_chat(user, span_warning("ОШИБКА: Этот боек уже авторизован!"))
			return
		if(id.registered_account == pin_owner)
			to_chat(user, span_notice("Отвязываю банковский счёт от бойка."))
			gun_owners -= user.get_bank_account()
			pin_owner = null
			owned = FALSE
			return
		var/transaction_amount = tgui_input_number(user, "Для покупки оружия внесите депозит", "Депозит")
		if(!transaction_amount || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
			return
		pin_owner = id.registered_account
		owned = TRUE
		payment_amount = transaction_amount
		gun_owners += user.get_bank_account()
		to_chat(user, span_notice("Вы привязываете карту к бойку"))

/obj/item/firing_pin/paywall/pin_auth(mob/living/user)
	if(!istype(user))//nice try commie
		return FALSE
	var/datum/bank_account/credit_card_details = user.get_bank_account()
	if(credit_card_details in gun_owners)
		if(multi_payment && credit_card_details)
			if(!gun.can_shoot())
				return TRUE //So you don't get charged for attempting to fire an empty gun.
			if(credit_card_details.adjust_money(-payment_amount, "Еврейский боек: аренда оружия"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "Еврейский боек: аренда оружия")
				return TRUE
			to_chat(user, span_warning("ОШИБКА: мало деняк на счету!"))
			return FALSE
		return TRUE
	if(!credit_card_details)
		to_chat(user, span_warning("ОШИБКА: Нет подходящего счёта для списания деняк!"))
		return FALSE
	if(active_prompt_user == user)
		return FALSE
	active_prompt_user = user
	var/license_request = tgui_alert(user, "Вы хотите заплатить [payment_amount] кредитов[( payment_amount > 1 ) ? "s" : ""] за [( multi_payment ) ? "каждый выстрел из [gun.name]" : "купить абонемент [gun.name]"]?", "Покупка оружия", list("Yes", "No"), 15 SECONDS)
	if(!user.can_perform_action(src))
		active_prompt_user = null
		return FALSE
	switch(license_request)
		if("Yes")
			if(multi_payment)
				gun_owners += credit_card_details
				to_chat(user, span_notice("Условия аренды оружия согласованы, удачного вам дня!"))

			else if(credit_card_details.adjust_money(-payment_amount, "Боек: лицензия на оружие"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "Боек: покупка лицензии на оружие")
				gun_owners += credit_card_details
				to_chat(user, span_notice("Лицензия на оружие куплена, удачного дня!"))

			else
				to_chat(user, span_warning("ОШИБКА: Мало деняк для успешной операции!"))

		if("No", null)
			to_chat(user, span_warning("ОШИБКА: Пользователь отказался приобрести лицензию на оружие!"))
	active_prompt_user = null
	return FALSE //we return false here so you don't click initially to fire, get the prompt, accept the prompt, and THEN the gun

// Explorer Firing Pin- Prevents use on station Z-Level, so it's justifiable to give Explorers guns that don't suck.
/obj/item/firing_pin/explorer
	name = "outback firing pin"
	desc = "A firing pin used by the austrailian defense force, retrofit to prevent weapon discharge on the station."
	icon_state = "firing_pin_explorer"
	fail_message = "cannot fire while on station, mate!"

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/explorer/pin_auth(mob/living/user)
	var/turf/station_check = get_turf(user)
	if(!station_check || is_station_level(station_check.z))
		return FALSE
	return TRUE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = "suit check failed!"
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return TRUE
	to_chat(user, span_warning("You need to be wearing [tagcolor] laser tag armor!"))
	return FALSE

/obj/item/firing_pin/tag/red
	name = "red laser tag firing pin"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "red"

/obj/item/firing_pin/tag/blue
	name = "blue laser tag firing pin"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "blue"

/obj/item/firing_pin/monkey
	name = "обезьяний боек"
	desc = "Этот боек запрещает стрелять не-мартышкам из оружия в который установлен."
	fail_message = "not a monkey!"

/obj/item/firing_pin/monkey/pin_auth(mob/living/user)
	if(!is_simian(user))
		playsound(get_turf(src), "sound/creatures/monkey/monkey_screech_[rand(1,7)].ogg", 75, TRUE)
		return FALSE
	return TRUE

/obj/item/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()
