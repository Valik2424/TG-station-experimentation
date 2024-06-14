/// Docks the target's pay
/datum/smite/dock_pay
	name = "Dock Pay"

/datum/smite/dock_pay/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("Это можно использовать только на /mob/living/carbon."), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	var/obj/item/card/id/card = dude.get_idcard(TRUE)
	if (!card)
		to_chat(user, span_warning("[dude] не имеет ID-карты!"), confidential = TRUE)
		return
	if (!card.registered_account)
		to_chat(user, span_warning("[dude] не имеет ID-карты с привязанным аккаунтом!"), confidential = TRUE)
		return
	if (card.registered_account.account_balance == 0)
		to_chat(user,  span_warning("На его ID-карте нет кредитов."))
		return

	var/balance = card.registered_account.account_balance
	var/new_cost = input("Сколько кредитов снять? Текущий баланс: [balance] кредит[get_num_string(balance)].", "СНЯТИЕ ЗАРПЛАТЫ") as num|null

	if (!new_cost)
		return
	if (!(card.registered_account.has_money(new_cost)))
		to_chat(user,  span_warning("На ID-карте недостаточно кредитов. Опустошаем аккаунт полностью."))
		card.registered_account.bank_card_talk("[new_cost] кредит[get_num_string(new_cost)] снято с вашего счета по результатам проверки.")
		card.registered_account.account_balance = 0
	else
		card.registered_account.account_balance = card.registered_account.account_balance - new_cost
		card.registered_account.bank_card_talk("[new_cost] кредит[get_num_string(new_cost)] снято с вашего счета по результатам проверки.")
	SEND_SOUND(target, 'sound/machines/buzz-sigh.ogg')
