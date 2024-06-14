#define GENERIC list(\
	'sound/ambience/white/ambi2.ogg',\
	'sound/ambience/white/ambi3.ogg',\
	'sound/ambience/white/ambi4.ogg',\
	'sound/ambience/white/ambi5.ogg',\
	'sound/ambience/white/ambi6.ogg',\
	'sound/ambience/white/ambi7.ogg',\
	'sound/ambience/white/ambi8.ogg',\
	'sound/ambience/white/ambi9.ogg',\
	'sound/ambience/white/ambi10.ogg',\
	'sound/ambience/white/ambi12.ogg',\
	'sound/ambience/white/ambi13.ogg')

#define HOLY list('sound/ambience/white/ambichurch1.ogg')

#define HIGHSEC list(\
	'sound/ambience/white/ambidanger1.ogg',\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambidanger3.ogg')

#define ENGINEERING list(\
	'sound/ambience/white/ambieng1.ogg',\
	'sound/ambience/white/ambidanger2.ogg')

#define MINING list(\
	'sound/ambience/white/ambidanger1.ogg',\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambi12.ogg')

#define MEDICAL list(\
	'sound/ambience/white/ambimed1.ogg',\
	'sound/ambience/white/ambimed2.ogg')

#define SPOOKY list('sound/ambience/white/ambimo1.ogg')

#define SPACE list(\
	'sound/ambience/white/ambispace1.ogg',\
	'sound/ambience/white/ambispace2.ogg',\
	'sound/ambience/white/ambispace3.ogg',\
	'sound/ambience/white/ambispace4.ogg')

#define MAINTENANCE list(\
	'sound/ambience/white/ambimaint1.ogg',\
	'sound/ambience/white/ambimaint2.ogg')

#define AWAY_MISSION list(\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambidanger3.ogg',\
	'sound/ambience/white/ambi12.ogg')

////////////////

/client
	// Is ambient played?
	var/played = FALSE

/area
	var/list/longambient_type = GENERIC
	var/ambience_volume = 15

/area/space
	longambient_type = SPACE

/area/centcom/asteroid
	longambient_type = MINING

/area/station/service/chapel
	longambient_type = HOLY

/area/station/engineering
	longambient_type = ENGINEERING

/area/station/solars
	longambient_type = ENGINEERING

/area/station/command/teleporter
	longambient_type = ENGINEERING

/area/station/command/gateway
	longambient_type = ENGINEERING

/area/station/construction
	longambient_type = ENGINEERING

/area/station/tcommsat
	longambient_type = ENGINEERING

/area/station/maintenance
	longambient_type = MAINTENANCE

/area/station/medical
	longambient_type = MEDICAL

/area/station/medical/morgue
	longambient_type = SPOOKY

/area/station/security
	longambient_type = HIGHSEC

/area/station/ai_monitored/security/armory
	longambient_type = HIGHSEC

/area/awaymission
	longambient_type = AWAY_MISSION

///////////////////
/area/proc/play_long_ambient(client/C)
	if(!C?.mob)
		return
	if(!C.played)
		var/sound/S = sound(pick(longambient_type), repeat = TRUE, channel = CHANNEL_BUZZ, wait = FALSE, volume = 15)
		S.status = SOUND_STREAM
		SEND_SOUND(C.mob, S)
		C.played = TRUE

		if(C)
			var/list/sounds_list = C.SoundQuery()
			for(var/sound/playing_sound in sounds_list)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/area, reset_long_ambient_played), C), playing_sound.len * 10)
				break

/area/proc/reset_long_ambient_played(client/C)
	C?.played = FALSE
