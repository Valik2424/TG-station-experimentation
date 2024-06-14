/obj/item/book/granter/crafting_recipe
	/// A list of all recipe types we grant on learn
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		var/datum/crafting_recipe/recipe = locate(crafting_recipe_type) in GLOB.crafting_recipes + GLOB.cooking_recipes
		to_chat(user, span_notice("Теперь я знаю, как создать [recipe.name]."))

/obj/item/book/granter/crafting_recipe/dusting
	icon_state = "book1"

/obj/item/book/granter/crafting_recipe/dusting/recoil(mob/living/user)
	to_chat(user, span_warning("Книга рассыпалась в пыль в моих руках."))
	qdel(src)
