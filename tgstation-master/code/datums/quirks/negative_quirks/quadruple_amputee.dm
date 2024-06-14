/datum/quirk/quadruple_amputee
	name = "Котлетка"
	desc = "Упс! Все мои конечности - протезы! Из-за некоторого действительно жестокого космического наказания все мои конечности были заменены на дешёвые протезы."
	icon = "tg-prosthetic-full"
	value = -6
	medical_record_text = "Во время физического обследования пациента было обнаружено, что все его конечности - протезы."
	hardcore_value = 6
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/weldingtool/mini, /obj/item/stack/cable_coil/five)

/datum/quirk/quadruple_amputee/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/left/robot/surplus, special = TRUE)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/right/robot/surplus, special = TRUE)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/leg/left/robot/surplus, special = TRUE)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/leg/right/robot/surplus, special = TRUE)

/datum/quirk/quadruple_amputee/post_add()
	to_chat(quirk_holder, span_boldannounce("Все ваши конечности были заменены на дешёвые протезы. Они хрупкие и легко разваливаются под давлением. \
	Кроме того, вам нужно использовать сварочный инструмент и кабели для их ремонта, а не обычные аптечки."))
