/area/station/maintenance
	name = "Техтоннели"
	ambience_index = AMBIENCE_MAINT
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED | PERSISTENT_ENGRAVINGS
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	forced_ambience = TRUE
	ambient_buzz = 'sound/ambience/source_corridor2.ogg'
	ambient_buzz_vol = 20

/*
* Departmental Maintenance
*/

/area/station/maintenance/department/chapel
	name = "Техтоннели: Церковь"
	icon_state = "maint_chapel"

/area/station/maintenance/department/chapel/monastery
	name = "Техтоннели: Монастырь"
	icon_state = "maint_monastery"

/area/station/maintenance/department/crew_quarters/bar
	name = "Техтоннели: Бар"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/maintenance/department/crew_quarters/dorms
	name = "Техтоннели: Дормитории"
	icon_state = "maint_dorms"

/area/station/maintenance/department/eva
	name = "Техтоннели: EVA"
	icon_state = "maint_eva"

/area/station/maintenance/department/eva/abandoned
	name = "Заброшенное хранилище EVA"

/area/station/maintenance/department/electrical
	name = "Техтоннели электрообслуживания"
	icon_state = "maint_electrical"

/area/station/maintenance/department/engine/atmos
	name = "Техтоннели: Атмосферный отдел"
	icon_state = "maint_atmos"

/area/station/maintenance/department/security
	name = "Техтоннели: Охрана"
	icon_state = "maint_sec"

/area/station/maintenance/department/security/upper
	name = "Техтоннели: Верхний Бриг"

/area/station/maintenance/department/security/brig
	name = "Техтоннели: Бриг"
	icon_state = "maint_brig"

/area/station/maintenance/department/medical
	name = "Техтоннели: Медбей"
	icon_state = "medbay_maint"

/area/station/maintenance/department/medical/central
	name = "Техтоннели: Центр Медбея"
	icon_state = "medbay_maint_central"

/area/station/maintenance/department/medical/morgue
	name = "Техтоннели: Морг"
	icon_state = "morgue_maint"

/area/station/maintenance/department/science
	name = "Техтоннели: Наука"
	icon_state = "maint_sci"

/area/station/maintenance/department/science/central
	name = "Техтоннели: Центр РнД"
	icon_state = "maint_sci_central"

/area/station/maintenance/department/cargo
	name = "Техтоннели: Карго"
	icon_state = "maint_cargo"

/area/station/maintenance/department/bridge
	name = "Техтоннели: Мостик"
	icon_state = "maint_bridge"

/area/station/maintenance/department/engine
	name = "Техтоннели: Инженерный отдел"
	icon_state = "maint_engi"

/area/station/maintenance/department/prison
	name = "Техтоннели: Тюрьма"
	icon_state = "sec_prison"

/area/station/maintenance/department/science/xenobiology
	name = "Техтоннели: Ксенобиология"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE | CULT_PERMITTED

/*
* Generic Maintenance Tunnels
*/

/area/station/maintenance/aft
	name = "Техтоннели: Южные"
	icon_state = "aftmaint"

/area/station/maintenance/aft/upper
	name = "Техтоннели: Верхние южные"
	icon_state = "upperaftmaint"

/* Use greater variants of area definitions for when the station has two different sections of maintenance on the same z-level.
* Can stand alone without "lesser".
* This one means that this goes more fore/north than the "lesser" maintenance area.
*/
/area/station/maintenance/aft/greater
	name = "Техтоннели: Основные южные"
	icon_state = "greateraftmaint"

/* Use lesser variants of area definitions for when the station has two different sections of maintenance on the same z-level in conjunction with "greater".
* (just because it follows better).
* This one means that this goes more aft/south than the "greater" maintenance area.
*/

/area/station/maintenance/aft/lesser
	name = "Техтоннели: Вторичные южные"
	icon_state = "lesseraftmaint"

/area/station/maintenance/central
	name = "Техтоннели: Центральные"
	icon_state = "centralmaint"

/area/station/maintenance/central/greater
	name = "Техтоннели: Основные центральные"
	icon_state = "greatercentralmaint"

/area/station/maintenance/central/lesser
	name = "Техтоннели: Вторичные центральные"
	icon_state = "lessercentralmaint"

/area/station/maintenance/fore
	name = "Техтоннели: Северные"
	icon_state = "foremaint"

/area/station/maintenance/fore/upper
	name = "Техтоннели: Верхние северные"
	icon_state = "upperforemaint"

/area/station/maintenance/fore/greater
	name = "Техтоннели: Основные северные"
	icon_state = "greaterforemaint"

/area/station/maintenance/fore/lesser
	name = "Техтоннели: Вторичные северные"
	icon_state = "lesserforemaint"

/area/station/maintenance/starboard
	name = "Техтоннели: Восточные"
	icon_state = "starboardmaint"

/area/station/maintenance/starboard/upper
	name = "Техтоннели: Верхние восточные"
	icon_state = "upperstarboardmaint"

/area/station/maintenance/starboard/central
	name = "Техтоннели: Центрально-восточные"
	icon_state = "centralstarboardmaint"

/area/station/maintenance/starboard/greater
	name = "Техтоннели: Основные восточные"
	icon_state = "greaterstarboardmaint"

/area/station/maintenance/starboard/lesser
	name = "Техтоннели: Вторичные восточные"
	icon_state = "lesserstarboardmaint"

/area/station/maintenance/starboard/aft
	name = "Техтоннели: Юго-восточные"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Техтоннели: Вторичные юго-восточные"
	icon_state = "asmaint_2"


/area/station/maintenance/starboard/fore
	name = "Техтоннели: Северо-восточные"
	icon_state = "fsmaint"

/area/station/maintenance/port
	name = "Техтоннели: Западные"
	icon_state = "portmaint"

/area/station/maintenance/port/central
	name = "Техтоннели: Центрально-западные"
	icon_state = "centralportmaint"

/area/station/maintenance/port/greater
	name = "Техтоннели: Основные западные"
	icon_state = "greaterportmaint"

/area/station/maintenance/port/lesser
	name = "Техтоннели: Вторично-восточные"
	icon_state = "lesserportmaint"

/area/station/maintenance/port/aft
	name = "Техтоннели: Юго-западные"
	icon_state = "apmaint"

/area/station/maintenance/port/fore
	name = "Техтоннели: Северно-западные"
	icon_state = "fpmaint"

/area/station/maintenance/tram
	name = "Техтоннели: Основные трамвайные"

/area/station/maintenance/tram/left
	name = "Техтоннели: Западные подтрамвайные"
	icon_state = "mainttramL"

/area/station/maintenance/tram/mid
	name = "Техтоннели: Центральные подтрамвайные"
	icon_state = "mainttramM"

/area/station/maintenance/tram/right
	name = "Техтоннели: Восточные подтрамвайные"
	icon_state = "mainttramR"

/*
* Discrete Maintenance Areas
*/

/area/maintenance/disposal
	name = "Техтоннели: Утилизация отходов"
	icon_state = "disposal"

/area/station/maintenance/hallway/abandoned_command
	name = "\improper Abandoned Command Hallway"
	icon_state = "maint_bridge"

/area/station/maintenance/hallway/abandoned_recreation
	name = "\improper Abandoned Recreation Hallway"
	icon_state = "maint_dorms"

/area/station/maintenance/disposal/incinerator
	name = "\improper Incinerator"
	icon_state = "incinerator"

/area/station/maintenance/space_hut
	name = "\improper Space Hut"
	icon_state = "spacehut"

/area/station/maintenance/space_hut/cabin
	name = "Abandoned Cabin"

/area/station/maintenance/space_hut/plasmaman
	name = "\improper Abandoned Plasmaman Friendly Startup"

/area/station/maintenance/space_hut/observatory
	name = "\improper Space Observatory"

/*
* Radation Storm Shelters
*/

/area/station/maintenance/radshelter
	name = "\improper Radstorm Shelter"
	icon_state = "radstorm_shelter"

/area/station/maintenance/radshelter/medical
	name = "\improper Medical Radstorm Shelter"

/area/station/maintenance/radshelter/sec
	name = "\improper Security Radstorm Shelter"

/area/station/maintenance/radshelter/service
	name = "\improper Service Radstorm Shelter"

/area/station/maintenance/radshelter/civil
	name = "\improper Civilian Radstorm Shelter"

/area/station/maintenance/radshelter/sci
	name = "\improper Science Radstorm Shelter"

/area/station/maintenance/radshelter/cargo
	name = "\improper Cargo Radstorm Shelter"

/*
* External Hull Access Areas
*/

/area/station/maintenance/external
	name = "\improper External Hull Access"
	icon_state = "amaint"

/area/station/maintenance/external/aft
	name = "\improper Aft External Hull Access"

/area/station/maintenance/external/port
	name = "\improper Port External Hull Access"

/area/station/maintenance/external/port/bow
	name = "\improper Port Bow External Hull Access"

/*
* Station Specific Areas
* If another station gets added, and you make specific areas for it
* Please make its own section in this file
* The areas below belong to North Star's Maintenance
*/

//1
/area/station/maintenance/floor1
	name = "\improper 1st Floor Maint"

/area/station/maintenance/floor1/port
	name = "\improper 1st Floor Central Port Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/port/fore
	name = "\improper 1st Floor Fore Port Maint"
	icon_state = "maintfore"
/area/station/maintenance/floor1/port/aft
	name = "\improper 1st Floor Aft Port Maint"
	icon_state = "maintaft"

/area/station/maintenance/floor1/starboard
	name = "\improper 1st Floor Central Starboard Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/starboard/fore
	name = "\improper 1st Floor Fore Starboard Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor1/starboard/aft
	name = "\improper 1st Floor Aft Starboard Maint"
	icon_state = "maintaft"
//2
/area/station/maintenance/floor2
	name = "\improper 2nd Floor Maint"
/area/station/maintenance/floor2/port
	name = "\improper 2nd Floor Central Port Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/port/fore
	name = "\improper 2nd Floor Fore Port Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor2/port/aft
	name = "\improper 2nd Floor Aft Port Maint"
	icon_state = "maintaft"

/area/station/maintenance/floor2/starboard
	name = "\improper 2nd Floor Central Starboard Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/starboard/fore
	name = "\improper 2nd Floor Fore Starboard Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor2/starboard/aft
	name = "\improper 2nd Floor Aft Starboard Maint"
	icon_state = "maintaft"
//3
/area/station/maintenance/floor3
	name = "\improper 3rd Floor Maint"

/area/station/maintenance/floor3/port
	name = "\improper 3rd Floor Central Port Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/port/fore
	name = "\improper 3rd Floor Fore Port Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor3/port/aft
	name = "\improper 3rd Floor Aft Port Maint"
	icon_state = "maintaft"

/area/station/maintenance/floor3/starboard
	name = "\improper 3rd Floor Central Starboard Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/starboard/fore
	name = "\improper 3rd Floor Fore Starboard Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor3/starboard/aft
	name = "\improper 3rd Floor Aft Starboard Maint"
	icon_state = "maintaft"
//4
/area/station/maintenance/floor4
	name = "\improper 4th Floor Maint"

/area/station/maintenance/floor4/port
	name = "\improper 4th Floor Central Port Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/port/fore
	name = "\improper 4th Floor Fore Port Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor4/port/aft
	name = "\improper 4th Floor Aft Port Maint"
	icon_state = "maintaft"

/area/station/maintenance/floor4/starboard
	name = "\improper 4th Floor Central Starboard Maint"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/starboard/fore
	name = "\improper 4th Floor Fore Starboard Maint"
	icon_state = "maintfore"

/area/station/maintenance/floor4/starboard/aft
	name = "\improper 4th Floor Aft Starboard Maint"
	icon_state = "maintaft"
