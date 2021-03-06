/datum/targetable/vampire/glare
	name = "Glare"
	desc = "Stuns one target for a short time. Blocked by eye protection."
	targeted = 1
	target_nodamage_check = 1
	max_range = 2
	cooldown = 600
	pointCost = 0
	when_stunned = 1
	not_when_handcuffed = 0
	sticky = 1

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M || !target || !ismob(target))
			return 1

		if (M == target)
			boutput(M, __red("Why would you want to stun yourself?"))
			return 1

		if (get_dist(M, target) > src.max_range)
			boutput(M, __red("[target] is too far away."))
			return 1

		if (target.stat == 2)
			boutput(M, __red("It would be a waste of time to stun the dead."))
			return 1

		if (!M.sight_check(1))
			boutput(M, __red("How do you expect this to work? You can't use your eyes right now."))
			M.visible_message("<span style=\"color:red\">What was that? There's something odd about [M]'s eyes.</span>")
			return 0 // Cooldown because spam is bad.

		M.visible_message("<span style=\"color:red\"><B>[M]'s eyes emit a blinding flash at [target]!</B></span>")

		if (target.bioHolder && target.bioHolder.HasEffect("training_chaplain"))
			boutput(target, __blue("[M]'s foul gaze falters as it stares upon your righteousness!"))
			target.visible_message("<span style=\"color:red\"><B>[target] glares right back at [M]!</B></span>")
		else
			target.apply_flash(30, 15)

		logTheThing("combat", M, target, "uses glare on %target% at [log_loc(M)].")
		return 0