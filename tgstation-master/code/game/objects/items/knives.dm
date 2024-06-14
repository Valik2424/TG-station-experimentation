// Knife Template, should not appear in game normaly //
/obj/item/knife
	name = "нож"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "knife"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	inhand_icon_state = "knife"
	worn_icon_state = "knife"
	desc = "Оригинальный нож, говорят, что все остальные ножи - это только копии этого."
	flags_1 = CONDUCT_1
	force = 10
	demolition_mod = 0.75
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 6
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	armor_type = /datum/armor/item_knife
	var/bayonet = FALSE //Can this be attached to a gun?
	wound_bonus = 5
	bare_wound_bonus = 15
	tool_behaviour = TOOL_KNIFE

/datum/armor/item_knife
	fire = 50
	acid = 50

/obj/item/knife/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)
	set_butchering()

///Adds the butchering component, used to override stats for special cases
/obj/item/knife/proc/set_butchering()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS - force, \
	effectiveness = 100, \
	bonus_modifier = force - 10, \
	)
	//bonus chance increases depending on force

/obj/item/knife/suicide_act(mob/living/user)
	user.visible_message(pick(span_suicide("[user] is slitting [user.p_their()] wrists with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide."), \
		span_suicide("[user] is slitting [user.p_their()] throat with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide."), \
		span_suicide("[user] is slitting [user.p_their()] stomach open with the [src.name]! It looks like [user.p_theyre()] trying to commit seppuku.")))
	return BRUTELOSS

/obj/item/knife/ritual
	name = "ритуальный серп"
	desc = "Неземные энергии, которые когда-то питали этот клинок, теперь дремлют."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "bone_blade"
	inhand_icon_state = "bone_blade"
	worn_icon_state = "bone_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_flags = CRUEL_IMPLEMENT //maybe they want to use it in surgery
	force = 15
	throwforce = 15
	wound_bonus = 20
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/knife/bloodletter
	name = "кровопускатель"
	desc = "Кинжал оккультного вида, холодный на ощупь. Каким-то образом безупречный шар на навершии полностью сделан из жидкой крови."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "bloodletter"
	worn_icon_state = "render"
	w_class = WEIGHT_CLASS_NORMAL
	/// Bleed stacks applied when an organic mob target is hit
	var/bleed_stacks_per_hit = 3

/obj/item/knife/bloodletter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target) || !proximity_flag)
		return
	var/mob/living/M = target
	if(!(M.mob_biotypes & MOB_ORGANIC))
		return
	var/datum/status_effect/stacking/saw_bleed/bloodletting/B = M.has_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting)
	if(!B)
		M.apply_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting, bleed_stacks_per_hit)
	else
		B.add_stacks(bleed_stacks_per_hit)

/obj/item/knife/butcher
	name = "тесак мясника"
	desc = "Огромная штука, используемая для измельчения мяса. Включая клоунов и прочее ГМО."
	icon_state = "butch"
	inhand_icon_state = "butch"
	flags_1 = CONDUCT_1
	force = 15
	throwforce = 10
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)
	attack_verb_continuous = list("slices", "dices", "chops", "cubes", "minces", "juliennes", "chiffonades", "batonnets")
	attack_verb_simple = list("slice", "dice", "chop", "cube", "mince", "julienne", "chiffonade", "batonnet")
	w_class = WEIGHT_CLASS_NORMAL
	custom_price = PAYCHECK_CREW * 5
	wound_bonus = 15

/obj/item/knife/hunting
	name = "охотничий нож"
	desc = "Несмотря на свое название, он в основном используется для разделки мяса мертвой добычи, а не для настоящей охоты."
	icon = 'icons/obj/weapons/stabby.dmi'
	inhand_icon_state = "huntingknife"
	icon_state = "huntingknife"
	wound_bonus = 10

/obj/item/knife/hunting/set_butchering()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS - force, \
	effectiveness = 100, \
	bonus_modifier = force + 10, \
	)

/obj/item/knife/combat
	name = "боевой нож"
	desc = "Армейский нож для выживания."
	icon = 'icons/obj/weapons/stabby.dmi'
	icon_state = "buckknife"
	embedding = list("pain_mult" = 4, "embed_chance" = 65, "fall_chance" = 10, "ignore_throwspeed_threshold" = TRUE)
	force = 20
	throwforce = 20
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "cut")
	bayonet = TRUE

/obj/item/knife/combat/survival
	name = "нож выживальщика"
	desc = "Охотничий нож для выживания."
	icon = 'icons/obj/weapons/stabby.dmi'
	icon_state = "survivalknife"
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	force = 15
	throwforce = 15
	bayonet = TRUE

/obj/item/knife/combat/bone
	name = "костяной нож"
	desc = "Заостренная кость. Абсолютный минимум для выживания."
	inhand_icon_state = "bone_dagger"
	icon = 'icons/obj/weapons/stabby.dmi'
	icon_state = "bone_dagger"
	worn_icon_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	force = 15
	throwforce = 15
	custom_materials = null

/obj/item/knife/combat/bone/Initialize(mapload)
	flags_1 &= ~CONDUCT_1
	return ..()

/obj/item/knife/combat/cyborg
	name = "нож киборга"
	desc = "Пластиковый нож киборга. Чрезвычайно острый и прочный."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "knife_cyborg"

/obj/item/knife/shiv
	name = "стеклянная заточка"
	desc = "Твой единственный шанс на сохранение невинности если ты вдруг уронил мыло."
	icon = 'icons/obj/weapons/stabby.dmi'
	icon_state = "shiv"
	inhand_icon_state = "shiv"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 8
	throwforce = 12
	attack_verb_continuous = list("shanks", "shivs")
	attack_verb_simple = list("shank", "shiv")
	armor_type = /datum/armor/none
	custom_materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 4)

/obj/item/knife/shiv/Initialize(mapload)
	flags_1 &= ~CONDUCT_1
	return ..()

/obj/item/knife/shiv/plasma
	name = "плазменная заточка"
	icon_state = "plasmashiv"
	inhand_icon_state = "plasmashiv"
	force = 9
	throwforce = 13
	armor_type = /datum/armor/shiv_plasma
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT *4, /datum/material/plasma=SMALL_MATERIAL_AMOUNT * 2)

/datum/armor/shiv_plasma
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 50
	acid = 50

/obj/item/knife/shiv/titanium
	name = "титановая заточка"
	icon_state = "titaniumshiv"
	inhand_icon_state = "titaniumshiv"
	throwforce = 14
	throw_range = 7
	wound_bonus = 10
	armor_type = /datum/armor/shiv_titanium
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT * 4, /datum/material/titanium=SMALL_MATERIAL_AMOUNT * 2)

/datum/armor/shiv_titanium
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 50
	acid = 50

/obj/item/knife/shiv/plastitanium
	name = "пластитановая заточка"
	icon_state = "plastitaniumshiv"
	inhand_icon_state = "plastitaniumshiv"
	force = 10
	throwforce = 15
	throw_speed = 4
	throw_range = 8
	wound_bonus = 10
	bare_wound_bonus = 20
	armor_type = /datum/armor/shiv_plastitanium
	custom_materials = list(/datum/material/glass= SMALL_MATERIAL_AMOUNT * 4, /datum/material/alloy/plastitanium= SMALL_MATERIAL_AMOUNT * 2)

/datum/armor/shiv_plastitanium
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 50
	fire = 75
	acid = 75

/obj/item/knife/shiv/carrot
	name = "морковная заточка"
	desc = "Не вся морковь полезна для здоровья."
	icon_state = "carrotshiv"
	inhand_icon_state = "carrotshiv"
	custom_materials = null

/obj/item/knife/shiv/carrot/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] forcefully drives  [src] into [user.p_their()] eye! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS
