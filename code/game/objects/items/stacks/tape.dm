/obj/item/stack/sticky_tape
	name = "клейкая лента"
	singular_name = "клейкая лента"
	desc = "Используется для приклеивания вещей, а иногда и для приклеивания упомянутых вещей к людям."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape"
	var/prefix = "sticky"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 5
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	splint_factor = 0.65
	merge_type = /obj/item/stack/sticky_tape
	var/list/conferred_embed = EMBED_HARMLESS
	///The tape type you get when ripping off a piece of tape.
	var/obj/tape_gag = /obj/item/clothing/mask/muzzle/tape
	greyscale_config = /datum/greyscale_config/tape
	greyscale_colors = "#B2B2B2#BD6A62"

/obj/item/stack/sticky_tape/attack_hand(mob/user, list/modifiers)
	if(user.get_inactive_held_item() == src)
		if(is_zero_amount(delete_if_zero = TRUE))
			return
		playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)
		if(!do_after(user, 1 SECONDS))
			return
		var/new_tape_gag = new tape_gag(src)
		user.put_in_hands(new_tape_gag)
		use(1)
		to_chat(user, span_notice("Отрываю немного клейкой ленты."))
		playsound(user, 'sound/items/duct_tape_snap.ogg', 50, TRUE)
		return TRUE
	return ..()

/obj/item/stack/sticky_tape/examine(mob/user)
	. = ..()
	. += "[span_notice("Могу оторвать кусок, используя пустую руку.")]"

/obj/item/stack/sticky_tape/afterattack(obj/item/target, mob/living/user, proximity)
	if(!proximity)
		return

	if(!istype(target))
		return

	. |= AFTERATTACK_PROCESSED_ITEM

	if(target.embedding && target.embedding == conferred_embed)
		to_chat(user, span_warning("[target] уже обёрнут в [src]!"))
		return .

	user.visible_message(span_notice("[user] начинает оборачивать [target] при помощи [src]."), span_notice("You begin wrapping [target] with [src]."))
	playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)

	if(do_after(user, 3 SECONDS, target=target))
		playsound(user, 'sound/items/duct_tape_snap.ogg', 50, TRUE)
		use(1)
		if(istype(target, /obj/item/clothing/gloves/fingerless))
			var/obj/item/clothing/gloves/tackler/offbrand/O = new /obj/item/clothing/gloves/tackler/offbrand
			to_chat(user, span_notice("Оборачиваю [target] в [O] используя [src]."))
			QDEL_NULL(target)
			user.put_in_hands(O)
			return .

		if(target.embedding && target.embedding == conferred_embed)
			to_chat(user, span_warning("[target] уже покрыт [src]!"))
			return .

		target.embedding = conferred_embed
		target.updateEmbedding()
		to_chat(user, span_notice("Заканчиваю оборачивать [target] используя [src]."))
		target.name = "[prefix] [target.name]"

		if(isgrenade(target))
			var/obj/item/grenade/sticky_bomb = target
			sticky_bomb.sticky = TRUE

	return .

/obj/item/stack/sticky_tape/super
	name = "супер клейкая лента"
	singular_name = "супер клейкая лента"
	desc = "Вполне возможно, самое вредное вещество в галактике. Используйте с крайней осторожностью."
	prefix = "очень липкий"
	conferred_embed = EMBED_HARMLESS_SUPERIOR
	splint_factor = 0.4
	merge_type = /obj/item/stack/sticky_tape/super
	greyscale_colors = "#4D4D4D#75433F"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/super

/obj/item/stack/sticky_tape/pointy
	name = "заостренная лента"
	singular_name = "заостренная лента"
	desc = "Используется для приклеивания к вещам, для того, чтобы приклеивать эти вещи к людям."
	icon_state = "tape_spikes"
	prefix = "заострённый"
	conferred_embed = EMBED_POINTY
	merge_type = /obj/item/stack/sticky_tape/pointy
	greyscale_config = /datum/greyscale_config/tape/spikes
	greyscale_colors = "#E64539#808080#AD2F45"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy

/obj/item/stack/sticky_tape/pointy/super
	name = "супер заостренная лента"
	singular_name = "супер заостренная лента"
	desc = "Вы не знали, что лента может выглядеть так зловеще. Добро пожаловать на Космическую Станцию 13."
	prefix = "невероятно острый"
	conferred_embed = EMBED_POINTY_SUPERIOR
	merge_type = /obj/item/stack/sticky_tape/pointy/super
	greyscale_colors = "#8C0A00#4F4F4F#300008"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy/super

/obj/item/stack/sticky_tape/surgical
	name = "хирургическая лента"
	singular_name = "хирургическая лента"
	desc = "Используется для сращивания поломаных костей как и костный гель. Не для пранков."
	prefix = "хирургический"
	conferred_embed = list("embed_chance" = 30, "pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
	splint_factor = 0.5
	custom_price = PAYCHECK_CREW
	merge_type = /obj/item/stack/sticky_tape/surgical
	greyscale_colors = "#70BAE7#BD6A62"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/surgical

/obj/item/stack/sticky_tape/surgical/get_surgery_tool_overlay(tray_extended)
	return "tape" + (tray_extended ? "" : "_out")
