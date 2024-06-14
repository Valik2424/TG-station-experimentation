///base arrow
/obj/item/ammo_casing/arrow
	name = "стрела"
	desc = "Стрела летит!"
	icon = 'icons/obj/weapons/bows/arrows.dmi'
	icon_state = "arrow"
	base_icon_state = "arrow"
	inhand_icon_state = "arrow"
	projectile_type = /obj/projectile/bullet/arrow
	flags_1 = NONE
	throwforce = 1
	firing_effect_type = null
	caliber = CALIBER_ARROW
	///Whether the bullet type spawns another casing of the same type or not.
	var/reusable = TRUE

/obj/item/ammo_casing/arrow/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/envenomable_casing)
	AddElement(/datum/element/caseless, reusable)

/obj/item/ammo_casing/arrow/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

///base arrow projectile
/obj/projectile/bullet/arrow
	name = "стрела"
	desc = "Ай! Вытащи её из меня!"
	icon = 'icons/obj/weapons/bows/arrows.dmi'
	icon_state = "arrow_projectile"
	damage = 50
	speed = 1
	range = 25
	embedding = list(
		embed_chance = 90,
		fall_chance = 2,
		jostle_chance = 2,
		ignore_throwspeed_threshold = TRUE,
		pain_stam_pct = 0.5,
		pain_mult = 3,
		jostle_pain_mult = 3,
		rip_time = 1 SECONDS
	)
	shrapnel_type = /obj/item/ammo_casing/arrow

/// holy arrows
/obj/item/ammo_casing/arrow/holy
	name = "святая стрела"
	desc = "Святая стрела ищет своего грешника."
	icon_state = "holy_arrow"
	inhand_icon_state = "holy_arrow"
	base_icon_state = "holy_arrow"
	projectile_type = /obj/projectile/bullet/arrow/holy

/// holy arrow projectile
/obj/projectile/bullet/arrow/holy
	name = "святая стрела"
	desc = "Уже на подходе, культистское отродье!"
	icon_state = "holy_arrow_projectile"
	damage = 20 //still a lot but this is roundstart gear so far less
	shrapnel_type =/obj/item/ammo_casing/arrow/holy
	embedding = list(
		embed_chance = 50,
		fall_chance = 2,
		jostle_chance = 0,
		ignore_throwspeed_threshold = TRUE,
		pain_stam_pct = 0.5,
		pain_mult = 3,
		rip_time = 1 SECONDS
	)

/obj/projectile/bullet/arrow/holy/Initialize(mapload)
	. = ..()
	//50 damage to revenants
	AddElement(/datum/element/bane, target_type = /mob/living/basic/revenant, damage_multiplier = 0, added_damage = 30)

/// special pyre sect arrow
/// in the future, this needs a special sprite, but bows don't support non-hardcoded arrow sprites
/obj/item/ammo_casing/arrow/holy/blazing
	name = "благословлённая святая стрела"
	desc = "Святая стрела, благославлённая святым огнём, ищет своего грешного грешника. Поджигает цель при попадании, уничтожая стрелу. Но если попасть по уже горящей цели...?"
	projectile_type = /obj/projectile/bullet/arrow/blazing
	reusable = FALSE

/obj/projectile/bullet/arrow/blazing
	name = "благословлённая стрела"
	desc = "<b>НЕПРЕВЗОЙДЕННАЯ СИЛА СОЛНЦА</b>"
	icon_state = "holy_arrow_projectile"
	damage = 20
	embedding = null

/obj/projectile/bullet/arrow/blazing/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	if(!human_target.on_fire)
		to_chat(human_target, span_danger("[src] взрывается ярким пламенем обволакивающим меня!"))
		human_target.adjust_fire_stacks(2)
		human_target.ignite_mob()
		return
	to_chat(human_target, span_danger("[src] реагирует с огнём на мн-.."))
	explosion(src, light_impact_range = 1, flame_range = 2) //ow
