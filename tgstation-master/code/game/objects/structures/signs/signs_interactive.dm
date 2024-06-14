/obj/structure/sign/clock
	name = "настенные часы"
	desc = "Это наши заурядные настенные часы, показывающие как местное стандартное время Коалиции, так и галактическое координированное время Договора. Идеально подходит для того, чтобы смотреть вместо того, чтобы работать."
	icon_state = "clock"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/clock, 32)

/obj/structure/sign/clock/examine(mob/user)
	. = ..()
	. += span_info("<hr>Текущее время CST (местное): [station_time_timestamp()].")
	. += span_info("\nТекущее время TCT (галактическое): [time2text(world.realtime, "hh:mm:ss")].")

/obj/structure/sign/calendar
	name = "настенный календарь"
	desc = "Я календарь."
	icon_state = "calendar"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/calendar, 32)

/obj/structure/sign/calendar/examine(mob/user)
	. = ..()
	. += span_info("<hr>Текущая дата: [time2text(world.realtime, "DD/MM")]/[CURRENT_STATION_YEAR].")
	if(length(GLOB.holidays))
		. += span_info("<hr>Праздники:")
		for(var/holidayname in GLOB.holidays)
			. += span_info("[holidayname]")
