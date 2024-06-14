// This file contains everything used by security, or in other combat applications.

/obj/item/storage/box/flashbangs
	name = "коробка светошумовых гранат"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут вызвать слепоту или глухоту при многократном использовании.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "коробка травматических гранат"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут привести к тяжелым травмам или смерти при повторном использовании.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "коробка вспышек"
	desc = "<B>ВНИМАНИЕ: Вспышки могут вызвать серьезные повреждения глаз, необходимо использовать защитные очки.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "комплект настенной вспышки"
	desc = "Эта коробка содержит все необходимое для создания настенной вспышки. <B> ВНИМАНИЕ: Вспышки могут вызвать серьезные повреждения глаз, необходимо использовать защитные очки.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)


/obj/item/storage/box/teargas
	name = "ящик со слезоточивым газом"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут вызвать слепоту и раздражение кожи.</B>"
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "коробка с ЭМИ гранатами"
	desc = "Простая коробка с 5 ЭМИ гранатами."
	illustration = "emp"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/trackimp
	name = "комплект отслеживающих имплантов"
	desc = "Коробка с приспособлениями для отслеживания подонков."
	icon_state = "secbox"
	illustration = "implant"

/obj/item/storage/box/trackimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 4,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/minertracker
	name = "комплект отслеживающих имплантов"
	desc = "Для поиска погибших в проклятом мире Лаваленда."
	illustration = "implant"

/obj/item/storage/box/minertracker/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 3,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/chemimp
	name = "комплект химических имплантов"
	desc = "Коробка с вещами, используемыми для имплантации химикатов."
	illustration = "implant"

/obj/item/storage/box/chemimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/chem = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/exileimp
	name = "набор имплантатов для изгнания"
	desc = "Коробка с набором имплантатов для изгнания. На нем есть изображение клоуна, которого выкидывают через Врата."
	illustration = "implant"

/obj/item/storage/box/exileimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/exile = 5,
		/obj/item/implanter = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/prisoner
	name = "коробка с идентификаторами для заключенных"
	desc = "Лишите их последнего клочка достоинства - их имени."
	icon_state = "secbox"
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/advanced/prisoner/one(src)
	new /obj/item/card/id/advanced/prisoner/two(src)
	new /obj/item/card/id/advanced/prisoner/three(src)
	new /obj/item/card/id/advanced/prisoner/four(src)
	new /obj/item/card/id/advanced/prisoner/five(src)
	new /obj/item/card/id/advanced/prisoner/six(src)
	new /obj/item/card/id/advanced/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "коробка картриджей безопасности для ПДА"
	desc = "Коробка, полная картриджей для ПДА, используемых службой безопасности."
	icon_state = "secbox"
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/computer_disk/security(src)

/obj/item/storage/box/firingpins
	name = "коробка штатных бойков"
	desc = "Коробка со стандартными бойками для стрельбы из нового огнестрельного оружия."
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/firingpins/paywall
	name = "коробка с платными бойками"
	desc = "Слыш. Плати"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/paywall/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/paywall(src)

/obj/item/storage/box/lasertagpins
	name = "ящик  бойков для лазертага"
	desc = "Коробка, полная бойков для лазертага, чтобы новое огнестрельное оружие требовало ношения яркой пластиковой брони, прежде чем его можно будет использовать."
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "коробка запасных стяжек"
	desc = "коробка запасных стяжек."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/rubbershot
	name = "12 Калибр: Резиновая пуля - 7 шт."
	desc = "Коробка с травматическими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "12 Калибр: Пулевой - 7 шт."
	desc = "Коробка с боевыми пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/beanbag
	name = "12 Калибр: Резиновая пуля - 6 шт."
	desc = "Коробка с травматическими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "beanbagshot_box"
	illustration = null

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/breacherslug
	name = "box of breaching shotgun shells"
	desc = "A box full of breaching slugs, designed for rapid entry, not very effective against anything else."
	icon_state = "breacher_box"
	illustration = null

/obj/item/storage/box/breacherslug/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/breacher(src)

/obj/item/storage/box/emptysandbags
	name = "коробка пустых мешков с песком"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/holy_grenades
	name = "коробка святых гранат"
	desc = "Содержит несколько гранат, используемых для быстрого избавления от ереси."
	illustration = "grenade"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/fireworks
	name = "коробка фейерверков"
	desc = "Содержит ассортимент фейерверков."
	illustration = "sparkler"

/obj/item/storage/box/fireworks/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	new /obj/item/toy/snappop(src)

/obj/item/storage/box/fireworks/dangerous

/obj/item/storage/box/fireworks/dangerous/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	if(prob(20))
		new /obj/item/grenade/frag(src)
	else
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/firecrackers
	name = "коробка петард"
	desc = "Коробка с нелегальной петардой. Вы задаетесь вопросом, кто до сих пор их делает."
	icon_state = "syndiebox"
	illustration = "firecracker"

/obj/item/storage/box/firecrackers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/firecracker(src)

/obj/item/storage/box/sparklers
	name = "коробка бенгальских огней"
	desc = "Коробка бенгальских огней марки НТ, горит даже в холод космической зимы."
	illustration = "sparkler"

/obj/item/storage/box/sparklers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/sparkler(src)
