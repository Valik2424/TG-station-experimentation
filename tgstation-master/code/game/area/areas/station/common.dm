/area/station/commons
	name = "\improper Crew Facilities"
	icon_state = "commons"
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/*
* Dorm Areas
*/

/area/station/commons/dorms
	name = "Зона отдыха: Дормитории"
	icon_state = "dorms"

/area/station/commons/dorms/room1
	name = "Зона отдыха: Дормитории - Комната 1"
	icon_state = "room1"

/area/station/commons/dorms/room2
	name = "Зона отдыха: Дормитории - Комната 2"
	icon_state = "room2"

/area/station/commons/dorms/room3
	name = "Зона отдыха: Дормитории - Комната 3"
	icon_state = "room3"

/area/station/commons/dorms/room4
	name = "Зона отдыха: Дормитории - Комната 4"
	icon_state = "room4"

/area/station/commons/dorms/room5
	name = "Зона отдыха: Дормитории - Комната 5"
	icon_state = "room5"


/area/station/commons/dorms/room6
	name = "Зона отдыха: Дормитории - Комната 6"
	icon_state = "room6"


/area/station/commons/dorms/room7
	name = "Зона отдыха: Дормитории - Комната 7"
	icon_state = "room7"


/area/station/commons/dorms/room8
	name = "Зона отдыха: Дормитории - Комната 8"
	icon_state = "room8"

/area/station/commons/dorms/room9
	name = "Зона отдыха: Дормитории - Комната 9"
	icon_state = "room9"

/area/station/commons/dorms/room10
	name = "Зона отдыха: Дормитории - Комната 10"
	icon_state = "room10"


/area/station/commons/dorms/room11
	name = "Зона отдыха: Дормитории - Комната 11"
	icon_state = "room11"


/area/station/commons/dorms/apartment1
	name = "Зона отдыха: Дормитории - Апартаменты 1"
	icon_state = "apartment1"

/area/station/commons/dorms/apartment2
	name = "Зона отдыха: Дормитории - Апартаменты 2"
	icon_state = "apartment2"

/area/station/commons/dorms/cabin1
	name = "Зона отдыха: Кабинка 1"
	icon_state = "dcabin1"

/area/station/commons/dorms/cabin2
	name = "Зона отдыха: Кабинка 2"
	icon_state = "dcabin2"

/area/station/commons/dorms/cabin3
	name = "Зона отдыха: Кабинка 3"
	icon_state = "dcabin3"

/area/station/commons/dorms/cabin4
	name = "Зона отдыха: Кабинка 4"
	icon_state = "dcabin4"

/area/station/commons/dorms/barracks // Барак обама сосал хуй и не только.
	name = "Зона отдыха: Бараки"

/area/station/commons/dorms/barracks/male
	name = "Зона отдыха: Мужские бараки"
	icon_state = "dorms_male"

/area/station/commons/dorms/barracks/female
	name = "Female Sleep Barracks"
	icon_state = "dorms_female"

/area/station/commons/dorms/laundry
	name = "Зона отдыха: Женские бараки"
	icon_state = "laundry_room"

/area/station/commons/toilet
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/commons/toilet/auxiliary
	name = "Зона отдыха: Вспомогательные туалеты"
	icon_state = "toilet"

/area/station/commons/toilet/locker
	name = "Зона отдыха: Туалеты раздевалки"
	icon_state = "toilet"

/area/station/commons/toilet/restrooms
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"

/*
* Rec and Locker Rooms
*/

/area/station/commons/locker
	name = "Зона отдыха: Раздевалка"
	icon_state = "locker"

/area/station/commons/lounge
	name = "Зона отдыха: Гостиная"
	icon_state = "lounge"
	mood_bonus = 5
	mood_message = "I love being in the bar!"
	mood_trait = TRAIT_EXTROVERT
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/commons/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/station/commons/fitness/locker_room
	name = "\improper Unisex Locker Room"
	icon_state = "locker"

/area/station/commons/fitness/locker_room/male
	name = "\improper Male Locker Room"
	icon_state = "locker_male"

/area/station/commons/fitness/locker_room/female
	name = "\improper Female Locker Room"
	icon_state = "locker_female"

/area/station/commons/fitness/recreation
	name = "\improper Recreation Area"
	icon_state = "rec"

/area/station/commons/cryopods
	name = "Криоподы"
	icon_state = "cryo"

/area/station/commons/fitness/maint_gym
	name = "Техтоннели: Качалка"
	icon_state = "rec"

/area/station/commons/fitness/recreation/entertainment
	name = "\improper Entertainment Center"
	icon_state = "entertainment"

/*
* Vacant Rooms
*/

/area/station/commons/vacant_room
	name = "Свободная комната"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT

/area/station/commons/vacant_room/office
	name = "Свободный офис"
	icon_state = "vacant_office"

/area/station/commons/vacant_room/commissary
	name = "Свободный магазин"
	icon_state = "vacant_commissary"

/area/station/vacant_room/commissary/second
	name = "Нижний магазин"

/area/station/vacant_room/commissary/third
	name = "Дополнительный магазин"

/area/station/vacant_room/commissary/fourth
	name = "Интересный магазин"
/*
* Storage Rooms
*/

/area/station/commons/storage
	name = "\improper Commons Storage"

/area/station/commons/storage/tools
	name = "\improper Auxiliary Tool Storage"
	icon_state = "tool_storage"

/area/station/commons/storage/primary
	name = "\improper Primary Tool Storage"
	icon_state = "primary_storage"

/area/station/commons/storage/art
	name = "\improper Art Supply Storage"
	icon_state = "art_storage"

/area/station/commons/storage/emergency/starboard
	name = "\improper Starboard Emergency Storage"
	icon_state = "emergency_storage"

/area/station/commons/storage/emergency/port
	name = "\improper Port Emergency Storage"
	icon_state = "emergency_storage"

/area/station/commons/storage/mining
	name = "\improper Public Mining Storage"
	icon_state = "mining_storage"
