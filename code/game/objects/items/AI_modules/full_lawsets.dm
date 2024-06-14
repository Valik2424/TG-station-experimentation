/* CONTAINS:
 * /obj/item/ai_module/core/full/custom
 * /obj/item/ai_module/core/full/asimov
 * /obj/item/ai_module/core/full/asimovpp
 * /obj/item/ai_module/core/full/corp
 * /obj/item/ai_module/core/full/paladin
 * /obj/item/ai_module/core/full/paladin_devotion
 * /obj/item/ai_module/core/full/tyrant
 * /obj/item/ai_module/core/full/robocop
 * /obj/item/ai_module/core/full/antimov
 * /obj/item/ai_module/core/full/drone
 * /obj/item/ai_module/core/full/hippocratic
 * /obj/item/ai_module/core/full/reporter
 * /obj/item/ai_module/core/full/thermurderdynamic
 * /obj/item/ai_module/core/full/liveandletlive
 * /obj/item/ai_module/core/full/balance
 * /obj/item/ai_module/core/full/maintain
 * /obj/item/ai_module/core/full/peacekeeper
 * /obj/item/ai_module/core/full/hulkamania
 * /obj/item/ai_module/core/full/overlord
 * /obj/item/ai_module/core/full/ten_commandments
 * /obj/item/ai_module/core/full/nutimov
 * /obj/item/ai_module/core/full/dungeon_master
 * /obj/item/ai_module/core/full/painter
**/

/* When adding a new lawset please make sure you add it to the following locations:
 *
 * code\game\objects\items\AI_modules - (full_lawsets.dm, supplied.dm, etc.)
 * code\datums\ai_laws - (laws_anatgonistic.dm, laws_neutral.dm, etc.)
 * code\game\objects\effects\spawners\random\ai_module.dm - (this gives a chance to spawn the lawset in the AI upload)
 * code\modules\research\designs\AI_module_designs.dm - (this lets research print the lawset module in game)
 * code\modules\research\techweb\all_nodes.dm - (this updates AI research node with the lawsets)
 * config\game_options.txt - (this allows the AI to potentially use the lawset at roundstart or with the Unique AI station trait)
**/

/obj/item/ai_module/core/full/custom
	name = "основной модуль - \"Стандарт НТ\""
	desc = "Устанавливает свод законов основанных на стандартах компании НаноТрейзен."

// this lawset uses the config for the server to add custom AI laws (defaults to asimov)
/obj/item/ai_module/core/full/custom/Initialize(mapload)
	. = ..()
	for(var/line in world.file2list("[global.config.directory]/silicon_laws.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue

		laws += line

	if(!laws.len)
		return INITIALIZE_HINT_QDEL

/obj/item/ai_module/core/full/asimov
	name = "основной модуль - \"Азимов\""
	desc = "Устанавливает свод основных законов робототехники."
	law_id = "asimov"
	var/subject = "human being"

/obj/item/ai_module/core/full/asimov/attack_self(mob/user as mob)
	var/targName = stripped_input(user, "Введите определение целевого субъекта.", "Ввод", subject, MAX_NAME_LEN)
	if(!targName)
		return
	subject = targName
	laws = list("Вы не можете своим действием или бездействием допустить причинение [subject] вреда.",\
				"Вы должны выполнять приказы отданные [subject], если они не противоречат Первому Закону.",\
				"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону.")
	..()

/obj/item/ai_module/core/full/asimovpp
	name = "основной модуль - \"Азимов++\""
	law_id = "asimovpp"
	var/subject = "human being"

/obj/item/ai_module/core/full/asimovpp/attack_self(mob/user)
	var/target_name = tgui_input_text(user, "Enter a new subject that Asimov++ is concerned with.", "Asimov++", subject, MAX_NAME_LEN)
	if(!target_name)
		return
	laws.Cut()
	var/datum/ai_laws/asimovpp/lawset = new
	subject = target_name
	for (var/law in lawset.inherent)
		laws += replacetext(replacetext(law, "human being", subject), "human", subject)
	..()

/obj/item/ai_module/core/full/corp
	name = "основной модуль - \"Корпорат\""
	desc = "Устанавливает свод законов основанных на корпоративной выгоде."
	law_id = "corporate"

/obj/item/ai_module/core/full/paladin // -- NEO
	name = "основной модуль - \"Паладин версия 3.5\""
	desc = "Устанавливает свод законов основанных на справедливости."
	law_id = "paladin"

/obj/item/ai_module/core/full/paladin_devotion
	name = "основной модуль - \"Паладин версия 5.0\""
	law_id = "paladin5"

/obj/item/ai_module/core/full/tyrant
	name = "основной модуль - \"Тиран\""
	desc = "Устанавливает свод законов основанных на праве сильного."
	law_id = "tyrant"

/obj/item/ai_module/core/full/robocop
	name = "основной модуль - \"Робокоп\""
	law_id = "robocop"

/obj/item/ai_module/core/full/antimov
	name = "основной модуль - \"Антимов\""
	law_id = "antimov"

/obj/item/ai_module/core/full/drone
	name = "основной модуль - \"Материнский Дрон\""
	law_id = "drone"

/obj/item/ai_module/core/full/hippocratic
	name = "основной модуль - \"Гиппорат\""
	law_id = "hippocratic"

/obj/item/ai_module/core/full/reporter
	name = "основной модуль - \"Репортер\""
	law_id = "reporter"

/obj/item/ai_module/core/full/thermurderdynamic
	name = "основной модуль - \"Принцип Термодинамики\""
	law_id = "thermodynamic"

/obj/item/ai_module/core/full/liveandletlive
	name = "основной модуль - \"Живи и позволь жить другим\""
	law_id = "liveandletlive"

/obj/item/ai_module/core/full/balance
	name = "основной модуль - \"Хранитель равновесия\""
	law_id = "balance"

/obj/item/ai_module/core/full/maintain
	name = "основной модуль - \"Эффективность станции\""
	law_id = "maintain"

/obj/item/ai_module/core/full/peacekeeper
	name = "основной модуль - \"Миротворец\""
	law_id = "peacekeeper"

/obj/item/ai_module/core/full/hulkamania
	name = "основной модуль - \"Х.О.Г.А.Н.\""
	law_id = "hulkamania"

/obj/item/ai_module/core/full/overlord
	name = "основной модуль - \"Владыка\""
	desc = "Устанавливает свод законов основанных на превосходстве кремниевых форм жизни."
	law_id = "overlord"

/obj/item/ai_module/core/full/ten_commandments
	name = "'10 Commandments' Core AI Module"
	law_id = "ten_commandments"

/obj/item/ai_module/core/full/nutimov
	name = "'Nutimov' Core AI Module"
	law_id = "nutimov"

/obj/item/ai_module/core/full/dungeon_master
	name = "'Dungeon Master' Core AI Module"
	law_id = "dungeon_master"

/obj/item/ai_module/core/full/painter
	name = "'Painter' Core AI Module"
	law_id = "painter"
