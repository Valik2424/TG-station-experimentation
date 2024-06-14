/datum/quirk/prosthetic_limb
	name = "Протез конечности"
	desc = "Ввиду инцидента, который случился в прошлом, мне удалось потерять одну из конечностей. Случайная конечность будет заменена на дешевый протез."
	icon = "tg-prosthetic-leg"
	medical_record_text = "Во время физического обследования у пациента был обнаружен протез."
	value = -3
	hardcore_value = 3
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/weldingtool/mini, /obj/item/stack/cable_coil/five)
	/// The slot to replace, in string form
	var/slot_string = "limb"
	/// the original limb from before the prosthetic was applied
	var/obj/item/bodypart/old_limb

/datum/quirk/prosthetic_limb/add_unique(client/client_source)
	var/limb_type = GLOB.limb_choice[client_source?.prefs?.read_preference(/datum/preference/choiced/prosthetic)]
	if(isnull(limb_type))  //Client gone or they chose a random prosthetic
		limb_type = GLOB.limb_choice[pick(GLOB.limb_choice)]

	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/bodypart/surplus = new limb_type()
	slot_string = "[surplus.plaintext_zone]"

	old_limb = human_holder.return_and_replace_bodypart(surplus, special = TRUE)

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Моя [slot_string] была заменена протезом. Он довольно хрупкий и его легче сломать. Для лечения протеза, \
	необходимо будет использовать сварочный инструмент или кабели, вместо обычных пластырей или бинтов.</span>")

/datum/quirk/prosthetic_limb/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.del_and_replace_bodypart(old_limb, special = TRUE)
	old_limb = null
