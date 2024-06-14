/*Viral adaptation
 * Greatly increases stealth
 * Tremendous buff for resistance
 * Greatly decreases stage speed
 * No effect to transmissibility
 *
 * Bonus: Buffs resistance & stealth. Extremely useful for buffing viruses
*/
/datum/symptom/viraladaptation
	name = "Вирусная самоадаптация"
	desc = "Вирус имитирует функцию нормальных клеток организма, его становится труднее обнаружить и уничтожить, но его скорость замедляется."
	stealth = 3
	resistance = 5
	stage_speed = -3
	transmittable = 0
	level = 3

/*Viral evolution
 * Reduces stealth
 * Greatly reduces resistance
 * Tremendous buff for stage speed
 * Greatly increases transmissibility
 *
 * Bonus: Buffs transmission and speed. Extremely useful for buffing viruse*
*/
/datum/symptom/viralevolution
	name = "Ускорение вирусной эволюции"
	desc = "Вирус быстро приспосабливается к максимально быстрому распространению как снаружи, так и внутри хозяина. Это, однако, облегчает обнаружение вируса и снижает его способность бороться с лекарством."
	stealth = -2
	resistance = -3
	stage_speed = 5
	transmittable = 3
	level = 3
