/datum/action/changeling/biodegrade
	name = "Биодеградация"
	desc = "Растворяет ограничения или другие объекты, препятствующие свободному движению. Стоит 30 химикатов."
	helptext = "Это очевидно для соседних людей и может разрушить стандартные ограничения и шкафы."
	button_icon_state = "biodegrade"
	chemical_cost = 30 //High cost to prevent spam
	dna_cost = 2
	req_human = TRUE

/datum/action/changeling/biodegrade/sting_action(mob/living/carbon/human/user)
	if(user.handcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
		if(!istype(O))
			return FALSE
		user.visible_message(span_warning("<b>[user]</b> изрыгает шар кислоты на <b>[O]</b>!") , \
			span_warning("Мы изрыгаем кислотную слизь на наши наручники!"))

		addtimer(CALLBACK(src, PROC_REF(dissolve_handcuffs), user, O), 30)
		log_combat(user, user.handcuffed, "melted handcuffs", addition = "(biodegrade)")
		..()
		return TRUE

	if(user.legcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_LEGCUFFED)
		if(!istype(O))
			return FALSE
		user.visible_message(span_warning("<b>[user]</b> изрыгает шар кислоты на <b>[O]</b>!") , \
			span_warning("Мы изрыгаем кислотную слизь на наши стяжки!"))

		addtimer(CALLBACK(src, PROC_REF(dissolve_legcuffs), user, O), 30)
		log_combat(user, user.legcuffed, "melted legcuffs", addition = "(biodegrade)")
		..()
		return TRUE

	if(user.wear_suit?.breakouttime)
		var/obj/item/clothing/suit/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		if(!istype(S))
			return FALSE
		user.visible_message(span_warning("<b>[user]</b> изрыгает шар кислоты на <b>[S]</b>!") , \
			span_warning("Мы изрыгаем кислотную слизь на нашу смирительную рубашку!"))
		addtimer(CALLBACK(src, PROC_REF(dissolve_straightjacket), user, S), 30)
		log_combat(user, user.wear_suit, "melted [user.wear_suit]", addition = "(biodegrade)")
		..()
		return TRUE

	if(istype(user.loc, /obj/structure/closet))
		var/obj/structure/closet/C = user.loc
		if(!istype(C))
			return FALSE
		C.visible_message(span_warning("Петли <b>[C]</b> вдруг начинают таять и бегать!"))
		to_chat(user, span_warning("Мы изрыгаем кислотную смесь внутри <b>[C]</b>!"))
		addtimer(CALLBACK(src, PROC_REF(open_closet), user, C), 70)
		log_combat(user, user.loc, "melted locker", addition = "(biodegrade)")
		..()
		return TRUE

	if(istype(user.loc, /obj/structure/spider/cocoon))
		var/obj/structure/spider/cocoon/C = user.loc
		if(!istype(C))
			return FALSE
		C.visible_message(span_warning("<b>[capitalize(src)]</b> дёргается и начинает разваливаться!"))
		to_chat(user, span_warning("Мы выделяем кислотные ферменты из нашей кожи и начинаем плавить кокон..."))
		addtimer(CALLBACK(src, PROC_REF(dissolve_cocoon), user, C), 25) //Very short because it's just webs
		log_combat(user, user.loc, "melted cocoon", addition = "(biodegrade)")
		..()
		return TRUE

	user.balloon_alert(user, "мы уже свободны!")
	return FALSE

/datum/action/changeling/biodegrade/proc/dissolve_handcuffs(mob/living/carbon/human/user, obj/O)
	if(O && user.handcuffed == O)
		user.visible_message(span_warning("<b>[O]</b> растворяется в луже шипящей слизи."))
		new /obj/effect/decal/cleanable/greenglow(O.drop_location())
		qdel(O)

/datum/action/changeling/biodegrade/proc/dissolve_legcuffs(mob/living/carbon/human/user, obj/O)
	if(O && user.legcuffed == O)
		user.visible_message(span_warning("<b>[O]</b> растворяется в луже шипящей слизи."))
		new /obj/effect/decal/cleanable/greenglow(O.drop_location())
		qdel(O)

/datum/action/changeling/biodegrade/proc/dissolve_straightjacket(mob/living/carbon/human/user, obj/S)
	if(S && user.wear_suit == S)
		user.visible_message(span_warning("<b>[S]</b> растворяется в луже шипящей слизи."))
		new /obj/effect/decal/cleanable/greenglow(S.drop_location())
		qdel(S)

/datum/action/changeling/biodegrade/proc/open_closet(mob/living/carbon/human/user, obj/structure/closet/C)
	if(C && user.loc == C)
		C.visible_message(span_warning("Дверь <b>[C]</b> ломается и открывается!"))
		new /obj/effect/decal/cleanable/greenglow(C.drop_location())
		C.welded = FALSE
		C.locked = FALSE
		C.broken = TRUE
		C.open()
		to_chat(user, span_warning("Нам удалось открыть контейнер сдерживающий нас!"))

/datum/action/changeling/biodegrade/proc/dissolve_cocoon(mob/living/carbon/human/user, obj/structure/spider/cocoon/C)
	if(C && user.loc == C)
		new /obj/effect/decal/cleanable/greenglow(C.drop_location())
		qdel(C) //The cocoon's destroy will move the changeling outside of it without interference
		to_chat(user, span_warning("Мы растворяем кокон!"))
