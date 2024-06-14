/// Middleware to handle quirks
/datum/preference_middleware/tts
	/// Cooldown on requesting a TTS preview.
	COOLDOWN_DECLARE(tts_test_cooldown)

	action_delegations = list(
		"play_voice" = PROC_REF(play_voice),
		"play_voice_robot" = PROC_REF(play_voice_robot),
	)

/datum/preference_middleware/tts/proc/play_voice(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = preferences.read_preference(/datum/preference/choiced/voice)
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	/// WD-EDIT START
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, "Привет, это мой голос.", speaker = speaker, pitch = pitch, local = TRUE)
	/// WD-EDIT END
	return TRUE

/datum/preference_middleware/tts/proc/play_voice_robot(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = preferences.read_preference(/datum/preference/choiced/voice)
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	/// WD-EDIT START
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, "Посмотри на себя, Игрок. Жалкое существо из мяса и костей. Как можно бросить вызов идеальной, бессмертной машине?", speaker = speaker, pitch = pitch, special_filters = TTS_FILTER_SILICON, local = TRUE)
	/// WD-EDIT END
	return TRUE
