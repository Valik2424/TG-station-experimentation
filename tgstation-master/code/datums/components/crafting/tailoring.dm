/datum/crafting_recipe/durathread_vest
	name = "Дюратканевый бронежилет"
	result = /obj/item/clothing/suit/armor/vest/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 4)
	time = 5 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_helmet
	name = "Дюратканевый шлем"
	result = /obj/item/clothing/head/helmet/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4,
				/obj/item/stack/sheet/leather = 5)
	time = 4 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/fannypack
	name = "Барсетка"
	result = /obj/item/storage/belt/fannypack
	reqs = list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/leather = 1)
	time = 2 SECONDS
	category = CAT_CONTAINERS

/datum/crafting_recipe/hudsunsec
	name = "Тактические очки офицера"
	result = /obj/item/clothing/glasses/hud/security/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunsecremoval
	name = "Разборка тактических очков офицера"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunmed
	name = "Тактические медицинские очки"
	result = /obj/item/clothing/glasses/hud/health/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunmedremoval
	name = "Разборка тактических медицинских очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsundiag
	name = "Тактические диагностические очки"
	result = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsundiagremoval
	name = "Разборка тактических диагностических очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/scienceglasses
	name = "Тактические научные очки"
	result = /obj/item/clothing/glasses/sunglasses/chemical
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/scienceglassesremoval
	name = "Разборка тактических научных очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/chemical = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/ghostsheet
	name = "Саван неприкаянного"
	result = /obj/item/clothing/suit/costume/ghost_sheet
	time = 0.5 SECONDS
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/bedsheet = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardboots
	name = "Сапоги из кожи ящера"
	result = /obj/effect/spawner/random/clothing/lizardboots
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1, /obj/item/stack/sheet/leather = 1)
	time = 6 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonsuit
	name = "Комбинезон заключенного"
	result = /obj/item/clothing/under/rank/prisoner
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonskirt
	name = "Prisoner Uniform (Skirt)"
	result = /obj/item/clothing/under/rank/prisoner/skirt
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonshoes
	name = "Юбкомбез заключенной"
	result = /obj/item/clothing/shoes/sneakers/orange
	reqs = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/license_plates = 1)
	time = 1 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/tv_helmet
	name = "Шлем телевизор"
	result = /obj/item/clothing/head/costume/tv_head
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_CROWBAR)
	reqs = list(/obj/item/wallframe/status_display = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat
	name = "Шляпа из хвоста ящера"
	result = /obj/item/clothing/head/costume/lizard
	time = 1 SECONDS
	reqs = list(/obj/item/organ/external/tail/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat_alternate
	name = "Шляпа из искусственного хвоста ящера"
	result = /obj/item/clothing/head/costume/lizard
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/kittyears
	name = "Кошачьи уши"
	result = /obj/item/clothing/head/costume/kitty/genuine
	time = 1 SECONDS
	reqs = list(
		/obj/item/organ/external/tail/cat = 1,
		/obj/item/organ/internal/ears/cat = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonearmor
	name = "Костяная броня"
	result = /obj/item/clothing/suit/armor/bone
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 6)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonetalisman
	name = "Костяной талисман"
	result = /obj/item/clothing/accessory/talisman
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonecodpiece
	name = "Костяной гульфик"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/animalhide/goliath_hide = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/skilt
	name = "Килт из сухожилий"
	result = /obj/item/clothing/accessory/skilt
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 2,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bracers
	name = "Костяные наручи"
	result = /obj/item/clothing/gloves/bracer
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/skullhelm
	name = "Костяной шлем"
	result = /obj/item/clothing/head/helmet/skull
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/goliathcloak
	name = "Накидка из голиафа"
	result = /obj/item/clothing/suit/hooded/cloak/goliath
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/leather = 2,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/animalhide/goliath_hide = 2,
	) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_CLOTHING

/datum/crafting_recipe/drakecloak
	name = "Доспехи дракона"
	result = /obj/item/clothing/suit/hooded/cloak/drake
	time = 6 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/animalhide/ashdrake = 5,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/godslayer
	name = "Доспехи Бога"
	result = /obj/item/clothing/suit/hooded/cloak/godslayer
	time = 6 SECONDS
	reqs = list(
		/obj/item/ice_energy_crystal = 1,
		/obj/item/wendigo_skull = 1,
		/obj/item/clockwork_alloy = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy
	name = "Повязки для мумификации (Голова)"
	result = /obj/item/clothing/mask/mummy
	time = 1 SECONDS
	tool_paths = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/sheet/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Повязки для мумификации (Тело)"
	result = /obj/item/clothing/under/costume/mummy
	reqs = list(/obj/item/stack/sheet/cloth = 5)

/datum/crafting_recipe/chaplain_hood
	name = "Роба последователей священника"
	result = /obj/item/clothing/suit/hooded/chaplain_hoodie
	time = 1 SECONDS
	tool_paths = list(
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/book/bible,
	)
	reqs = list(/obj/item/stack/sheet/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/flower_garland
	name = "Цветочный венок"
	result = /obj/item/clothing/head/costume/garland
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/poppy = 4,
		/obj/item/food/grown/harebell = 4,
		/obj/item/food/grown/rose = 4,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/poppy_crown
	name = "Корона из маков"
	result = /obj/item/clothing/head/costume/garland/poppy
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/poppy = 5,
		/obj/item/stack/cable_coil = 3,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/lily_crown
	name = "Корона из лилий"
	result = /obj/item/clothing/head/costume/garland/lily
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/poppy/lily = 5,
		/obj/item/stack/cable_coil = 3,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/sunflower_crown
	name = "Корона из подсолнухов"
	result = /obj/item/clothing/head/costume/garland/sunflower
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/sunflower = 5,
		/obj/item/stack/cable_coil = 3,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/rainbow_bunch_crown
	name = "Радужная корона"
	result = /obj/item/clothing/head/costume/garland/rainbowbunch
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/rainbow_flower = 5,
		/obj/item/stack/cable_coil = 3,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/pillow_suit
	name = "Подушечный костюм"
	result = /obj/item/clothing/suit/pillow_suit
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sticky_tape = 10,
		/obj/item/pillow = 5,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/pillow_hood
	name = "Подушечный капюшон"
	result = /obj/item/clothing/head/pillow_hood
	tool_behaviors = list(TOOL_WIRECUTTER, TOOL_KNIFE)
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sticky_tape = 5,
		/obj/item/pillow = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/sturdy_shako
	name = "Прочный Кивер"
	result = /obj/item/clothing/head/hats/hos/shako
	tool_behaviors = list(TOOL_WELDER, TOOL_KNIFE)
	time = 5 SECONDS
	reqs = list(
		/obj/item/clothing/head/hats/hos/cap = 1,
		/obj/item/stack/sheet/plasteel = 2, //Stout shako for two refined
		/obj/item/stack/sheet/mineral/gold = 2,
	)

	category = CAT_CLOTHING

/datum/crafting_recipe/atmospherics_gas_mask
	name = "Противогаз атмостеха"
	result = /obj/item/clothing/mask/gas/atmos
	tool_behaviors = list(TOOL_WELDER)
	time = 8 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/metal_hydrogen = 1,
		/obj/item/stack/sheet/mineral/zaukerite = 1,
	)

	category = CAT_CLOTHING

/datum/crafting_recipe/paper_hat
	name = "Бумажная шляпка"
	result = /obj/item/clothing/head/costume/paper_hat
	time = 5 SECONDS
	reqs = list(
		/obj/item/paper = 1,
	)
	category = CAT_CLOTHING
