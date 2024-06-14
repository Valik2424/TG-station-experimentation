// This file contains all boxes used by the Medical department, or otherwise associated with the task of mob interactions.

/obj/item/storage/box/syringes
	name = "коробка шприцев"
	desc = "Коробка со шприцами."
	illustration = "syringe"

/obj/item/storage/box/syringes/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syringes/variety
	name = "коробка разнообразных шприцов"

/obj/item/storage/box/syringes/variety/PopulateContents()
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/syringe/lethal(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/bluespace(src)

/obj/item/storage/box/medipens
	name = "коробка медипенов"
	desc = "Коробка, полная адреналином медипенов."
	illustration = "epipen"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/storage/box/medipens/utility
	name = "набор стимуляторов"
	desc = "Коробка с несколькими стимуляторами для экономичного шахтёра."
	illustration = "epipen"

/obj/item/storage/box/medipens/utility/PopulateContents()
	..() // includes regular medipens.
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack(src)

/obj/item/storage/box/beakers
	name = "коробка химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/cup/beaker( src )

/obj/item/storage/box/beakers/bluespace
	name = "коробка блюспейс химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/bluespace/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/cup/beaker/bluespace(src)

/obj/item/storage/box/beakers/variety
	name = "коробка различных химических стаканов"

/obj/item/storage/box/beakers/variety/PopulateContents()
	new /obj/item/reagent_containers/cup/beaker(src)
	new /obj/item/reagent_containers/cup/beaker/bluespace(src)
	new /obj/item/reagent_containers/cup/beaker/large(src)
	new /obj/item/reagent_containers/cup/beaker/meta(src)
	new /obj/item/reagent_containers/cup/beaker/noreact(src)
	new /obj/item/reagent_containers/cup/beaker/plastic(src)

/obj/item/storage/box/medigels
	name = "коробка аэрозолей"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля."
	illustration = "medgel"

/obj/item/storage/box/medigels/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/medigel( src )

/obj/item/storage/box/injectors
	name = "коробка ДНК инъекторов"
	desc = "В этой коробке, кажется, находятся инъекторы."
	illustration = "dna"

/obj/item/storage/box/injectors/PopulateContents()
	var/static/items_inside = list(
		/obj/item/dnainjector/h2m = 3,
		/obj/item/dnainjector/m2h = 3,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/bodybags
	name = "сумки для тела"
	desc = "На этикетке указано, что он содержит мешки для тела."
	illustration = "bodybags"

/obj/item/storage/box/bodybags/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/bodybag(src)

/obj/item/storage/box/pillbottles
	name = "коробка с баночками для таблеток"
	desc = "На передней панели изображены пузырьки с таблетками."
	illustration = "pillbox"

/obj/item/storage/box/pillbottles/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/pill_bottle(src)

/obj/item/storage/box/plumbing/PopulateContents()
	var/list/items_inside = list(
		/obj/item/stock_parts/water_recycler = 2,
		/obj/item/stack/ducts/fifty = 1,
		/obj/item/stack/sheet/iron/ten = 1,
		)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/evilmeds
	name = "box of premium medicine"
	desc = "Contains a large number of beakers filled with premium medical supplies. Straight from Interdyne Pharmaceutics!"
	icon_state = "syndiebox"
	illustration = "beaker"

/obj/item/storage/box/evilmeds/PopulateContents()
	var/static/list/items_inside = list(
		/obj/item/reagent_containers/cup/beaker/meta/omnizine = 1,
		/obj/item/reagent_containers/cup/beaker/meta/sal_acid = 1,
		/obj/item/reagent_containers/cup/beaker/meta/oxandrolone = 1,
		/obj/item/reagent_containers/cup/beaker/meta/pen_acid = 1,
		/obj/item/reagent_containers/cup/beaker/meta/atropine = 1,
		/obj/item/reagent_containers/cup/beaker/meta/salbutamol = 1,
		/obj/item/reagent_containers/cup/beaker/meta/rezadone = 1,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/bandages
	name = "коробка бинтов"
	desc = "Коробка с гелевыми бинтами DeForest."
	icon_state = "brutebox"
	base_icon_state = "brutebox"
	inhand_icon_state = "brutebox"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	drop_sound = 'sound/items/handling/matchbox_drop.ogg'
	pickup_sound = 'sound/items/handling/matchbox_pickup.ogg'
	illustration = null
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_CREW * 1.75

/obj/item/storage/box/bandages/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 6
	atom_storage.set_holdable(list(
		/obj/item/stack/medical/bandage,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/pill/patch,
		))

/obj/item/storage/box/bandages/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/stack/medical/bandage(src)

/obj/item/storage/box/bandages/update_icon_state()
	. = ..()
	switch(length(contents))
		if(5)
			icon_state = "[base_icon_state]_f"
		if(3 to 4)
			icon_state = "[base_icon_state]_almostfull"
		if(1 to 2)
			icon_state = "[base_icon_state]_almostempty"
		if(0)
			icon_state = base_icon_state
