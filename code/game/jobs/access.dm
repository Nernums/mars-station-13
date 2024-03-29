/var/const
	access_security = 1
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_medlab = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_bar = 24
	access_janitor = 25
	access_crematorium = 26
	access_kitchen = 27
	access_robotics = 28
	access_cargo = 29
	access_construction = 30
	access_chemistry = 31
	access_cargo_bot = 32
	access_mining = 33
	access_barber = 34
	access_manufactory = 35
	access_dummy = 36
	access_mail = 37
	access_hangar = 38


/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/New()

	if(src.req_access_txt)
		var/req_access_str = params2list(req_access_txt)
		var/req_access_changed = 0
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				if(!req_access_changed)
					req_access = list()
				req_access += n
	..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(istype(M, /mob/living/silicon))
		//AI can do whatever he wants
		return 1
	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.equipped()) || src.check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/carbon/monkey) || istype(M, /mob/living/carbon/alien/humanoid))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(george.equipped() && istype(george.equipped(), /obj/item/weapon/card/id) && src.check_access(george.equipped()))
			return 1
	return 0

/obj/proc/check_access(obj/item/weapon/card/id/I)
	if(!src.req_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/weapon/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in src.req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/proc/get_access(job)
	switch(job)
		if("Geneticist")
			return list(access_medical, access_morgue, access_medlab)
		if("Station Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks)
		if("Assistant")
			return list(access_maint_tunnels)
		if("Chaplain")
			return list(access_morgue, access_chapel_office, access_crematorium)
		if("Detective")
			return list(access_security, access_forensics_lockers, access_morgue, access_maint_tunnels)
		if("Medical Doctor")
			return list(access_medical, access_morgue)
		if("Captain")
			return get_all_accesses()
		if("Security Officer")
			return list(access_security, access_brig)
		if("Scientist")
			return list(access_tox, access_tox_storage)
		if("Head of Security")
			return list(access_medical, access_morgue, access_tox, access_tox_storage, access_chemistry, access_medlab,
			            access_teleporter, access_heads, access_tech_storage, access_security, access_brig,
			            access_maint_tunnels, access_bar, access_janitor, access_kitchen, access_robotics, access_armory,
			            access_mining, access_mail, access_hangar)
		if("Head of Personnel")
			return list(access_security, access_brig, access_forensics_lockers,
			            access_tox, access_tox_storage, access_chemistry, access_medical, access_medlab, access_engine,
			            access_emergency_storage, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
			            access_crematorium, access_kitchen, access_robotics, access_cargo, access_cargo_bot, access_mining,
			            access_mail, access_hangar)
		if("Barman")
			return list(access_bar, access_maint_tunnels)
		if("Chemist")
			return list(access_medical, access_tox, access_chemistry)
		if("Janitor")
			return list(access_janitor, access_maint_tunnels)
		if("Clown")
			return list(access_maint_tunnels)
		if("Chef")
			return list(access_kitchen, access_maint_tunnels)
		if("Roboticist")
			return list(access_robotics, access_tech_storage, access_medical, access_morgue, access_engine,
			            access_maint_tunnels)
		if("Quartermaster")
			return list(access_maint_tunnels, access_cargo, access_cargo_bot)
		if("Chief Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_emergency_storage, access_eva,
			            access_heads, access_ai_upload, access_construction, access_mining, access_hangar)
		if("Research Director")
			return list(access_medical, access_morgue, access_medlab, access_robotics,
			            access_tech_storage, access_maint_tunnels, access_heads, access_tox,
			            access_tox_storage, access_chemistry, access_teleporter, access_hangar)
		if("Lawyer")
			return list(access_maint_tunnels)
		if("Miner")
			return list(access_maint_tunnels, access_external_airlocks, access_mining, access_hangar)
		if("Barber")
			return list(access_barber)
		if("Mailman")
			return list(access_maint_tunnels, access_mail)
		else
			return list()

/proc/get_all_accesses()
	return list(access_security, access_brig, access_armory, access_forensics_lockers,
	            access_medical, access_medlab, access_morgue,
	            access_tox, access_tox_storage, access_chemistry, access_engine, access_engine_equip, access_maint_tunnels,
	            access_external_airlocks, access_emergency_storage, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers,
	            access_tech_storage, access_chapel_office, access_kitchen,access_bar, access_janitor, access_crematorium,
	            access_robotics, access_cargo, access_cargo_bot, access_construction, access_mining, access_barber, access_manufactory,
	            access_mail, access_hangar)

/proc/get_access_desc(A)
	switch(A)
		if(access_cargo)
			return "Cargo Bay"
		if(access_cargo_bot)
			return "Cargo Bot Delivery"
		if(access_security)
			return "Security"
		if(access_brig)
			return "Brig"
		if(access_forensics_lockers)
			return "Forensics"
		if(access_medical)
			return "Medical"
		if(access_medlab)
			return "Med-Sci"
		if(access_morgue)
			return "Morgue"
		if(access_tox)
			return "Toxins Research"
		if(access_tox_storage)
			return "Toxins Storage"
		if(access_chemistry)
			return "Toxins Chemical Lab"
		if(access_bar)
			return "Bar"
		if(access_janitor)
			return "Janitorial Equipment"
		if(access_engine)
			return "Engineering"
		if(access_engine_equip)
			return "Engine & Power Control Equipment"
		if(access_maint_tunnels)
			return "Maintenance"
		if(access_external_airlocks)
			return "External Airlock"
		if(access_emergency_storage)
			return "Emergency Storage"
		if(access_change_ids)
			return "ID Computer"
		if(access_ai_upload)
			return "AI Upload"
		if(access_teleporter)
			return "Teleporter"
		if(access_eva)
			return "EVA"
		if(access_heads)
			return "Head's Quarters/Bridge"
		if(access_captain)
			return "Captain's Quarters"
		if(access_all_personal_lockers)
			return "Personal Locker"
		if(access_chapel_office)
			return "Chapel Office"
		if(access_tech_storage)
			return "Technical Storage"
		if(access_crematorium)
			return "Crematorium"
		if(access_armory)
			return "Armory"
		if(access_construction)
			return "Construction Site"
		if(access_kitchen)
			return "Kitchen"
		if(access_mining)
			return "Mining"
		if(access_barber)
			return "Barbers shop"
		if(access_manufactory)
			return "manufactory access"
		if(access_mail)
			return "Mailroom"
		if(access_hangar)
			return "Hangar"


/proc/get_all_jobs()
	return list("Assistant", "Station Engineer", "Detective", "Medical Doctor", "Captain", "Security Officer",
				"Geneticist", "Scientist", "Head of Security", "Head of Personnel", "Atmospheric Technician",
				"Chaplain", "Barman", "Chemist", "Janitor", "Clown", "Chef", "Roboticist", "Quartermaster",
				"Chief Engineer", "Research Director", "Lawyer", "Miner", "Mailman")

