#define DONUT_SPRINKLE_CHANCE 30

/obj/item/food/donut
	name = "пончик"
	desc = "Идеально подходит к кофе."
	icon = 'icons/obj/food/donuts.dmi'
	inhand_icon_state = "donut1"
	bite_consumption = 5
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3)
	tastes = list("пончик" = 1)
	foodtypes = JUNKFOOD | GRAIN | SUGAR | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	var/decorated_icon = "donut_homer"
	var/is_decorated = FALSE
	var/extra_reagent = null
	var/decorated_adjective = "sprinkled"
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/donut/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, amount_per_dunk = 10)
	if(prob(DONUT_SPRINKLE_CHANCE))
		decorate_donut()

///Override for checkliked callback
/obj/item/food/donut/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, check_liked = CALLBACK(src, PROC_REF(check_liked)))

/obj/item/food/donut/proc/decorate_donut()
	if(is_decorated || !decorated_icon)
		return
	is_decorated = TRUE
	name = "[decorated_adjective] [name]"
	icon_state = decorated_icon //delish~!
	inhand_icon_state = "donut2"
	reagents.add_reagent(/datum/reagent/consumable/sprinkles, 1)
	return TRUE

/// Returns the sprite of the donut while in a donut box
/obj/item/food/donut/proc/in_box_sprite()
	return "[icon_state]_inbox"

///Override for checkliked in edible component, because all cops LOVE donuts
/obj/item/food/donut/proc/check_liked(mob/living/carbon/human/consumer)
	var/obj/item/organ/internal/liver/liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!HAS_TRAIT(consumer, TRAIT_AGEUSIA) && liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		return FOOD_LIKED

//Use this donut ingame
/obj/item/food/donut/plain
	icon_state = "donut"

/obj/item/food/donut/chaos
	name = "пончик хаоса"
	desc = "Как и в реальной жизни, ты никогда не сможешь угадать каким будет вкус и последствия."
	icon_state = "donut_chaos"
	bite_consumption = 10
	tastes = list("пончик" = 3, "хаос" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/chaos/Initialize(mapload)
	. = ..()
	extra_reagent = pick(
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/capsaicin,
		/datum/reagent/consumable/frostoil,
		/datum/reagent/drug/krokodil,
		/datum/reagent/toxin/plasma,
		/datum/reagent/consumable/coco,
		/datum/reagent/toxin/slimejelly,
		/datum/reagent/consumable/banana,
		/datum/reagent/consumable/berryjuice,
		/datum/reagent/medicine/omnizine,
	)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/food/donut/meat
	name = "мясной пончик"
	desc = "На вкус такая же гадость, как и на вид."
	icon_state = "donut_meat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/ketchup = 3,
	)
	tastes = list( "мясо"= 1)
	foodtypes = JUNKFOOD | MEAT | GORE | FRIED | BREAKFAST
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/berry
	name = "ягодный пончик"
	desc = "Отлично сочетается с соевым латте."
	icon_state = "donut_pink"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/berryjuice = 3,
		/datum/reagent/consumable/sprinkles = 1, //Extra sprinkles to reward frosting
	)
	decorated_icon = "donut_homer"

/obj/item/food/donut/trumpet
	name = "пончик космонавтов"
	desc = "Отлично сочетается с холодным стаканом малака."
	icon_state = "donut_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 3, "фиалки" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/apple
	name = "яблочный пончик"
	desc = "Отлично сочетается со шнапсом с корицей."
	icon_state = "donut_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 3, "зелёные яблоки" = 1)
	is_decorated = TRUE

/obj/item/food/donut/caramel
	name = "карамельный пончик"
	desc = "Отлично сочетается с чашкой горячего кофе."
	icon_state = "donut_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 3, "маслянистая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/choco
	name = "шоколадный пончик"
	desc = "Отлично сочетается со стаканом теплого молока."
	icon_state = "donut_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
	) //the coco reagent is just bitter.
	tastes = list("пончик" = 4, "горечь" = 1)
	decorated_icon = "donut_choc_sprinkles"
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/blumpkin
	name = "синетыквенный пончик"
	desc = "Отлично сочетается с кружкой успокаивающего пьяного синетыквенника."
	icon_state = "donut_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 2, "синетыква" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/bungo
	name = "бунго пончик"
	desc = "Отлично сочетается с баночкой \"Восторг хиппи\"."
	icon_state = "donut_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 3, "тропическая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/matcha
	name = "матчавый пончик"
	desc = "Отлично сочетается с чашкой чая."
	icon_state = "donut_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("пончик" = 3, "матча" = 1)
	is_decorated = TRUE

/obj/item/food/donut/laugh
	name = "пончик из душистого горошка"
	desc = "Отлично сочетается с бутылкой \"Bastion Burbon\"!"
	icon_state = "donut_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("пончик" = 3)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

//////////////////////JELLY DONUTS/////////////////////////

/obj/item/food/donut/jelly
	name = "желеный пончик"
	desc = "НеуЖЕЛЛИ?"
	icon_state = "jelly"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	extra_reagent = /datum/reagent/consumable/berryjuice
	tastes = list("желе" = 1, "пончик" = 3)
	foodtypes = JUNKFOOD | GRAIN | FRIED | FRUIT | SUGAR | BREAKFAST

// Jelly donuts don't have holes, but look the same on the outside
/obj/item/food/donut/jelly/in_box_sprite()
	return "[replacetext(icon_state, "jelly", "donut")]_inbox"

/obj/item/food/donut/jelly/Initialize(mapload)
	. = ..()
	if(extra_reagent)
		reagents.add_reagent(extra_reagent, 3)

/obj/item/food/donut/jelly/plain //use this ingame to avoid inheritance related crafting issues.
	decorated_icon = "jelly_homer"

/obj/item/food/donut/jelly/berry
	name = "пончик с ягодным желе"
	desc = "Отлично сочетается с соевым латте."
	icon_state = "jelly_pink"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/berryjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1) //Extra sprinkles to reward frosting.
	decorated_icon = "jelly_homer"

/obj/item/food/donut/jelly/trumpet
	name = "желейный пончик космонавта"
	desc = "Отлично сочетается с холодным стаканом малака."
	icon_state = "jelly_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "фиалки" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/apple
	name = "пончик с яблочным желе"
	desc = "Отлично сочетается со шнапсом с корицей."
	icon_state = "jelly_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "зелёные яблоки" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/caramel
	name = "карамальный желейный пончик"
	desc = "Отлично сочетается с чашкой горячего какао."
	icon_state = "jelly_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "маслянистая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/choco
	name = "шоколадный желейный пончик"
	desc = "Отлично сочетается со стаканом тёплого молока."
	icon_state = "jelly_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 4, "горечь" = 1)
	decorated_icon = "jelly_choc_sprinkles"
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/blumpkin
	name = "пончик с синетыквенным желе"
	desc = "Отлично сочетается с кружкой успокаивающего пьяного синетыквенника."
	icon_state = "jelly_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 2, "синетыква" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/bungo
	name = "пончик с желе Бунго"
	desc = "Отлично сочетается с баночкой \"Восторг хиппи\"."
	icon_state = "jelly_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "тропическая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/matcha
	name = "матчавый желейный пончик"
	desc = "Отлично сочетается с чашкой чая."
	icon_state = "jelly_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "матча" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/laugh
	name = "пончик с желе из душистого горошка"
	desc = "Отлично сочетается с бутылкой \"Bastion Burbon\"!"
	icon_state = "jelly_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("желе" = 3, "пончик" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

//////////////////////////SLIME DONUTS/////////////////////////

/obj/item/food/donut/jelly/slimejelly
	name = "слаймовый пончик"
	desc = "НеуЖЕЛЛИ?"
	extra_reagent = /datum/reagent/toxin/slimejelly
	foodtypes = JUNKFOOD | GRAIN | FRIED | TOXIC | SUGAR | BREAKFAST

/obj/item/food/donut/jelly/slimejelly/plain
	icon_state = "jelly"

/obj/item/food/donut/jelly/slimejelly/berry
	name = "ягодный слаймовый пончик"
	desc = "Отлично сочетается с соевым латте."
	icon_state = "jelly_pink"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/berryjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) //Extra sprinkles to reward frosting

/obj/item/food/donut/jelly/slimejelly/trumpet
	name = "слаймовый пончик космонавта"
	desc = "Отлично сочетается с холодным стаканом малака."
	icon_state = "jelly_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "фиалки" =  1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/slimejelly/apple
	name = "яблочный слаймовый пончик"
	desc = "Отлично сочетается со шнапсом с корицей."
	icon_state = "jelly_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "зелёные яблоки" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/caramel
	name = "карамельный слаймовый пончик"
	desc = "Отлично сочетается с чашкой горячего какао."
	icon_state = "jelly_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "маслянистая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/choco
	name = "шоколадный слаймовый пончик"
	desc = "Отлично сочетается со стаканом теплого молока."
	icon_state = "jelly_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 4, "горечь" = 1)
	decorated_icon = "jelly_choc_sprinkles"
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/slimejelly/blumpkin
	name = "синетыквенный слаймовый пончик"
	desc = "Отлично сочетается с кружкой успокаивающего пьяного синетыквенника."
	icon_state = "jelly_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 2, "синетыква" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donut/jelly/slimejelly/bungo
	name = "бунго слаймовый пончик"
	desc = "Отлично сочетается с баночкой \"Восторг хиппи\"."
	icon_state = "jelly_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "тропическая сладость" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/matcha
	name = "матчавый слаймовый пончик"
	desc = "Отлично сочетается с чашкой чая."
	icon_state = "jelly_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("желе" = 1, "пончик" = 3, "матча" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/laugh
	name = "слаймовый пончик с желе из душистого горошка"
	desc = "Отлично сочетается с бутылкой \"Bastion Burbon\"!"
	icon_state = "jelly_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("желе" = 3, "пончик" = 1, "fizzy tutti frutti" = 1)
	is_decorated = TRUE
	crafting_complexity = FOOD_COMPLEXITY_3

#undef DONUT_SPRINKLE_CHANCE
