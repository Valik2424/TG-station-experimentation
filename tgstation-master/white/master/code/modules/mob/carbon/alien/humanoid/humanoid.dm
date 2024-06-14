/mob/living/carbon/alien/humanoid
	var/custom_pixel_y_offset = 0
	var/custom_pixel_x_offset = 0

/mob/living/carbon/alien/humanoid/get_standard_pixel_y_offset(lying = 0)
	. = ..()
	if(leaping)
		. -= 32
	if(custom_pixel_y_offset)
		. += custom_pixel_y_offset

/mob/living/carbon/alien/humanoid/get_standard_pixel_x_offset(lying = 0)
	. = ..()
	if(leaping)
		. -= 32
	if(custom_pixel_x_offset)
		. += custom_pixel_x_offset
