///////////////////////////////////////////////////////////
/// Copyright 2013 Ross Hendrickson
///
///  BSD License
///
/////////////////////////////////////////////////////////

test();

///////////////////////////
//Customizer Variables
///////////////////////////

material_z = 1.5;

retain_screw_od = 2;
retain_screw_height = 5;

retain_nut_od = 4.5;
retain_nut_height = 1.7;
anchor_width = 2;

//Position where the nut should be in the channel
channel_top = 0.5;
channel_bottom = 1 - channel_top;

////////////////////////////////
//Non-Customizer Variables
////////////////////////////////

//Related to anchors and harbors
buffer = 0.1;
anchor_target_width = material_z;
harbor_offset = material_z;
harbor_width = anchor_width*2 + retain_screw_od + buffer;

module test()
{
	//North, East, South, West
	pylons = [3,2,1,2];
	types = [1,0,1,0];
	offsets = [0,0,0,0];
	offcenters = [0,0,0,0];
	generate_cube([100,110,1], true, pylons, types, offsets, offcenters);	
}

module generate_negative_grid(dim, p, t, offsets = [0,0,0,0],  offcenters = [0,0,0,0])
{
	cube_x = dim[0];
	cube_y = dim[1];
	side_off = cube_y - cube_x;

	for ( i = [ 0 : 3 ] )
	{
		if ( t[i] == 1)
		{
		echo("POSITIVE:" ,p[i]);
		//North
		if ( i == 0)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			translate([offcenters[i],0,0])
			generate_shafts(cube_x + offsets[0], cube_y, p[i]); 
		}
		
		//East
		if ( i == 1)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			translate([-side_off/2,0,0])
			rotate([0,0,270])
			translate([offcenters[i],0,0])
			generate_shafts(cube_x + offsets[i], cube_y, p[i]); 
		}

		//South
		if ( i == 2)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			mirror([0,1,0])
			translate([offcenters[i],0,0])
			generate_shafts(cube_x + offsets[i], cube_y, p[i]); 
		}

		//West
		if ( i == 3)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			
			translate([side_off/2,0,0])
			mirror([1,0,0])
			rotate([0,0,-90])
			translate([offcenters[i],0,0])
			generate_shafts(cube_x + offsets[i], cube_y, p[i]); 
		}
		
	////////////////
		}else{
	////////////////
		echo("NEGATIVE", p[i]);
		//North
		if ( i == 0)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			translate([offcenters[i],0,0])
			generate_harbors(cube_x + offsets[i], cube_y, p[i]); 
		}
		
		//East
		if ( i == 1)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			
			translate([-side_off/2,0,0])
			rotate([0,0,270])
			translate([offcenters[i],0,0])
			generate_harbors(cube_x + offsets[i], cube_y, p[i]); 
		}

		//South
		if ( i == 2)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			
			mirror([0,1,0])
			translate([offcenters[i],0,0])
			generate_harbors(cube_x + offsets[i], cube_y, p[i]); 
		}

		//West
		if ( i == 3)
		{
			echo("OFFCENTERS: ", offcenters[i]);
			translate([side_off/2,0,0])
			mirror([1,0,0])
			rotate([0,0,-90])
			translate([offcenters[i],0,0])
			generate_harbors(cube_x + offsets[i], cube_y, p[i]); 
		}

		}

	}

}


module generate_positive_grid(dim, p, t, offsets = [0,0,0,0], offcenters = [0,0,0,0])
{
	cube_x = dim[0];
	cube_y = dim[1];
	side_off = cube_y - cube_x;
	echo("OFFCENTERS_POSITIVE: ", offcenters);
	echo("OFFSETS", offsets);
	for ( i = [ 0 : 3 ] )
	{
		if ( t[i] == 1)
		{
		//North
		if ( i == 0)
		{
			translate([offcenters[i],0,0])
			generate_anchors(cube_x + offsets[0], cube_y, p[i]); 
			
		}
		
		//East
		if ( i == 1)
		{
			translate([-side_off/2,0,0])
			rotate([0,0,270])
			translate([offcenters[i],0,0])
			generate_anchors(cube_x + offsets[i], cube_y, p[i]); 		
		}

		//South
		if ( i == 2)
		{
			mirror([0,1,0])
			translate([offcenters[i],0,0])
			generate_anchors(cube_x + offsets[i], cube_y, p[i]); 		
		}

		//West
		if ( i == 3)
		{
			translate([side_off/2,0,0])
			mirror([1,0,0])
			rotate([0,0,-90])
			translate([offcenters[i],0,0])
			generate_anchors(cube_x + offsets[i], cube_y, p[i]); 
		}
		}
	}

}

module generate_cube(dim, centered, points, types, offsets = [0,0,0,0], offcenters = [0,0,0,0])
{
	
	x = dim;
	y = dim;
	z = dim;

	if ( len(dim) > 1 )
	{
		assign( x = dim[0], y = dim[1], z = dim[2])
		{
			gen_cube(x , y, z, centered, points, types, offsets, offcenters);
		}
		
	}else{
		assign(x = dim, y = dim, z = dim)
		{
			gen_cube(x, y, z, centered,  points, types, offsets, offcenters);
		}
	}
	
	
}

module gen_cube(x, y , z, centered, points, types, offsets = [0,0,0,0], offcenters = [0,0,0,0] )
{
	union(){
	difference(){
	
	cube([x,y,z], center = centered);
	
	//difference out shafts
	//difference out harbor
		generate_negative_grid([x,y,z], points, types, offsets, offcenters);
	}
	//union anchors
		generate_positive_grid([x,y,z], points, types, offsets, offcenters);
	}
}


module generate_anchors(c_x, c_y, num)
{
	width = c_x / (num + 1);

	reset_y = (c_y/2);
	reset_x =  (width * (num-1))/2;

	if ( num > 0)
	{
	translate([-reset_x,reset_y,0])
	gen_anchor_span(c_x, c_y, num);
	}
}

module gen_anchor_span(c_x, c_y, num)
{
	width = c_x / (num + 1);
	
	number = num -1;
	for ( x = [0 : number ])
	{
		translate([ width * x,0,0])
		anchors();
	}
}




module generate_harbors(c_x, c_y, num){
	
	width = c_x / (num + 1);
	//if the harbor is going to go into a thicker target modify anchor_target_width
	reset_y = (c_y/2) - anchor_target_width/2 - harbor_offset;
	reset_x =  (width * (num-1))/2;

	if(num > 0)
	{
	translate([-reset_x,reset_y,0])
	gen_harbor_span(c_x, c_y, num);
	}
}

module gen_harbor_span(c_x, c_y, num){
	
	width = c_x / (num + 1);
	number = num -1;
	for ( x = [0 : number ])
	{
		translate([ width * x,0,0])
		harbor();
	}

}

module generate_shafts(c_x, c_y, num){

width = c_x / (num + 1);

	reset_y = (c_y/2);
	reset_x =  (width * (num-1))/2;

	translate([-reset_x,reset_y,0])
	if( num > 0)
	{

	
	gen_shaft_span(c_x, c_y, num);
	}

}

module gen_shaft_span(c_x, c_y, num){
	
	width = c_x / (num + 1);
	
	number = num -1;
	for ( x = [0 : number ])
	{
		translate([ width * x,0,0])
		shaft();
	}

}



module base(){

	cube([cube_x, cube_y, 4], center = true);
}

module generate_retaining_nut(c_x, c_y, p, t){

	for ( i = [ 0 : 3 ] )
	{
		if ( t[i] == 1)
		{
		echo("POSITIVE:" ,p[i]);

		generate_pylons(c_x, c_y, p[i]);
		
		}else{
		echo("NEGATIVE", p[i]);
		}

	}

}

module fake_pylon()
{
	cube(pylon_width, center = true);
}



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















