/**********************Mine areas**************************/
/area/mine
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | CULT_PERMITTED
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/mine/lobby
	name = "Шахта: Лобби"
	icon_state = "mining_lobby"

/area/mine/storage
	name = "Шахта: Хранилище"
	icon_state = "mining_storage"

/area/mine/storage/public
	name = "Шахта: Публичное хранилище"
	icon_state = "mining_storage"

/area/mine/production
	name = "Шахта: Порт"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "Шахта: Заброшенная станция"

/area/mine/living_quarters
	name = "Шахта: Порт"
	icon_state = "mining_living"

/area/mine/eva
	name = "Шахта: ЕВА"
	icon_state = "mining_eva"

/area/mine/eva/lower
	name = "Шахта: нижний уровень ЕВА"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "Шахта: Техтоннели"

/area/mine/maintenance/production
	name = "Шахта: Техтоннели порта"

/area/mine/maintenance/living
	name = "Шахта: Техтоннели жилых помещений"

/area/mine/maintenance/living/north
	name = "Шахта: Северные техтоннели жилых помещений"

/area/mine/maintenance/living/south
	name = "Шахта: Южные техтоннели жилых помещений"

/area/mine/maintenance/public
	name = "Шахта: Техтоннели публичного хранилища"

/area/mine/maintenance/public/north
	name = "Шахта: Северные техтоннели публичного хранилища"

/area/mine/maintenance/public/south
	name = "Шахта: Южные техтоннели публичного хранилища"

/area/mine/maintenance/service
	name = "Шахта: Техтоннели сервиса"

/area/mine/maintenance/service/disposals
	name = "Шахта: Техтоннели сервиса"

/area/mine/maintenance/service/comms
	name = "Шахта: Коммуникации"


/area/mine/maintenance/labor
	name = "Каторга: Техтоннели"

/area/mine/cafeteria
	name = "Шахта: Кафетерии"
	icon_state = "mining_cafe"

/area/mine/cafeteria/labor
	name = "Каторга: Кафетерии"
	icon_state = "mining_labor_cafe"

/area/mine/hydroponics
	name = "Шахта: Гидропоника"
	icon_state = "mining_hydro"

/area/mine/medical
	name = "Шахта: Медбей"

/area/mine/mechbay
	name = "Шахта: Мехдок"
	icon_state = "mechbay"

/area/mine/lounge
	name = "Шахта: Лаунж"
	icon_state = "mining_lounge"

/area/mine/laborcamp
	name = "Каторга"
	icon_state = "mining_labor"

/area/mine/laborcamp/quarters
	name = "Каторга: Порт"
	icon_state = "mining_labor_quarters"

/area/mine/laborcamp/production
	name = "Каторга: Порт"
	icon_state = "mining_labor_production"

/area/mine/laborcamp/security
	name = "Каторга: Охрана"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER

/area/mine/laborcamp/security/maintenance
	name = "Каторга: Техтоннели охраны"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER




/**********************Lavaland Areas**************************/

/area/lavaland
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_LAVALAND
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/lavaland/surface
	name = "Лаваленд"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lavaland/underground
	name = "Лаваленд: Пещеры"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lavaland/surface/outdoors
	name = "Лаваленд: Пустоши"
	outdoors = TRUE

/area/lavaland/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/lavaland

/area/lavaland/surface/outdoors/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/// Same thing as parent, but uses a different map generator for the icemoon ruin that needs it.
/area/lavaland/surface/outdoors/unexplored/danger/no_ruins
	map_generator = /datum/map_generator/cave_generator/lavaland/ruin_version

/area/lavaland/surface/outdoors/explored
	name = "Лаваленд: Каторга"
	area_flags = VALID_TERRITORY | UNIQUE_AREA



/**********************Ice Moon Areas**************************/

/area/icemoon
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_ICEMOON
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/icemoon/surface
	name = "Луна"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/icemoon/surface/outdoors // parent that defines if something is on the exterior of the station.
	name = "Луна: Пустоши"
	outdoors = TRUE

/area/icemoon/surface/outdoors/nospawn // this is the area you use for stuff to not spawn, but if you still want weather.

/area/icemoon/surface/outdoors/nospawn/New() // unless you roll forested trait lol
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		area_flags = MOB_SPAWN_ALLOWED | FLORA_ALLOWED//flip this on, the generator has already disabled dangerous fauna

/area/icemoon/surface/outdoors/noteleport // for places like the cursed spring water
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | NOTELEPORT

/area/icemoon/surface/outdoors/noruins // when you want random generation without the chance of getting ruins
	icon_state = "noruins"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator =  /datum/map_generator/cave_generator/icemoon/surface/noruins

/area/icemoon/surface/outdoors/labor_camp
	name = "Луна: Каторга"
	area_flags = UNIQUE_AREA

/area/icemoon/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED

/area/icemoon/surface/outdoors/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface

/area/icemoon/surface/outdoors/unexplored/rivers/New()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		area_flags |= MOB_SPAWN_ALLOWED //flip this on, the generator has already disabled dangerous fauna

/area/icemoon/surface/outdoors/unexplored/rivers/no_monsters
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED

/area/icemoon/underground
	name = "Луна: Пещеры"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/icemoon/underground/unexplored // mobs and megafauna and ruins spawn here
	name = "Луна: Не исследовано"
	icon_state = "unexplored"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/area/icemoon/underground/unexplored/no_rivers
	icon_state = "norivers"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED // same rules as "shoreline" turfs since we might need this to pull double-duty
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers/deep
	map_generator = /datum/map_generator/cave_generator/icemoon/deep

/area/icemoon/underground/unexplored/rivers/deep/shoreline //use this for when you don't want mobs to spawn in certain areas in the "deep" portions. Think adjacent to rivers or station structures.
	icon_state = "shore"
	area_flags = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED

/area/icemoon/underground/explored // ruins can't spawn here
	name = "Луна: Подземелье"
	area_flags = UNIQUE_AREA
