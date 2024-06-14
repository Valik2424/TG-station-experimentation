#define CREDIT_TYPE_BITRUNNING "np"

/obj/machinery/computer/order_console/bitrunning
	name = "консоль заказа Битраннеров"
	desc = "НексаКэш™! Сомнительно подлинное оборудование для цифровых смельчаков."
	icon = 'icons/obj/machines/bitrunning.dmi'
	icon_state = "vendor"
	icon_keyboard = null
	icon_screen = null
	circuit = /obj/item/circuitboard/computer/order_console/bitrunning
	cooldown_time = 10 SECONDS
	cargo_cost_multiplier = 0.65
	express_cost_multiplier = 1
	purchase_tooltip = @{"Ваш заказ прибудет в карго,
	и в лучшем случае доставлен ими.
	на 35% дешевле чем экспресс доставка."}
	express_tooltip = @{"Отправляет ваш заказ моментально."}
	credit_type = CREDIT_TYPE_BITRUNNING

	order_categories = list(
		CATEGORY_BITRUNNING_FLAIR,
		CATEGORY_BITRUNNING_TECH,
		CATEGORY_BEPIS,
	)
	blackbox_key = "bitrunning"

/obj/machinery/computer/order_console/bitrunning/subtract_points(final_cost, obj/item/card/id/card)
	if(final_cost <= card.registered_account.bitrunning_points)
		card.registered_account.bitrunning_points -= final_cost
		return TRUE
	return FALSE

/obj/machinery/computer/order_console/bitrunning/order_groceries(mob/living/purchaser, obj/item/card/id/card, list/groceries)
	var/list/things_to_order = list()
	for(var/datum/orderable_item/item as anything in groceries)
		things_to_order[item.item_path] = groceries[item]

	var/datum/supply_pack/bitrunning/pack = new(
		purchaser = purchaser, \
		cost = get_total_cost(), \
		contains = things_to_order,
	)

	var/datum/supply_order/new_order = new(
		pack = pack,
		orderer = purchaser,
		orderer_rank = "Bitrunning Vendor",
		orderer_ckey = purchaser.ckey,
		reason = "",
		paying_account = card.registered_account,
		department_destination = null,
		coupon = null,
		charge_on_purchase = FALSE,
		manifest_can_fail = FALSE,
		cost_type = credit_type,
		can_be_cancelled = FALSE,
	)
	say("Спасибо за Ваш заказ! Он прибудет в следующем шаттле карго!")
	radio.talk_into(src, "Битраннер заказал снаряжение, которое прибудет на шаттле карго! Пожалуйста, убедитесь что он получит заказ как можно быстрее!", radio_channel)
	SSshuttle.shopping_list += new_order

/obj/machinery/computer/order_console/bitrunning/retrieve_points(obj/item/card/id/id_card)
	return round(id_card.registered_account.bitrunning_points)

/obj/machinery/computer/order_console/bitrunning/ui_act(action, params)
	. = ..()
	if(!.)
		flick("vendor_off", src)

/obj/machinery/computer/order_console/bitrunning/update_icon_state()
	icon_state = "[initial(icon_state)][powered() ? null : "_off"]"
	return ..()

/datum/supply_pack/bitrunning
	name = "заказ битраннера"
	hidden = TRUE
	crate_name = "ящик заказа битраннера"
	access = list(ACCESS_BIT_DEN)

/datum/supply_pack/bitrunning/New(purchaser, cost, list/contains)
	. = ..()
	name = "Битраннерский заказ [purchaser]"
	src.cost = cost
	src.contains = contains

#undef CREDIT_TYPE_BITRUNNING
