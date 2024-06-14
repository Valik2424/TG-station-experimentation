/datum/dog_fashion
	///Name modifier for the dog that we're dressing up
	var/name = null
	///Description modifier for the dog that we're dressing up
	var/desc = null
	///Hearable emotes modifier for the dog that we're dressing up
	var/list/emote_hear = list()
	///Visible emotes modifier for the dog that we're dressing up
	var/list/emote_see = list()
	///Speech modifier for the dog that we're dressing up
	var/list/speak = list()
	///Speech verb modifier for the dog that we're dressing up
	var/list/speak_emote = list()

	// This isn't applied to the dog, but stores the icon_state of the
	// sprite that the associated item uses
	///Icon path for the fashion item
	var/icon_file = null
	///Icon state for the fashion item
	var/obj_icon_state = null
	///Alpha level (opacity) modifier of the fashion item
	var/obj_alpha
	///Color modifier of the fasion item
	var/obj_color

/datum/dog_fashion/New(mob/M)
	name = replacetext(name, "REAL_NAME", M.real_name)
	desc = replacetext(desc, "NAME", name)

///Applies the name, description and speak emote modifiers to the dog
/datum/dog_fashion/proc/apply(mob/living/basic/pet/dog/dressup_doggy)
	if(name)
		dressup_doggy.name = name
	if(desc)
		dressup_doggy.desc = desc
	if(length(speak_emote))
		dressup_doggy.speak_emote = string_list(speak_emote)

///Applies random speech modifiers to the dog
/datum/dog_fashion/proc/apply_to_speech(datum/ai_planning_subtree/random_speech/speech)
	if(length(emote_see))
		speech.emote_see = string_list(emote_see)
	if(length(emote_hear))
		speech.emote_hear = string_list(emote_hear)
	if(length(speak))
		speech.speak = string_list(speak)

/**
 * Generates the icon overlay for the equipped item
 * dir: passed direction for the sprite, e.g. to apply to a dead dog, we use the EAST dir and just flip it 180.
 */
/datum/dog_fashion/proc/get_overlay(dir)
	if(icon_file && obj_icon_state)
		var/image/corgI = image(icon_file, icon_state = obj_icon_state, dir = dir)
		corgI.alpha = obj_alpha
		corgI.color = obj_color
		return corgI


/datum/dog_fashion/head
	icon_file = 'icons/mob/simple/corgi_head.dmi'

/datum/dog_fashion/back
	icon_file = 'icons/mob/simple/corgi_back.dmi'

/datum/dog_fashion/back/armorvest
	obj_icon_state = "armor"

/datum/dog_fashion/back/deathsquad
	name = "Кавалерист REAL_NAME"
	desc = "Это не красная краска. Это настоящая кровь корги."

/datum/dog_fashion/head/helmet
	name = "Сержант REAL_NAME"
	desc = "Всегда верный, всегда бдительный."

/datum/dog_fashion/head/chef
	name = "Соусный шеф REAL_NAME"
	desc = "Ваша еда будет проверена на вкус. Да."

/datum/dog_fashion/head/captain
	name = "Капитан REAL_NAME"
	desc = "Наверное, лучше, чем последний капитан."

/datum/dog_fashion/head/kitty
	name = "Рантайм"
	emote_see = list("выкашливает клубок шерсти", "тянется")
	emote_hear = list("мурлычет")
	speak = list("Мурр", "Мяу!", "МИААААУ!", "ПШШШШШШШ", "МИИИИИУ")
	desc = "Это милый маленький котенок!... подождите... какого черта?"

/datum/dog_fashion/head/rabbit
	name = "Хоппи"
	emote_see = list("дергает носиком", "немного прыгает")
	desc = "Это Хоппи. Это корги... Урмм... кролик."

/datum/dog_fashion/head/beret
	name = "Янн"
	desc = "Mon dieu! C'est un chien!"
	speak = list("le-вуф!", "le-гаф!", "JAPPE!!")
	emote_see = list("в страхе.", "сдаётся.", "изображает мёртвого.","выглядит так, как будто перед ним стена.")

/datum/dog_fashion/head/detective
	name = "Детектив REAL_NAME"
	desc = "NAME видит меня насквозь..."
	emote_see = list("исследует область.","обнюхивает подсказки.","ищет вкусные закуски.","берет конфетку из шляпы.")

/datum/dog_fashion/head/nurse
	name = "Медсестра REAL_NAME"
	desc = "NAME требуется 100к стейка... СРОЧНО!"

/datum/dog_fashion/head/pirate
	name = "Пират"
	desc = "Яррррх!! Эта собака с цингой!"
	emote_see = list("охотится за сокровищами.","смотрит холодно...","скрежетает своими крошечными корги зубами!")
	emote_hear = list("свирепо рычит!", "огрызается.")
	speak = list("Аррргх!!","Гррррр!")

/datum/dog_fashion/head/pirate/New(mob/M)
	. = ..()
	name = "[pick("Ol'","Scurvy","Black","Rum","Gammy","Bloody","Gangrene","Death","Long-John")] [pick("kibble","leg","beard","tooth","poop-deck","Threepwood","Le Chuck","corsair","Silver","Crusoe")]"

/datum/dog_fashion/head/ushanka
	name = "Котлетки будут завтра"
	desc = "Последователь Карла Баркса."
	emote_see = list("рассматривает недостатки капиталистической экономической модели.", "обдумывает плюсы и минусы авангардизма.")

/datum/dog_fashion/head/ushanka/New(mob/M)
	name = "[pick("Comrade","Commissar","Glorious Leader")] REAL_NAME"
	return ..()

/datum/dog_fashion/head/warden
	name = "Офицер REAL_NAME"
	emote_see = list("пускает слюни.","ищет пончики.")
	desc = "Stop right there criminal scum!"

/datum/dog_fashion/head/warden_red
	name = "Офицер REAL_NAME"
	emote_see = list("пускает слюни.","ищет пончики.")
	desc = "Stop right there criminal scum!"

/datum/dog_fashion/head/blue_wizard
	name = "Великий Волшебник REAL_NAME"
	speak = list("ЯП", "Вуф!", "Гав!", "АУУУУУ", "ЭЙ, НАХ!")

/datum/dog_fashion/head/red_wizard
	name = "Пиромансер REAL_NAME"
	speak = list("ЯП", "Вуф!", "Гав!", "АУУУУУ", "СОСНИ СОМА!")

/datum/dog_fashion/head/cardborg
	name = "Борги"
	speak = list("Пинг!","Бип!","Вуф!")
	emote_see = list("суетится.", "вынюхивает нелюдей.")
	desc = "Результат сокращения бюджета робототехники."

/datum/dog_fashion/head/ghost
	name = "Призрак"
	speak = list("ВуууУУУуууу~","АУУУУУУУУУУУУУУУУУУУУУУ")
	emote_see = list("спотыкается вокруг.", "дрожит.")
	emote_hear = list("воет!","стонет.")
	desc = "Жуткий!"
	obj_icon_state = "sheet"

/datum/dog_fashion/head/santa
	name = "Помощник Санты"
	emote_hear = list("лает рождественские песни.", "весело тявкает!")
	emote_see = list("ищет подарки.", "проверяет его список.")
	desc = "Он очень любит молоко и печенье."

/datum/dog_fashion/head/cargo_tech
	name = "Грузорги REAL_NAME"
	desc = "Причина, по которой у ваших желтых перчаток есть жевательные метки."

/datum/dog_fashion/head/reindeer
	name = "Красноносый корги REAL_NAME"
	emote_hear = list("освещает путь!", "подсвечивается.", "тявкает!")
	desc = "У него очень блестящий нос."

/datum/dog_fashion/head/sombrero
	name = "Старейшина REAL_NAME"
	desc = "Нужно уважать его."

/datum/dog_fashion/head/hop
	name = "Лейтенант REAL_NAME"
	desc = "На самом деле можно доверять, чтобы он не сбежал сам по себе."

/datum/dog_fashion/head/deathsquad
	name = "Кавалерист REAL_NAME"
	desc = "Это не красная краска. Это настоящая кровь корги."

/datum/dog_fashion/head/clown
	name = "Клоун REAL_NAME"
	desc = "Лучший друг хонкающего человека"
	speak = list("ХОНК!", "Хонк!")
	emote_see = list("трюкачит.", "скользит.")

/datum/dog_fashion/head/festive
	name = "Праздничный REAL_NAME"
	desc = "Готов к вечеринке!"
	obj_icon_state = "festive"

/datum/dog_fashion/head/pumpkin/unlit
	name = "Headless HoP-less REAL_NAME"
	desc = "A spooky dog spirit of a beloved pet who lost their owner."
	obj_icon_state = "pumpkin0"
	speak = list("BOO!", "AUUUUUUU", "RAAARGH!")
	emote_see = list("shambles around.", "yaps ominously.", "shivers.")
	emote_hear = list("howls at the Moon.", "yaps at the crows!")

/datum/dog_fashion/head/pumpkin/lit
	obj_icon_state = "pumpkin1"

/datum/dog_fashion/head/blumpkin/unlit
	name = "Hue-less Headless HoP-less REAL_NAME"
	desc = "An evil dog spirit of a beloved pet that haunts your treats pantries!"
	obj_icon_state = "blumpkin0"
	speak = list("BOO!", "AUUUUUUU", "RAAARGH!")
	emote_see = list("shambles around.", "yaps ominously.", "shivers.")
	emote_hear = list("howls at the Moon.", "yaps at the crows!", "growls eerily!")

/datum/dog_fashion/head/blumpkin/lit
	obj_icon_state = "blumpkin1"

/datum/dog_fashion/head/butter
	name = "Butter REAL_NAME"
	desc = "REAL_NAME. REAL_NAME with the butter. REAL_NAME. REAL_NAME with a butter on 'em."
	obj_icon_state = "butter"
	speak = list() //they're very patient and focused on holding the butter on 'em
	emote_see = list("shakes a little.", "looks around.")
	emote_hear = list("licks a trickle of the butter up.", "smiles.")

/datum/dog_fashion/head/eyepatch
	name = "Punished REAL_NAME"
	desc = "REAL_NAME has really been going through it today."
	obj_icon_state = "eyepatch"
	emote_hear = list("sighs gruffly.", "groans.")
	emote_see = list("considers their own mortality.", "stares bleakly into the middle distance.", "ponders the horrors of warfare.")
