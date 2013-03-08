//90710A020 part 6.48 per 100
// Thin Hex Nut
// OD = 4mm
// Height = 1.2mm
// Metric 18-8 Stainless Steel
// M2 x 0.4 Thread


//92000A012 - 4.10 per 100
//18-8 SS Metric Pan Head Machine Screw
// head OD 4mm
// head height = 1.7mm
// body length = 5mm
// body OD = 2mm
// M2 X 0.4 Thread

retain_screw_od = 2;
retain_screw_height = 5;

retain_nut_od = 4.5;
retain_nut_height = 1.7;
material_z = 1.5;

buffer = 0.5;

anchor_width = 2;
anchor_target_width = material_z;
harbor_offset = 2;
harbor_width = anchor_width*2 + retain_screw_od + buffer;

channel_top = 0.5;
channel_bottom = 1 - channel_top;

//main();

//harbor();
//main();
//pylon();
//anchors();


module anchors()
{
	y_off =  retain_screw_height/2 + anchor_target_width/2;
	translate([0,- retain_screw_height/2,0])
	union(){
	
	translate([retain_screw_od/2 + anchor_width/2, y_off, 0])
	color("Red")
	cube([anchor_width, anchor_target_width, material_z], center = true);
	
	translate([-(retain_screw_od/2 + anchor_width/2), y_off, 0])
	color("Orange")
	cube([anchor_width, anchor_target_width, material_z], center = true);
	}
}

module shaft(){

	translate([0, - (retain_screw_height - anchor_target_width)/2,0])
	union()
	{
	//nut trap
	translate([0, -((retain_screw_height - anchor_target_width )/2 - ((retain_screw_height - anchor_target_width ) * channel_bottom)), 0])
	cube([retain_nut_od, retain_nut_height, material_z], center = true);

	//main pillar
	color("Blue")
	cube([retain_screw_od, retain_screw_height - anchor_target_width, material_z], center = true);

	}
}

module pylon()
{
	union()
	{
	translate([0, - (retain_screw_height - anchor_target_width)/2,0])
	shaft();
	translate([0,- retain_screw_height/2,0])
	anchors();
	}
	
}

module harbor()
{
	color("White")
	cube([harbor_width, anchor_target_width, material_z], center = true);
}


module main()
{
	translate([0, cube_y + 5, 0])
	color("Brown")
	difference()
	{
	cube([cube_x, cube_y/1.25, anchor_target_width], center = true);
	translate([0, (cube_y/2) , 0]) 
	harbor();
	}
	
	union()
	{
	difference()
	{
	cube([cube_x,cube_y,material_z], center = true);
	translate([0,(cube_y/2),0])
	shaft();
	}

	translate([0,(cube_y/2),0])
	anchors();
	}
}














