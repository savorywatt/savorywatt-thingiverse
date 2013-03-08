// platform height
p_h = 1.5; 

// can height - between ridges
can_h = 106.5;

// can diameter
can_d = 73;

// bump height
b_h = 15;

// connection length
c_l = 4;

// center_cut percent
c_c = 0.4;

//connection circle
con_d = 10;

//minokowski
min = 5;

// how fine the circles should be, higher is better, lower is faster to render
fn=20;

main();

//connection_attach();
module main() 
{
	main_square();
	bumps();
}



module connection_attach()
{
	hull()
	{
	linear_extrude(height=p_h*2)
	connection_circle();
	translate([-con_d/2,0,0])
	linear_extrude(height=p_h)
	connection_circle();
	}
}


module main_square()
{
	linear_extrude(height=p_h)
	{
	difference()
	{
		minkowski()
		{
		square([can_d, can_h], center=true);
		circle(r=min, $fn=fn);
		}
		hull()
		{
		translate([0,can_h/3,0])
		circle(r=(c_c * can_d/ 2), center=true, $fn=fn);
		translate([0,-can_h/3,0])
		circle(r=(c_c * can_d/ 2), center=true, $fn=fn);
		}
		
		translate([-(can_d/2 +min/2) - con_d/4,0,0])
		connection_circle();
	}

	}
	translate([(can_d/2 + min/2) + con_d/4,0,0])
	connection_attach();
}


module connection_circle()
{
	radius=con_d;
	circle(r=radius, center=true, $fn=fn);
}




module connection()
{
	width=8;
	height=5;
	square([width-3, height], center=true);
	translate([width/2,0,0])
	hull()
	{
	translate([0,width,0])
	circle(r=(c_c * height), center=true, $fn=fn);
	translate([0,-width,0])
	circle(r=(c_c * height), center=true, $fn=fn);
	}
}

module bumps()
{
	offset = 10 + c_l;
	translate([can_d/2 - offset, 0, p_h])
	bump();

	mirror([1,0,0])
	translate([can_d/2 - offset, 0, p_h])
	bump();

}

module bump()
{
	difference()
	{
	rotate([90,0,0])
	cylinder(r=b_h/2, h=can_h, center=true, $fn=fn);
	
	rotate([90,0,0])
	translate([0,-b_h/2,0])
	cube([b_h, b_h, can_h], center=true);
	}
}

