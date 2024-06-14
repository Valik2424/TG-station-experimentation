/datum/quirk/pineapple_hater
	name = "Отвращение к ананасам"
	desc = "Ненавижу ананасы. Серьёзно, они же совсем невкусные! И кто вообще посмеет положить их в пиццу!?"
	icon = FA_ICON_THUMBS_DOWN
	value = 0
	gain_text = span_notice("Думаю над тем, какой кусок идиота любит ананасы...")
	lose_text = span_notice("Моя ненависть к ананасам медленнно угасает...")
	medical_record_text = "Пациент считает, что ананасы отвратительны."
	mail_goodies = list( // basic pizza slices
		/obj/item/food/pizzaslice/margherita,
		/obj/item/food/pizzaslice/meat,
		/obj/item/food/pizzaslice/mushroom,
		/obj/item/food/pizzaslice/vegetable,
		/obj/item/food/pizzaslice/sassysage,
	)

/datum/quirk/pineapple_hater/add(client/client_source)
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.disliked_foodtypes |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)
