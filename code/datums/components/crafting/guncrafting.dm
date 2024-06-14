//Gun crafting parts til they can be moved elsewhere

// PARTS //

/obj/item/weaponcrafting/Initialize(mapload)
	. = ..()
	create_slapcraft_component()

/obj/item/weaponcrafting/proc/create_slapcraft_component()
	return

/obj/item/weaponcrafting/receiver
	name = "модульный приёмник"
	desc = "Прототип модульного приёмника, который может послужить как спусковой крючок для огнестрела."
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "receiver"

/obj/item/weaponcrafting/receiver/create_slapcraft_component()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/pipegun)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/weaponcrafting/stock
	name = "приклад"
	desc = "Классический приклад от винтовки, так же служит как ручка. Грубо выструган из дерева."
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 6)
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "riflestock"

/obj/item/weaponcrafting/stock/create_slapcraft_component()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/smoothbore_disabler, /datum/crafting_recipe/laser_musket)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/weaponcrafting/giant_wrench
	name = "Набор запчастей для Big Slappy"
	desc = "Набор запчастей для изготовления огромного гаечного ключа, известного как Big Slappy."
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "weaponkit_gw"

/obj/item/weaponcrafting/giant_wrench/create_slapcraft_component() // slappycraft
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/giant_wrench)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

///These gun kits are printed from the security protolathe to then be used in making new weapons

// GUN PART KIT //

/obj/item/weaponcrafting/gunkit // These don't get a slapcraft component, it's added to the gun - more intuitive player-facing to slap the kit onto the gun.
	name = "стандартный комплект оружейных деталей"
	desc = "Это пустой контейнер для деталей оружия! Зачем тебе это?"
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "kitsuitcase"

/obj/item/weaponcrafting/gunkit/nuclear
	name = "комплект деталей продвинутой энергетической винтовки"
	desc = "Кейс, содержащий необходимые детали винтовки для преобразования стандартной энергетической винтовки в продвиную энергетическую винтовку."

/obj/item/weaponcrafting/gunkit/tesla
	name = "комлект деталей пушки тесла"
	desc = "Кейс, содержащий необходимые детали для создания пушки тесла с использованием ядра аномалии. Применять с соблюдением техники безопасности."

/obj/item/weaponcrafting/gunkit/xray
	name = "комплект деталей рентгеновской лазерной винтовки"
	desc = "Кейс, содержащий необходимые детали для преобразования стандартной энергетической винтовки в рентгеновскую лазерную винтовку. Не направляйте большую часть деталей прямо на лицо."

/obj/item/weaponcrafting/gunkit/ion
	name = "комплект деталей ионного карабина"
	desc = "Кейс, содержащий необходимые детали для преобразования стандартной энергетической винтовки в ионный карабин. Идеально подходит для открытия шкафчиков, к которым у вас нет доступа."

/obj/item/weaponcrafting/gunkit/temperature
	name = "комплект деталей для температурной винтовки"
	desc = "Кейс, содержащий необходимые детали для преобразования стандартной энергетической винтовки в температурную винтовку. Фантастический подарок на день рождения и убийство местных популяций ящеров."

/obj/item/weaponcrafting/gunkit/beam_rifle
	name = "комплект деталей для частицеускоряющей винтовки"
	desc = "Кейс, содержащий необходимые детали для преобразования стандартной энергетической винтовки в частицеускоряющую винтовку. Требует энергетическую винтовку, стабилизированную аномалию потока и стабилизированную аномалию гравитации."

/obj/item/weaponcrafting/gunkit/decloner
	name = "комплект деталей клеточного демокуляризатора"
	desc = "Полный набор запчастей и технологий, который каким-то образом превращает лазерную винтовку в клеточный демокуляризатор. Стрижка не включена."

/obj/item/weaponcrafting/gunkit/ebow
	name = "комплект деталей энергетического арбалета"
	desc = "Кейс, содержащий необходимые детали для преобразования стандартного прото-кинетического ускорителя в энергетический арбалет. Почти как настоящий!"

/obj/item/weaponcrafting/gunkit/hellgun
	name = "комплект для создания винтовки \"Адское пламя\""
	desc = "Возьмите полностью функционирующую лазерную винтовку. Изуродуйте внутренности оружия, чтобы оно работало горячо и злобно. Теперь у вас есть винтовка \"Адское пламя\". Вы чудовище."
