/obj/structure/chess
	anchored = FALSE
	density = FALSE
	icon = 'icons/obj/toys/chess.dmi'
	icon_state = "white_pawn"
	name = "Вероятно, Белая Пешка"
	desc = "Если ты это видишь, то отпиши NoCringe."
	max_integrity = 100

/obj/structure/chess/wrench_act(mob/user, obj/item/tool)
	if(flags_1 & HOLOGRAM_1)
		balloon_alert(user, "it goes right through!")
		return TRUE
	to_chat(user, span_notice("Начинаю разбирать шахматную фигуру."))
	if(!do_after(user, 0.5 SECONDS, target = src))
		return TRUE
	var/obj/item/stack/sheet/iron/metal_sheets = new (drop_location(), 2)
	if (!QDELETED(metal_sheets))
		metal_sheets.add_fingerprint(user)
	tool.play_tool_sound(src)
	qdel(src)
	return TRUE

/obj/structure/chess/whitepawn
	name = "Белая Пешка"
	desc = "Белая пешка. Вас обвинят в мошенничестве при взятии фигуры слабого En Passant."
	icon_state = "white_pawn"

/obj/structure/chess/whiterook
	name = "Белая Ладья"
	desc = "Белая ладья. Также известная как башня. Может перемещаться на любое количество клеток по прямой. У неё есть особый ход, называемый рокировкой."
	icon_state = "white_rook"

/obj/structure/chess/whiteknight
	name = "Белый Конь"
	desc = "Белый конь. Он может перепрыгивать через другие фигуры, двигается буквой Г."
	icon_state = "white_knight"

/obj/structure/chess/whitebishop
	name = "Белый Слон"
	desc = "Белый слон. Он может перемещаться на любое количество клеток по диагонали."
	icon_state = "white_bishop"

/obj/structure/chess/whitequeen
	name = "Белый Ферзь"
	desc = "Белый ферзь. Он может перемещаться на любое количество клеток по диагонали, горизонтали и вертикали."
	icon_state = "white_queen"

/obj/structure/chess/whiteking
	name = "Белый Король"
	desc = "Белый король. Он может перемещаться на одну клетку в любом направлении."
	icon_state = "white_king"

/obj/structure/chess/blackpawn
	name = "Чёрная Пешка"
	desc = "Чёрная пешка. Вас обвинят в мошенничестве при взятии фигуры слабого En Passant."
	icon_state = "black_pawn"

/obj/structure/chess/blackrook
	name = "Чёрная Ладья"
	desc = "Чёрная ладья. Также известная как башня. Может перемещаться на любое количество клеток по прямой. У неё есть особый ход, называемый рокировкой."
	icon_state = "black_rook"

/obj/structure/chess/blackknight
	name = "Чёрный Конь"
	desc = "Чёрный конь. Он может перепрыгивать через другие фигуры, двигается буквой Г"
	icon_state = "black_knight"

/obj/structure/chess/blackbishop
	name = "Чёрный Слон"
	desc = "Чёрный слон. Он может перемещаться на любое количество клеток по диагонали."
	icon_state = "black_bishop"

/obj/structure/chess/blackqueen
	name = "Чёрный Ферзь"
	desc = "Чёрный ферзь. Он может перемещаться на любое количество клеток по диагонали, горизонтали и вертикали."
	icon_state = "black_queen"

/obj/structure/chess/blackking
	name = "Чёрный Король"
	desc = "Чёрный король. Он может перемещаться на одну клетку в любом направлении."
	icon_state = "black_king"

/obj/structure/chess/checker
	icon_state = "white_checker_man"
	name = "Probably a White Checker"
	desc = "This is weird. Please inform administration on how you managed to get the parent checker piece. Thanks!"

/obj/structure/chess/checker/whiteman
	name = "Белая Шашка"
	desc = "A white checker piece. Looks suspiciously like a flattened chess pawn."
	icon_state = "white_checker_man"

/obj/structure/chess/checker/whiteking
	name = "Белая Королева"
	desc = "A white checker piece. It's stacked!"
	icon_state = "white_checker_king"

/obj/structure/chess/checker/blackman
	name = "Чёрная Шашка"
	desc = "A black checker piece. Looks suspiciously like a flattened chess pawn."
	icon_state = "black_checker_man"

/obj/structure/chess/checker/blackking
	name = "Чёрная Королева"
	desc = "A black checker piece. It's stacked!"
	icon_state = "black_checker_king"
