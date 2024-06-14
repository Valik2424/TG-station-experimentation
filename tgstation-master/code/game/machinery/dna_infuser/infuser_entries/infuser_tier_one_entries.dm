/*
 * Tier one entries are unlocked at the start, and are for dna mutants that are:
 * - easy to aquire (rats)
 * - have a bonus for getting past a threshold
 * - might serve a job purpose for others (goliath) and thus should be gainable early enough
*/
/datum/infuser_entry/goliath
	name = "Голиаф"
	infuse_mob_name = "голиафа"
	desc = "Кто-то сказал: 'Кто борется с чудовищами, тот должен позаботиться о том, чтобы в процессе он сам не стал чудовищем'. Но этот человек явно не видел, что может сделать голиаф-шахтер!"
	threshold_desc = "он сможет ходить по лаве!"
	qualities = list(
		"может дышать как воздухом станции, так и воздухом лаваленда, но будьте осторожны с чистым кислородом",
		"иммунитет к пепельным бурям",
		"глаза, которые могут видеть в темноте",
		"руки-тентакли легко пробиваются через базальт и уничтожают враждебную фауну, но дни ношения перчаток позади...",
	)
	input_obj_or_mob = list(
		/mob/living/basic/mining/goliath,
	)
	output_organs = list(
		/obj/item/organ/internal/brain/goliath,
		/obj/item/organ/internal/eyes/night_vision/goliath,
		/obj/item/organ/internal/heart/goliath,
		/obj/item/organ/internal/lungs/lavaland/goliath,
	)
	infusion_desc = "бронированный, щупольцеподобный"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/goliath

/datum/infuser_entry/carp
	name = "Карп"
	infuse_mob_name = "космического карпа"
	desc = "Карп-мутанты очень хорошо подготовлены для длительных космических путешествий. На самом деле, они не могут устоять перед ними."
	threshold_desc = "он узнает, как \"плавать\" в космосе!"
	qualities = list(
		"большие челюсти, большие зубы",
		"плавать в космосе - не проблема",
		"всегда хочет путешествовать",
	)
	input_obj_or_mob = list(
		/mob/living/basic/carp,
	)
	output_organs = list(
		/obj/item/organ/internal/brain/carp,
		/obj/item/organ/internal/heart/carp,
		/obj/item/organ/internal/lungs/carp,
		/obj/item/organ/internal/tongue/carp,
	)
	infusion_desc = "кочующий"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/carp

/datum/infuser_entry/rat
	name = "Крыса"
	infuse_mob_name = "крысы"
	desc = "Крысы - это маленькие, но очень быстрые существа, которые могут проникнуть в самые маленькие щели. Они также очень быстро размножаются, так что будьте осторожны!"
	threshold_desc = "он станет настолько маленьким, что сможет пролезть через вентиляцию."
	qualities = list(
		"ест все, что попадется под руку",
		"может пролезть в самые маленькие щели",
		"слабый, но быстрый",
	)
	input_obj_or_mob = list(
		/obj/item/food/deadmouse,
	)
	output_organs = list(
		/obj/item/organ/internal/eyes/night_vision/rat,
		/obj/item/organ/internal/heart/rat,
		/obj/item/organ/internal/stomach/rat,
		/obj/item/organ/internal/tongue/rat,
	)
	infusion_desc = "пугливый"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/rat

/datum/infuser_entry/roach
	name = "Таракан"
	infuse_mob_name = "таракана"
	desc = "Судя по вашему интересу к этому, вы поклонник древней литературы. Несомненно, включение ДНК таракана в ваш геном\
		не приведет к тому, что вы не сможете встать с постели. Эти существа невероятно устойчивы ко многим вещам\
		, и мы можем это использовать! Кто бы не хотел пережить ядерный взрыв?\
		ПРИМЕЧАНИЕ: Раздавленные тараканы не подойдут, если это не было очевидно. Попробуйте опрыскать их каким-нибудь средством от вредителей из ботаники!"
	threshold_desc = "он будет невероятно устойчивым к вирусам, взрывам и радиации."
	qualities = list(
		"устойчивость к нападениям сзади",
		"более здоровые органы",
		"способен пережить ядерный апокалипсис",
	)
	input_obj_or_mob = list(
		/mob/living/basic/cockroach,
	)
	output_organs = list(
		/obj/item/organ/internal/heart/roach,
		/obj/item/organ/internal/stomach/roach,
		/obj/item/organ/internal/liver/roach,
		/obj/item/organ/internal/appendix/roach,
	)
	infusion_desc = "kafkaesque" // Gregor Samsa !!
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/roach
