/obj/item/encryptionkey
	name = "стандартный ключ шифрования"
	desc = "Ключ шифрования радиогарнитуры."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey_basic"
	w_class = WEIGHT_CLASS_TINY
	/// Can this radio key access the binary radio channel?
	var/translate_binary = FALSE
	/// Decrypts Syndicate radio transmissions.
	var/syndie = FALSE
	/// If true, the radio can say/hear on the special CentCom channel.
	var/independent = FALSE
	/// What channels does this encryption key grant to the parent headset.
	var/list/channels = list()
	var/datum/language/translated_language
	greyscale_config = /datum/greyscale_config/encryptionkey_basic
	greyscale_colors = "#820a16#3758c4"

/obj/item/encryptionkey/examine(mob/user)
	. = ..()
	if(LAZYLEN(channels) || translate_binary)
		var/list/examine_text_list = list()
		for(var/i in channels)
			examine_text_list += "[GLOB.channel_tokens[i]] - [lowertext(i)]"

		if(translate_binary)
			examine_text_list += "[GLOB.channel_tokens[MODE_BINARY]] - [MODE_BINARY]"

		. += "<hr><span class='notice'>Имеет доступ к следующим каналам; [jointext(examine_text_list, ", ")].</span>"

/obj/item/encryptionkey/syndicate
	name = "ключ шифрования синдиката"
	icon_state = "cypherkey_syndicate"
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	syndie = TRUE
	greyscale_config = /datum/greyscale_config/encryptionkey_syndicate
	greyscale_colors = "#171717#990000"

/obj/item/encryptionkey/binary
	name = "ключ бинарного транслятора"
	icon_state = "cypherkey_basic"
	translate_binary = TRUE
	translated_language = /datum/language/machine
	greyscale_config = /datum/greyscale_config/encryptionkey_basic
	greyscale_colors = "#24a157#3758c4"

/obj/item/encryptionkey/headset_sec
	name = "ключ шифрования безопасности"
	icon_state = "cypherkey_security"
	channels = list(RADIO_CHANNEL_SECURITY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_security
	greyscale_colors = "#820a16#280b1a"

/obj/item/encryptionkey/headset_eng
	name = "инженерный ключ шифрования"
	icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_ENGINEERING = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#f8d860#dca01b"

/obj/item/encryptionkey/headset_rob
	name = "ключ шифрования роботехников"
	icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_ENGINEERING = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#793a80#dca01b"

/obj/item/encryptionkey/headset_med
	name = "ключ шифрования медбея"
	icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_MEDICAL = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#69abd1"

/obj/item/encryptionkey/headset_sci
	name = "ключ шифрования научного отдела"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_SCIENCE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_research
	greyscale_colors = "#793a80#bc4a9b"

/obj/item/encryptionkey/headset_medsci
	name = "ключ шифрования медбея и научки"
	icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_MEDICAL = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#9d1de8"

/obj/item/encryptionkey/headset_srvsec
	name = "ключ шифрования закона и порядка"
	icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_SECURITY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#820a16#3bca5a"

/obj/item/encryptionkey/headset_srvmed
	name = "ключ шифрования психолога"
	icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_SERVICE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#ebebeb#3bca5a"

/obj/item/encryptionkey/headset_com
	name = "ключ шифрования командования"
	icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#67a552"

/obj/item/encryptionkey/heads/captain
	name = "ключ шифрования капитана"
	icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_ENGINEERING = 0, RADIO_CHANNEL_SCIENCE = 0, RADIO_CHANNEL_MEDICAL = 0, RADIO_CHANNEL_SUPPLY = 0, RADIO_CHANNEL_SERVICE = 0)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#dca01b"

/obj/item/encryptionkey/heads/rd
	name = "ключ шифрования научного руководителя"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_research
	greyscale_colors = "#bc4a9b#793a80"

/obj/item/encryptionkey/heads/hos
	name = "ключ шифрования начальника охраны"
	icon_state = "cypherkey_security"
	channels = list(RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_security
	greyscale_colors = "#280b1a#820a16"

/obj/item/encryptionkey/heads/ce
	name = "ключ шифрования старшего инженера"
	icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_ENGINEERING = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#dca01b#f8d860"

/obj/item/encryptionkey/heads/cmo
	name = "ключ шифрования старшего медицинского офицера"
	icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#2b2793"

/obj/item/encryptionkey/heads/hop
	name = "ключ шифрования главы персонала"
	icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#c2c1c9"

/obj/item/encryptionkey/heads/qm
	name = "ключ шифрования снабжения"
	icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#dca01b"

/obj/item/encryptionkey/headset_cargo
	name = "ключ шифрования снабжения"
	icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#7b3f2e"

/obj/item/encryptionkey/headset_mining
	name = "ключ шифрования шахтёров"
	icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_SCIENCE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#bc4a9b"

/obj/item/encryptionkey/headset_service
	name = "ключ шифрования сервиса"
	icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_SERVICE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#3758c4#3bca5a"

/obj/item/encryptionkey/headset_cent
	name = "ключ шифрования ЦК"
	icon_state = "cypherkey_centcom"
	independent = TRUE
	channels = list(RADIO_CHANNEL_CENTCOM = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_centcom
	greyscale_colors = "#24a157#dca01b"

/obj/item/encryptionkey/ai //ported from NT, this goes 'inside' the AI.
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_ENGINEERING = 1, RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_AI_PRIVATE = 1)

/obj/item/encryptionkey/ai/evil //ported from NT, this goes 'inside' the AI.
	name = "ключ бинарного транслятора синдиката"
	icon_state = "cypherkey_syndicate"
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	syndie = TRUE
	greyscale_config = /datum/greyscale_config/encryptionkey_syndicate
	greyscale_colors = "#171717#990000"

/obj/item/encryptionkey/secbot
	channels = list(RADIO_CHANNEL_AI_PRIVATE = 1, RADIO_CHANNEL_SECURITY = 1)
