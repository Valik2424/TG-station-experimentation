/datum/ert
	var/mobtype = /mob/living/carbon/human
	var/team = /datum/team/ert
	var/opendoors = TRUE
	var/leader_role = /datum/antagonist/ert/commander
	var/enforce_human = TRUE
	var/roles = list(/datum/antagonist/ert/security, /datum/antagonist/ert/medic, /datum/antagonist/ert/engineer) //List of possible roles to be assigned to ERT members.
	var/rename_team
	var/code
	var/mission = "Помочь станции."
	var/teamsize = 5
	var/polldesc
	/// If TRUE, gives the team members "[role] [random last name]" style names
	var/random_names = TRUE
	/// If TRUE, the admin who created the response team will be spawned in the briefing room in their preferred briefing outfit (assuming they're a ghost)
	var/spawn_admin = FALSE
	/// If TRUE, we try and pick one of the most experienced players who volunteered to fill the leader slot
	var/leader_experience = TRUE
	/// A custom map template to spawn the ERT at. If this is null or use_custom_shuttle is FALSE, the ERT will spawn at Centcom.
	var/datum/map_template/ert_template
	/// If we should actually _use_ the ert_template custom shuttle
	var/use_custom_shuttle = TRUE

/datum/ert/New()
	if (!polldesc)
		polldesc = "Специальном Отряде Быстрого Реагирования. Код: [code]"

/datum/ert/blue
	opendoors = FALSE
	code = "Синий"

/datum/ert/amber
	code = "Оранжевый"

/datum/ert/red
	leader_role = /datum/antagonist/ert/commander/red
	roles = list(/datum/antagonist/ert/security/red, /datum/antagonist/ert/medic/red, /datum/antagonist/ert/engineer/red)
	code = "Красный"

/datum/ert/deathsquad
	roles = list(/datum/antagonist/ert/deathsquad)
	leader_role = /datum/antagonist/ert/deathsquad/leader
	rename_team = "Эскадрон Смерти"
	code = "Дельта"
	mission = "Не оставляйте свидетелей."
	polldesc = "эскадроне смерти Nanotrasen"

/datum/ert/marine
	leader_role = /datum/antagonist/ert/marine
	roles = list(/datum/antagonist/ert/marine/security, /datum/antagonist/ert/marine/engineer, /datum/antagonist/ert/marine/medic)
	rename_team = "Marine Squad"
	polldesc = "спецназе Nanotrasen"
	opendoors = FALSE

/datum/ert/centcom_official
	code = "Инспекция"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/ert/official
	roles = list(/datum/antagonist/ert/official)
	rename_team = "Инспектор ЦК"
	polldesc = "инспектором Центрального Командования"
	random_names = FALSE
	leader_experience = FALSE

/datum/ert/centcom_official/New()
	mission = "Проведите плановую проверку состояния станции \"[station_name()]\" и её экипажа."

/datum/ert/inquisition
	roles = list(/datum/antagonist/ert/chaplain/inquisitor, /datum/antagonist/ert/security/inquisitor, /datum/antagonist/ert/medic/inquisitor)
	leader_role = /datum/antagonist/ert/commander/inquisitor
	rename_team = "Инквизиция"
	mission = "Уничтожьте все следы паранормальной активности на борту станции."
	polldesc = "группе реагирования на паранормальные явления Nanotrasen"

/datum/ert/janitor
	roles = list(/datum/antagonist/ert/janitor, /datum/antagonist/ert/janitor/heavy)
	leader_role = /datum/antagonist/ert/janitor/heavy
	teamsize = 4
	opendoors = FALSE
	rename_team = "Уборщик"
	mission = "Убери ВСЁ."
	polldesc = "группе специальных уборщиков Nanotrasen"

/datum/ert/intern
	roles = list(/datum/antagonist/ert/intern)
	leader_role = /datum/antagonist/ert/intern/leader
	teamsize = 7
	opendoors = FALSE
	rename_team = "Орда Интернов"
	mission = "Помочь в разрешении конфликтов."
	polldesc = "возможности неоплачиваемой стажировки в Nanotrasen"
	random_names = FALSE

/datum/ert/intern/unarmed
	roles = list(/datum/antagonist/ert/intern/unarmed)
	leader_role = /datum/antagonist/ert/intern/leader/unarmed
	rename_team = "Безоружная орда Интернов"

/datum/ert/erp
	roles = list(/datum/antagonist/ert/security/party, /datum/antagonist/ert/clown/party, /datum/antagonist/ert/engineer/party, /datum/antagonist/ert/janitor/party)
	leader_role = /datum/antagonist/ert/commander/party
	opendoors = FALSE
	rename_team = "ЕРП"
	mission = "Создайте развлечение для экипажа."
	polldesc = "группе партийного реагирования Nanotrasen. Код: Радужный"
	code = "Радужный"

/datum/ert/bounty_hunters
	roles = list(/datum/antagonist/ert/bounty_armor, /datum/antagonist/ert/bounty_hook, /datum/antagonist/ert/bounty_synth)
	leader_role = /datum/antagonist/ert/bounty_armor
	teamsize = 3
	opendoors = FALSE
	rename_team = "Охотники за головами"
	mission = "Помогайте станции ловить преступников, неважно живых или мёртвых."
	polldesc = "группе охотников за головами ЦК"
	random_names = FALSE
	ert_template = /datum/map_template/shuttle/ert/bounty

/datum/ert/militia
	roles = list(/datum/antagonist/ert/militia)
	leader_role = /datum/antagonist/ert/militia/general
	teamsize = 4
	opendoors = FALSE
	rename_team = "Полиция"
	mission = "Помочь станции в защите от врагов."
	polldesc = "группе милиции Nanotrasen"
	random_names = TRUE
