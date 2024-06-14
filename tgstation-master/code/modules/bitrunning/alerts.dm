/atom/movable/screen/alert/bitrunning
	name = "Generic Bitrunning Alert"
	icon_state = "template"
	timeout = 10 SECONDS

/atom/movable/screen/alert/bitrunning/netpod_crowbar
	name = "Вскрытие"
	desc = "Кто-то вскрывает дверь сетевого пода. Ищи выход."

/atom/movable/screen/alert/bitrunning/netpod_damaged
	name = "Нарушение целостности"
	desc = "Сетевой под повреждён. Ищи выход."

/atom/movable/screen/alert/bitrunning/qserver_shutting_down
	name = "Перезапуск домена"
	desc = "Домен перезапускается. Ищи выход."

/atom/movable/screen/alert/bitrunning/qserver_threat_deletion
	name = "Удаление из очереди"
	desc = "Сервер перезапускается. Забвение ждёт."

/atom/movable/screen/alert/bitrunning/qserver_threat_spawned
	name = "Угроза обнаружена"
	desc = "Наличие отклонений в потоке данных."

/atom/movable/screen/alert/bitrunning/qserver_domain_complete
	name = "Домен завершён"
	desc = "Домен завершён. Активируйте для выхода."
	timeout = 20 SECONDS

/atom/movable/screen/alert/bitrunning/qserver_domain_complete/Click(location, control, params)
	if(..())
		return

	var/mob/living/living_owner = owner
	if(!isliving(living_owner))
		return

	if(tgui_alert(living_owner, "Безопасно отключиться?", "Сообщение сервера", list("Выйти", "Остаться"), 10 SECONDS) == "Выйти")
		SEND_SIGNAL(living_owner, COMSIG_BITRUNNER_SAFE_DISCONNECT)
