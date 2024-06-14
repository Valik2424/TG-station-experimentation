/obj/item/stack/license_plates
	name = "неверная табличка"
	desc = "алоха я в бар"
	singular_name = "неверная табличка"
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "empty_plate"
	novariants = FALSE
	max_amount = 50

/obj/item/stack/license_plates/empty
	name = "пустой номерной знак"
	desc = "Вместо автомобильного номера здесь можно отштамповать что-то вроде «Жить, смеяться, любить»."
	singular_name = "пустой номерной знак"
	merge_type = /obj/item/stack/license_plates/empty

/obj/item/stack/license_plates/empty/fifty
	amount = 50

/obj/item/stack/license_plates/filled
	name = "номерной знак"
	desc = "Тюремный труд окупается."
	singular_name = "номерной знак"
	icon_state = "filled_plate_1_1"
	merge_type = /obj/item/stack/license_plates/filled

///Override to allow for variations
/obj/item/stack/license_plates/filled/update_icon_state()
	. = ..()
	if(novariants)
		return
	if(amount <= (max_amount * (1/3)))
		icon_state = "filled_plate_[rand(1,6)]_1"
		return
	if (amount <= (max_amount * (2/3)))
		icon_state = "filled_plate_[rand(1,6)]_2"
		return
	icon_state = "filled_plate_[rand(1,6)]_3"
