
/obj/effect/anomaly/hallucination
	name = "галюциногенная аномалия"
	icon_state = "hallucination"
	aSignal = /obj/item/assembly/signaler/anomaly/hallucination
	/// Time passed since the last effect, increased by seconds_per_tick of the SSobj
	var/ticks = 0
	/// How many seconds between each small hallucination pulses
	var/release_delay = 5
	/// Messages sent to people feeling the pulses
	var/static/list/messages = list(
		span_warning("Сознание разваливается!"),
		span_warning("Реальность оборачивается вокруг меня!"),
		span_warning("Кто-то что-то шепчет!"),
		span_warning("ААААААААААААААА!"),
	)

/obj/effect/anomaly/hallucination/anomalyEffect(seconds_per_tick)
	. = ..()
	ticks += seconds_per_tick
	if(ticks < release_delay)
		return
	ticks -= release_delay
	if(!isturf(loc))
		return

	visible_hallucination_pulse(
		center = get_turf(src),
		radius = 5,
		hallucination_duration = 50 SECONDS,
		hallucination_max_duration = 300 SECONDS,
		optional_messages = messages,
	)

/obj/effect/anomaly/hallucination/detonate()
	if(!isturf(loc))
		return

	visible_hallucination_pulse(
		center = get_turf(src),
		radius = 10,
		hallucination_duration = 50 SECONDS,
		hallucination_max_duration = 300 SECONDS,
		optional_messages = messages,
	)
