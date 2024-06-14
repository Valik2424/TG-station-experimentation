/obj/structure/closet/crate/secure
	desc = "Защищенный ящик."
	name = "надежный защищенный ящик"
	icon_state = "securecrate"
	base_icon_state = "securecrate"
	secure = TRUE
	locked = TRUE
	max_integrity = 500
	armor_type = /datum/armor/crate_secure
	damage_deflection = 25

	var/tamperproof = 0

/datum/armor/crate_secure
	melee = 30
	bullet = 50
	laser = 50
	energy = 100
	fire = 80
	acid = 80

/obj/structure/closet/crate/secure/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_MISSING_ITEM_ERROR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_MANIFEST_CONTENTS_ERROR, TRAIT_GENERIC)

/obj/structure/closet/crate/secure/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	if(prob(tamperproof) && damage_amount >= DAMAGE_PRECISION)
		boom()
	else
		return ..()

/obj/structure/closet/crate/secure/proc/boom(mob/user)
	if(user)
		to_chat(user, span_danger("Cистема защиты от несанкционированного доступа к ящику активированна!"))
		log_bomber(user, "has detonated a", src)
	dump_contents()
	explosion(src, heavy_impact_range = 1, light_impact_range = 5, flash_range = 5)
	qdel(src)

/obj/structure/closet/crate/secure/weapon
	desc = "Защищенный ящик для оружия."
	name = "ящик для оружия"
	icon_state = "weaponcrate"
	base_icon_state = "weaponcrate"

/obj/structure/closet/crate/secure/plasma
	desc = "Защищенный ящик с плазмой."
	name = "ящик с плазмой"
	icon_state = "plasmacrate"
	base_icon_state = "plasmacrate"

/obj/structure/closet/crate/secure/gear
	desc = "Защищенный ящик для снаряжения."
	name = "ящик с снаряжением"
	icon_state = "secgearcrate"
	base_icon_state = "secgearcrate"

/obj/structure/closet/crate/secure/hydroponics
	desc = "Ящик с замком, на нём нарисована эмблема ботаников станции"
	name = "защищенный ящик гидропоники"
	icon_state = "hydrosecurecrate"
	base_icon_state = "hydrosecurecrate"

/obj/structure/closet/crate/secure/freezer //for consistency with other "freezer" closets/crates
	desc = "Холодильник с замком, используемый для хранения еды."
	name = "защищенный кухонный ящик"
	icon_state = "kitchen_secure_crate"
	base_icon_state = "kitchen_secure_crate"
	paint_jobs = null

/obj/structure/closet/crate/secure/freezer/pizza
	name = "защищенный ящик с пиццей"
	desc = "Холодильник с замком, используемый для, очевидно, хранения пиццы."
	tamperproof = 10
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/crate/secure/freezer/pizza/PopulateContents()
	. = ..()
	new /obj/effect/spawner/random/food_or_drink/pizzaparty(src)

/obj/structure/closet/crate/secure/engineering
	desc = "Ящик с замком, на нём нарисована эмблема инженеров станции."
	name = "защищенный ящик инженеров"
	icon_state = "engi_secure_crate"
	base_icon_state = "engi_secure_crate"

/obj/structure/closet/crate/secure/science
	name = "защищенный ящик учёных"
	desc = "Ящик с замком, на нём нарисована эмблема учёных станции."
	icon_state = "scisecurecrate"
	base_icon_state = "scisecurecrate"

/obj/structure/closet/crate/secure/owned
	name = "личный ящик"
	desc = "Крышка ящика, которую может открывать только тот, кто купил содержимое ящика."
	icon_state = "privatecrate"
	base_icon_state = "privatecrate"
	///Account of the person buying the crate if private purchasing.
	var/datum/bank_account/buyer_account
	///Department of the person buying the crate if buying via the NIRN app.
	var/datum/bank_account/department/department_account
	///Is the secure crate opened or closed?
	var/privacy_lock = TRUE
	///Is the crate being bought by a person, or a budget card?
	var/department_purchase = FALSE

/obj/structure/closet/crate/secure/owned/examine(mob/user)
	. = ..()
	. += span_notice("Он закрыт на замок и может быть открыт только по ID покупателя.")

/obj/structure/closet/crate/secure/owned/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account
	if(IS_DEPARTMENTAL_ACCOUNT(buyer_account))
		department_purchase = TRUE
		department_account = buyer_account

/obj/structure/closet/crate/secure/owned/togglelock(mob/living/user, silent)
	if(!privacy_lock)
		return ..()

	if (broken && !silent)
		to_chat(user, span_warning("[capitalize(src.name)] сломан!"))
		return ..()

	var/obj/item/card/id/id_card = user.get_idcard(TRUE)
	if(!id_card)
		if(!silent)
			to_chat(user, span_notice("ID не обнаружен"))
		return ..()

	if(!id_card.registered_account)
		if(!silent)
			to_chat(user, span_notice("Связанных банковских счетов не обнаружено!"))
		return ..()

	if(id_card.registered_account == buyer_account || (department_purchase && (id_card.registered_account?.account_job?.paycheck_department) == (department_account.department_id)))
		if(iscarbon(user))
			add_fingerprint(user)
		locked = !locked
		user.visible_message(span_notice("[user] открывает замок [src].") ,
						span_notice("Открываю замок [src]."))
		privacy_lock = FALSE
		update_appearance()
	else if(!silent)
		to_chat(user, span_notice("Банковский счет не принадлежит покупателю! "))

