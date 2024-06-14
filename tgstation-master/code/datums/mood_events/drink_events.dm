/datum/mood_event/drunk
	mood_change = 3
	description = "<span class='nicegreen'>Просто после пары бокалов чувствуешь себя лучше.</span>\n"

	/// The blush overlay to display when the owner is drunk
	var/datum/bodypart_overlay/simple/emote/blush_overlay

/datum/mood_event/drunk/add_effects(param)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	blush_overlay = human_owner.give_emote_overlay(/datum/bodypart_overlay/simple/emote/blush)

/datum/mood_event/drunk/remove_effects()
	QDEL_NULL(blush_overlay)

/datum/mood_event/wrong_brandy
	description = "<span class='boldwarning'>Я ненавижу этот напиток.</span>\n"
	mood_change = -2
	timeout = 6 MINUTES

/datum/mood_event/quality_revolting
	description = "<span class='warning'>Этот напиток был просто отвратительным!</span>\n"
	mood_change = -8
	timeout = 7 MINUTES

/datum/mood_event/quality_nice
	description = "<span class='nicegreen'>Этот напиток совсем неплохой.</span>\n"
	mood_change = 2
	timeout = 7 MINUTES

/datum/mood_event/quality_good
	description = "<span class='nicegreen'>Этот напиток был хорош.</span>\n"
	mood_change = 4
	timeout = 7 MINUTES

/datum/mood_event/quality_verygood
	description = "<span class='nicegreen'>Этот напиток был великолепен!</span>\n"
	mood_change = 6
	timeout = 7 MINUTES

/datum/mood_event/quality_fantastic
	description = "<span class='nicegreen'>Этот напиток был потрясающим!</span>\n"
	mood_change = 8
	timeout = 7 MINUTES

/datum/mood_event/amazingtaste
	description = "<span class='nicegreen'>Потрясающий вкус!</span>\n"
	mood_change = 50
	timeout = 10 MINUTES

/datum/mood_event/wellcheers
	description = "What a tasty can of Wellcheers! The salty grape flavor is a great pick-me-up."
	mood_change = 3
	timeout = 7 MINUTES
