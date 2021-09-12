clearscreen.
wait 4.
stage.
lock throttle to 1.
wait 3.
stage.
wait 2.
set runmode to "Liftoff".
set ses2 to "n".
set stage1 to "y".
set dir to 350.

until runmode = "Done" {
	if alt:radar > 30000 and stage1 = "y" {
			lock throttle to 0.3.
	}
	else if alt:radar > 10000 and stage1 = "y" {
			lock throttle to 0.7.
	}
	if runmode = "Liftoff" {
		if ship:periapsis > 100000 {
			lock throttle to 0.
			wait 7.
			stage.
			set runmode to "Done".
		}
		turn(dir).
		
		if ship:stagedeltav(ship:stagenum):current < 50 and stage1 = "y" {
			stage.
			wait 3.
			toggle ag1.
			stage.
			wait 0.8.
			stage.
			toggle ag1.
			lock throttle to 0.5.
			set stage1 to "n".
		}
	}
		
	printVesselStats().
}
sas on.

function printVesselStats {
	clearscreen.
	print "Telemetry:" at(1, 4).
	print "Altitude above sea level: " + round(ship:altitude) + "m" at(10, 5).
	print "Current apoapsis: " + round(ship:apoapsis) + "m" at (10, 6).
	print "Current periapsis: " + round(ship:periapsis) + "m" at (10, 7).
	print "Orbital velocity: " + round(ship:velocity:orbit:mag * 3.6) + "km/h" at(10, 9).
	print "Ship longitude: " + round(ship:longitude) + "º" at (10, 10).
}

function turn {
	parameter heading.
	if alt:radar < 300 {
		lock angle to 90.
		lock steering to heading(heading, angle).
	}
	if alt:radar > 10000 and alt:radar < 40000 {
		lock steering to srfprograde.
	}
	if alt:radar > 300 and alt:radar < 10000 {
		lock angle to 97 - 1.03287 * alt:radar^.4.
		lock steering to heading(heading, angle).
	}
	if alt:radar > 40000 and alt:radar < 80000 {
		lock steering to prograde.
	}
	if alt:radar > 80000 {
		if eta:apoapsis > 30 {
			lock steering to heading(heading, -10).
		}
		else {
			lock steering to prograde.
		}
	}
}

