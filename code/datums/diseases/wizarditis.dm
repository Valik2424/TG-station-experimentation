/datum/disease/wizarditis
	name = "Визардитис"
	max_stages = 4
	spread_text = "Воздушное"
	cure_text = "Мэнли Дорф"
	cures = list(/datum/reagent/consumable/ethanol/manly_dorf)
	cure_chance = 100
	agent = "Ринсвиндус Вульгарис"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 0.75
	desc = "Некоторые предполагают, что этот вирус является причиной существования Федерации космических волшебников. Пострадавшие субъекты проявляют признаки повреждения мозга, выкрикивают непонятные предложения или полную тарабарщину. На поздних стадиях субъекты иногда выражают чувство внутренней силы и, цитируют, «способность управлять самими силами космоса!» Глоток сильных, мужественных духов обычно возвращает их в нормальное, человеческое состояние."
	severity = DISEASE_SEVERITY_HARMFUL

	/// List of random non-targeted spells to pick from to cast
	var/list/datum/action/cooldown/spell/random_spells = list()
	/// List of random targeted spells to pick from to cast
	var/list/datum/action/cooldown/spell/random_targeted_spells = list()

	/// The hat type to give the infected
	var/hat_type
	/// The robe type to give the infected
	var/robe_type

/datum/disease/wizarditis/after_add()
	switch(pick("blue", "red", "yellow"))
		if("blue")
			hat_type = /obj/item/clothing/head/wizard
			robe_type = /obj/item/clothing/suit/wizrobe
		if("red")
			hat_type = /obj/item/clothing/head/wizard/red
			robe_type = /obj/item/clothing/suit/wizrobe/red
		if("yellow")
			hat_type = /obj/item/clothing/head/wizard/yellow
			robe_type = /obj/item/clothing/suit/wizrobe/yellow

	init_spells()

/datum/disease/wizarditis/Destroy()
	QDEL_LIST(random_spells)
	QDEL_LIST(random_targeted_spells)
	return ..()

/datum/disease/wizarditis/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	if(affected_mob.can_block_magic(charge_cost = 0))
		update_stage(1)
		return

	if(stage >= 3 && SPT_PROB(0.15 * stage, seconds_per_tick))
		var/datum/action/cooldown/spell/picked = pick(random_spells)
		if(!picked.try_invoke(affected_mob, feedback = FALSE))
			to_chat(affected_mob, span_danger("Ты чувствуешь, как что-то накапливается внутри... но это чувство проходит."))
			return

		picked.spell_feedback(affected_mob)
		return

	if(stage <= 3 && SPT_PROB(0.33 * stage, seconds_per_tick))
		affected_mob.manual_emote("sniffles.")

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.say(pick("Ты не пройдёшь!", "Экспеллиармус!", "Бородой Мерлина!", "Почувствуй мощь Темной стороны!"), forced = "wizarditis")
		if(3)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Ощущаю [pick("кипящую магию в моих венах", "эта местность даёт мне +1 к INT", "надобность кого-то призвать")]."))
				spawn_wizard_clothes(10)

		if(4)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("Ощущаю [pick("приливную волну новой силы внутри меня", "эта местность даёт мне +2 к INT и +1 к WIS", "надобность телепортироваться")]."))
				spawn_wizard_clothes(50)

			if(SPT_PROB(0.2, seconds_per_tick))
				if(prob(15))
					var/list/targets = list()
					var/datum/action/cooldown/spell/target_picked = pick(random_targeted_spells)
					for(var/mob/living/potential_target in view(affected_mob))
						if(potential_target == affected_mob)
							continue
						targets += potential_target

					if(length(targets))
						target_picked.Activate(pick(targets))
						affected_mob.emote("cough")
						return

				var/datum/action/cooldown/spell/picked = pick(random_spells)
				picked.Activate(affected_mob)
				affected_mob.emote("sneeze")
				return

/datum/disease/wizarditis/proc/spawn_wizard_clothes(chance = 0)
	if(prob(chance) && affected_mob.usable_hands >= 1)
		var/obj/item/staff/funny_staff = new(affected_mob)
		if(!affected_mob.put_in_hands(funny_staff))
			qdel(funny_staff)

	if(!ishuman(affected_mob))
		return


	var/mob/living/carbon/human/human_mob = affected_mob
	if(prob(chance) && !(human_mob.head?.item_flags & CASTING_CLOTHES))
		if(human_mob.dropItemToGround(human_mob.head))
			human_mob.equip_to_slot_or_del(new hat_type(human_mob), ITEM_SLOT_HEAD)

	if(prob(chance) && !(human_mob.wear_suit?.item_flags & CASTING_CLOTHES))
		if(human_mob.dropItemToGround(human_mob.wear_suit))
			human_mob.equip_to_slot_or_del(new robe_type(human_mob), ITEM_SLOT_OCLOTHING)

	if(prob(chance) && !istype(human_mob.shoes, /obj/item/clothing/shoes/sandal/magic))
		if(human_mob.dropItemToGround(human_mob.shoes))
			human_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal/magic(human_mob), ITEM_SLOT_FEET)

/datum/disease/wizarditis/proc/init_spells()
	// Some self cast spells
	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/sneeze_teleport = new(src)
	sneeze_teleport.randomise_selection = TRUE
	random_spells += sneeze_teleport

	var/datum/action/cooldown/spell/emp/disable_tech/sneeze_emp = new(src)
	sneeze_emp.emp_heavy = 1
	sneeze_emp.emp_light = 2
	random_spells += sneeze_emp

	var/datum/action/cooldown/spell/apply_mutations/mutate/sneeze_mutate = new(src)
	sneeze_mutate.mutation_duration = 3 SECONDS
	random_spells += sneeze_mutate

	var/datum/action/cooldown/spell/aoe/knock/sneeze_knock = new(src)
	random_spells += sneeze_knock

	var/datum/action/cooldown/spell/forcewall/sneeze_forcewall = new(src)
	random_spells += sneeze_forcewall

	var/datum/action/cooldown/spell/teleport/radius_turf/blink/sneeze_blink = new(src)
	sneeze_blink.inner_tele_radius = 1
	sneeze_blink.outer_tele_radius = 3
	random_spells += sneeze_blink

	var/datum/action/cooldown/spell/smoke/sneeze_smoke = new(src)
	sneeze_smoke.smoke_amt = 2
	random_spells += sneeze_smoke

	var/datum/action/cooldown/spell/spacetime_dist/sneeze_spacetime = new(src)
	sneeze_spacetime.scramble_radius = 2
	sneeze_spacetime.duration = 5 SECONDS
	random_spells += sneeze_spacetime

	var/datum/action/cooldown/spell/timestop/sneeze_timestop = new(src)
	sneeze_timestop.timestop_range = 1 // heh
	sneeze_timestop.timestop_duration = 5 SECONDS
	random_spells += sneeze_timestop

	var/datum/action/cooldown/spell/aoe/repulse/sneeze_repulse = new(src)
	sneeze_repulse.aoe_radius = 2
	sneeze_repulse.max_throw = 3
	random_spells += sneeze_repulse

	// Some targeted spells
	var/datum/action/cooldown/spell/pointed/blind/cough_blind = new(src)
	cough_blind.eye_blind_duration = 2 SECONDS
	cough_blind.eye_blur_duration = 10 SECONDS
	random_targeted_spells += cough_blind

	var/datum/action/cooldown/spell/pointed/projectile/lightningbolt/cough_zap = new(src)
	cough_zap.bolt_range /= 3
	cough_zap.bolt_power /= 3
	random_targeted_spells += cough_zap

	var/datum/action/cooldown/spell/pointed/swap/cough_swap = new(src)
	random_targeted_spells += cough_swap
