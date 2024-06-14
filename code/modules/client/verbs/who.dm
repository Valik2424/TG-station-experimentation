#define NO_ADMINS_ONLINE_MESSAGE "Админхелпы также отправляются через Discord. Если в игре нет администраторов, отправка админ-хелпа все равно может быть замечена и принята."

/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Текущие игроки:</b>\n"

	var/living = 0
	var/dead = 0
	var/observers = 0
	var/lobby = 0
	var/living_antags = 0
	var/dead_antags = 0

	var/list/Lines = list()

	if(holder)
		if (check_rights(R_ADMIN,0) && isobserver(src.mob))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
			var/mob/dead/observer/G = src.mob
			if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
				log_admin("[key_name(usr)] checked advanced who in-round")
			for(var/client/client in GLOB.clients)
				var/entry = "\t[client.key]"
				if(client.holder && client.holder.fakekey)
					entry += " <i>(as [client.holder.fakekey])</i>"
				if (isnewplayer(client.mob))
					entry += " - <font color='darkgray'><b>Лобби</b></font>"
					lobby++
				else
					entry += " - [client.mob.real_name]"
					switch(client.mob.stat)
						if(UNCONSCIOUS, HARD_CRIT)
							entry += " - <font color='darkgray'><b>Без сознания</b></font>"
							living++
						if(DEAD)
							if(isobserver(client.mob))
								var/mob/dead/observer/O = client.mob
								if(O.started_as_observer)
									entry += " - <font color='gray'>Наблюдает</font>"
									observers++
								else
									entry += " - <font color='white'><b>МЁРТВ</b></font>"
									dead++
							else
								entry += " - <font color='white'><b>МЁРТВ</b></font>"
								dead++
						else
							living++
					if(is_special_character(client.mob))
						entry += " - <b><font color='red'>Антагонист</font></b>"
						living_antags++
						if(client.mob.stat == DEAD)
							dead_antags++
							living_antags--
				entry += " [ADMIN_QUE(client.mob)]"
				entry += " ([round(client.avgping, 1)]мс)"
				Lines += entry
		else//If they don't have +ADMIN, only show hidden admins
			for(var/client/client in GLOB.clients)
				var/entry = "[client.key]"
				if(client.holder && client.holder.fakekey)
					entry += " <i>(как [client.holder.fakekey])</i>"
				entry += " ([round(client.avgping, 1)]мс)"
				Lines += entry
	else
		for(var/client/client in GLOB.clients)
			if(client.holder && client.holder.fakekey)
				Lines += "[client.holder.fakekey] ([round(client.avgping, 1)]мс)"
			else
				Lines += "[client.key] ([round(client.avgping, 1)]мс)"

	for(var/line in sort_list(Lines))
		msg += "[line]\n"

	if(check_rights(R_ADMIN, 0))
		msg += "<b><font color='green'>L: [living]</font> | D: [dead] | <font color='gray'>O: [observers]</font> | <font color='#006400'>LOBBY: [lobby]</font> | <font color='#8100aa'>LA: [living_antags]</font> | <font color='#9b0000'>DA: [dead_antags]</font></b>\n"

	msg += "<b>Всего игроков: [length(Lines)]</b>"
	to_chat(src, "<span class='infoplain'>[msg]</span>")

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/list/lines = list()
	var/payload_string = generate_adminwho_string()
	var/header

	if(payload_string == NO_ADMINS_ONLINE_MESSAGE)
		header = "Педалей на данный момент нет в сети."
	else
		header = "Текущие педали:"

	lines += span_bold(header)
	lines += payload_string

	var/finalized_string = examine_block(jointext(lines, "\n"))
	to_chat(src, finalized_string)

/// Proc that generates the applicable string to dispatch to the client for adminwho.
/client/proc/generate_adminwho_string()
	var/list/list_of_admins = get_list_of_admins()
	if(isnull(list_of_admins))
		return NO_ADMINS_ONLINE_MESSAGE

	var/list/message_strings = list()
	if(isnull(holder))
		message_strings += get_general_adminwho_information(list_of_admins)
		message_strings += NO_ADMINS_ONLINE_MESSAGE
	else
		message_strings += get_sensitive_adminwho_information(list_of_admins)

	return jointext(message_strings, "\n")

/// Proc that returns a list of cliented admins. Remember that this list can contain nulls!
/// Also, will return null if we don't have any admins.
/proc/get_list_of_admins()
	var/returnable_list = list()

	for(var/client/admin in GLOB.admins)
		returnable_list += admin

	if(length(returnable_list) == 0)
		return null

	return returnable_list

/// Proc that will return the applicable display name, linkified or not, based on the input client reference.
/proc/get_linked_admin_name(client/admin)
	var/feedback_link = admin.holder.feedback_link()
	return isnull(feedback_link) ? admin : "<a href=[feedback_link]>[admin]</a>"

/// Proc that gathers adminwho information for a general player, which will only give information if an admin isn't AFK, and handles potential fakekeying.
/// Will return a list of strings.
/proc/get_general_adminwho_information(list/checkable_admins)
	var/returnable_list = list()

	for(var/client/admin in checkable_admins)
		if(admin.is_afk() || !isnull(admin.holder.fakekey))
			continue //Don't show afk or fakekeyed admins to adminwho

		returnable_list += "• [get_linked_admin_name(admin)] - [admin.holder.rank_names()]"

	return returnable_list

/// Proc that gathers adminwho information for admins, which will contain information on if the admin is AFK, readied to join, etc. Only arg is a list of clients to use.
/// Will return a list of strings.
/proc/get_sensitive_adminwho_information(list/checkable_admins)
	var/returnable_list = list()

	for(var/client/admin in checkable_admins)
		var/list/admin_strings = list()

		admin_strings += "• [get_linked_admin_name(admin)] - [admin.holder.rank_names()]"

		if(admin.holder.fakekey)
			admin_strings += "<i>(как [admin.holder.fakekey])</i>"

		if(isobserver(admin.mob))
			admin_strings += "- Наблюдает"
		else if(isnewplayer(admin.mob))
			if(SSticker.current_state <= GAME_STATE_PREGAME)
				var/mob/dead/new_player/lobbied_admin = admin.mob
				if(lobbied_admin.ready == PLAYER_READY_TO_PLAY)
					admin_strings += "- Лобби (ГОТОВ)"
				else
					admin_strings += "- Лобби (Не готов)"
			else
				admin_strings += "- Лобби"
		else
			admin_strings += "- <b>Играет</b>"

		if(admin.is_afk())
			admin_strings += "(AFK)"

		returnable_list += jointext(admin_strings, " ")

	return returnable_list

#undef NO_ADMINS_ONLINE_MESSAGE
