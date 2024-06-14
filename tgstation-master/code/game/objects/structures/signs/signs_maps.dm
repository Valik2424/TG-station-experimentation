//map and direction signs

/obj/structure/sign/map
	name = "карта станции"
	desc = "Навигационная карта станции. Кто это вообще рисовал?!"
	max_integrity = 500

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/directions/science
	name = "указатель РНД"
	desc = "Указатель направления, указывающий, в какой стороне находится отдел науки."
	icon_state = "direction_sci"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/science, 32)

/obj/structure/sign/directions/engineering
	name = "указатель инженерного отдела"
	desc = "Указатель направления, указывающий, в какой стороне находится инженерный отдел."
	icon_state = "direction_eng"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/engineering, 32)

/obj/structure/sign/directions/security
	name = "указатель отдела безопасности"
	desc = "Указатель направления, указывающий, в какой стороне находится служба безопасности."
	icon_state = "direction_sec"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/security, 32)

/obj/structure/sign/directions/medical
	name = "указатель медицинского отдела"
	desc = "Указатель направления, указывающий, в какой стороне находится медицинский отдел."
	icon_state = "direction_med"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/medical, 32)

/obj/structure/sign/directions/evac
	name = "указатель эвакуации"
	desc = "Указатель направления, указывающий, где находится док-станция эвакуационного шаттла."
	icon_state = "direction_evac"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/evac, 32)

/obj/structure/sign/directions/supply
	name = "указатель грузового отдела"
	desc = "Указатель направления, указывающий, где находится грузовой отсек."
	icon_state = "direction_supply"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/supply, 32)

/obj/structure/sign/directions/command
	name = "указатель командного управления"
	desc = "Указатель направления, указывающий, в какую сторону находится командный отдел."
	icon_state = "direction_bridge"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/command, 32)

/obj/structure/sign/directions/vault
	name = "указатель хранилища"
	desc = "Указатель направления, указывающий, где находится Хранилище станции."
	icon_state = "direction_vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/vault, 32)

/obj/structure/sign/directions/upload
	name = "указатель аплоада"
	desc = "Указатель направления, указывающий, в каком направлении находится аплоад ИИ."
	icon_state = "direction_upload"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/upload, 32)

/obj/structure/sign/directions/dorms
	name = "указатель дорм"
	desc = "A direction sign, pointing out which way the dormitories are."
	icon_state = "direction_dorms"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/dorms, 32)

/obj/structure/sign/directions/lavaland
	name = "указатель лаваленда"
	desc = "A direction sign, pointing out which way the hot stuff is."
	icon_state = "direction_lavaland"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/lavaland, 32)

/obj/structure/sign/directions/arrival
	name = "указатель прибытия"
	desc = "A direction sign, pointing out which way the arrivals shuttle dock is."
	icon_state = "direction_arrival"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/arrival, 32)
