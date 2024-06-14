/obj/item/food/bait
	name = "наживка"
	desc = "Попался!"
	icon = 'icons/obj/fishing.dmi'
	/// Quality trait of this bait
	var/bait_quality = TRAIT_BASIC_QUALITY_BAIT
	/// Icon state added to main fishing rod icon when this bait is equipped
	var/rod_overlay_icon_state

/obj/item/food/bait/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, bait_quality, INNATE_TRAIT)

/obj/item/food/bait/worm
	name = "червь"
	desc = "Это червяк из банки с наживкой. Ты же не собираешься его есть?"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "worm"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("meat" = 1, "worms" = 1)
	foodtypes = GROSS | MEAT | BUGS
	w_class = WEIGHT_CLASS_TINY
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	rod_overlay_icon_state = "worm_overlay"

/obj/item/food/bait/worm/premium
	name = "премиум червь"
	desc = "Этот червь выглядит очень изысканно."
	bait_quality = TRAIT_GOOD_QUALITY_BAIT

/obj/item/food/bait/natural
	name = "\"натуральная\" наживка"
	desc = "Рыба не может насытиться этим!"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "pill9"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "pen"
	food_reagents = list(/datum/reagent/drug/kronkaine = 1)
	tastes = list("hypocrisy" = 1)
	bait_quality = TRAIT_GREAT_QUALITY_BAIT

/obj/item/food/bait/doughball
	name = "кусочек теста"
	desc = "Маленький кусочек теста. Простая, но эффективная наживка."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "doughball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("dough" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	rod_overlay_icon_state = "dough_overlay"

/**
 * Bound to the tech fishing rod, from which cannot be removed,
 * Bait-related preferences and traits, both negative and positive,
 * should be ignored by this bait.
 * Otherwise it'd be hard/impossible to cath some fish with it,
 * making that rod a shoddy choice in the long run.
 */
/obj/item/food/bait/doughball/synthetic
	name = "кусочек синтетического теста"
	icon_state = "doughball"
	preserved_food = TRUE

/obj/item/food/bait/doughball/synthetic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, OMNI_BAIT_TRAIT, INNATE_TRAIT)
