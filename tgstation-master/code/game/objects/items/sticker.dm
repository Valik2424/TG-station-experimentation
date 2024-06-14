/// parent type for all other stickers. do not spawn directly
/obj/item/sticker
	name = "стикер"
	desc = "Стикер с чем-то клейким на обратной стороне. Приклей его!"
	item_flags = NOBLUDGEON | XENOMORPH_HOLDABLE //funny
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/toys/stickers.dmi'
	w_class = WEIGHT_CLASS_TINY
	throw_range = 3
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
	///If not null, pick an icon_state from this list
	var/icon_states
	/// If the sticker should be disincluded from normal sticker boxes.
	var/contraband = FALSE

/obj/item/sticker/Initialize(mapload)
	. = ..()
	if(icon_states)
		icon_state = pick(icon_states)
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	AddElement(/datum/element/sticker)

/obj/item/sticker/smile
	name = "улыбающийся стикер"
	icon_state = "smile"

/obj/item/sticker/frown
	name = "грустный стикер"
	icon_state = "frown"

/obj/item/sticker/left_arrow
	name = "стикер стрелки влево"
	icon_state = "larrow"

/obj/item/sticker/right_arrow
	name = "стикер стрелки вправо"
	icon_state = "rarrow"

/obj/item/sticker/star
	name = "стикер звезды"
	icon_state = "star1"
	icon_states = list("star1","star2")

/obj/item/sticker/heart
	name = "стикер сердечка"
	icon_state = "heart"

/obj/item/sticker/googly
	name = "стикер глазика"
	icon_state = "googly1"
	icon_states = list("googly1","googly2")

/obj/item/sticker/rev
	name = "стикер синей R"
	desc = "\"FUCK THE SYSTEM\" - галактическая хардкорная панк группа."
	icon_state = "revhead"

/obj/item/sticker/pslime
	name = "стикер слайма"
	icon_state = "pslime"

/obj/item/sticker/pliz
	name = "стикер ящера"
	icon_state = "plizard"

/obj/item/sticker/pbee
	name = "стикер пчелы"
	icon_state = "pbee"

/obj/item/sticker/psnake
	name = "стикер змейки"
	icon_state = "psnake"

/obj/item/sticker/robot
	name = "стикер бота"
	icon_state = "tile"
	icon_states = list("tile","medbot","clean")

/obj/item/sticker/toolbox
	name = "стикер ящика с инструментами"
	icon_state = "toolbox"

/obj/item/sticker/clown
	name = "стикер клоуна"
	icon_state = "honkman"

/obj/item/sticker/mime
	name = "стикер мима"
	icon_state = "silentman"

/obj/item/sticker/assistant
	name = "стикер ассистента"
	icon_state = "tider"

/obj/item/sticker/syndicate
	name = "стикер синдиката"
	icon_state = "synd"
	contraband = TRUE

/obj/item/sticker/syndicate/c4
	name = "стикер C-4"
	icon_state = "c4"

/obj/item/sticker/syndicate/bomb
	name = "стикер бомбы синдиката"
	icon_state = "sbomb"

/obj/item/sticker/syndicate/apc
	name = "стикер АПЦ"
	icon_state = "milf"

/obj/item/sticker/syndicate/larva
	name = "стикер личинки"
	icon_state = "larva"

/obj/item/sticker/syndicate/cult
	name = "стикер кровавой бумажки"
	icon_state = "cult"

/obj/item/sticker/syndicate/flash
	name = "стикер вспышки"
	icon_state = "flash"

/obj/item/sticker/syndicate/op
	name = "стикер оперативника"
	icon_state = "newcop"

/obj/item/sticker/syndicate/trap
	name = "стикер капкана"
	icon_state = "trap"
