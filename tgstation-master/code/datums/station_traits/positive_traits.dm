#define PARTY_COOLDOWN_LENGTH_MIN (6 MINUTES)
#define PARTY_COOLDOWN_LENGTH_MAX (12 MINUTES)


/datum/station_trait/lucky_winner
	name = "Везунчик"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 1
	show_in_report = TRUE
	report_message = "Ваша станция выиграла главный приз ежегодного благотворительного мероприятия. Бесплатные закуски будут доставляться в бар время от времени."
	trait_processes = TRUE
	COOLDOWN_DECLARE(party_cooldown)

/datum/station_trait/lucky_winner/on_round_start()
	. = ..()
	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

/datum/station_trait/lucky_winner/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, party_cooldown))
		return

	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

	var/area/area_to_spawn_in = pick(GLOB.bar_areas)
	var/turf/T = pick(area_to_spawn_in.contents)

	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()
	var/obj/item/pizzabox/pizza_to_spawn = pick(list(/obj/item/pizzabox/margherita, /obj/item/pizzabox/mushroom, /obj/item/pizzabox/meat, /obj/item/pizzabox/vegetable, /obj/item/pizzabox/pineapple))
	new pizza_to_spawn(toLaunch)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/glass/bottle/beer(toLaunch)
	new /obj/effect/pod_landingzone(T, toLaunch)

/datum/station_trait/galactic_grant
	name = "Галактический грант"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Ваша станция была выбрана для получения специального гранта. Вашему грузовому отделу были предоставлены дополнительные средства."

/datum/station_trait/galactic_grant/on_round_start()
	var/datum/bank_account/cargo_bank = SSeconomy.get_dep_account(ACCOUNT_CAR)
	cargo_bank.adjust_money(rand(2000, 5000))

/datum/station_trait/bountiful_bounties
	name = "Щедрые щедрости"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Похоже, что коллекционеры в этой системе особенно заинтересованы в вознаграждениях и будут платить больше, чтобы увидеть их выполнение."

/datum/station_trait/bountiful_bounties/on_round_start()
	SSeconomy.bounty_modifier *= 1.2

/datum/station_trait/strong_supply_lines
	name = "Сильные линии снабжения"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "В этой системе низкие цены, ПОКУПАТЬ ПОКУПАТЬ ПОКУПАТЬ!"
	blacklist = list(/datum/station_trait/distant_supply_lines)


/datum/station_trait/strong_supply_lines/on_round_start()
	SSeconomy.pack_price_modifier *= 0.8

/datum/station_trait/scarves
	name = "Шарфы"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	var/list/scarves

/datum/station_trait/scarves/New()
	. = ..()
	report_message = pick(
		"Nanotrasen экспериментирует с тем, чтобы увидеть, улучшает ли тепло шеи моральный дух сотрудников.",
		"После Недели космической моды шарфы - новый модный аксессуар.",
		"Всем одновременно было немного холодно, когда они собирались на вокзал.",
		"Станцию определенно не атакуют инопланетяне, маскирующиеся под шерсть. Точно нет.",
		"Вы все получаете бесплатные шарфы. Не спрашивайте почему.",
		"На станцию доставили партию шарфов.",
	)
	scarves = typesof(/obj/item/clothing/neck/scarf) + list(
		/obj/item/clothing/neck/large_scarf/red,
		/obj/item/clothing/neck/large_scarf/green,
		/obj/item/clothing/neck/large_scarf/blue,
	)

	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))


/datum/station_trait/scarves/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	var/scarf_type = pick(scarves)

	spawned.equip_to_slot_or_del(new scarf_type(spawned), ITEM_SLOT_NECK, initial = FALSE)

/datum/station_trait/quick_shuttle
	name = "Быстрый шаттл"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Благодаря близости к нашей станции снабжения грузовой шаттл будет быстрее добираться до грузового отдела."
	blacklist = list(/datum/station_trait/slow_shuttle)

/datum/station_trait/quick_shuttle/on_round_start()
	. = ..()
	SSshuttle.supply.callTime *= 0.5

/datum/station_trait/deathrattle_all
	name = "Предсмертная станция"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	weight = 1
	report_message = "Все члены станции получили имплант, чтобы уведомить друг-друга, если один из них умирает. Это должно помочь повысить безопасность труда!"
	var/datum/deathrattle_group/deathrattle_group


/datum/station_trait/deathrattle_all/New()
	. = ..()
	deathrattle_group = new("station group")
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))


/datum/station_trait/deathrattle_all/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	var/obj/item/implant/deathrattle/implant_to_give = new()
	deathrattle_group.register(implant_to_give)
	implant_to_give.implant(spawned, spawned, TRUE, TRUE)


/datum/station_trait/wallets
	name = "Кошельки!"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	weight = 10
	report_message = "Кошельки снова в моде! Поэтому каждый на станции получил по одному."

/datum/station_trait/wallets/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))

/datum/station_trait/wallets/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/living_mob, mob/M, joined_late)
	SIGNAL_HANDLER

	var/obj/item/card/id/advanced/id_card = living_mob.get_item_by_slot(ITEM_SLOT_ID)
	if(!istype(id_card))
		return

	living_mob.temporarilyRemoveItemFromInventory(id_card, force=TRUE)

	// "Doc, what's wrong with me?"
	var/obj/item/storage/wallet/wallet = new(src)
	// "You've got a wallet embedded in your chest."
	wallet.add_fingerprint(living_mob, ignoregloves = TRUE)

	living_mob.equip_to_slot_if_possible(wallet, ITEM_SLOT_ID, initial=TRUE)

	id_card.forceMove(wallet)

	var/holochip_amount = id_card.registered_account.account_balance
	new /obj/item/holochip(wallet, holochip_amount)
	id_card.registered_account.adjust_money(-holochip_amount, "System: Withdrawal")

	new /obj/effect/spawner/random/entertainment/wallet_storage(wallet)

	// Put our filthy fingerprints all over the contents
	for(var/obj/item/item in wallet)
		item.add_fingerprint(living_mob, ignoregloves = TRUE)

/datum/station_trait/cybernetic_revolution
	name = "Cybernetic Revolution"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	weight = 1
	report_message = "The new trends in cybernetics have come to the station! Everyone has some form of cybernetic implant."
	trait_to_give = STATION_TRAIT_CYBERNETIC_REVOLUTION
	/// List of all job types with the cybernetics they should receive.
	var/static/list/job_to_cybernetic = list(
		/datum/job/assistant = /obj/item/organ/internal/heart/cybernetic, //real cardiac
		/datum/job/atmospheric_technician = /obj/item/organ/internal/cyberimp/mouth/breathing_tube,
		/datum/job/bartender = /obj/item/organ/internal/liver/cybernetic/tier3,
		/datum/job/bitrunner = /obj/item/organ/internal/eyes/robotic/thermals,
		/datum/job/botanist = /obj/item/organ/internal/cyberimp/chest/nutriment,
		/datum/job/captain = /obj/item/organ/internal/heart/cybernetic/tier3,
		/datum/job/cargo_technician = /obj/item/organ/internal/stomach/cybernetic/tier2,
		/datum/job/chaplain = /obj/item/organ/internal/cyberimp/brain/anti_drop,
		/datum/job/chemist = /obj/item/organ/internal/liver/cybernetic/tier2,
		/datum/job/chief_engineer = /obj/item/organ/internal/cyberimp/chest/thrusters,
		/datum/job/chief_medical_officer = /obj/item/organ/internal/cyberimp/chest/reviver,
		/datum/job/clown = /obj/item/organ/internal/cyberimp/brain/anti_stun, //HONK!
		/datum/job/cook = /obj/item/organ/internal/cyberimp/chest/nutriment/plus,
		/datum/job/coroner = /obj/item/organ/internal/tongue/bone, //hes got a bone to pick with you
		/datum/job/curator = /obj/item/organ/internal/eyes/robotic/glow,
		/datum/job/detective = /obj/item/organ/internal/lungs/cybernetic/tier3,
		/datum/job/doctor = /obj/item/organ/internal/cyberimp/arm/surgery,
		/datum/job/geneticist = /obj/item/organ/internal/fly, //we don't care about implants, we have cancer.
		/datum/job/head_of_personnel = /obj/item/organ/internal/eyes/robotic,
		/datum/job/head_of_security = /obj/item/organ/internal/eyes/robotic/thermals,
		/datum/job/janitor = /obj/item/organ/internal/eyes/robotic/xray,
		/datum/job/lawyer = /obj/item/organ/internal/heart/cybernetic/tier2,
		/datum/job/mime = /obj/item/organ/internal/tongue/robot, //...
		/datum/job/paramedic = /obj/item/organ/internal/cyberimp/eyes/hud/medical,
		/datum/job/prisoner = /obj/item/organ/internal/eyes/robotic/shield,
		/datum/job/psychologist = /obj/item/organ/internal/ears/cybernetic/upgraded,
		/datum/job/quartermaster = /obj/item/organ/internal/stomach/cybernetic/tier3,
		/datum/job/research_director = /obj/item/organ/internal/cyberimp/bci,
		/datum/job/roboticist = /obj/item/organ/internal/cyberimp/eyes/hud/diagnostic,
		/datum/job/scientist = /obj/item/organ/internal/ears/cybernetic,
		/datum/job/security_officer = /obj/item/organ/internal/cyberimp/arm/flash,
		/datum/job/shaft_miner = /obj/item/organ/internal/monster_core/rush_gland,
		/datum/job/station_engineer = /obj/item/organ/internal/cyberimp/arm/toolset,
		/datum/job/virologist = /obj/item/organ/internal/lungs/cybernetic/tier2,
		/datum/job/warden = /obj/item/organ/internal/cyberimp/eyes/hud/security,
	)

/datum/station_trait/cybernetic_revolution/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))

/datum/station_trait/cybernetic_revolution/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	var/cybernetic_type = job_to_cybernetic[job.type]
	if(!cybernetic_type)
		if(isAI(spawned))
			var/mob/living/silicon/ai/ai = spawned
			ai.eyeobj.relay_speech = TRUE //surveillance upgrade. the ai gets cybernetics too.
		return
	var/obj/item/organ/internal/cybernetic = new cybernetic_type()
	cybernetic.Insert(spawned, special = TRUE, drop_if_replaced = FALSE)

/datum/station_trait/luxury_escape_pods
	name = "Luxury Escape Pods"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Due to good performance, we've provided your station with luxury escape pods."
	trait_to_give = STATION_TRAIT_BIGGER_PODS
	blacklist = list(/datum/station_trait/cramped_escape_pods)

/datum/station_trait/medbot_mania
	name = "Advanced Medbots"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Your station's medibots have recieved a hardware upgrade, enabling expanded healing capabilities."
	trait_to_give = STATION_TRAIT_MEDBOT_MANIA

/datum/station_trait/random_event_weight_modifier/shuttle_loans
	name = "Loaner Shuttle"
	report_message = "Due to an uptick in pirate attacks around your sector, there are few supply vessels in nearby space willing to assist with special requests. Expect to recieve more shuttle loan opportunities, with slightly higher payouts."
	trait_type = STATION_TRAIT_POSITIVE
	weight = 4
	event_control_path = /datum/round_event_control/shuttle_loan
	weight_multiplier = 2.5
	max_occurrences_modifier = 5 //All but one loan event will occur over the course of a round.
	trait_to_give = STATION_TRAIT_LOANER_SHUTTLE

/datum/station_trait/random_event_weight_modifier/wise_cows
	name = "Wise Cow Invasion"
	report_message = "Bluespace harmonic readings show unusual interpolative signals between your sector and agricultural sector MMF-D-02. Expect an increase in cow encounters. Encownters, if you will."
	trait_type = STATION_TRAIT_POSITIVE
	weight = 1
	event_control_path = /datum/round_event_control/wisdomcow
	weight_multiplier = 3
	max_occurrences_modifier = 10 //lotta cows

/datum/station_trait/shuttle_sale
	name = "Shuttle Firesale"
	report_message = "The Nanotrasen Emergency Dispatch team is celebrating a record number of shuttle calls in the recent quarter. Some of your emergency shuttle options have been discounted!"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 4
	trait_to_give = STATION_TRAIT_SHUTTLE_SALE
	show_in_report = TRUE

/datum/station_trait/missing_wallet
	name = "Misplaced Wallet"
	report_message = "A repair technician left their wallet in a locker somewhere. They would greatly appreciate if you could locate and return it to them when the shift has ended."
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE

/datum/station_trait/missing_wallet/on_round_start()
	. = ..()

	var/obj/structure/closet/locker_to_fill = pick(GLOB.roundstart_station_closets)

	var/obj/item/storage/wallet/new_wallet = new(locker_to_fill)

	new /obj/item/stack/spacecash/c500(new_wallet)
	if(prob(25)) //Jackpot!
		new /obj/item/stack/spacecash/c1000(new_wallet)

	new /obj/item/card/id/advanced/technician_id(new_wallet)
	new_wallet.refreshID()

	if(prob(35))
		report_message += " The technician reports they last remember having their wallet around [get_area_name(new_wallet)]."

	message_admins("A missing wallet has been placed in the [locker_to_fill] locker, in the [get_area_name(locker_to_fill)] area.")

/obj/item/card/id/advanced/technician_id
	name = "Repair Technician ID"
	desc = "Repair Technician? We don't have those in this sector, just a bunch of lazy engineers! This must have been from the between-shift crew..."
	registered_name = "Pluoxium LXVII"
	registered_age = 67
	trim = /datum/id_trim/technician_id

/datum/id_trim/technician_id
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS)
	assignment = "Repair Technician"
	trim_state = "trim_stationengineer"
	department_color = COLOR_ASSISTANT_GRAY

#undef PARTY_COOLDOWN_LENGTH_MIN
#undef PARTY_COOLDOWN_LENGTH_MAX
