var/global/datum/controller/game_controller/master_controller //Set in world.New()

datum/controller/game_controller
	var/processing = 1

	proc
		setup()
		setup_objects()
		setup_rocks()
		process()

	setup()
		if(master_controller && (master_controller != src))
			del(src)
			//There can be only one master.

		if(!air_master)
			air_master = new /datum/controller/air_system()
			air_master.setup()

		setup_objects()

		setupgenetics()

		if(dynrocks)
			setup_rocks()

		// all initializations above this line.
		world << "\red \b Initializations complete."

		emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()

		if(!ticker)
			ticker = new /datum/controller/gameticker()

		spawn
			ticker.pregame()

	setup_objects()
		world << "\red \b Initializing objects"
		sleep(-1)

		for(var/obj/object in world)
			object.initialize()

		world << "\red \b Initializing pipe networks"
		sleep(-1)

		for(var/obj/machinery/atmospherics/machine in world)
			machine.build_network()

	setup_rocks()
		world << "\red \b Initializing dynamic rocks"

		// only set up z-layer 1 to not cause performance issues
		for(var/turf/mars/T in world)
			if(prob(3))
				new /obj/mars/rock(T.loc)


	process()

		if(!processing)
			return 0
		//world << "Processing"

		var/start_time = world.timeofday

		air_master.process()

		sleep(1)

		sun.calc_position()

		sleep(-1)

		for(var/mob/M in world)
			M.Life()

		sleep(-1)

		for(var/obj/machinery/machine in machines)
			machine.process()

		sleep(-1)
		sleep(1)

		for(var/obj/item/item in processing_items)
			item.process()

		for(var/datum/pipe_network/network in pipe_networks)
			network.process()

		for(var/datum/powernet/P in powernets)
			P.reset()

		sleep(-1)

		ticker.process()

		sleep(world.timeofday+10-start_time)

		spawn process()

		return 1