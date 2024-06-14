/// Some defines for items the cult archives can create.
#define CULT_BLINDFOLD "Повязка зилота"
#define CURSE_ORB "Проклятие шаттла"
#define VEIL_WALKER "Комплект для ходьбы по вуали"

// Cult archives. Gives out utility items.
/obj/structure/destructible/cult/item_dispenser/archives
	name = "архивы"
	desc = "Письменный стол, заваленный заумными манускриптами и томами на неизвестных языках. При взгляде на текст по коже бегут мурашки."
	cult_examine_tip = "Можно использовать для создания повязок зелота, шаттловых орбов проклятия и комплектов для ходьбы по вуали."
	icon_state = "tomealtar"
	light_range = 1.5
	light_color = LIGHT_COLOR_FIRE
	break_message = "<span class='warning'>Книги и тома архива сгорают в пепел, а стол разбивается вдребезги!</span>"

/obj/structure/destructible/cult/item_dispenser/archives/setup_options()
	var/static/list/archive_items = list(
		CULT_BLINDFOLD = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/clothing/glasses.dmi', icon_state = "blindfold"),
			OUTPUT_ITEMS = list(/obj/item/clothing/glasses/hud/health/night/cultblind),
			),
		CURSE_ORB = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/antags/cult/items.dmi', icon_state = "shuttlecurse"),
			OUTPUT_ITEMS = list(/obj/item/shuttle_curse),
			),
		VEIL_WALKER = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/antags/cult/items.dmi', icon_state = "shifter"),
			OUTPUT_ITEMS = list(/obj/item/cult_shift, /obj/item/flashlight/flare/culttorch),
			),
	)

	options = archive_items

/obj/structure/destructible/cult/item_dispenser/archives/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_cultitalic("Призываю [spawned_item] с [src]!"))

// Preset for the library that doesn't spawn runed metal on destruction.
/obj/structure/destructible/cult/item_dispenser/archives/library
	debris = list()

#undef CULT_BLINDFOLD
#undef CURSE_ORB
#undef VEIL_WALKER
