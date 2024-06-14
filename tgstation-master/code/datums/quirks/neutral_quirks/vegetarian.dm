/datum/quirk/vegetarian
	name = "Вегетарианец"
	desc = "Нахожу идею есть мясо физически и морально отталкивающим."
	icon = FA_ICON_CARROT
	value = 0
	gain_text = span_notice("Нахожу идею есть мясо физически и морально отталкивающим.")
	lose_text = span_notice("А мясо-то довольно вкусное!")
	medical_record_text = "Пациент сообщает о вегетарианской диете."
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/salad)

/datum/quirk/vegetarian/add(client/client_source)
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes &= ~MEAT
	tongue.disliked_foodtypes |= MEAT

/datum/quirk/vegetarian/remove()
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
	tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)
