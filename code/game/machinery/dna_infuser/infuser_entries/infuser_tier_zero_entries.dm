/*
 * Tier zero entries are unlocked at the start, and are for dna mutants that are:
 * - a roundstart race (felinid)
 * - something of equal power to a roundstart race (flyperson)
 * - mutants without a bonus, just bringing cosmetics (fox ears)
 * basically just meme, cosmetic, and base species entries
*/
/datum/infuser_entry/fly
	name = "Отклонено"
	infuse_mob_name = "мухи"
	desc = "По какой-то причине, когда тело отвергает ДНК, ДНК становится кислой, превращаясь в своеобразную ДНК мухи."
	threshold_desc = "то он станет чудовищем!"
	qualities = list(
		"пьёт рвоту",
		"говорит как муха",
		"непонятные органы",
		"это плохая идея",
	)
	output_organs = list(
		/obj/item/organ/internal/appendix/fly,
		/obj/item/organ/internal/eyes/fly,
		/obj/item/organ/internal/heart/fly,
		/obj/item/organ/internal/lungs/fly,
		/obj/item/organ/internal/stomach/fly,
		/obj/item/organ/internal/tongue/fly,
	)
	infusion_desc = "мухоподобная"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/vulpini
	name = "Лиса"
	infuse_mob_name = "вульпы"
	desc = "Лисы теперь довольно редки из-за безумной моды на \"лисьи уши\" в 2555 году. Я имею в виду, также потому, что мы космические путешественники, которые уничтожили естественные места обитания лис, но это относится к большинству животных."
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"ну нет",
		"ты позоришь всех генетиков",
		"надеюсь, это того стоило",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/fox,
	)
	output_organs = list(
		/obj/item/organ/internal/ears/fox,
	)
	infusion_desc = "непростительная"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/mothroach
	name = "Mothroach"
	infuse_mob_name = "lepi-blattidae"
	desc = "So first they mixed moth and roach DNA to make mothroaches, and now we mix mothroach DNA with humanoids to make mothmen hybrids?"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"eyes weak to bright lights",
		"you flutter when you talk",
		"wings that can't even carry your body weight",
		"i hope it was worth it",
	)
	input_obj_or_mob = list(
		/mob/living/basic/mothroach,
	)
	output_organs = list(
		/obj/item/organ/external/antennae,
		/obj/item/organ/external/wings/moth,
		/obj/item/organ/internal/eyes/moth,
		/obj/item/organ/internal/tongue/moth,
	)
	infusion_desc = "fluffy"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/felinid
	name = "Кот"
	infuse_mob_name = "кота"
	desc = "УСПОКОЙТЕСЬ! Я на на что не намекаю этой записью. Мы действительно так удивлены, что фелиниды - это люди с примесью днк фелина?"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"дай угадаю, ты большой поклонник тех японских туристических ботов",
		"фу, фурри",
		"надеюсь, это того стоило",
	)
	input_obj_or_mob = list(
		/mob/living/simple_animal/pet/cat,
	)
	output_organs = list(
		/obj/item/organ/internal/ears/cat,
		/obj/item/organ/external/tail/cat,
	)
	infusion_desc = "прислуга"
	tier = DNA_MUTANT_TIER_ZERO
