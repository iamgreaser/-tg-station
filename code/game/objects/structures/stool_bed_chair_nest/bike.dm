/* A bike. Honk honk!
 *
 */
/obj/structure/stool/bed/chair/bike // Because you sit on it, but can also ride it around.
	name = "bike"
	desc = "A traditional method of transportation."
	icon = 'icons/obj/bike.dmi'
	icon_state = "main"
	anchored = 0

/obj/structure/stool/bed/chair/bike/Destroy()
	unbuckle()
	..()

/obj/structure/stool/bed/chair/bike/relaymove(mob/user, direction)
	var/wrongdir = turn(src.dir, 180) // Cannot instantly back onto yourself
	if(direction == wrongdir)
		return 0
	var/result = step(src,direction)
	return result

/obj/structure/stool/bed/chair/bike/buckle_mob(mob/M as mob, mob/user as mob)
	// Constraints are slightly different here.
	if (!ticker)
		user << "You can't put anyone on the [src] before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (get_dist(src, M) > 1) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) || M.anchored)
		return

	if (istype(M, /mob/living/carbon/slime) || istype(M, /mob/living/simple_animal/slime))
		user << "\The [M] is too squishy to place on the [src]."
		return

	unbuckle()

	if (M == usr)
		M.visible_message(\
			"<span class='notice'>[M.name] gets on [src]!</span>",\
			"You get on [src].",\
			"You hear a chain being pulled taut")
	else
		M.visible_message(\
			"<span class='notice'>[M.name] is placed on [src] by [user.name]!</span>",\
			"You are placed on [src] by [user.name].",\
			"You hear a chain being pulled taut")
	M.buckled = src
	M.anchored = anchored
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)

	afterbuckle(M)
	return