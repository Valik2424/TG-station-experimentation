/mob/living/silicon/robot/examine(mob/user)
	. = list("<span class='info'>Это же [icon2html(src, user)] <EM>[src]</EM>!<hr>")
	if(desc)
		. += "[desc]"

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += "Он держит [icon2html(act_module, user)] <b>[act_module]</b>.\n"
	. += get_status_effect_examinations()
	if (getBruteLoss())
		if (getBruteLoss() < maxHealth*0.5)
			. += span_warning("Выглядит немного побитым.")
		else
			. += span_warning("<B>Выглядит сильно побитым!</B>")
	if (getFireLoss() || getToxLoss())
		var/overall_fireloss = getFireLoss() + getToxLoss()
		if (overall_fireloss < maxHealth * 0.5)
			. += span_warning("Выглядит немного обугленным.")
		else
			. += span_warning("<B>Выглядит так, будто его прожарили в печи!</B>")
	if (health < -maxHealth*0.5)
		. += span_warning("Выглядит едва рабочим.")
	if (fire_stacks < 0)
		. += span_warning("Он мокрый.")
	else if (fire_stacks > 0)
		. += span_warning("Он в чём-то горючем.")

	if(opened)
		. += span_warning("Крышка открыта, батарейка [cell ? "установлена" : "отсутствует"].")
	else
		. += "Крышка закрыта[locked ? "" : "и, похоже, не заперта"]."

	if(cell && cell.charge <= 0)
		. += span_warning("Индикатор заряда мигает красным!")

	switch(stat)
		if(CONSCIOUS)
			if(shell)
				. += "Похоже, это [deployed ? "активная" : "пустая"] оболочка ИИ."
			else if(!client)
				. += "Похоже, он в режиме ожидания."
		if(SOFT_CRIT, UNCONSCIOUS, HARD_CRIT)
			. += span_warning("Он не реагирует на движения.")
		if(DEAD)
			. += span_deadsay("Похоже, его система повреждена и требует перезагрузки.")
	. += "</span>"

	. += ..()

/mob/living/silicon/robot/get_examine_string(mob/user, thats = FALSE)
	return null
