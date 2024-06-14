
/atom/movable/screen/blob
	icon = 'icons/hud/blob.dmi'

/atom/movable/screen/blob/MouseEntered(location,control,params)
	. = ..()
	openToolTip(usr,src,params,title = name,content = desc, theme = "blob")

/atom/movable/screen/blob/MouseExited()
	closeToolTip(usr)

/atom/movable/screen/blob/jump_to_node
	icon_state = "ui_tonode"
	name = "Прыгнуть к массе"
	desc = "Перемещает камеру к выбраному узлу."

/atom/movable/screen/blob/jump_to_node/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	blob.jump_to_node()

/atom/movable/screen/blob/jump_to_core
	icon_state = "ui_tocore"
	name = "Прыгнуть к ядру"
	desc = "Перемещает камеру к ядру."

/atom/movable/screen/blob/jump_to_core/MouseEntered(location,control,params)
	if(hud?.mymob && isovermind(hud.mymob))
		var/mob/camera/blob/B = hud.mymob
		if(!B.placed)
			name = "Установить ядро"
			desc = "Попробуем, да."
		else
			name = initial(name)
			desc = initial(desc)
	return ..()

/atom/movable/screen/blob/jump_to_core/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	if(!blob.placed)
		blob.place_blob_core(BLOB_NORMAL_PLACEMENT)
	blob.transport_core()

/atom/movable/screen/blob/blobbernaut
	icon_state = "ui_blobbernaut"
	// Name and description get given their proper values on Initialize()
	name = "Произвести массанаута (ERROR)"
	desc = "Производит сильного, умного массанаута из производящей массы за (ERROR) ресурсов.<br>Завод станет хрупким и не сможет производить споры."

/atom/movable/screen/blob/blobbernaut/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести массанаута ([BLOBMOB_BLOBBERNAUT_RESOURCE_COST])"
	desc = "Производит сильного, умного массанаута из производящей массы за [BLOBMOB_BLOBBERNAUT_RESOURCE_COST] ресурсов.<br>Завод станет хрупким и не сможет производить споры."

/atom/movable/screen/blob/blobbernaut/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	blob.create_blobbernaut()

/atom/movable/screen/blob/resource_blob
	icon_state = "ui_resource"
	// Name and description get given their proper values on Initialize()
	name = "Произвсти ресурсную массу (ERROR)"
	desc = "Производит ресурсную массу за ERROR ресурсов.<br>Ресурсная масса будет предоставлять ресурсы каждые несколько секунд."

/atom/movable/screen/blob/resource_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвсти ресурсную массу ([BLOB_STRUCTURE_RESOURCE_COST])"
	desc = "Производит ресурсную массу за [BLOB_STRUCTURE_RESOURCE_COST] ресурсов.<br>Ресурсная масса будет предоставлять ресурсы каждые несколько секунд."

/atom/movable/screen/blob/resource_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_RESOURCE_COST, /obj/structure/blob/special/resource, BLOB_RESOURCE_MIN_DISTANCE, TRUE)

/atom/movable/screen/blob/node_blob
	icon_state = "ui_node"
	// Name and description get given their proper values on Initialize()
	name = "Произвести родительскую массу (ERROR)"
	desc = "Производит родительскую массу за ERROR ресурсов.<br>Родительская масса будет расширяться и активировать близлежащие ресурсные и производящие массы."

/atom/movable/screen/blob/node_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести родительскую массу ([BLOB_STRUCTURE_NODE_COST])"
	desc = "Производит родительскую массу за [BLOB_STRUCTURE_NODE_COST] ресурсов.<br>Родительская масса будет расширяться и активировать близлежащие ресурсные и производящие массы."

/atom/movable/screen/blob/node_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_NODE_COST, /obj/structure/blob/special/node, BLOB_NODE_MIN_DISTANCE, FALSE)

/atom/movable/screen/blob/factory_blob
	icon_state = "ui_factory"
	// Name and description get given their proper values on Initialize()
	name = "Произвести производящую массу (ERROR)"
	desc = "Производит производящую массу за ERROR ресурсов.<br>Производящая масса будет производить споры каждые несколько секунд."

/atom/movable/screen/blob/factory_blob/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Произвести производящую массу ([BLOB_STRUCTURE_FACTORY_COST])"
	desc = "Производит производящую массу за [BLOB_STRUCTURE_FACTORY_COST] ресурсов.<br>Производящая масса будет производить споры каждые несколько секунд."

/atom/movable/screen/blob/factory_blob/Click()
	if(!isovermind(usr))
		return FALSE
	var/mob/camera/blob/blob = usr
	blob.create_special(BLOB_STRUCTURE_FACTORY_COST, /obj/structure/blob/special/factory, BLOB_FACTORY_MIN_DISTANCE, TRUE)

/atom/movable/screen/blob/readapt_strain
	icon_state = "ui_chemswap"
	// Description gets given its proper values on Initialize()
	name = "Перестроить структуру"
	desc = "Позволяет выбрать новую структуру из ERROR случайных типов за ERROR ресурсов."

/atom/movable/screen/blob/readapt_strain/MouseEntered(location,control,params)
	if(hud?.mymob && isovermind(hud.mymob))
		var/mob/camera/blob/B = hud.mymob
		if(B.free_strain_rerolls)
			name = "[initial(name)] (БЕСПЛАТНО)"
			desc = "Позволяет выбрать новую структуру бесплатно."
		else
			name = "[initial(name)] ([BLOB_POWER_REROLL_COST])"
			desc = "Позволяет выбрать новую структуру из [BLOB_POWER_REROLL_CHOICES] случайных типов за [BLOB_POWER_REROLL_COST] ресурсов."
	return ..()

/atom/movable/screen/blob/readapt_strain/Click()
	if(isovermind(usr))
		var/mob/camera/blob/B = usr
		B.strain_reroll()

/atom/movable/screen/blob/relocate_core
	icon_state = "ui_swap"
	// Name and description get given their proper values on Initialize()
	name = "Переместить ядро (ERROR)"
	desc = "Меняет местами ядро и родительскую массу за ERROR ресурсов."

/atom/movable/screen/blob/relocate_core/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = "Переместить ядро ([BLOB_POWER_RELOCATE_COST])"
	desc = "Меняет местами ядро и родительскую массу за [BLOB_POWER_RELOCATE_COST] ресурсов."

/atom/movable/screen/blob/relocate_core/Click()
	if(isovermind(usr))
		var/mob/camera/blob/B = usr
		B.relocate_core()

/datum/hud/blob_overmind/New(mob/owner)
	..()
	var/atom/movable/screen/using

	blobpwrdisplay = new /atom/movable/screen(null, src)
	blobpwrdisplay.name = "blob power"
	blobpwrdisplay.icon_state = "block"
	blobpwrdisplay.screen_loc = ui_health
	blobpwrdisplay.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_PLANE_EXPLICIT(blobpwrdisplay, ABOVE_HUD_PLANE, owner)
	infodisplay += blobpwrdisplay

	healths = new /atom/movable/screen/healths/blob(null, src)
	infodisplay += healths

	using = new /atom/movable/screen/blob/jump_to_node(null, src)
	using.screen_loc = ui_inventory
	static_inventory += using

	using = new /atom/movable/screen/blob/jump_to_core(null, src)
	using.screen_loc = ui_zonesel
	static_inventory += using

	using = new /atom/movable/screen/blob/blobbernaut(null, src)
	using.screen_loc = ui_belt
	static_inventory += using

	using = new /atom/movable/screen/blob/resource_blob(null, src)
	using.screen_loc = ui_back
	static_inventory += using

	using = new /atom/movable/screen/blob/node_blob(null, src)
	using.screen_loc = ui_hand_position(2)
	static_inventory += using

	using = new /atom/movable/screen/blob/factory_blob(null, src)
	using.screen_loc = ui_hand_position(1)
	static_inventory += using

	using = new /atom/movable/screen/blob/readapt_strain(null, src)
	using.screen_loc = ui_storage1
	static_inventory += using

	using = new /atom/movable/screen/blob/relocate_core(null, src)
	using.screen_loc = ui_storage2
	static_inventory += using
