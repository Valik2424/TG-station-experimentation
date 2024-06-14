/obj/item/food/monkeycube
	name = "обезьяний кубик"
	desc = "Просто добавь воды!"
	icon_state = "monkeycube"
	bite_consumption = 12
	food_reagents = list(/datum/reagent/monkey_powder = 30)
	tastes = list("джунгли" = 1, "бананы" = 1)
	foodtypes = MEAT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	/// Mob typepath to spawn when expanding
	var/spawned_mob = /mob/living/carbon/human/species/monkey
	/// Whether we've been wetted and are expanding
	var/expanding = FALSE

/obj/item/food/monkeycube/attempt_pickup(mob/M)
	if(expanding)
		return FALSE
	return ..()

/obj/item/food/monkeycube/proc/Expand()
	if(expanding)
		return

	expanding = TRUE

	if(ismob(loc))
		var/mob/holder = loc
		holder.dropItemToGround(src)

	var/mob/spammer = get_mob_by_key(fingerprintslast)
	var/mob/living/bananas = new spawned_mob(drop_location(), TRUE, spammer) // funny that we pass monkey init args to non-monkey mobs, that's totally a future issue
	if (!QDELETED(bananas))
		if(faction)
			bananas.faction = faction

		visible_message(span_notice("[capitalize(src.name)] расширяется!"))
		bananas.log_message("spawned via [src], Last attached mob: [key_name(spammer)].", LOG_ATTACK)

		var/alpha_to = bananas.alpha
		var/matrix/scale_to = matrix(bananas.transform)
		bananas.alpha = 0
		bananas.transform = bananas.transform.Scale(0.1)
		animate(bananas, 0.5 SECONDS, alpha = alpha_to, transform = scale_to, easing = QUAD_EASING|EASE_OUT)

	else if (!spammer) // Visible message in case there are no fingerprints
		visible_message(span_notice("[capitalize(src.name)] не смог достаточно расшириться!"))
		return

	animate(src, 0.4 SECONDS, alpha = 0, transform = transform.Scale(0), easing = QUAD_EASING|EASE_IN)
	QDEL_IN(src, 0.5 SECONDS)

/obj/item/food/monkeycube/suicide_act(mob/living/M)
	M.visible_message(span_suicide("[M] суёт [src] в [M.ru_ego()] рот! Похоже, [M.p_theyre()] пытается совершить самоубийство!"))
	var/eating_success = do_after(M, 1 SECONDS, src)
	if(QDELETED(M)) //qdeletion: the nuclear option of self-harm
		return SHAME
	if(!eating_success || QDELETED(src)) //checks if src is gone or if they failed to wait for a second
		M.visible_message(span_suicide("[M] струсил!"))
		return SHAME
	if(HAS_TRAIT(M, TRAIT_NOHUNGER)) //plasmamen don't have saliva/stomach acid
		M.visible_message(span_suicide("[M] понимает, что [M.ru_ego()] тело не может принять [src]!")
		,span_warning("Моё тело не может принять [src]..."))
		return SHAME
	playsound(M, 'sound/items/eatfood.ogg', rand(10, 50), TRUE)
	M.temporarilyRemoveItemFromInventory(src) //removes from hands, keeps in M
	addtimer(CALLBACK(src, PROC_REF(finish_suicide), M), 15) //you've eaten it, you can run now
	return MANUAL_SUICIDE

/obj/item/food/monkeycube/proc/finish_suicide(mob/living/M) ///internal proc called by a monkeycube's suicide_act using a timer and callback. takes as argument the mob/living who activated the suicide
	if(QDELETED(M) || QDELETED(src))
		return
	if(src.loc != M) //how the hell did you manage this
		to_chat(M, span_warning("Что-то случилось с [src]..."))
		return
	Expand()
	M.visible_message(span_danger("[M] лопается, и из него появляется примат!"))
	M.gib(DROP_BRAIN|DROP_BODYPARTS|DROP_ITEMS) // just remove the organs

/obj/item/food/monkeycube/syndicate
	faction = list(FACTION_NEUTRAL, ROLE_SYNDICATE)

/obj/item/food/monkeycube/gorilla
	name = "горилловый кубил"
	desc = "Кубик гориллы марки Waffle Co. Теперь с дополнительными молекулами!"
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/monkey_powder = 30,
		/datum/reagent/medicine/strange_reagent = 5,
	)
	tastes = list("джунгли" = 1, "бананы" = 1, "jimmies" = 1)
	spawned_mob = /mob/living/basic/gorilla

/obj/item/food/monkeycube/chicken
	name = "куриный кубик"
	desc = "Новая классика Нанотрейзен - куриный кубик. На вкус как все возможное!"
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/consumable/eggyolk = 30,
		/datum/reagent/medicine/strange_reagent = 1,
	)
	tastes = list("курица" = 1, "деревня" = 1, "куриный бульон" = 1)
	spawned_mob = /mob/living/basic/chicken

/obj/item/food/monkeycube/bee
	name = "пчелиный кубик"
	desc = "Мы были уверены, что это хорошая идея. Просто добавьте воды."
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/consumable/honey = 10,
		/datum/reagent/toxin = 5,
		/datum/reagent/medicine/strange_reagent = 1,
	)
	tastes = list("жужжание" = 1, "мед" = 1, "сожаление" = 1)
	spawned_mob = /mob/living/basic/bee
