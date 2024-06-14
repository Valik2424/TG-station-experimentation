/obj/item/implant/mindshield
	name = "микроимплант щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной NT промывкой мозгов."
	actions_types = null

/obj/item/implant/mindshield/get_data()
	var/dat = {"<b>Спецификация импланта:</b><BR>
				<b>Название:</b> Имплантат лояльности сотрудника Nanotrasen<BR>
				<b>Срок службы:</b> 10 лет.<BR>
				<b>Важные замечания:</b> Персонал, которому вводится это устройство, гораздо более устойчив к промыванию мозгов.<BR>
				<HR>
				<b>Детали имплантации:</b><BR>
				<b>Техническое описание:</b> Содержит небольшой набор наноботов, который защищает психические функции хозяина от манипуляций.<BR>
				<b>Спец свойства:</b> Предотвратит и вылечит большинство форм промывания мозгов.<BR>
				<b>Целостность:</b> Имплантат прослужит до тех пор, пока нанороботы находятся в кровотоке."}
	return dat


/obj/item/implant/mindshield/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(target.mind)
		if((SEND_SIGNAL(target.mind, COMSIG_PRE_MINDSHIELD_IMPLANT, user) & COMPONENT_MINDSHIELD_RESISTED) || target.mind.unconvertable)
			if(!silent)
				target.visible_message(span_warning("[target] сопротивляется воздействию импланта!") , span_warning("Чувствую, что что-то пытается вмешаться в мое подсознание, но я сопротивляетесь этому!"))
			removed(target, TRUE)
			qdel(src)
			return TRUE
		if(SEND_SIGNAL(target.mind, COMSIG_MINDSHIELD_IMPLANTED, user) & COMPONENT_MINDSHIELD_DECONVERTED)
			if(prob(1) || check_holidays(APRIL_FOOLS))
				target.say("Только не по почкам!", forced = "Только не по почкам!")

	ADD_TRAIT(target, TRAIT_MINDSHIELD, IMPLANT_TRAIT)
	target.sec_hud_set_implants()
	if(!silent)
		to_chat(target, span_warning("Чувствую, что что-то пытается вмешаться в мое подсознание, но я сопротивляетесь этому!"))
	return TRUE

/obj/item/implant/mindshield/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		var/mob/living/L = target
		REMOVE_TRAIT(L, TRAIT_MINDSHIELD, IMPLANT_TRAIT)
		L.sec_hud_set_implants()
	if(target.stat != DEAD && !silent)
		to_chat(target, span_boldnotice("Your mind suddenly feels terribly vulnerable. You are no longer safe from brainwashing."))
	return TRUE

/obj/item/implanter/mindshield
	name = "имплантер щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	imp_type = /obj/item/implant/mindshield

/obj/item/implantcase/mindshield
	name = "футляр микроимпланта щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	imp_type = /obj/item/implant/mindshield
