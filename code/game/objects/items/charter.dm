/obj/item/station_charter
	name = "чартер станции"
	icon = 'icons/obj/scrolls.dmi'
	icon_state = "charter"
	desc = "Официальный документ, поручающий управление \
		и окружающее пространство капитану."
	var/used = FALSE
	var/name_type = "station"

	var/unlimited_uses = FALSE
	var/ignores_timeout = FALSE
	var/response_timer_id = null
	var/approval_time = 600

	var/static/regex/standard_station_regex

/obj/item/station_charter/Initialize(mapload)
	. = ..()
	if(!standard_station_regex)
		var/prefixes = jointext(GLOB.station_prefixes, "|")
		var/names = jointext(GLOB.station_names, "|")
		var/suffixes = jointext(GLOB.station_suffixes, "|")
		var/numerals = jointext(GLOB.station_numerals, "|")
		var/regexstr = "^(([prefixes]) )?(([names]) ?)([suffixes]) ([numerals])$"
		standard_station_regex = new(regexstr)

/obj/item/station_charter/attack_self(mob/living/user)
	if(used)
		to_chat(user, span_warning("[capitalize(name_type)] уже названа!"))
		return
	if(!ignores_timeout && (world.time-SSticker.round_start_time > STATION_RENAME_TIME_LIMIT)) //5 minutes
		to_chat(user, span_warning("Экипаж уже заселился. Будет странно, если [name_type] переименуется сейчас."))
		return
	if(response_timer_id)
		to_chat(user, span_warning("Всё еще жду одобрения от своих работодателей по поводу предлагаемого изменения имени, лучше пока подождать."))
		return

	var/new_name = tgui_input_text(user, "Как мы назовём \
		[station_name()]? Имейте в виду, что особенно ужасные имена могут быть \
		отклонены вашими работодателями, а имена указанные в стандартном формате, \
		будет автоматически принято.", "Название станции", max_length = MAX_CHARTER_LEN)

	if(response_timer_id)
		to_chat(user, span_warning("Всё еще жду одобрения от своих работодателей по поводу предлагаемого изменения имени, лучше пока подождать.."))
		return

	if(!new_name)
		return
	user.log_message("has proposed to name the station as \
		[new_name]", LOG_GAME)

	if(standard_station_regex.Find(new_name))
		to_chat(user, span_notice("Новое имя станции было принято автоматически."))
		rename_station(new_name, user.name, user.real_name, key_name(user))
		return

	to_chat(user, span_notice("Название было отправлено на утверждение работодателям."))
	// Autoapproves after a certain time
	response_timer_id = addtimer(CALLBACK(src, PROC_REF(rename_station), new_name, user.name, user.real_name, key_name(user)), approval_time, TIMER_STOPPABLE)
	to_chat(GLOB.admins, span_adminnotice("<b><font color=orange>CUSTOM STATION RENAME:</font></b>[ADMIN_LOOKUPFLW(user)] proposes to rename the [name_type] to [new_name] (will autoapprove in [DisplayTimeText(approval_time)]). [ADMIN_SMITE(user)] (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];reject_custom_name=[REF(src)]'>REJECT</A>) [ADMIN_CENTCOM_REPLY(user)]"))
	for(var/client/admin_client in GLOB.admins)
		if(admin_client.prefs.toggles & SOUND_ADMINHELP)
			window_flash(admin_client, ignorepref = TRUE)
			SEND_SOUND(admin_client, sound('sound/effects/gong.ogg'))

/obj/item/station_charter/proc/reject_proposed(user)
	if(!user)
		return
	if(!response_timer_id)
		return
	var/turf/T = get_turf(src)
	T.visible_message("<span class='warning'>Изменения исчезают \
		с [src]; видимо их отклонили.</span>")
	var/m = "[key_name(user)] has rejected the proposed station name."

	message_admins(m)
	log_admin(m)

	deltimer(response_timer_id)
	response_timer_id = null

/obj/item/station_charter/proc/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce("[ureal_name] переименовывает нашу станцию в [station_name()]", "Капитанский указ", 0)
	log_game("[ukey] has renamed the station as [station_name()].")

	name = "договор аренды станции [station_name()]"
	desc = "Официальный документ, поручающий управление \
		[station_name()] и окружающее пространство капитану [uname]."
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE

/obj/item/station_charter/admin
	unlimited_uses = TRUE
	ignores_timeout = TRUE


/obj/item/station_charter/banner
	name = "знамя Nanotrasen"
	icon = 'icons/obj/banner.dmi'
	name_type = "planet"
	icon_state = "banner"
	inhand_icon_state = "banner"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	desc = "A cunning device used to claim ownership of celestial bodies."
	w_class = WEIGHT_CLASS_HUGE
	force = 15

/obj/item/station_charter/banner/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce("[ureal_name] переименовывает нашу станцию в [station_name()]", "Капитанское знамя", 0)
	log_game("[ukey] has renamed the [name_type] as [station_name()].")
	name = "знамя [station_name()]"
	desc = "На баннере изображен официальный герб Nanotrasen, означающий, что [station_name()] принадлежит капитану [uname] во имя корпорации."
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE
