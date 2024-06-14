// Sweets that didn't make it into any other category

/obj/item/food/candy_corn
	name = "леденцовая кукуруза"
	desc = "Это горсть леденцовой кукурузы. Может храниться в шляпе детектива."
	icon_state = "candy_corn"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sugar = 2,
	)
	tastes = list("candy corn" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/candy_corn/prison
	name = "сушеная леденцовая кукуруза"
	desc = "Если бы эта леденцовая кукуруза была более твердой, служба безопасности конфисковала бы ее как потенциальную заточку."
	force = 1 // the description isn't lying
	throwforce = 1 // if someone manages to bust out of jail with candy corn god bless them
	tastes = list("bitter wax" = 1)
	foodtypes = GROSS

/obj/item/food/candiedapple
	name = "карамелизированное яблоко"
	desc = "Яблоко, покрытое сахарным сиропом."
	icon_state = "candiedapple"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 5,
	)
	tastes = list("apple" = 2, "caramel" = 3)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/mint
	name = "мята"
	desc = "Это всего лишь тонкая пластинка."
	icon_state = "mint"
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/mintextract = 2)
	foodtypes = TOXIC | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/ant_candy
	name = "муравьиная конфета"
	desc = "Колония муравьев, в затвердевшем сахаре. Эти твари мертвы, верно?"
	icon_state = "ant_pop"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/ants = 3,
	)
	tastes = list("candy" = 1, "insects" = 1)
	foodtypes = JUNKFOOD | SUGAR | BUGS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

// Chocolates
/obj/item/food/chocolatebar
	name = "шоколадка"
	desc = "Такая сладкая.. такая.. жирная.."
	icon_state = "chocolatebar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/coco = 2,
	)
	tastes = list("chocolate" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/chococoin
	name = "шоколадная монетка"
	desc = "Полностью съедобная монетка."
	icon_state = "chococoin"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("chocolate" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/fudgedice
	name = "помадный кубик"
	desc = "У вас появится шоколадная помадка на губах после его поедания."
	icon_state = "chocodice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/sugar = 1,
	)
	trash_type = /obj/item/dice/fudge
	tastes = list("fudge" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/chocoorange
	name = "шоколадный апельсин"
	desc = "Фестивальное угощение."
	icon_state = "chocoorange"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("chocolate" = 3, "oranges" = 1)
	foodtypes = JUNKFOOD | SUGAR | ORANGES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/bonbon
	name = "bon bon"
	desc = "A tiny and sweet chocolate."
	icon_state = "tiny_chocolate"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/coco = 1,
	)
	tastes = list("chocolate" = 1)
	foodtypes = DAIRY | JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/bonbon/caramel_truffle
	name = "caramel truffle"
	desc = "A bite-sized chocolate truffle with a chewy caramel filling."
	icon_state = "caramel_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("chocolate" = 1, "chewy caramel" = 1)
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/bonbon/chocolate_truffle
	name = "chocolate truffle"
	desc = "A bite-sized chocolate truffle with a rich chocolate mousse filling."
	icon_state = "chocolate_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)

/obj/item/food/bonbon/peanut_truffle
	name = "peanut truffle"
	desc = "A bite-sized chocolate truffle with crunchy peanuts mixed in."
	icon_state = "peanut_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("chocolate" = 1, "peanuts" = 1)
	foodtypes = DAIRY | SUGAR | JUNKFOOD | NUTS
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/bonbon/peanut_butter_cup
	name = "peanut butter cup"
	desc = "An ultra-sweet chocolate treat with a savory peanut butter filling."
	icon_state = "peanut_butter_cup"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("chocolate" = 1, "peanut butter" = 1)
	foodtypes = DAIRY | SUGAR | JUNKFOOD | NUTS
	crafting_complexity = FOOD_COMPLEXITY_1

// Gum
/obj/item/food/bubblegum
	name = "жвачка"
	desc = "Резиновая полоска жвачки. Не совсем насыщает, но держит вас в тонусе."
	icon_state = "bubblegum"
	inhand_icon_state = null
	color = "#E48AB5" // craftable custom gums someday?
	food_reagents = list(/datum/reagent/consumable/sugar = 5)
	tastes = list("candy" = 1)
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

	/// The amount to metabolize per second
	var/metabolization_amount = REAGENTS_METABOLISM / 2

/obj/item/food/bubblegum/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] swallows [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	qdel(src)
	return TOXLOSS

/obj/item/food/bubblegum/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/chewable, metabolization_amount = metabolization_amount)

/obj/item/food/bubblegum/nicotine
	name = "никотиновая жвачка"
	food_reagents = list(
		/datum/reagent/drug/nicotine = 10,
		/datum/reagent/consumable/menthol = 5,
	)
	tastes = list("mint" = 1)
	color = "#60A584"

/obj/item/food/bubblegum/happiness
	name = "HP+ жвачка"
	desc = "Резиновая полоска жвачки. Пахнет забавно."
	food_reagents = list(/datum/reagent/drug/happiness = 15)
	tastes = list("paint thinner" = 1)
	color = "#EE35FF"

/obj/item/food/bubblegum/bubblegum
	name = "резиновая жвачка"
	desc = "Резиновая полоска жвачки. Кажется, что есть ее - не лучшая идея."
	color = "#913D3D"
	food_reagents = list(/datum/reagent/blood = 15)
	tastes = list("hell" = 1, "people" = 1)
	metabolization_amount = REAGENTS_METABOLISM

/obj/item/food/bubblegum/bubblegum/process()
	. = ..()
	if(iscarbon(loc))
		hallucinate(loc)

/obj/item/food/bubblegum/bubblegum/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, on_consume = CALLBACK(src, PROC_REF(OnConsume)))

/obj/item/food/bubblegum/bubblegum/proc/OnConsume(mob/living/eater, mob/living/feeder)
	if(iscarbon(eater))
		hallucinate(eater)

///This proc has a 5% chance to have a bubblegum line appear, with an 85% chance for just text and 15% for a bubblegum hallucination and scarier text.
/obj/item/food/bubblegum/bubblegum/proc/hallucinate(mob/living/carbon/victim)
	if(prob(95)) //cursed by bubblegum
		return
	if(prob(15))
		victim.cause_hallucination(/datum/hallucination/oh_yeah, "bubblegum bubblegum", haunt_them = TRUE)
	else
		to_chat(victim, span_warning("[pick("Я слышу тихий шепот.","Я чувствую запах пепла.","Мне жарко.","Я слышу рев вдали.")]"))

/obj/item/food/bubblegum/bubblegum/suicide_act(mob/living/user)
	user.say(";[pick(BUBBLEGUM_HALLUCINATION_LINES)]")
	return ..()

/obj/item/food/gumball
	name = "жвачка"
	desc = "Яркий, сладкий шарик жвачки."
	icon = 'icons/obj/food/lollipop.dmi'
	icon_state = "gumball"
	worn_icon_state = "bubblegum"
	food_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/sal_acid = 2, /datum/reagent/medicine/oxandrolone = 2) //Kek
	tastes = list("candy")
	foodtypes = JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_WORTHLESS

/obj/item/food/gumball/Initialize(mapload)
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	AddElement(/datum/element/chewable)


// Lollipop
/obj/item/food/lollipop
	name = "леденец"
	desc = "Вкусный леденец. Подойдет для отличного подарка на День Святого Валентина."
	icon = 'icons/obj/food/lollipop.dmi'
	icon_state = "lollipop_stick"
	inhand_icon_state = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("candy" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_WORTHLESS
	var/mutable_appearance/head
	var/head_color = rgb(0, 0, 0)

/obj/item/food/lollipop/Initialize(mapload)
	. = ..()
	head = mutable_appearance('icons/obj/food/lollipop.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
	AddElement(/datum/element/chewable)

/obj/item/food/lollipop/proc/change_head_color(C)
	head_color = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/lollipop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/lollipop/cyborg
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/iron = 10,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/psicodine = 2, //psicodine instead of omnizine, because the latter was making coders freak out
	)

/obj/item/food/spiderlollipop
	name = "паучий леденец"
	desc = "Все равно противно, но, по крайней мере, на нем есть гора сахара."
	icon_state = "spiderlollipop"
	worn_icon_state = "lollipop_stick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/toxin = 1,
		/datum/reagent/iron = 10,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/omnizine = 2,
	) //lollipop, but vitamins = toxins
	tastes = list("cobwebs" = 1, "sugar" = 2)
	foodtypes = JUNKFOOD | SUGAR | BUGS
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/spiderlollipop/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/chewable)
