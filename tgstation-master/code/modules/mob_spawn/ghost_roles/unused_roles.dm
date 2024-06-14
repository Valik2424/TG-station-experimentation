
//i couldn't find any map that uses these, so they're delegated to admin events for now.

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport
	name = "prisoner containment sleeper"
	desc = "A sleeper designed to put its occupant into a deep coma, unbreakable until the sleeper turns off. This one's glass is cracked and you can see a pale, sleeping face staring out."
	prompt_name = "an escaped prisoner"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/lavalandprisoner
	you_are_text = "You're a prisoner, sentenced to hard work in one of Nanotrasen's labor camps, but it seems as \
	though fate has other plans for you."
	flavour_text = "Good. It seems as though your ship crashed. You remember that you were convicted of "
	spawner_job_path = /datum/job/escaped_prisoner

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/Initialize(mapload)
	. = ..()
	var/list/crimes = list("murder", "larceny", "embezzlement", "unionization", "dereliction of duty", "kidnapping", "gross incompetence", "grand theft", "collaboration with the Syndicate", \
	"worship of a forbidden deity", "interspecies relations", "mutiny")
	flavour_text += "[pick(crimes)]. but regardless of that, it seems like your crime doesn't matter now. You don't know where you are, but you know that it's out to kill you, and you're not going \
	to lose this opportunity. Find a way to get out of this mess and back to where you rightfully belong - your [pick("house", "apartment", "spaceship", "station")]."

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/Destroy()
	new /obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.fully_replace_character_name(null, "NTP #LL-0[rand(111,999)]") //Nanotrasen Prisoner #Lavaland-(numbers)

/datum/outfit/lavalandprisoner
	name = "Lavaland Prisoner"
	uniform = /obj/item/clothing/under/rank/prisoner
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/orange
	r_pocket = /obj/item/tank/internals/emergency_oxygen


//spawners for the space hotel, which isn't currently in the code but heyoo secret away missions or something

//Space Hotel Staff
/obj/effect/mob_spawn/ghost_role/human/hotel_staff //not free antag u little shits
	name = "staff sleeper"
	desc = "A sleeper designed for long-term stasis between guest visits."
	prompt_name = "a hotel staff member"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/hotelstaff
	you_are_text = "You are a staff member of a top-of-the-line space hotel!"
	flavour_text = "Cater to visiting guests with your fellow staff, advertise the hotel, and make sure the manager doesn't fire you. Remember, the customer is always right!"
	important_text = "Do NOT leave the hotel, as that is grounds for contract termination."
	spawner_job_path = /datum/job/hotel_staff

/datum/outfit/hotelstaff
	name = "Hotel Staff"
	uniform = /obj/item/clothing/under/misc/assistantformal
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off

	implants = list(
		/obj/item/implant/exile/noteleport,
		/obj/item/implant/mindshield,
	)

/obj/effect/mob_spawn/ghost_role/human/hotel_staff/security
	name = "hotel security sleeper"
	prompt_name = "a hotel security member"
	outfit = /datum/outfit/hotelstaff/security
	you_are_text = "You are a peacekeeper."
	flavour_text = "You have been assigned to this hotel to protect the interests of the company while keeping the peace between \
		guests and the staff."
	important_text = "Do NOT leave the hotel, as that is grounds for contract termination."

/datum/outfit/hotelstaff/security
	name = "Hotel Security"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	back = /obj/item/storage/backpack/security
	belt = /obj/item/storage/belt/security/full
	head = /obj/item/clothing/head/helmet/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots

/obj/effect/mob_spawn/ghost_role/human/hotel_staff/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/syndicate
	name = "Syndicate Operative"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "a syndicate operative"
	you_are_text = "You are a syndicate operative."
	flavour_text = "You have awoken, without instruction. Death to Nanotrasen! If there are some clues around as to what you're supposed to be doing, you best follow those."
	outfit = /datum/outfit/syndicate_empty
	spawner_job_path = /datum/job/space_syndicate

/datum/outfit/syndicate_empty
	name = "Syndicate Operative Empty"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate
	back = /obj/item/storage/backpack
	ears = /obj/item/radio/headset/syndicate/alt
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	shoes = /obj/item/clothing/shoes/combat

	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicate_empty/post_equip(mob/living/carbon/human/H)
	H.faction |= ROLE_SYNDICATE

//For ghost bar.
/obj/effect/mob_spawn/ghost_role/human/space_bar_patron
	name = "криокапсульный бар"
	uses = INFINITY
	prompt_name = "Хранитель космобара"
	you_are_text = "Вы Хранитель!"
	flavour_text = "Присматривай за баром и болтай со своими приятелями. Не стесняйся запрыгнуть назад в криокапсулу, когда наболтаешься со своими друзьями."
	outfit = /datum/outfit/cryobartender
	spawner_job_path = /datum/job/space_bar_patron

/obj/effect/mob_spawn/ghost_role/human/space_bar_patron/attack_hand(mob/user, list/modifiers)
	var/despawn = tgui_alert(usr, "Вернуться в криокапсулу? (Внимание, ваш персонаж будет удалён!)", null, list("Да", "Нет"))
	if(despawn == "No" || !loc || !Adjacent(user))
		return
	user.visible_message(span_notice("[user.name] забираюсь назад в криокапсулу..."))
	qdel(user)

/datum/outfit/cryobartender
	name = "Бармен из криокапсулы"
	neck = /obj/item/clothing/neck/bowtie
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/service
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	shoes = /obj/item/clothing/shoes/sneakers/black

//Timeless prisons: Spawns in Wish Granter prisons in lavaland. Ghosts become age-old users of the Wish Granter and are advised to seek repentance for their past.
/obj/effect/mob_spawn/ghost_role/human/exile
	name = "вечное заключение"
	desc = "Хотя этот стазис выглядит медицинским, похоже что он был создан для заключения кого-то в течение долгого времени...."
	prompt_name = "раскаивающийся изгнанник"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/shadow
	you_are_text = "Ты проклят."
	flavour_text = "Годы назад ты пожертвовал жизнью своих преданных друзей и своей человечностью чтобы достигнуть Исполнителя Желаний. Это имело последствия: \
	твоё тело отвергает любой свет, обрекая тебя бесконечно скитаться в этой ужасной пустоши..."
	spawner_job_path = /datum/job/exile

/obj/effect/mob_spawn/ghost_role/human/exile/Destroy()
	new/obj/structure/fluff/empty_sleeper(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/exile/special(mob/living/new_spawn)
	. = ..()
	new_spawn.fully_replace_character_name(null,"Жертва Исполнителя Желаний ([rand(1,999)])")
	var/wish = rand(1,4)
	var/message = ""
	switch(wish)
		if(1)
			message = "<b>Я хотел убить, и я это сделал. Уже давно потерял счет количеству убийств и та искра возбуждения, которая когда-то возникала в процессе убийства давно погасла. Я испытываю одно лишь сожаление.</b>"
		if(2)
			message = "<b>Я желал нескончаемого богатства, но никакие деньги не стоили такого существования. Может быть, благотворительность сможет искупить грехи?</b>"
		if(3)
			message = "<b>Всё, чего когда-либо я желал - власть. Стоила ли власть изгнания из мира? Я [gender == MALE ? "князь" : "княгиня"] тьмы, [gender == MALE ? "князь" : "княгиня"] тишины, и чувствую только раскаяние  .</b>"
		if(4)
			message = "<b>Я желал бессмертия, когда мои друзья умирали ради моих целей. Вне зависимости от того, сколько раз я брошусь в лаву, через несколько дней всё равно проснусь в этой комнате. Спасения нет.</b>"
	to_chat(new_spawn, "<span class='infoplain'>[message]</span>")

/obj/effect/mob_spawn/ghost_role/human/nanotrasensoldier
	name = "Криокапсула"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list(FACTION_NANOTRASEN_PRIVATE)
	prompt_name = "офицер службы безопасности"
	you_are_text = "Вы офицер службы безопасности Нанотрейзен!"
	flavour_text = "Если у высшего командования есть для меня задание, лучше всего ему следовать. Если нет - смерть Синдикату!"
	outfit = /datum/outfit/nanotrasensoldier

/obj/effect/mob_spawn/ghost_role/human/commander
	name = "Криокапсула"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "командующий нанотрейзен"
	you_are_text = "Вы командующий Нанотрейзен!"
	flavour_text = "Верхушка цепи командования Нанотрейзен. Меня следует уважать как можно сильнее!"
	outfit = /datum/outfit/nanotrasencommander

//space doctor, a rat with cancer, and bessie from an old removed lavaland ruin.

/obj/effect/mob_spawn/ghost_role/human/doctor
	name = "sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "космический Айболит"
	you_are_text = "Ты - космический Айболит!"
	flavour_text = "Моя работа - хотя скорее призвание - заботиться и лечить всех, кто в нужде."
	outfit = /datum/outfit/job/doctor
	spawner_job_path = /datum/job/space_doctor

/obj/effect/mob_spawn/ghost_role/human/doctor/alive/equip(mob/living/carbon/human/doctor)
	. = ..()
	// Remove radio and PDA so they wouldn't annoy station crew.
	var/list/del_types = list(/obj/item/modular_computer/pda, /obj/item/radio/headset)
	for(var/del_type in del_types)
		var/obj/item/unwanted_item = locate(del_type) in doctor
		qdel(unwanted_item)

/obj/effect/mob_spawn/ghost_role/mouse
	name = "sleeper"
	mob_type = /mob/living/basic/mouse
	prompt_name = "мыш"
	you_are_text = "Я - мыш!"
	flavour_text = "Ммм...! Пи-пи, пидрила!"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/ghost_role/cow
	name = "sleeper"
	mob_name = "Бурёнка"
	mob_type = /mob/living/basic/cow
	prompt_name = "коровка"
	you_are_text = "Я коровка!"
	flavour_text = "Пожуй немного травы!"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/cow/special(mob/living/spawned_mob)
	. = ..()
	gender = FEMALE

// snow operatives on snowdin - unfortunately seemingly removed in a map remake womp womp

/obj/effect/mob_spawn/ghost_role/human/snow_operative
	name = "Криокапсула"
	prompt_name = "Оперативник во льдах"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list(ROLE_SYNDICATE)
	outfit = /datum/outfit/snowsyndie
	you_are_text = "Вы — оперативник синдиката, недавно очнувшийся от криостаза на подземной заставе."
	flavour_text = "Контролируйте связь Nanotrasen и записывайте информацию. Любые посторонние лица на заставе должны быть уничтожены, \
	чтобы гарантировать, что собранная информация не будет украдена или потеряна. Старайтесь не отходить слишком далеко от аванпоста, во избежания \
	неоправданной гибели таких ценных кадров, как Вы."

/datum/outfit/snowsyndie
	name = "Syndicate Snow Operative"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate/coldres
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/combat/coldres
	r_pocket = /obj/item/gun/ballistic/automatic/pistol

	implants = list(/obj/item/implant/exile)

//Forgotten syndicate ship

/obj/effect/mob_spawn/ghost_role/human/syndicatespace
	name = "Член экипажа Cybersun Industries"
	show_flavor = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "cybersun crew"
	you_are_text = "Вы оперативник синдиката на старом корабле, застрявшем во враждебном секторе космоса."
	flavour_text = "Ваш корабль наконец-то прекратил прекратил дрейфовать по космосу, остановившись где-то посреди космической бездны. \
	Понимая, что рядом находится вражеская станция Нанотрейзен, вы должны починить корабль, найти способ восстановить подачу энергии, следовать приказам капитана и НЕ ПОКИДАТЬ корабль, оставляя его на произвол судьбы."
	important_text = "Подчиняйтесь приказам Вашего капитана. НЕ ДАЙТЕ кораблю попасть в чужие руки, НЕ ПОКИДАЙТЕ корабль, превратите его в защищённую крепость для отражения возможных нападений."
	outfit = /datum/outfit/syndicatespace/syndicrew
	spawner_job_path = /datum/job/syndicate_cybersun

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/special(mob/living/new_spawn)
	. = ..()
	new_spawn.grant_language(/datum/language/codespeak, source = LANGUAGE_MIND)
	var/datum/job/spawn_job = SSjob.GetJobType(spawner_job_path)
	var/policy = get_policy(spawn_job.policy_index)
	if(policy)
		to_chat(new_spawn, span_bold("[policy]"))

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/captain
	name = "Капитан корабля Cybersun Industries"
	prompt_name = "a cybersun captain"
	you_are_text = "Вы капитан старого корабля, застрявшего во враждебном секторе космоса."
	flavour_text = "Ваш корабль наконец-то прекратил  прекратил дрейфовать по космосу, остановившись где-то посреди космической бездны. \
	Понимая, что рядом находится вражеская станция Нанотрейзен, вы должны починить корабль, найти способ восстановить подачу энергии, НЕ ПОКИДАТЬ корабль, оставляя его на произвол судьбы."
	important_text = "Защитите корабль и секретные документы в своём рюкзаке любой ценой, даже ценой своей жизни! ЗАПРЕЩЕНО покидать корабль во избежание риска захвата его сотрудниками вражеской корпорации."
	outfit = /datum/outfit/syndicatespace/syndicaptain
	spawner_job_path = /datum/job/syndicate_cybersun_captain

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/captain/Destroy()
	new /obj/structure/fluff/empty_sleeper/syndicate/captain(get_turf(src))
	return ..()

/datum/outfit/syndicatespace
	name = "Syndicate Ship Base"
	id = /obj/item/card/id/advanced/black/syndicate_command/crew_id
	uniform = /obj/item/clothing/under/syndicate/combat
	back = /obj/item/storage/backpack
	belt = /obj/item/storage/belt/military/assault
	ears = /obj/item/radio/headset/syndicate/alt
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat

	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatespace/post_equip(mob/living/carbon/human/syndie_scum)
	syndie_scum.faction |= ROLE_SYNDICATE

/datum/outfit/syndicatespace/syndicrew
	name = "Syndicate Ship Crew Member"
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_pocket = /obj/item/knife/combat/survival

/datum/outfit/syndicatespace/syndicaptain
	name = "Syndicate Ship Captain"
	id = /obj/item/card/id/advanced/black/syndicate_command/captain_id
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	ears = /obj/item/radio/headset/syndicate/alt/leader
	head = /obj/item/clothing/head/hats/hos/beret/syndicate
	r_pocket = /obj/item/knife/combat/survival
	backpack_contents = list(
		/obj/item/documents/syndicate/red,
		/obj/item/gun/ballistic/automatic/pistol/aps,
		/obj/item/paper/fluff/ruins/forgottenship/password,
	)
