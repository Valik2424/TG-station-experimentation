// Quantum server

/obj/item/circuitboard/machine/quantum_server
	name = "Quantum Server"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/quantum_server
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/capacitor = 1,
	)

/**
 * quantum server design
 * are you absolutely sure??
 */

// Netpod

/obj/item/circuitboard/machine/netpod
	name = "Сетевой под"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/netpod
	req_components = list(
		/datum/stock_part/servo = 1,
		/datum/stock_part/matter_bin = 2,
	)

/datum/design/board/netpod
	name = "Плата сетевого пода"
	desc = "Печатная плата для сетевого пода."
	id = "netpod"
	build_path = /obj/item/circuitboard/machine/netpod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

// Quantum console

/obj/item/circuitboard/computer/quantum_console
	name = "Квантовая консоль"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/quantum_console

/datum/design/board/quantum_console
	name = "Печатная плата квантовой консоли"
	desc = "Позволяет создавать печатные платы, используемые для сборки квантовой консоли."
	id = "quantum_console"
	build_path = /obj/item/circuitboard/computer/quantum_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

// Byteforge

/obj/item/circuitboard/machine/byteforge
	name = "Бинарная кузня"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/byteforge
	req_components = list(
		/datum/stock_part/micro_laser = 1,
	)

/datum/design/board/byteforge
	name = "Печатная плата бинарной кузни"
	desc = "Позволяет создавать печатные платы, используемые для сборки бинарной кузни"
	id = "byteforge"
	build_path = /obj/item/circuitboard/machine/byteforge
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING


/datum/techweb_node/bitrunning
	id = "bitrunning"
	display_name = "Технология Виртуальных Доменов"
	description = "Блюспейс технология позволила расширить возможности квантовых вычислений, которые, в свою очередь, \
	открывают возможности для материализации атомных структур при выполнении передовых программ.."
	prereq_ids = list("practical_bluespace")
	design_ids = list(
		"byteforge",
		"quantum_console",
		"netpod",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
