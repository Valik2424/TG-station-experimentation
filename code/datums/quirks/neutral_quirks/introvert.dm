/datum/quirk/introvert
	name = "Интроверт"
	desc = "Не люблю общаться с людьми, но люблю читать книги."
	icon = FA_ICON_BOOK_READER
	value = 0
	mob_trait = TRAIT_INTROVERT
	gain_text = span_notice("Хочу почитать книжку.")
	lose_text = span_danger("Библиотеки скучны.")
	medical_record_text = "Пациент не любит общаться."
	mail_goodies = list(/obj/item/book/random)
