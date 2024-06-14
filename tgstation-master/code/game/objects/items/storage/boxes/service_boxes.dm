// This file contains all boxes used by the Service department and its purpose on the station.
// Because we want to avoid some sort of "miscellaneous" file, let's put all the bureaucracy (pens and stuff) and the HoP's stuff here as well.

/obj/item/storage/box/drinkingglasses
	name = "коробка стаканов"
	desc = "На ней изображены стаканы."
	illustration = "drinkglass"

/obj/item/storage/box/drinkingglasses/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/glass/drinkingglass(src)
/obj/item/storage/box/cups
	name = "коробка бумажных стаканчиков"
	desc = "На лицевой стороне изображены бумажные стаканчики."
	illustration = "cup"

/obj/item/storage/box/cups/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/cup/glass/sillycup(src)

//Some spare PDAs in a box
/obj/item/storage/box/pdas
	name = "Коробка запасных картриджей ПДА"
	desc = "Коробка запасных картриджей ПДА."
	illustration = "pda"

/obj/item/storage/box/pdas/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/modular_computer/pda(src)

/obj/item/storage/box/ids
	name = "коробка запасных идентификаторов"
	desc = "В нём так много пустых идентификаторов."
	illustration = "id"

/obj/item/storage/box/ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/advanced(src)
/obj/item/storage/box/silver_ids
	name = "коробка запасных серебряных удостоверений"
	desc = "Блестящие идентификаторы для важных людей."
	illustration = "id"

/obj/item/storage/box/silver_ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/advanced/silver(src)

/obj/item/storage/box/mousetraps
	name = "коробка мышеловок Pest-B-Gon"
	desc = span_alert("Храните в недоступном для детей месте.")
	illustration = "mousetrap"

/obj/item/storage/box/mousetraps/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/mousetrap(src)

/obj/item/storage/box/snappops
	name = "коробка бахающих фантиков"
	desc = "Восемь фантиков веселья! От 8 лет и старше. Не подходит для детей."
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "spbox"
	illustration = ""

/obj/item/storage/box/snappops/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/toy/snappop))
	atom_storage.max_slots = 8

/obj/item/storage/box/snappops/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/matches
	name = "спичечный коробок"
	desc = "Маленькая коробочка Почти, Но Не Совсем Плазменных Премиальных Спичек."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	inhand_icon_state = "zippo"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "lighter"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	drop_sound = 'sound/items/handling/matchbox_drop.ogg'
	pickup_sound = 'sound/items/handling/matchbox_pickup.ogg'
	custom_price = PAYCHECK_CREW * 0.4
	base_icon_state = "matchbox"
	illustration = null

/obj/item/storage/box/matches/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 10
	atom_storage.set_holdable(list(/obj/item/match))

/obj/item/storage/box/matches/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/match(src)

/obj/item/storage/box/matches/attackby(obj/item/match/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/match))
		W.matchignite()

/obj/item/storage/box/matches/update_icon_state()
	. = ..()
	switch(length(contents))
		if(10)
			icon_state = base_icon_state
		if(5 to 9)
			icon_state = "[base_icon_state]_almostfull"
		if(1 to 4)
			icon_state = "[base_icon_state]_almostempty"
		if(0)
			icon_state = "[base_icon_state]_e"

/obj/item/storage/box/lights
	name = "коробка сменных лампочек"
	desc = "Эта коробка имеет такую форму, что туда вмещаются только лампочки и лампы накаливания."
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	foldable_result = /obj/item/stack/sheet/cardboard //BubbleWrap
	illustration = "light"

/obj/item/storage/box/lights/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 21
	atom_storage.set_holdable(list(/obj/item/light/tube, /obj/item/light/bulb))
	atom_storage.max_total_storage = 21
	atom_storage.allow_quick_gather = FALSE //temp workaround to re-enable filling the light replacer with the box

/obj/item/storage/box/lights/bulbs/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "коробка ламп дневного света "
	illustration = "lighttube"

/obj/item/storage/box/lights/tubes/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/tube(src)

/obj/item/storage/box/lights/mixed
	name = "коробка сменных ламп"
	illustration = "lightmixed"

/obj/item/storage/box/lights/mixed/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/light/tube(src)
	for(var/i in 1 to 7)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/fountainpens
	name = "коробка перьевых ручек"
	illustration = "fpen"

/obj/item/storage/box/fountainpens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/pen/fountain(src)

/obj/item/storage/box/dishdrive
	name = "комплект утилизатора тарелок"
	desc = "Содержит детали длям ашины, которая использует преобразование вещества в энергию для хранения посуды и осколков. Удобно!"
	custom_premium_price = PAYCHECK_CREW * 3

/obj/item/storage/box/dishdrive/PopulateContents()
	var/static/items_inside = list(
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/screwdriver = 1,
		/obj/item/stack/cable_coil/five = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/sheet/iron/five = 1,
		/obj/item/stock_parts/servo = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/wrench = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/actionfigure
	name = "коробка фигурок"
	desc = "Последний набор коллекционных фигурок."
	icon_state = "box"

/obj/item/storage/box/actionfigure/PopulateContents()
	for(var/i in 1 to 4)
		var/random_figure = pick(subtypesof(/obj/item/toy/figure))
		new random_figure(src)

/obj/item/storage/box/tail_pin
	name = "pin the tail on the corgi supplies"
	desc = "For ages 10 and up. ...Why is this even on a space station? Aren't you a little old for babby games?" //Intentional typo.
	custom_price = PAYCHECK_COMMAND * 1.25

/obj/item/storage/box/tail_pin/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/poster/tail_board(src)
		new /obj/item/tail_pin(src)

/obj/item/storage/box/party_poppers
	name = "box of party poppers"
	desc = "Turn any event into a celebration and ensure the janitor stays busy."

/obj/item/storage/box/party_poppers/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/spray/chemsprayer/party(src)

/obj/item/storage/box/stickers
	name = "коробка стикеров"
	desc = "Полная коробка случайных стикеров. Не давать клоуну."

/obj/item/storage/box/stickers/proc/generate_non_contraband_stickers_list()
	. = list()
	for(var/obj/item/sticker/sticker_type as anything in subtypesof(/obj/item/sticker))
		if(!initial(sticker_type.contraband))
			. += sticker_type
	return .
/obj/item/storage/box/stickers/PopulateContents()
	var/static/list/non_contraband
	if(!non_contraband)
		non_contraband = generate_non_contraband_stickers_list()
	for(var/i in 1 to rand(4,8))
		var/type = pick(non_contraband)
		new type(src)

/obj/item/storage/box/stickers/googly
	name = "коробка глазиков"
	desc = "Время сделать что-то живым!"

/obj/item/storage/box/stickers/googly/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/sticker/googly(src)
