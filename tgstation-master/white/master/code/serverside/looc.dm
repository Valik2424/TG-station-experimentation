#define LOOC_RANGE 7
#define BAN_LOOC "LOOC"

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	looc_message(msg)

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="can you even see verb descriptions anywhere?"
	set name="🔄 Toggle LOOC"
	toggle_looc()
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, "Toggle LOOC|[GLOB.looc_allowed]")

/datum/admins/proc/toggleloocdead()
	set category = "Server"
	set desc = "seriously, why do we even bother"
	set name = "🔄 Toggle Dead LOOC"
	GLOB.dlooc_allowed = !(GLOB.dlooc_allowed)
	log_admin("[key_name(usr)] toggled Dead LOOC.")
	message_admins("[key_name_admin(usr)] toggled Dead LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, "Toggle Dead LOOC|[GLOB.dlooc_allowed]")

/mob/proc/get_top_level_mob()
	if(ismob(loc) && (loc != src))
		var/mob/M = loc
		return M.get_top_level_mob()
	return src


/client/proc/looc_message(msg)
	if(GLOB.say_disabled)
		to_chat(usr, span_danger("Говорить запретили всем!"))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC выключен."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			log_admin("[key_name(src)] попытался дать рекламу айпи сервера в LOOC: [msg]")
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger("Не могу писать в LOOC (muted)."))
			return
		if(is_banned_from(ckey, BAN_LOOC))
			to_chat(src, span_warning("У меня бан на LOOC!"))
			return
		if(mob.stat && !GLOB.dlooc_allowed)
			to_chat(src, span_danger("Не могу писать в LOOC, пока я мертв или без сознания."))
			return
		if(istype(mob, /mob/dead))
			to_chat(src, span_danger("Не могу писать в LOOC, пока я призрак."))
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg,LOG_OOC, tag="LOOC")
	var/list/heard
	heard = get_hearers_in_view(LOOC_RANGE, mob.get_top_level_mob())

	//so the ai can post looc text
	if(istype(mob, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai = mob
		heard = get_hearers_in_view(LOOC_RANGE, ai.eyeobj)
	//so the ai can see looc text
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.client && !(ai in heard) && (ai.eyeobj in heard))
			heard += ai

	var/list/admin_seen = list()
	for(var/mob/hearing in heard)
		if(!hearing.client)
			continue
		var/client/hearing_client = hearing.client
		if (hearing_client.holder)
			admin_seen[hearing_client] = TRUE
			continue //they are handled after that

		if (isobserver(hearing))
			continue //Also handled later.

		to_chat(hearing_client, span_looc(span_prefix("LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]")))

	for(var/cli in GLOB.admins)
		var/client/cli_client = cli
		if (admin_seen[cli_client])
			to_chat(cli_client, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>LOOC:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"))
		else if (cli_client.prefs.read_preference(/datum/preference/toggle/see_looc))
			to_chat(cli_client, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>(R)LOOC:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"))

/proc/toggle_looc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.looc_allowed)
			GLOB.looc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.looc_allowed = !GLOB.looc_allowed
	message_admins(span_bold("LOOC [GLOB.looc_allowed ? "включен" : "выключен"]."))


#undef LOOC_RANGE
