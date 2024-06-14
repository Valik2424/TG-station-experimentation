/datum/quirk/voracious
	name = "Прожорливый"
	desc = "Ничего не встает на пути между мной и едой. Буду есть в два раза быстрее и вполне смогу перекусить нездоровой пищей. Быть толстым мне очень подходит."
	icon = FA_ICON_DRUMSTICK_BITE
	value = 4
	mob_trait = TRAIT_VORACIOUS
	gain_text = span_notice("Чувствую бурление в желудке.")
	lose_text = span_danger("Мне кажется, что мой аппетит немного снизился.")
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/dinner)
