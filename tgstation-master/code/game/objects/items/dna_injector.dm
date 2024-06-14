/obj/item/dnainjector
	name = "инъектор ДНК"
	desc = "Позволяет быстро заменить ДНК у пациента."
	icon = 'icons/obj/medical/syringe.dmi'
	icon_state = "dnainjector"
	inhand_icon_state = "dnainjector"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

	var/damage_coeff = 1
	var/list/fields
	var/list/add_mutations = list()
	var/list/remove_mutations = list()

	var/used = FALSE

/obj/item/dnainjector/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	if(used)
		update_appearance()

/obj/item/dnainjector/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, used))
		update_appearance()

/obj/item/dnainjector/update_icon_state()
	. = ..()
	icon_state = inhand_icon_state = "[initial(icon_state)][used ? "0" : null]"

/obj/item/dnainjector/update_desc(updates)
	. = ..()
	desc = "[initial(desc)][used ? "This one is used up." : null]"

/obj/item/dnainjector/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/item/dnainjector/proc/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	for(var/removed_mutation in remove_mutations)
		target.dna.remove_mutation(removed_mutation)
	for(var/added_mutation in add_mutations)
		if(added_mutation == /datum/mutation/human/race)
			message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(target)] with the [name] [span_danger("(MONKEY)")]")
		if(target.dna.mutation_in_sequence(added_mutation))
			target.dna.activate_mutation(added_mutation)
		else
			target.dna.add_mutation(added_mutation, MUT_EXTRA)
	if(fields)
		if(fields["name"] && fields["UE"] && fields["blood_type"])
			target.real_name = fields["name"]
			target.dna.unique_enzymes = fields["UE"]
			target.name = target.real_name
			target.dna.blood_type = fields["blood_type"]
		if(fields["UI"]) //UI+UE
			target.dna.unique_identity = merge_text(target.dna.unique_identity, fields["UI"])
		if(fields["UF"])
			target.dna.unique_features = merge_text(target.dna.unique_features, fields["UF"])
		if(fields["UI"] || fields["UF"])
			target.updateappearance(mutcolor_update = TRUE, mutations_overlay_update = TRUE)
	return TRUE

/obj/item/dnainjector/attack(mob/target, mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("А как?!"))
		return
	if(used)
		to_chat(user, span_warning("Этот инъектор уже был использован!"))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target
		if (!humantarget.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			return
	log_combat(user, target, "attempted to inject", src)

	if(target != user)
		target.visible_message(span_danger("<b>[user]</b> пытается вколоть <b>[target]</b> <b>[src.name]</b>!") , \
			span_userdanger("<b>[user]</b> пытается вколоть мне <b>[src.name]</b>!"))
		if(!do_after(user, 3 SECONDS, target) || used)
			return
		target.visible_message(span_danger("<b>[user]</b> вкалывает <b>[target]</b> <b>[src.name]</b>!") , \
						span_userdanger("<b>[user]</b> вкалывает мне <b>[src.name]</b>!"))

	else
		to_chat(user, span_notice("Вкалываю себе <b>[src.name]</b>."))

	log_combat(user, target, "injected", src)

	if(!inject(target, user)) //Now we actually do the heavy lifting.
		to_chat(user, span_notice("Похоже <b>[target]</b> не имеет подходящего ДНК."))

	used = TRUE
	update_appearance()

/obj/item/dnainjector/timed
	var/duration = 600

/obj/item/dnainjector/timed/inject(mob/living/carbon/target, mob/user)
	if(target.stat == DEAD) //prevents dead people from having their DNA changed
		to_chat(user, span_notice("You can't modify [target]'s DNA while [target.p_theyre()] dead."))
		return FALSE
	if(!target.can_mutate())
		return FALSE
	var/endtime = world.time + duration
	for(var/mutation in remove_mutations)
		if(mutation == /datum/mutation/human/race)
			if(!ismonkey(target))
				continue
			target = target.dna.remove_mutation(mutation)
		else
			target.dna.remove_mutation(mutation)
	for(var/mutation in add_mutations)
		if(target.dna.get_mutation(mutation))
			continue //Skip permanent mutations we already have.
		if(mutation == /datum/mutation/human/race && !ismonkey(target))
			message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(target)] with the [name] [span_danger("(MONKEY)")]")
			target = target.dna.add_mutation(mutation, MUT_OTHER, endtime)
		else
			target.dna.add_mutation(mutation, MUT_OTHER, endtime)
	if(fields)
		if(fields["name"] && fields["UE"] && fields["blood_type"])
			if(!target.dna.previous["name"])
				target.dna.previous["name"] = target.real_name
			if(!target.dna.previous["UE"])
				target.dna.previous["UE"] = target.dna.unique_enzymes
			if(!target.dna.previous["blood_type"])
				target.dna.previous["blood_type"] = target.dna.blood_type
			target.real_name = fields["name"]
			target.dna.unique_enzymes = fields["UE"]
			target.name = target.real_name
			target.dna.blood_type = fields["blood_type"]
			target.dna.temporary_mutations[UE_CHANGED] = endtime
		if(fields["UI"]) //UI+UE
			if(!target.dna.previous["UI"])
				target.dna.previous["UI"] = target.dna.unique_identity
			target.dna.unique_identity = merge_text(target.dna.unique_identity, fields["UI"])
			target.dna.temporary_mutations[UI_CHANGED] = endtime
		if(fields["UF"]) //UI+UE
			if(!target.dna.previous["UF"])
				target.dna.previous["UF"] = target.dna.unique_features
			target.dna.unique_features = merge_text(target.dna.unique_features, fields["UF"])
			target.dna.temporary_mutations[UF_CHANGED] = endtime
		if(fields["UI"] || fields["UF"])
			target.updateappearance(mutcolor_update = TRUE, mutations_overlay_update = TRUE)
	return TRUE

/obj/item/dnainjector/timed/hulk
	name = "инъектор ДНК (Халк)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	add_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/timed/h2m
	name = "инъектор ДНК (Human > Monkey)"
	desc = "Will make you a flea bag."
	add_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/activator
	name = "Активатор ДНК"
	desc = "Activates the current mutation on injection, if the subject has it."
	var/doitanyway = FALSE
	var/research = FALSE //Set to true to get expended and filled injectors for chromosomes
	var/filled = FALSE
	var/crispr_charge = FALSE // Look for viruses, look at symptoms, if research and Dormant DNA Activator or Viral Evolutionary Acceleration, set to true

/obj/item/dnainjector/activator/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	for(var/mutation in add_mutations)
		var/datum/mutation/human/added_mutation = mutation
		if(istype(added_mutation, /datum/mutation/human))
			mutation = added_mutation.type
		if(!target.dna.activate_mutation(added_mutation))
			if(doitanyway)
				target.dna.add_mutation(added_mutation, MUT_EXTRA)
		else if(research && target.client)
			filled = TRUE
		for(var/datum/disease/advance/disease in target.diseases)
			for(var/datum/symptom/symp in disease.symptoms)
				if((symp.type == /datum/symptom/genetic_mutation) || (symp.type == /datum/symptom/viralevolution))
					crispr_charge = TRUE
		log_combat(user, target, "[!doitanyway ? "failed to inject" : "injected"]", "[src] ([mutation])[crispr_charge ? " with CRISPR charge" : ""]")
	return TRUE

/// DNA INJECTORS

/obj/item/dnainjector/acidflesh
	name = "инъектор ДНК (Кислотная плоть)"
	desc = "Под кожей жертвы образуются нарывы с едкой кислотой. Летально!"
	add_mutations = list(/datum/mutation/human/acidflesh)

/obj/item/dnainjector/antiacidflesh
	name = "инъектор ДНК (Анти-Кислотная плоть)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/acidflesh)

/obj/item/dnainjector/antenna
	name = "инъектор ДНК (Антенна)"
	desc = "Из головы носителя вырастает радиоантенна. Это позволяет ему общаться на базовых радиочастотах даже без внешней гарнитуры."
	add_mutations = list(/datum/mutation/human/antenna)

/obj/item/dnainjector/antiantenna
	name = "инъектор ДНК (Анти-Антенна)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/antenna)

/obj/item/dnainjector/antiglow
	name = "инъектор ДНК (Светопоглощение)"
	desc = "Кожа носителя поглощает частицы света и препятствует его отражению, образно говоря создавая вокруг носителя тьму."
	add_mutations = list(/datum/mutation/human/glow/anti)

/obj/item/dnainjector/removeantiglow
	name = "инъектор ДНК (Анти-Светопоглощение)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/glow/anti)

/obj/item/dnainjector/blindmut
	name = "инъектор ДНК (Слепота)"
	desc = "Носитель этой мутации слеп как крот."
	add_mutations = list(/datum/mutation/human/blind)

/obj/item/dnainjector/antiblind
	name = "инъектор ДНК (Анти-Слепота)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/blind)

/obj/item/dnainjector/chameleonmut
	name = "инъектор ДНК (Хамелеон)"
	desc = "Геном изменяющий эпидермис носителя, позволяя ему сливаться окружающим пространством с течением времени."
	add_mutations = list(/datum/mutation/human/chameleon)

/obj/item/dnainjector/antichameleon
	name = "инъектор ДНК (Анти-Хамелеон)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/chameleon)

/obj/item/dnainjector/chavmut
	name = "инъектор ДНК (Феня)"
	desc = "Ген случайным образом вырабатывающийся у ассистентов"
	add_mutations = list(/datum/mutation/human/chav)

/obj/item/dnainjector/antichav
	name = "инъектор ДНК (Анти-Феня)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/chav)

/obj/item/dnainjector/clumsymut
	name = "инъектор ДНК (Неуклюжесть)"
	desc = "Ген нарушающий тонкую моторику и блокирующий некоторые связи в мозге носителя. Хонк!"
	add_mutations = list(/datum/mutation/human/clumsy)

/obj/item/dnainjector/anticlumsy
	name = "инъектор ДНК (Анти-Неуклюжесть)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/clumsy)

/obj/item/dnainjector/coughmut
	name = "инъектор ДНК (Кашель)"
	desc = "Хронический кашель."
	add_mutations = list(/datum/mutation/human/cough)

/obj/item/dnainjector/anticough
	name = "инъектор ДНК (Анти-Кашель)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/cough)

/obj/item/dnainjector/cryokinesis
	name = "инъектор ДНК (Криокинез)"
	desc = "Псионическая способность заморозить цель на расстоянии."
	add_mutations = list(/datum/mutation/human/cryokinesis)

/obj/item/dnainjector/anticryokinesis
	name = "инъектор ДНК (Анти-Криокинез)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/cryokinesis)

/obj/item/dnainjector/deafmut
	name = "инъектор ДНК (Глухота)"
	desc = "Носитель полностью генетически глух."
	add_mutations = list(/datum/mutation/human/deaf)

/obj/item/dnainjector/antideaf
	name = "инъектор ДНК (Анти-Глухота)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/deaf)

/obj/item/dnainjector/dwarf
	name = "инъектор ДНК (Дворфизм)"
	desc = "Мутация которая увеличивает мир вокруг носителя."
	add_mutations = list(/datum/mutation/human/dwarfism)

/obj/item/dnainjector/antidwarf
	name = "инъектор ДНК (Анти-Дворфизм)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/dwarfism)

/obj/item/dnainjector/elvismut
	name = "инъектор ДНК (Элвис)"
	desc = "Чудовищная мутация названная в честь нулевого пациента."
	add_mutations = list(/datum/mutation/human/elvis)

/obj/item/dnainjector/antielvis
	name = "инъектор ДНК (Анти-Элвис)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/elvis)

/obj/item/dnainjector/epimut
	name = "инъектор ДНК (Эпилепсия)"
	desc = "Генетический дефект, который время от времени вызывает судороги."
	add_mutations = list(/datum/mutation/human/epilepsy)

/obj/item/dnainjector/antiepi
	name = "инъектор ДНК (Анти-Эпилепсия)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/epilepsy)

/obj/item/dnainjector/geladikinesis
	name = "инъектор ДНК (Аквакрионика)"
	desc = "Позволяет сконденсировать влагу из воздуха в руках и обратить ее в снег."
	add_mutations = list(/datum/mutation/human/geladikinesis)

/obj/item/dnainjector/antigeladikinesis
	name = "инъектор ДНК (Анти-Аквакрионика)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/geladikinesis)

/obj/item/dnainjector/gigantism
	name = "инъектор ДНК (Гигантизм)"
	desc = "Увеличивает межклеточное пространство в организме носителя, тем самым увеличивая его физический размер."
	add_mutations = list(/datum/mutation/human/gigantism)

/obj/item/dnainjector/antigigantism
	name = "инъектор ДНК (Анти-Гигантизм)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/gigantism)

/obj/item/dnainjector/glassesmut
	name = "инъектор ДНК (Близорукость)"
	desc = "Обладатель этой мутации имеет плохое зрение."
	add_mutations = list(/datum/mutation/human/nearsight)

/obj/item/dnainjector/antiglasses
	name = "инъектор ДНК (Анти-Близорукость)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/nearsight)

/obj/item/dnainjector/glow
	name = "инъектор ДНК (Свечение)"
	desc = "Трансмутирует кожный покров носителя, тем самым вынуждая его постоянно излучать свет случайного цвета и интенсивностью."
	add_mutations = list(/datum/mutation/human/glow)

/obj/item/dnainjector/removeglow
	name = "инъектор ДНК (Анти-Свечение)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/glow)

/obj/item/dnainjector/hulkmut
	name = "инъектор ДНК (Халк)"
	desc = "Плохо изученный геном, который неестественно увеличивает мышцы, угнетает речевой аппарат и окрашивает кожу в странный зеленый цвет."
	add_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/antihulk
	name = "инъектор ДНК (Анти-Халк)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/h2m
	name = "инъектор ДНК (Манкификация)"
	desc = "Странный геном, который показывает, что мы не так уж и далеко ушли от обезьян."
	add_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/m2h
	name = "инъектор ДНК (Анти-Манкификация)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/insulated
	name = "инъектор ДНК (Электроизоляция)"
	desc = "Делает организм носителя невосприимчивым к ударам электрическим током."
	add_mutations = list(/datum/mutation/human/insulated)

/obj/item/dnainjector/antiinsulated
	name = "инъектор ДНК (Анти-Электроизоляция)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/insulated)

/obj/item/dnainjector/lasereyesmut
	name = "инъектор ДНК (Глаза-Лазеры)"
	desc = "Перестраивает хрусталик глаза позволяя аккумулировать свет и выстреливать им в цель в виде сконцентрированного лазерного луча."
	add_mutations = list(/datum/mutation/human/laser_eyes)

/obj/item/dnainjector/antilasereyes
	name = "инъектор ДНК (Анти-Глаза-Лазеры)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/laser_eyes)

/obj/item/dnainjector/mindread
	name = "инъектор ДНК (Чтение мыслей)"
	desc = "Носитель получает способность читать последние мысли цели, а так же определять его истинную суть."
	add_mutations = list(/datum/mutation/human/mindreader)

/obj/item/dnainjector/antimindread
	name = "инъектор ДНК (Анти-Чтение мыслей)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/mindreader)

/obj/item/dnainjector/mutemut
	name = "инъектор ДНК (Немота)"
	desc = "Полностью подавляет речевой отдел мозга."
	add_mutations = list(/datum/mutation/human/mute)

/obj/item/dnainjector/antimute
	name = "инъектор ДНК (Анти-Немота)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/mute)

/obj/item/dnainjector/olfaction
	name = "инъектор ДНК (Сверхчувствительное обоняние)"
	desc = "Изменяет обонятельные рецепторы подопытного, усиливая их чувствительность до уровня сравнимого с охотничьими гончими."
	add_mutations = list(/datum/mutation/human/olfaction)

/obj/item/dnainjector/antiolfaction
	name = "инъектор ДНК (Анти-Сверхчувствительное обоняние)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/olfaction)

/obj/item/dnainjector/paranoia
	name = "инъектор ДНК (Паранойя)"
	desc = "Субъект легко поддается панике и может страдать от галлюцинаций."
	add_mutations = list(/datum/mutation/human/paranoia)

/obj/item/dnainjector/antiparanoia
	name = "инъектор ДНК (Анти-Паранойя)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/paranoia)

/obj/item/dnainjector/pressuremut
	name = "инъектор ДНК (Космическая адаптация)"
	desc = "Мутация сформировавшаяся у экипажей разведывательных межсистемных первопроходцев, странным образом ограждает носителя от холода и космического вакуума. К сожалению мы все еще нуждаемся в кислороде."
	add_mutations = list(/datum/mutation/human/space_adaptation)

/obj/item/dnainjector/antipressure
	name = "инъектор ДНК (Анти-Космическая адаптация)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/space_adaptation)

/obj/item/dnainjector/radioactive
	name = "инъектор ДНК (Радиоактивность)"
	desc = "Мутация которая активирует радиоизотопный распад молекулярной структуры носителя, вредоносное как для него, так и окружающих."
	add_mutations = list(/datum/mutation/human/radioactive)

/obj/item/dnainjector/antiradioactive
	name = "инъектор ДНК (Анти-Радиоактивность)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/radioactive)

/obj/item/dnainjector/shock
	name = "инъектор ДНК (Электрошок)"
	desc = "Позволяет накапливать крайне высокий заряд статического электричества и при желании разряжаться на выбраную цель при касании."
	add_mutations = list(/datum/mutation/human/shock)

/obj/item/dnainjector/antishock
	name = "инъектор ДНК (Анти-Электрошок)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/shock)

/obj/item/dnainjector/spastic
	name = "инъектор ДНК (Мышечные спазмы)"
	desc = "Субъект страдает от мышечных спазмов."
	add_mutations = list(/datum/mutation/human/spastic)

/obj/item/dnainjector/antispastic
	name = "инъектор ДНК (Анти-Мышечные спазмы)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/spastic)

/obj/item/dnainjector/spatialinstability
	name = "инъектор ДНК (Пространственная нестабильность)"
	desc = "Жертва теряет связь с пространственно-временным континуумом и совершает неконтролируемые прыжки. Также вызывает сильную тошноту."
	add_mutations = list(/datum/mutation/human/badblink)

/obj/item/dnainjector/antispatialinstability
	name = "инъектор ДНК (Анти-Пространственная нестабильность)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/badblink)

/obj/item/dnainjector/stuttmut
	name = "инъектор ДНК (Нервозность)"
	desc = "Вызывает заикание."
	add_mutations = list(/datum/mutation/human/nervousness)

/obj/item/dnainjector/antistutt
	name = "\improper DNA injector (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	remove_mutations = list(/datum/mutation/human/nervousness)

/obj/item/dnainjector/swedishmut
	name = "инъектор ДНК (Анти-Нервозность)"
	desc = "Удаляет конкретную мутацию."
	add_mutations = list(/datum/mutation/human/swedish)

/obj/item/dnainjector/antiswedish
	name = "инъектор ДНК (Анти-Швед)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/swedish)

/obj/item/dnainjector/telemut
	name = "инъектор ДНК (Телекинез)"
	desc = "Мутация, позволяющая владельцу перемещать предметы силой мысли."
	add_mutations = list(/datum/mutation/human/telekinesis)

/obj/item/dnainjector/telemut/darkbundle
	desc = "Да пребудет с тобой темная сила."

/obj/item/dnainjector/antitele
	name = "инъектор ДНК (Анти-Телекинез)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/telekinesis)

/obj/item/dnainjector/thermal
	name = "инъектор ДНК (Термосенсорное восприятие)"
	desc = "Позволяет носителю чувствовать тепловые сигнатуры живых объектов даже сквозь многометровые стальные перегородки."
	add_mutations = list(/datum/mutation/human/thermal)


/obj/item/dnainjector/tourmut
	name = "инъектор ДНК (Анти-Термосенсорное восприятие)"
	desc = "Удаляет конкретную мутацию."
	add_mutations = list(/datum/mutation/human/tourettes)

/obj/item/dnainjector/antitour
	name = "инъектор ДНК (Анти-Синдром Туретта)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/tourettes)

/obj/item/dnainjector/twoleftfeet
	name = "инъектор ДНК (Две левых ноги)"
	desc = "Мутация, которая заменяет вашу правую ногу еще одной левой ногой. Будьте готовы к постоянным встречам вашего лица с полом."
	add_mutations = list(/datum/mutation/human/extrastun)

/obj/item/dnainjector/antitwoleftfeet
	name = "инъектор ДНК (Анти-Две левых ноги)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/extrastun)

/obj/item/dnainjector/unintelligiblemut
	name = "инъектор ДНК (Невнятность)"
	desc = "Частично подавляет речевой отдел мозга, сильно искажая речь."
	add_mutations = list(/datum/mutation/human/unintelligible)

/obj/item/dnainjector/antiunintelligible
	name = "инъектор ДНК (Анти-Невнятность)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/unintelligible)

/obj/item/dnainjector/void
	name = "инъектор ДНК (Слияние с пустотой)"
	desc = "Редкий геном, способный преодолеть законы эвклидового пространства и укрыть носителя за завесой мрачной и холодной пустоты мертвого космоса."
	add_mutations = list(/datum/mutation/human/void)

/obj/item/dnainjector/antivoid
	name = "инъектор ДНК (Анти-Слияние с пустотой)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/void)

/obj/item/dnainjector/xraymut
	name = "инъектор ДНК (Рентгеновское зрение)"
	desc = "Редчайшая мутация, возможно даже навсегда утеренная для будущих поколений, позволяет в прямом смысле видеть сквозь стены!" //actual x-ray would mean you'd constantly be blasting rads, wich might be fun for later //hmb
	add_mutations = list(/datum/mutation/human/xray)

/obj/item/dnainjector/antixray
	name = "инъектор ДНК (Анти-Рентгеновское зрение)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/xray)

/obj/item/dnainjector/wackymut
	name = "инъектор ДНК (Чокнутый)"
	desc = "Нет... Ты не клоун... Ты весь цирк в одном лице..."
	add_mutations = list(/datum/mutation/human/wacky)

/obj/item/dnainjector/antiwacky
	name = "инъектор ДНК (Анти-Чокнутый)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/wacky)

/obj/item/dnainjector/webbing
	name = "инъектор ДНК (Паутиновые железы)"
	desc = "Позволяет носителю создавать паутину и беспрепятственно двигаться через нее."
	add_mutations = list(/datum/mutation/human/webbing)

/obj/item/dnainjector/antiwebbing
	name = "инъектор ДНК (Анти-Паутиновые железы)"
	desc = "Удаляет конкретную мутацию."
	remove_mutations = list(/datum/mutation/human/webbing)
