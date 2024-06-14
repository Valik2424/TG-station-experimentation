/datum/reagent/consumable/nutriment/protein/semen
	name = "Сперма"
	description = "Натуральный биопродукт."
	brute_heal = 0.3
	nutriment_factor = 18 * REAGENTS_METABOLISM

/datum/reagent/consumable/nutriment/protein/semen/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/cum/reagentdecal = new(exposed_turf,,FALSE)
	reagentdecal = locate() in exposed_turf
	if(reagentdecal)
		reagentdecal.reagents.add_reagent(/datum/reagent/consumable/nutriment/protein/semen, reac_volume)
