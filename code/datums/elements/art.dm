/datum/element/art
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY // Detach for turfs
	argument_hash_start_idx = 2
	var/impressiveness = 0

/datum/element/art/Attach(datum/target, impress)
	. = ..()
	if(!isatom(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	impressiveness = impress
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/element/art/Detach(datum/target)
	UnregisterSignal(target, COMSIG_ATOM_EXAMINE)
	return ..()

/datum/element/art/proc/apply_moodlet(atom/source, mob/living/user, impress)
	SIGNAL_HANDLER

	var/msg
	switch(impress)
		if(GREAT_ART to INFINITY)
			user.add_mood_event("artgreat", /datum/mood_event/artgreat)
			msg = "Что за [pick("шедевральное", "гениальное")] произведение искусства. Какой [pick("непревзойденный", "внушающий благоговение", "завораживающий", "безупречный")] стиль!"
		if (GOOD_ART to GREAT_ART)
			user.add_mood_event("artgood", /datum/mood_event/artgood)
			msg = "Это [pick("уважаемое", "похвальное", "качественное")] произведение искусства, которое можно только увидеть."
		if (BAD_ART to GOOD_ART)
			user.add_mood_event("artok", /datum/mood_event/artok)
			msg = "Это выглядит на среднем уровне, достаточно, чтобы называться \"ИСКУССТВОМ\"."
		if (0 to BAD_ART)
			user.add_mood_event("artbad", /datum/mood_event/artbad)
			msg = "Вау, [source.ru_who()] выглядит ущербно."

	user.visible_message(span_notice("[user] останавливается и пристально смотрит на [source].") , \
		span_notice("Оцениваю [source]... [msg]"))

/datum/element/art/proc/on_examine(atom/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	if(!isliving(user))
		return
	if(!DOING_INTERACTION_WITH_TARGET(user, source))
		INVOKE_ASYNC(src, PROC_REF(appraise), source, user) //Do not sleep the proc.

/datum/element/art/proc/appraise(atom/source, mob/user)
	to_chat(user, span_notice("Любуюсь [source]..."))
	if(!do_after(user, 2 SECONDS, target = source))
		return
	var/mult = 1
	if(source.uses_integrity)
		mult = source.get_integrity() / source.max_integrity
	apply_moodlet(source, user, impressiveness * mult)

/datum/element/art/rev

/datum/element/art/rev/apply_moodlet(atom/source, mob/living/user, impress)
	var/msg
	if(user.mind?.has_antag_datum(/datum/antagonist/rev))
		user.add_mood_event("artgreat", /datum/mood_event/artgreat)
		msg = "Какое [pick("шедевральное", "гениальное")] произведение искусства. Какой [pick("разрушительный", "революционный", "объединяющий", "эгалитарный")] стиль!"
	else
		user.add_mood_event("artbad", /datum/mood_event/artbad)
		msg = "Вау, [source.ru_who()] выглядит ущербно."

	user.visible_message(span_notice("[user] прекращает изучать [source].") , \
		span_notice("Оцениваю [source], осмотрев искусное мастерство пролетариата... [msg]"))

/datum/element/art/commoner

/datum/element/art/commoner/apply_moodlet(atom/source, mob/living/user, impress)
	var/msg
	var/list/haters = list()
	for(var/hater_department_type as anything in list(/datum/job_department/security, /datum/job_department/command))
		var/datum/job_department/hater_department = SSjob.get_department_type(hater_department_type)
		for(var/datum/job/hater_job as anything in hater_department.department_jobs)
			haters += hater_job.title
	var/datum/job/quartermaster/fucking_quartermaster = SSjob.GetJobType(/datum/job/quartermaster)
	haters += fucking_quartermaster.title

	if(!(user.mind.assigned_role.title in haters))
		user.add_mood_event("artgreat", /datum/mood_event/artgreat)
		msg = "Какое [pick("шедевральное", "гениальное")] произведение искусства. Какой [pick("разрушительный", "революционный", "объединяющий", "эгалитарный")] стиль!"
	else
		user.add_mood_event("artbad", /datum/mood_event/artbad)
		msg = "Вау, [source.ru_who()] выглядит ущербно."

	user.visible_message(span_notice("[user] stops to inspect [source]."), \
		span_notice("Оцениваю [source], осмотрев искусное мастерство пролетариата... [msg]"))
