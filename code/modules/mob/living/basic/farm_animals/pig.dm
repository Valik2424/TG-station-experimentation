//pig
/mob/living/basic/pig
	name = "Свинья"
	real_name = "Свинья"
	desc = "Хрюкает."
	icon = 'white/valtos/icons/animal.dmi'
	icon_state = "pig"
	icon_living = "pig"
	icon_dead = "pig_dead"
	icon_gib = "pig_gib"
	gender = MALE
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	speak_emote = list("хрюкает")
	butcher_results = list(/obj/item/food/meat/slab/salo = 6, /obj/item/food/meat/slab/pig = 3)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "отталкивает"
	response_disarm_simple = "отталкивает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/weapons/punch1.ogg'
	attack_vis_effect = ATTACK_EFFECT_KICK
	attacked_sound = 'white/valtos/sound/pig/oink.ogg'
	melee_damage_lower = 1
	melee_damage_upper = 2
	health = 500
	maxHealth = 500
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	ai_controller = /datum/ai_controller/basic_controller/pig

/mob/living/basic/pig/Initialize(mapload)
	. = ..()

	if (prob(1))
		name = "Гриша"
		desc = "<big>Лучший ГМ в мире.</big>"

	AddElement(/datum/element/pet_bonus, "хрю!")
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/ai_flee_while_injured)
	make_tameable()

///wrapper for the tameable component addition so you can have non tamable cow subtypes
/mob/living/basic/pig/proc/make_tameable()
	AddComponent(/datum/component/tameable, food_types = list(/obj/item/food/grown/carrot), tame_chance = 25, bonus_tame_chance = 15, after_tame = CALLBACK(src, PROC_REF(tamed)))

/mob/living/basic/pig/proc/tamed(mob/living/tamer)
	can_buckle = TRUE
	buckle_lying = 0
	AddElement(/datum/element/ridable, /datum/component/riding/creature/pig)
	visible_message(span_notice("[src] уважительно хрюкает."))

/datum/ai_controller/basic_controller/pig
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic,
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/random_speech/pig,
	)

#define CELL_LINE_TABLE_PIG "cell_line_pig_table"

/obj/item/food/meat/slab/salo
	name = "сало"
	icon = 'white/valtos/icons/food.dmi'
	icon_state = "salo"
	foodtypes = MEAT

/obj/item/food/meat/rawcutlet/plain/salo
	name = "сало"
	icon = 'white/valtos/icons/food.dmi'
	icon_state = "salo_slice"

/obj/item/food/meat/slab/pig/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PIG, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pig/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/salo, 3, 30)

#undef CELL_LINE_TABLE_PIG
