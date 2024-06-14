/*!

This component makes it possible to make things edible. What this means is that you can take a bite or force someone to take a bite (in the case of items).
These items take a specific time to eat, and can do most of the things our original food items could.

Behavior that's still missing from this component that original food items had that should either be put into separate components or somewhere else:
	Components:
	Drying component (jerky etc)
	Processable component (Slicing and cooking behavior essentialy, making it go from item A to B when conditions are met.)

	Misc:
	Something for cakes (You can store things inside)

*/
/datum/component/edible
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	///Amount of reagents taken per bite
	var/bite_consumption = 2
	///Amount of bites taken so far
	var/bitecount = 0
	///Flags for food
	var/food_flags = NONE
	///Bitfield of the types of this food
	var/foodtypes = NONE
	///Amount of seconds it takes to eat this food
	var/eat_time = 30
	///Defines how much it lowers someones satiety (Need to eat, essentialy)
	var/junkiness = 0
	///Message to send when eating
	var/list/eatverbs
	///Callback to be ran for when you take a bite of something
	var/datum/callback/after_eat
	///Callback to be ran for when you finish eating something
	var/datum/callback/on_consume
	///Callback to be ran for when the code check if the food is liked, allowing for unique overrides for special foods like donuts with cops.
	var/datum/callback/check_liked
	///Last time we checked for food likes
	var/last_check_time
	///The initial volume of the foods reagents
	var/volume = 50
	///The flavortext for taste (haha get it flavor text)
	var/list/tastes

/datum/component/edible/Initialize(
	list/initial_reagents,
	food_flags = NONE,
	foodtypes = NONE,
	volume = 50,
	eat_time = 1 SECONDS,
	list/tastes,
	list/eatverbs = list("ест","вкушает","поедает","пожирает","наяривает","кушает"),
	bite_consumption = 2,
	junkiness,
	datum/callback/after_eat,
	datum/callback/on_consume,
	datum/callback/check_liked,
	reagent_purity = 0.5,
)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.bite_consumption = bite_consumption
	src.food_flags = food_flags
	src.foodtypes = foodtypes
	src.volume = volume
	src.eat_time = eat_time
	src.eatverbs = string_list(eatverbs)
	src.junkiness = junkiness
	src.after_eat = after_eat
	src.on_consume = on_consume
	src.tastes = string_assoc_list(tastes)
	src.check_liked = check_liked

	setup_initial_reagents(initial_reagents, reagent_purity)

/datum/component/edible/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine))
	RegisterSignals(parent, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(UseByAnimal))
	RegisterSignal(parent, COMSIG_ATOM_CHECKPARTS, PROC_REF(OnCraft))
	RegisterSignal(parent, COMSIG_ATOM_CREATEDBY_PROCESSING, PROC_REF(OnProcessed))
	RegisterSignal(parent, COMSIG_FOOD_INGREDIENT_ADDED, PROC_REF(edible_ingredient_added))
	RegisterSignal(parent, COMSIG_OOZE_EAT_ATOM, PROC_REF(on_ooze_eat))

	if(isturf(parent))
		RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	else
		var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
		AddComponent(/datum/component/connect_loc_behalf, parent, loc_connections)

	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(UseFromHand))
		RegisterSignal(parent, COMSIG_ITEM_USED_AS_INGREDIENT, PROC_REF(used_to_customize))

		var/obj/item/item = parent
		if(!item.grind_results)
			item.grind_results = list() //If this doesn't already exist, add it as an empty list. This is needed for the grinder to accept it.

	else if(isturf(parent) || isstructure(parent))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(TryToEatIt))

/datum/component/edible/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_CHECKPARTS,
		COMSIG_ATOM_CREATEDBY_PROCESSING,
		COMSIG_ATOM_ENTERED,
		COMSIG_FOOD_INGREDIENT_ADDED,
		COMSIG_ITEM_ATTACK,
		COMSIG_ITEM_USED_AS_INGREDIENT,
		COMSIG_OOZE_EAT_ATOM,
		COMSIG_ATOM_EXAMINE,
	))

	qdel(GetComponent(/datum/component/connect_loc_behalf))

/datum/component/edible/InheritComponent(
	datum/component/edible/old_comp,
	i_am_original,
	list/initial_reagents,
	food_flags = NONE,
	foodtypes = NONE,
	volume,
	eat_time,
	list/tastes,
	list/eatverbs,
	bite_consumption,
	junkiness,
	datum/callback/after_eat,
	datum/callback/on_consume,
	datum/callback/check_liked,
)

	// If we got passed an old comp, take only the values that will not override our current ones
	if(old_comp)
		food_flags = old_comp.food_flags
		foodtypes = old_comp.foodtypes
		tastes = old_comp.tastes
		eatverbs = old_comp.eatverbs

	// only edit if we're OG
	if(!i_am_original)
		return

	// add food flags and types
	src.food_flags |= food_flags
	src.foodtypes |= foodtypes

	// add all new eatverbs to the list
	if(islist(eatverbs))
		var/list/cached_verbs = src.eatverbs
		if(islist(cached_verbs))
			// eatverbs becomes a combination of existing verbs and new ones
			src.eatverbs = string_list(cached_verbs | eatverbs)
		else
			src.eatverbs = string_list(eatverbs)

	// add all new tastes to the tastes
	if(islist(tastes))
		var/list/cached_tastes = src.tastes
		if(islist(cached_tastes))
			// tastes becomes a combination of existing tastes and new ones
			var/list/mixed_tastes = cached_tastes.Copy()
			for(var/new_taste in tastes)
				mixed_tastes[new_taste] += tastes[new_taste]

			src.tastes = string_assoc_list(mixed_tastes)
		else
			src.tastes = string_assoc_list(tastes)

	// just set these directly
	if(!isnull(bite_consumption))
		src.bite_consumption = bite_consumption
	if(!isnull(volume))
		src.volume = volume
	if(!isnull(eat_time))
		src.eat_time = eat_time
	if(!isnull(junkiness))
		src.junkiness = junkiness
	if(!isnull(after_eat))
		src.after_eat = after_eat
	if(!isnull(on_consume))
		src.on_consume = on_consume
	if(!isnull(check_liked))
		src.check_liked = check_liked

	// add newly passed in reagents
	setup_initial_reagents(initial_reagents)

/datum/component/edible/Destroy(force, silent)
	after_eat = null
	on_consume = null
	check_liked = null
	return ..()

/// Sets up the initial reagents of the food.
/datum/component/edible/proc/setup_initial_reagents(list/reagents, reagent_purity)
	var/atom/owner = parent
	if(owner.reagents)
		owner.reagents.maximum_volume = volume
	else
		owner.create_reagents(volume, INJECTABLE)

	for(var/rid in reagents)
		var/amount = reagents[rid]
		if(length(tastes) && (rid == /datum/reagent/consumable/nutriment || rid == /datum/reagent/consumable/nutriment/vitamin))
			owner.reagents.add_reagent(rid, amount, tastes.Copy(), added_purity = reagent_purity)
		else
			owner.reagents.add_reagent(rid, amount, added_purity = reagent_purity)

/datum/component/edible/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/atom/A = parent

	if(!(food_flags & FOOD_IN_CONTAINER))
		switch (bitecount)
			if (0)
				return
			if(1)
				examine_list += "\n[capitalize(A.name)] был[A.ru_a()] кем-то покусан[A.ru_a()]!"
			if(2,3)
				examine_list += "\n[capitalize(A.name)] был[A.ru_a()] покусан[A.ru_a()] [bitecount] раз!"
			else
				examine_list += "\n[capitalize(A.name)] был[A.ru_a()] покусан[A.ru_a()] множество раз!"

/datum/component/edible/proc/UseFromHand(obj/item/source, mob/living/M, mob/living/user)
	SIGNAL_HANDLER

	return TryToEat(M, user)

/datum/component/edible/proc/TryToEatIt(datum/source, mob/user)
	SIGNAL_HANDLER

	if (!in_range(source, user))
		return
	return TryToEat(user, user)

///Called when food is created through processing (Usually this means it was sliced). We use this to pass the OG items reagents.
/datum/component/edible/proc/OnProcessed(datum/source, atom/original_atom, list/chosen_processing_option)
	SIGNAL_HANDLER

	if(!original_atom.reagents)
		return

	var/atom/this_food = parent

	//Make sure we have a reagent container large enough to fit the original atom's reagents.
	volume = max(volume, ROUND_UP(original_atom.reagents.maximum_volume / chosen_processing_option[TOOL_PROCESSING_AMOUNT]))

	this_food.create_reagents(volume)
	original_atom.reagents.copy_to(this_food, original_atom.reagents.total_volume / chosen_processing_option[TOOL_PROCESSING_AMOUNT], 1)

	if(original_atom.name != initial(original_atom.name))
		this_food.name = "кусочек [original_atom.name]"
	if(original_atom.desc != initial(original_atom.desc))
		this_food.desc = "[original_atom.desc]"

///Called when food is crafted through a crafting recipe datum.
/datum/component/edible/proc/OnCraft(datum/source, list/parts_list, datum/crafting_recipe/food/recipe)
	SIGNAL_HANDLER

	var/atom/this_food = parent

	for(var/obj/item/food/crafted_part in parts_list)
		if(!crafted_part.reagents)
			continue
		this_food.reagents.maximum_volume += crafted_part.reagents.maximum_volume
		crafted_part.reagents.trans_to(this_food.reagents, crafted_part.reagents.maximum_volume)

	this_food.reagents.maximum_volume = ROUND_UP(this_food.reagents.maximum_volume) // Just because I like whole numbers for this.

	BLACKBOX_LOG_FOOD_MADE(this_food.type)

///Makes sure the thing hasn't been destroyed or fully eaten to prevent eating phantom edibles
/datum/component/edible/proc/IsFoodGone(atom/owner, mob/living/feeder)
	if(QDELETED(owner) || !(IS_EDIBLE(owner)))
		return TRUE
	if(owner.reagents.total_volume)
		return FALSE
	return TRUE

/// Normal time to forcefeed someone something
#define EAT_TIME_FORCE_FEED (3 SECONDS)
/// Multiplier for eat time if the eater has TRAIT_VORACIOUS
#define EAT_TIME_VORACIOUS_MULT 0.65 // voracious folk eat 35% faster
/// Multiplier for how much longer it takes a voracious folk to eat while full
#define EAT_TIME_VORACIOUS_FULL_MULT 4 // Takes at least 4 times as long to eat while full, so dorks cant just clear out the kitchen before they get robusted

///All the checks for the act of eating itself and
/datum/component/edible/proc/TryToEat(mob/living/eater, mob/living/feeder)

	set waitfor = FALSE

	var/atom/owner = parent

	if(feeder.combat_mode)
		return

	. = COMPONENT_CANCEL_ATTACK_CHAIN //Point of no return I suppose

	if(IsFoodGone(owner, feeder))
		return

	if(!CanConsume(eater, feeder))
		return
	var/fullness = eater.get_fullness() + 10 //The theoretical fullness of the person eating if they were to eat this

	var/time_to_eat = (eater == feeder) ? eat_time : EAT_TIME_FORCE_FEED
	if(HAS_TRAIT(eater, TRAIT_VORACIOUS))
		if(fullness < NUTRITION_LEVEL_FAT || (eater != feeder)) // No extra delay when being forcefed
			time_to_eat *= EAT_TIME_VORACIOUS_MULT
		else
			time_to_eat *= (fullness / NUTRITION_LEVEL_FAT) * EAT_TIME_VORACIOUS_FULL_MULT // takes longer to eat the more well fed you are

	if(eater == feeder)//If you're eating it yourself.
		if(eat_time > 0 && !do_after(feeder, time_to_eat, eater, timed_action_flags = food_flags & FOOD_FINGER_FOOD ? IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE : NONE)) //Gotta pass the minimal eat time
			return
		if(IsFoodGone(owner, feeder))
			return
		var/eatverb = pick(eatverbs)

		var/message_to_nearby_audience = ""
		var/message_to_consumer = ""
		var/message_to_blind_consumer = ""

		if(junkiness && eater.satiety < -150 && eater.nutrition > NUTRITION_LEVEL_STARVING + 50 && !HAS_TRAIT(eater, TRAIT_VORACIOUS))
			to_chat(eater, span_warning("Не хочу я жрать эти отбросы!"))
			return
		else if(fullness > (600 * (1 + eater.overeatduration / (4000 SECONDS)))) // The more you eat - the more you can eat
			if(HAS_TRAIT(eater, TRAIT_VORACIOUS))
				message_to_nearby_audience = span_warning("[eater] жадно запихивает [parent] в свою глотку!")
				message_to_consumer = span_notice("Жадно запихиваю [parent] в свою глотку.")
			else
				message_to_nearby_audience = span_warning("[eater] не может запихнуть [parent] в свою глотку!")
				message_to_consumer = span_warning("В меня больше не лезет [parent]!")
				message_to_blind_consumer = message_to_consumer
				eater.show_message(message_to_consumer, MSG_VISUAL, message_to_blind_consumer)
				eater.visible_message(message_to_nearby_audience, ignored_mobs = eater)
				//if we're too full, return because we can't eat whatever it is we're trying to eat
				return
		else if(fullness > 500)
			if(HAS_TRAIT(eater, TRAIT_VORACIOUS))
				message_to_nearby_audience = span_notice("[eater] [eatverb] [parent].")
				message_to_consumer = span_notice("Я пожираю [parent].")
			else
				message_to_nearby_audience = span_notice("[eater] нехотя [eatverb] кусочек [parent].")
				message_to_consumer = span_notice("Нямкаю кусочек [parent].")
		else if(fullness > 150)
			message_to_nearby_audience = span_notice("[eater] [eatverb] [parent].")
			message_to_consumer = span_notice("Кушаю [parent].")
		else if(fullness > 50)
			message_to_nearby_audience = span_notice("[eater] жадно [eatverb] [parent].")
			message_to_consumer = span_notice("Жадно пожираю [parent].")
		else
			message_to_nearby_audience = span_notice("[eater] жадно [eatverb] [parent], проглатывая кусками!")
			message_to_consumer = span_notice("Жадно кусаю [parent], проглатывая кусками!")

		//if we're blind, we want to feel how hungrily we ate that food
		message_to_blind_consumer = message_to_consumer
		eater.show_message(message_to_consumer, MSG_VISUAL, message_to_blind_consumer)
		eater.visible_message(message_to_nearby_audience, ignored_mobs = eater)

	else //If you're feeding it to someone else.
		if(isbrain(eater))
			to_chat(feeder, span_warning("[eater] похоже не имеет рта!"))
			return
		if(fullness <= (600 * (1 + eater.overeatduration / (2000 SECONDS))) || HAS_TRAIT(eater, TRAIT_VORACIOUS))
			eater.visible_message(
				span_danger("[feeder] пытается дать [eater] попробовать [parent]."),
				span_userdanger("[feeder] пытается дать мне попробовать [parent].")
			)
			if(eater.is_blind())
				to_chat(eater, span_userdanger("Кто-то пытается накормить меня!"))
		else
			eater.visible_message(
				span_warning("[feeder] не может больше запихнуть [parent] внутрь [eater]!"),
				span_warning("[feeder] не может больше запихнуть [parent] в меня!")
			)
			if(eater.is_blind())
				to_chat(eater, span_userdanger("Я слишком сыт, чтобы есть то, что мне дают!"))
			return
		if(!do_after(feeder, delay = time_to_eat, target = eater)) //Wait 3-ish seconds before you can feed
			return
		if(IsFoodGone(owner, feeder))
			return
		log_combat(feeder, eater, "fed", owner.reagents.get_reagent_log_string())
		eater.visible_message(
			span_danger("[feeder] принуждает [eater] скушать [parent]!"),
			span_userdanger("[feeder] принуждает меня скушать [parent]!")
		)
		if(eater.is_blind())
			to_chat(eater, span_userdanger("Меня заставили что-то съесть!"))

	TakeBite(eater, feeder)

	//If we're not force-feeding and there's an eat delay, try take another bite
	if(eater == feeder && eat_time > 0)
		INVOKE_ASYNC(src, PROC_REF(TryToEat), eater, feeder)

#undef EAT_TIME_FORCE_FEED
#undef EAT_TIME_VORACIOUS_MULT
#undef EAT_TIME_VORACIOUS_FULL_MULT

///This function lets the eater take a bite and transfers the reagents to the eater.
/datum/component/edible/proc/TakeBite(mob/living/eater, mob/living/feeder)

	var/atom/owner = parent

	if(!owner?.reagents)
		stack_trace("[eater] failed to bite [owner], because [owner] had no reagents.")
		return FALSE
	if(eater.satiety > -200)
		eater.satiety -= junkiness
	playsound(eater.loc,'sound/items/eatfood.ogg', rand(10,50), TRUE)
	if(!owner.reagents.total_volume)
		return
	var/sig_return = SEND_SIGNAL(parent, COMSIG_FOOD_EATEN, eater, feeder, bitecount, bite_consumption)
	if(sig_return & DESTROY_FOOD)
		qdel(owner)
		return

	//Give a buff when the dish is hand-crafted and unbitten
	if(bitecount == 0)
		apply_buff(eater)

	var/fraction = min(bite_consumption / owner.reagents.total_volume, 1)
	owner.reagents.trans_to(eater, bite_consumption, transferred_by = feeder, methods = INGEST)
	bitecount++

	checkLiked(fraction, eater)

	if(!owner.reagents.total_volume)
		On_Consume(eater, feeder)

	//Invoke our after eat callback if it is valid
	if(after_eat)
		after_eat.Invoke(eater, feeder, bitecount)

	//Invoke the eater's stomach's after_eat callback if valid
	if(iscarbon(eater))
		var/mob/living/carbon/carbon_eater = eater
		var/obj/item/organ/internal/stomach/stomach = carbon_eater.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(istype(stomach))
			stomach.after_eat(owner)

	return TRUE

///Checks whether or not the eater can actually consume the food
/datum/component/edible/proc/CanConsume(mob/living/carbon/eater, mob/living/feeder)
	if(!iscarbon(eater))
		return FALSE
	if(eater.is_mouth_covered())
		eater.balloon_alert(feeder, "рот закрыт!")
		return FALSE

	var/atom/food = parent

	if(food.flags_1 & HOLOGRAM_1)
		if(eater == feeder)
			to_chat(eater, span_notice("Пытаюсь откусить кусочек, но он исчезает!"))
		else
			to_chat(eater, span_notice("Пытаюсь накормить [eater], но еда исчезает!"))

		qdel(food)
		return FALSE

	if(SEND_SIGNAL(eater, COMSIG_CARBON_ATTEMPT_EAT, food) & COMSIG_CARBON_BLOCK_EAT)
		return
	return TRUE

///Applies food buffs according to the crafting complexity
/datum/component/edible/proc/apply_buff(mob/eater)
	var/buff
	var/recipe_complexity = get_recipe_complexity()
	if(recipe_complexity == 0)
		return
	var/obj/item/food/food = parent
	if(!isnull(food.crafted_food_buff))
		buff = food.crafted_food_buff
	else
		buff = pick_weight(GLOB.food_buffs[recipe_complexity])
	if(!isnull(buff))
		var/mob/living/living_eater = eater
		var/atom/owner = parent
		var/timeout_mod = owner.reagents.get_average_purity(/datum/reagent/consumable) * 2 // buff duration is 100% at average purity of 50%
		var/strength = recipe_complexity
		living_eater.apply_status_effect(buff, timeout_mod, strength)

///Check foodtypes to see if we should send a moodlet
/datum/component/edible/proc/checkLiked(fraction, mob/eater)
	if(last_check_time + 50 > world.time)
		return FALSE
	if(!ishuman(eater))
		return FALSE
	var/mob/living/carbon/human/gourmand = eater

	if(istype(parent, /obj/item/food))
		var/obj/item/food/food = parent
		if(food.venue_value >= FOOD_PRICE_EXOTIC)
			gourmand.add_mob_memory(/datum/memory/good_food, food = parent)

	//Bruh this breakfast thing is cringe and shouldve been handled separately from food-types, remove this in the future (Actually, just kill foodtypes in general)
	if((foodtypes & BREAKFAST) && world.time - SSticker.round_start_time < STOP_SERVING_BREAKFAST)
		gourmand.add_mood_event("breakfast", /datum/mood_event/breakfast)
	last_check_time = world.time

	var/food_quality = get_perceived_food_quality(gourmand)

	if(food_quality <= TOXIC_FOOD_QUALITY_THRESHOLD)
		to_chat(gourmand,span_warning("ГОСПОДИ, ЭТО ОТВРАТИТЕЛЬНО!"))
		gourmand.adjust_disgust(25 + 30 * fraction)
		gourmand.add_mood_event("toxic_food", /datum/mood_event/disgusting_food)
		return

	if(food_quality < 0)
		to_chat(gourmand,span_notice("Фу! Я не люблю это..."))
		gourmand.adjust_disgust(11 + 15 * fraction)
		gourmand.add_mood_event("gross_food", /datum/mood_event/gross_food)
		return

	if(food_quality == 0)
		return // meh

	food_quality = min(food_quality, FOOD_QUALITY_TOP)
	var/atom/owner = parent
	var/timeout_mod = owner.reagents.get_average_purity(/datum/reagent/consumable) * 2 // mood event duration is 100% at average purity of 50%
	var/event = GLOB.food_quality_events[food_quality]
	gourmand.add_mood_event("quality_food", event, timeout_mod)
	gourmand.adjust_disgust(-5 + -2 * food_quality * fraction)
	to_chat(gourmand, span_notice("Вкусно!"))

/// Get the complexity of the crafted food
/datum/component/edible/proc/get_recipe_complexity()
	if(!HAS_TRAIT(parent, TRAIT_FOOD_CHEF_MADE) || !istype(parent, /obj/item/food))
		return 0 // It is factory made. Soulless.
	var/obj/item/food/food = parent
	return food.crafting_complexity

/// Get food quality adjusted according to eater's preferences
/datum/component/edible/proc/get_perceived_food_quality(mob/living/carbon/human/eater)
	var/food_quality = get_recipe_complexity()

	if(HAS_TRAIT(parent, TRAIT_FOOD_SILVER)) // it's not real food
		if(!isjellyperson(eater)) //if you aren't a jellyperson, it makes you sick no matter how nice it looks
			return TOXIC_FOOD_QUALITY_THRESHOLD
		food_quality += LIKED_FOOD_QUALITY_CHANGE

	if(check_liked) //Callback handling; use this as an override for special food like donuts
		var/special_reaction = check_liked.Invoke(eater)
		switch(special_reaction) //return early for special foods
			if(FOOD_LIKED)
				return LIKED_FOOD_QUALITY_CHANGE
			if(FOOD_DISLIKED)
				return DISLIKED_FOOD_QUALITY_CHANGE
			if(FOOD_TOXIC)
				return TOXIC_FOOD_QUALITY_THRESHOLD
			if(FOOD_ALLERGIC)
				return FOOD_QUALITY_DANGEROUS

	if(ishuman(eater))
		if(count_matching_foodtypes(foodtypes, eater.get_toxic_foodtypes())) //if the food is toxic, we don't care about anything else
			return TOXIC_FOOD_QUALITY_THRESHOLD
		if(HAS_TRAIT(eater, TRAIT_AGEUSIA)) //if you can't taste it, it doesn't taste good
			return 0
		food_quality += DISLIKED_FOOD_QUALITY_CHANGE * count_matching_foodtypes(foodtypes, eater.get_disliked_foodtypes())
		food_quality += LIKED_FOOD_QUALITY_CHANGE * count_matching_foodtypes(foodtypes, eater.get_liked_foodtypes())

	return food_quality

/// Get the number of matching food types in provided bitfields
/datum/component/edible/proc/count_matching_foodtypes(bitfield_one, bitfield_two)
	var/count = 0
	var/matching_bits = bitfield_one & bitfield_two
	while (matching_bits > 0)
		if (matching_bits & 1)
			count++
		matching_bits >>= 1
	return count

///Delete the item when it is fully eaten
/datum/component/edible/proc/On_Consume(mob/living/eater, mob/living/feeder)
	SEND_SIGNAL(parent, COMSIG_FOOD_CONSUMED, eater, feeder)

	on_consume?.Invoke(eater, feeder)
	if (QDELETED(parent)) // might be destroyed by the callback
		return

	to_chat(feeder, span_warning("Совсем не осталось [parent], о нет!"))
	if(isturf(parent))
		var/turf/T = parent
		T.ScrapeAway(1, CHANGETURF_INHERIT_AIR)
	else
		qdel(parent)

///Ability to feed food to puppers
/datum/component/edible/proc/UseByAnimal(datum/source, mob/living/basic/pet/dog/doggy)
	SIGNAL_HANDLER

	if(!isdog(doggy))
		return

	var/atom/food = parent

	if(food.flags_1 & HOLOGRAM_1)
		to_chat(doggy, span_notice("Пытаюсь откусить кусочек, но он исчезает!"))
		qdel(food)
		return

	if(bitecount == 0 || prob(50))
		doggy.manual_emote("откусывает кусочек [parent]")
	bitecount++
	. = COMPONENT_CANCEL_ATTACK_CHAIN

	doggy.taste(food.reagents) // why should carbons get all the fun?
	if(bitecount >= 5)
		var/satisfaction_text = pick("отрыгивает от удовольствия", "просит ещё", "гавкает дважды", "не может найти куда пропал [parent]")
		doggy.manual_emote(satisfaction_text)
		qdel(food)

///Ability to feed food to puppers
/datum/component/edible/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	SEND_SIGNAL(parent, COMSIG_FOOD_CROSSED, arrived, bitecount)

///Response to being used to customize something
/datum/component/edible/proc/used_to_customize(datum/source, atom/customized)
	SIGNAL_HANDLER

	SEND_SIGNAL(customized, COMSIG_FOOD_INGREDIENT_ADDED, src)

///Response to an edible ingredient being added to parent.
/datum/component/edible/proc/edible_ingredient_added(datum/source, datum/component/edible/ingredient)
	SIGNAL_HANDLER

	InheritComponent(ingredient, TRUE)

/// Response to oozes trying to eat something edible
/datum/component/edible/proc/on_ooze_eat(datum/source, mob/eater, edible_flags)
	SIGNAL_HANDLER

	var/atom/food = parent

	if(food.flags_1 & HOLOGRAM_1)
		to_chat(eater, span_notice("Пытаюсь откусить кусочек, но он исчезает!"))
		qdel(food)
		return COMPONENT_ATOM_EATEN

	if(foodtypes & edible_flags)
		food.reagents.trans_to(eater, food.reagents.total_volume, transferred_by = eater)
		eater.visible_message(span_warning("[src] ест [food]!"), span_notice("Ем [food]."))
		playsound(get_turf(eater),'sound/items/eatfood.ogg', rand(30,50), TRUE)
		qdel(food)
		return COMPONENT_ATOM_EATEN