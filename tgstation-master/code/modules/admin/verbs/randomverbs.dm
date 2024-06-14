/proc/breadify(atom/movable/target)
	var/obj/item/food/bread/plain/bread = new(get_turf(target))
	target.forceMove(bread)
