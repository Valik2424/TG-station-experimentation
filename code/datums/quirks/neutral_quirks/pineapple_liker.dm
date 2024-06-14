/datum/quirk/pineapple_liker
	name = "Любитель ананасов"
	desc = "Обожаю ананасы!"
	icon = FA_ICON_THUMBS_UP
	value = 0
	gain_text = span_notice("Чувствую, что испытываю сильную тягу к ананасам.")
	lose_text = span_notice("Моя любовь к ананасам медленно угасает.")
	medical_record_text = "Пациент демонстрирует патологическую любовь к ананасу."
	mail_goodies = list(/obj/item/food/pizzaslice/pineapple)

/datum/quirk/pineapple_liker/add(client/client_source)
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/obj/item/organ/internal/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
