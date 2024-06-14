/*
 * Tier two entries are unlocked after infusing someone/being infused and achieving a bonus, and are for dna mutants that are:
 * - harder to aquire (gondolas) but not *necessarily* requiring job help
 * - have a bonus for getting past a threshold
 *
 * todos for the future:
 * - tier threes, requires xenobio cooperation, unlocked after getting a tier two entity bonus
 * - when completing a tier, add the bonus to an xp system for unlocking new tiers. so instead of getting/giving a tier 1 bonus and unlocking tier 2, tier 1 would add "1" to a total. when you have a total of say, 3, you get the next tier
*/
/datum/infuser_entry/gondola
	name = "Гондола"
	infuse_mob_name = "гондолы"
	desc = "Гондолы - редкие существа, которые предпочитают просто наблюдать, а не действовать, а также имеют целый набор интересных качеств, которые можно использовать в своих целях. Вы знаете. Дзен, мир, счастье... и способность выжить в пламени плазмы..."
	threshold_desc = "он сможет не обращать внимания на большинство условий окружающей среды!"
	qualities = list(
		"обнимай людей",
		"входи в состояние блаженства",
		"слишком слаб, чтобы поднять что-то больше ручки",
		"не обращай внимания на температуру... или давление, или атмос... или что-либо еще...",
	)
	input_obj_or_mob = list(
		/obj/item/food/meat/slab/gondola,
	)
	output_organs = list(
		/obj/item/organ/internal/heart/gondola,
		/obj/item/organ/internal/tongue/gondola,
		/obj/item/organ/internal/liver/gondola,
	)
	infusion_desc = "наблюдатель"
	tier = DNA_MUTANT_TIER_TWO
	status_effect_type = /datum/status_effect/organ_set_bonus/gondola
