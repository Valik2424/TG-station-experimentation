/// Gives the target bad luck, optionally permanently
/datum/smite/bad_luck
	name = "Bad Luck"

	/// Should the target know they've received bad luck?
	var/silent

	/// Is this permanent?
	var/incidents

/datum/smite/bad_luck/configure(client/user)
	silent = tgui_alert(user, "Хочешь уведомить пользователя?", "Уведомить?", list("Уведомить", "Нет")) == "Нет"
	incidents = tgui_input_number(user, "Сколько времени будет длиться проклятие? 0 - бесконечно.", "Длительность?", default = 0, round_value = 1)
	if(incidents == 0)
		incidents = INFINITY

/datum/smite/bad_luck/effect(client/user, mob/living/target)
	. = ..()
	//if permanent, replace any existing omen
	if(incidents == INFINITY)
		var/existing_component = target.GetComponent(/datum/component/omen)
		qdel(existing_component)
		message_admins("Перманентная неудача, скорее всего юзер сдохнет нахуй")
		log_admin("Перманентная неудача, скорее всего юзер сдохнет нахуй")
	target.AddComponent(/datum/component/omen/smite, incidents_left = incidents)
	if(silent)
		return

	if(incidents == INFINITY)
		to_chat(target, span_warning("Очень плохое предчувствие... Как будто злые силы наблюдают за мной..."))
	else
		to_chat(target, span_warning("У меня плохое предчувствие..."))
