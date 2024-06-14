/area/station/medical
	name = "Медбей"
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/station/medical/abandoned
	name = "Медбей: Заброшенный"
	icon_state = "abandoned_medbay"
	ambientsounds = list(
		'sound/ambience/signal.ogg',
		)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/medbay/central
	name = "Медбей: Центр"
	icon_state = "med_central"

/area/station/medical/medbay/extra
	name = "Медбей: Дополнительный"
	icon_state = "medbay"

/area/station/medical/medbay/lobby
	name = "Медбей: Лобби"
	icon_state = "med_lobby"

/area/station/medical/medbay/aft
	name = "Медбей: Западный"
	icon_state = "med_aft"

/area/station/medical/storage
	name = "Медбей: Хранилище"
	icon_state = "med_storage"

/area/station/medical/paramedic
	name = "Медбей: Фельдшер"
	icon_state = "paramedic"

/area/station/medical/office
	name = "Медбей: Офис"
	icon_state = "med_office"

/area/station/medical/break_room
	name = "Медбей: Комната отдыха"
	icon_state = "med_break"

/area/station/medical/coldroom
	name = "Медбей: Морозилка"
	icon_state = "kitchen_cold"

/area/station/medical/zone2
	name = "Мини-медбей: Прибытие"
	icon_state = "medbay2"

/area/station/medical/patients_rooms
	name = "Медбей: Палаты"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/patients_rooms/room_a
	name = "Медбей: Палата пациента A"
	icon_state = "patients"

/area/station/medical/patients_rooms/room_b
	name = "Медбей: Палата пациента Б"
	icon_state = "patients"

/area/station/medical/virology
	name = "Медбей: Вирусология"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/station/medical/virology/isolation
	name = "Медбей: Вирусология - Карантин"
	icon_state = "virology_isolation"

/area/station/medical/morgue
	name = "Медбей: Морг"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/chemistry
	name = "Медбей: Химия"
	icon_state = "chem"

/area/station/medical/pharmacy
	name = "Медбей: Аптека"
	icon_state = "pharmacy"

/area/station/medical/chem_storage
	name = "Медбей: Хранилище химикатов"
	icon_state = "chem_storage"

/area/station/medical/surgery
	name = "Медбей: Операционная"
	icon_state = "surgery"

/area/station/medical/surgery/fore
	name = "Медбей: Северная операционная"
	icon_state = "foresurgery"

/area/station/medical/surgery/aft
	name = "Медбей: Южная операционная"
	icon_state = "aftsurgery"

/area/station/medical/surgery/theatre
	name = "Медбей: Большая операционная"
	icon_state = "surgerytheatre"

/area/station/medical/cryo
	name = "Медбей: Криогеника"
	icon_state = "cryo"

/area/station/medical/exam_room
	name = "Медбей: Экзаменационная комната"
	icon_state = "exam_room"

/area/station/medical/treatment_center
	name = "Медбей: Лечебный центр"
	icon_state = "exam_room"

/area/station/medical/psychology
	name = "Медбей: Психолог"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "Чувствую себя тут спокойно."
	ambientsounds = list(
		'sound/ambience/aurora_caelus_short.ogg',
		)
