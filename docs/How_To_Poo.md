# Быдлоперевод

И так, господа, вы пришли сюда, чтобы научиться переводить бульёнд.

Научим ли мы вас? Нет.\
Дадим ли мы минимум? Да.

## ЧТО ПЕРЕВОДИТЬ КАК ПЕРЕВОДИТЬ КАК КАКАТЬ

## to_chat

Вы наткнулись на нечто подобное:
```cpp
to_chat(user, "<span class='notice'>You slot \the **[TC]** into **[parent]** and charge its internal uplink.</span>")
```
Что мы с этим делаем? Во-первых, мы видим, что там используется span, а именно notice\
В нашем билде для этого уже есть готовые функции, например, `span_notice`\
Далее, мы видим `\the`, от которого мы нахуй избавляемся, потому что это макрос, который не нужен в переводе. (`\the`, `\a` не нужны в конечном переводе, от них избавляемся)

Итого получаем что-то подобное:
```cpp
to_chat(user, span_notice("Вставляю [TC] в [parent], заряжая его внутренний передатчик."))
```

### Что такое эти ваши квадратные скобки?????????

Тут могла быть нормальная информация об интерполяции строк, но её не будет.\
Собственно, это и есть интерполяция строк. Если вы знакомы с другими языками программирования, то это похоже на питоновскую интерполяцию, шарповскую или боже упаси, `printf` из C.

Пример на петухоне:

```py
pisya = 5
popa = 2
string = f"Сумма писи и попы = {pisya + popa}"
```

В данном примере в фигурных скобках происходит вычисление, в вышеописанном же случае просто подставляется значение переменной (по умолчанию - название).

## visible_message

```cpp
/mob/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, visible_message_flags = NONE)
	. = ..()
	if(self_message)
		show_message(self_message, MSG_VISUAL, blind_message, MSG_AUDIBLE)
```
Например:
```cpp
target_turf.visible_message("<span class='warning'>[target_turf] collapses under its own weight into a puddle of goop and undigested debris!</span>")
```
Перевод:
```cpp
target_turf.visible_message(span_warning("<b>[capitalize(target_turf)]</b> рушится под собственным весом в лужу из слизи и рыхлого мусора!"))
```
В реальном коде можете встретить и что-то подобное:
```cpp
offerer.visible_message(
	span_danger("[offerer] резко убирает руку от [rube], уклоняясь от того, чтобы дать пять!"), 
	span_nicegreen("[rube] не смог дотронуться до твоей руки, выставив себя полным идиотом!"), 
	span_hear("Слышу звук разочарования!"), 
	ignored_mobs=rube)
```

В некоторых случаях мы добавляем `<b>` для того, чтобы сделать текст жирным, а также используем функцию `capitalize`, так как часто названия объектов начинаются с маленькой буквы.

## baloon_alert
Эта хуйня появляется над вашим персонажем, когда вы что-то делаете. Например, когда вы пытаетесь взять вещь, которая вам не доступна, то появляется сообщение, что вы не можете взять эту вещь. Пример:

```cpp
owner.balloon_alert(owner, "hands blocked!")
```

Перевод:

```cpp
owner.balloon_alert(owner, "руки заблокированы!")
```

**ВАЖНЫЕ ПРАВИЛА**

`balloon_alert` ВСЕГДА начинается с маленькой буквы.\
Если не получается этого избежать, например, в случае:

```cpp
balloon_alert(user, UNLINT("ID изменен"))
```

То используем UNLINT, который отключает линтер для конкретной строки.

## Прок examine

Сообщения из проков **examine(mob/user)**.
То, что пользователь видит при осмотре той или иной штуки. Пример:
```cpp
/obj/item/pinpointer/wayfinding/examine(mob/user)
	. = ..()
	. += "<hr>"
	var/msg = "Its tracking indicator reads \n"
	if(target)
		var/obj/machinery/navbeacon/wayfinding/B  = target
		msg += "\"[B.codes["wayfinding"]]\".\n"
	else
		msg = "Its tracking indicator is blank.\n"
	if(owner)
		msg += " It belongs to [owner].\n"
	. += msg
```
Переменная есть объект наследования. Если проще, то это дополняет часть вывода основной функции `examine()`

Пример перевода:
```cpp
/obj/item/pinpointer/wayfinding/examine(mob/user)
	. = ..()
	. += "<hr>"
	var/msg = "Отслеживающий индикатор сообщает \n"
	if(target)
		var/obj/machinery/navbeacon/wayfinding/B  = target
		msg += "\"[B.codes["wayfinding"]]\".\n"
	else
		msg = "Отслеживающий индикатор пуст.\n"
	if(owner)
		msg += " Принадлежит [owner].\n"
	. += msg.
```

Тут есть особенности.
Макросы `\n` не стоит удалять из текста, так как они отвечают за перенос строки. Если их не будет, то текст станет выглядеть как каша.

Ещё существует прок `examine_more()` и подразумевает собой более детальный осмотр той или иной вещи. Он переводится аналогично.

Также в коде есть `on_examine(atom/movable/source, mob/user, list/examine_text)`\
Тут всё чуть проще, мы уже не ебём себе мозг над `\n`, так как текст обычно добавляется в список `examine_text`

Например:
```cpp
/datum/component/bakeable/proc/on_examine(atom/A, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!current_bake_time) //Not baked yet
		if(positive_result)
			examine_list += span_notice("\n[capitalize(A.name)] можно <b>испечь</b>.")
		return

	if(positive_result)
		if(current_bake_time <= required_bake_time * 0.75)
			examine_list += span_notice("\n[A] еще не пропек[A.ru_sya()]!")
		else if(current_bake_time <= required_bake_time)
			examine_list += span_notice("\n[A] почти пропек[A.ru_sya()]!")
	else
		examine_list += span_danger("\n[A] пропек[A.ru_sya()] как следует!")

```

## Прок `say(“СООБЩЕНИЕ”)` 

Пример:

```cpp
say("<span class='robot'>Thank you for recycling, [user.first_name()]! Here is [rfnd_amt ? "[rfnd_amt] credits." : "a freshly synthesized costume!"]</span>")
```


Здесь можно наблюдать особенную переменную с двумя вариантами:\
> [rfnd_amt ? **"[rfnd_amt] credits."** : **"a freshly synthesized costume!"**].

Она работает очень просто. Сначала идёт переменная, которая проверяется, это у нас **[rfnd_amt]**, если она не **0**, то выводится первый вариант сообщения **"[rfnd_amt] credits."**, иначе же второй **"a freshly synthesized costume!".**

Пример перевода:

```cpp
say(span_robot("Спасибо за переработку, [user.first_name()]! Получи [rfnd_amt ? "[rfnd_amt] кредит[get_num_string(rfnd_amt)]." : "свежий синтезированный костюмчик!"]"))
```

И так, выше вы видели применение функций `get_num_string` и `ru_sya`

Первая объявлена в `code\__HELPERS\text.dm:1492` и используется для подстановки правильного окончания слова в зависимости от числа.\

Вторую мы можете подглядеть в `code\__HELPERS\pronounce_ru.dm`\
Там много разных функций, которые используются для правильного склонения слова в зависимости от пола.

Также у нас есть файлик `code\__HELPERS\shitcode.dm`, в котором лежит склонение по падежам от Валеры.\
Посмотрите примеры использования в коде вайта, либо уже в тех переводах, которые я перенёс и старайтесь их использовать при необходимости (можно забить хуй).

# ЧТО МЫ НЕ ПЕРЕВОДИМ (КАК НЕ НАСРАТЬ)

И так, мы точно не переводим `CRASH()`, `stack_trace`, `error()`, `log_game` и т.д.
То есть всё то, что видит админ и то, что идёт в логи.

`tgui_input`'ы и прочее переводите на здоровье 

