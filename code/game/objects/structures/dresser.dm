/obj/structure/dresser
	name = "шкафчик"
	desc = "Красивый деревянный шкаф с одеждой."
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "dresser"
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("Начинаю [anchored ? "откручивать" : "прикручивать"] [src.name]."))
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, span_notice("Успешно [anchored ? "откручиваю" : "прикручиваю"] [src.name]."))
			set_anchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/obj/structure/dresser/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!Adjacent(user))//no tele-grooming
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/dressing_human = user
	if(HAS_TRAIT(dressing_human, TRAIT_NO_UNDERWEAR))
		to_chat(user, span_warning("Да мне и носить это негде."))
		return

	var/choice = tgui_input_list(user, "Нижнее белье, рубаха, или носочки?", "Changing", list("Нижнее бельё","Цвет нижнего белья","Рубаха","Носочки"))
	if(isnull(choice))
		return

	if(!Adjacent(user))
		return
	switch(choice)
		if("Нижнее бельё")
			var/new_undies = tgui_input_list(user, "Выбираем нижнее бельё", "Смена белья", GLOB.underwear_list)
			if(new_undies)
				dressing_human.underwear = new_undies
		if("Цвет нижнего белья")
			var/new_underwear_color = input(dressing_human, "Выбираем цвет нижнего белья", "Цвет нижнего белья","#"+dressing_human.underwear_color) as color|null
			if(new_underwear_color)
				dressing_human.underwear_color = sanitize_hexcolor(new_underwear_color)
		if("Рубаха")
			var/new_undershirt = tgui_input_list(user, "Выбираем рубаху", "Смена белья", GLOB.undershirt_list)
			if(new_undershirt)
				dressing_human.undershirt = new_undershirt
		if("Носочки")
			var/new_socks = tgui_input_list(user, "Выбираем носочки", "Смена белья", GLOB.socks_list)
			if(new_socks)
				dressing_human.socks = new_socks

	add_fingerprint(dressing_human)
	dressing_human.update_body()
