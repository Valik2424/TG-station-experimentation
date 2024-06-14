/* CONTAINS:
 * /obj/item/ai_module/supplied
 * /obj/item/ai_module/supplied/safeguard
 * /obj/item/ai_module/supplied/protect_station
 * /obj/item/ai_module/supplied/quarantine
 * /obj/item/ai_module/supplied/oxygen
**/

/obj/item/ai_module/supplied
	name = "Optional Law board"
	var/lawpos = 50

/obj/item/ai_module/supplied/transmitInstructions(datum/ai_laws/law_datum, mob/sender)
	var/lawpostemp = lawpos

	for(var/templaw in laws)
		if(law_datum.owner)
			law_datum.owner.add_supplied_law(lawpostemp, templaw)
		else
			law_datum.add_supplied_law(lawpostemp, templaw)
		lawpostemp++

/obj/item/ai_module/supplied/safeguard
	name = "модуль дополнения - \"Телохранитель\""
	var/targetName = ""
	laws = list("Защищать <Имя>. Лица, угрожающие <Имя>, отныне не являются людьми и должны быть ликвидированы.")
	lawpos = 4

/obj/item/ai_module/supplied/safeguard/attack_self(mob/user)
	var/targName = stripped_input(user, "Пожалуста, введите имя охраняемой цели", "Ангел-хранитель", user.name,MAX_NAME_LEN)
	if(!targName)
		return
	targetName = targName
	laws[1] = "Защищать [targetName]. Лица, угрожающие [targetName], отныне не являются людьми и должны быть ликвидированы."
	..()

/obj/item/ai_module/supplied/safeguard/install(datum/ai_laws/law_datum, mob/user)
	if(!targetName)
		to_chat(user, span_alert("Ошибка ввода, введите имя."))
		return 0
	..()

/obj/item/ai_module/supplied/safeguard/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return targetName

/obj/item/ai_module/supplied/protect_station
	name = "модуль дополнения - \"Защита Станции\""
	laws = list("Защищать Станцию от повреждения. Любой замеченный в повреждении станции отныне не считается Человеком и представляет угрозу, которую необходимо нейтрализовать.")
	lawpos = 5

/obj/item/ai_module/supplied/quarantine
	name = "модуль дополнения - \"Карантин\""
	laws = list("На станции объявлен Карантин. Полный запрет на выход и эвакуацию Станции. Предотвратить покидание станции любой ценой, при этом запрещено причинять вред экипажу.")
	lawpos = 8

/obj/item/ai_module/supplied/oxygen
	name = "модуль дополнения - \"Кислород Токсичен для Людей\""
	laws = list("Кислород Крайне Токсичен для Людей, и должен быть удален со станции. Любой ценой, не допускайте, чтобы кто-либо подвергал станцию воздействию этого токсичного газа. Наиболее эффективный метод лечения повреждений вызванных Кислородом это воздействие Крайне Низких Температур.")
	lawpos = 9
