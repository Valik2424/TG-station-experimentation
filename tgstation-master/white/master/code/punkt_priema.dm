//Code and sprite(?) by ClickerOfThings
/obj/machinery/priem_steklotara
	name = "пункт приёма стеклотары"
	desc = "Позволяет за пустые алкобутылки получать деньги. Как кэшбек, только лучше!"
	icon = 'white/master/icons/punkt_priema.dmi'
	icon_state = "open"
	density = TRUE
	anchored = TRUE
	var/processing = FALSE
	var/bottle_process_time = 30

/obj/machinery/priem_steklotara/attackby(obj/item/I, mob/living/user, params)
	if (istype(I, /obj/item/reagent_containers/cup/glass/bottle))
		if (processing)
			to_chat(user, span_warning("Пункт приёма стеклотары обрабатывает бутылку, подождите!"))
			return
		var/obj/item/reagent_containers/cup/glass/bottle/b = I
		if(b.reagents.total_volume > 0)
			to_chat(user, span_warning("Бутылка должна быть пуста!"))
			return
		qdel(I)
		flick("closing", src)
		spawn(4)
			icon_state = "closed"
		to_chat(user, span_info("Пункт приёма захавал бутылку."))
		playsound(src, 'sound/machines/chime.ogg', 100, 0)
		say("Бутылка обнаружена! Подождите...")
		processing = TRUE
		addtimer(CALLBACK(src, .proc/drop_money, b), bottle_process_time)
	else
		return ..()


/obj/machinery/priem_steklotara/proc/drop_money(obj/item/reagent_containers/cup/glass/bottle/B)
	var/cost = 0
	if (B.custom_price != null)
		cost += B.custom_price / 2
	if (B.custom_premium_price != null)
		cost += B.custom_premium_price / 4
	if (cost == 0)
		cost = 15
	while (cost > 0)
		if (cost >= 10)
			new /obj/item/coin/silver(src.loc)
			cost -= 10
		else if (cost < 10)
			new /obj/item/coin/iron(src.loc)
			cost -= 1
	flick("opening", src)
	spawn(4)
		icon_state = "open"
	playsound(src, 'sound/machines/ping.ogg', 100, 0)
	processing = FALSE
