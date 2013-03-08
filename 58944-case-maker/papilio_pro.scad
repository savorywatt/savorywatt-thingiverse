include <place_retaining_nut.scad>;
include <headers.scad>;

material_thickness = 1.5;
fn = 30;

wall_height = 10;
north_buffer = 1;

mill_space = 60;

board_x = 68.6;
board_y = 85.1;
board_z = 1.6;

spacer = 1.8;
 
main_buffer = 10;
main_x = board_x+ material_thickness + main_buffer;
main_y = board_y + material_thickness + main_buffer/2;
main_z = material_thickness;

//mill_me();
//assembled();  
print_me();
//board();
module mounting_holes(){
	offset =  -6;
	//1mm from edge, hole width;
	side_width = board_y - 5;//79.5;
	translate([0,0,0])
	union(){
	
	//north and south west
	translate([(board_x/2 - 3/2) - 0.5, 0,0])
	mounting_span(side_width);

	//north and south west
	translate([-(board_x/2 - 2) + 0.5, 0,0])
	mounting_span(side_width);

	//west
	translate([-(board_x/2 - 2) + 0.5, offset,0])
	mounting_span(20);
	
	//east west
	translate([(board_x/2 - 13) + 0.5, offset,0])
	mounting_span(20);

	//east 
	translate([(board_x/2 - 1.5), 0,0])
	mounting_span(20.5);
	}
}

module north_wall()
{
	pylons = [0,1,0,1]; 
	types = [1,0,1,0];
	offset = material_thickness * 2;
	offsets = [-offset, 0, 0, -offset];

	south_x = main_x;
	south_y = wall_height;
	
	difference(){
	generate_cube([main_x, wall_height, material_thickness], true, pylons, types, offsets);

	translate([0,spacer + material_thickness/2,-board_y/2 - material_thickness/2])
	rotate([90,0,0])
	board();
	}

}

module east_wall()
{
	
	east_x = main_x + 6.6; //- harbor_offset * 2 - (material_thickness * 4) ;
	east_y = wall_height;

	pylons = [2,1,1,1]; 
	types = [1,1,1,1];
	offset = main_x - east_x;
	offsets = [offset, 0, 0, 0];
	offcenters = [material_thickness/3 * 2,0,material_thickness/3 * 2,0];
	
	generate_cube([east_x,east_y,main_z], true, pylons, types, offsets, 	offcenters);
}

module headers()
{
	x_off = board_x/2;
	y_off = board_y/2;
	z_off = board_z/2;

	east_width = 2.5 * 4;
	west_width = 2.5 * 2;

	east_height = 2.5 * 16;
	west_height = east_height;

	//3mm off south
	//2mm right + 1/2 width
	east_off = 2;
	west_off = east_off;

	south_off = 20;
	union(){
	translate([-x_off + west_width/2 + west_off,-y_off + west_height/2 + south_off, z_off])
	//cube([x, y, z], center = true);
	small_header();

	translate([x_off -  (east_width/2 + east_off), -y_off + east_height/2 + south_off, z_off])
	//cube([s_x, s_y, z], center = true);
	large_header();
	}
}


module top()
{
	
	pylons = [0,1,1,1]; 
	types = [0,0,0,0];

	top_x = main_x;
	top_y = main_y;

	difference()
	{
	generate_cube([top_x,top_y,main_z], true, pylons, types);
	translate([0,0,-board_z * 4])
	board();
	}
}



module bottom()
{

	pylons = [0,2,1,2]; 
	types = [0,0,0,0];

	below_z = 7;
	above_z = 11;

	difference(){
	generate_cube([main_x,main_y,main_z], true, pylons, types);
	mounting_holes();
	}
}



module mounting_span(n=0){
	
	span_distance = n;
	translate([0,-span_distance/2,0])
	union(){
	cylinder(r = 3/2, h = material_thickness * 2, center = true, $fn = fn);
	translate([0,span_distance,0])
	cylinder(r = 3/2, h = material_thickness * 2, center = true, $fn = fn);
	}


}




module board()
{

	//USB hole
	color("white")
	usb_assembled();
	
	//headers
	color("grey") 
	headers();
	//board
	color("green")
	difference(){
	cube([board_x, board_y, board_z], center = true);
	mounting_holes();
	}
}

module assembled() 
{
	translate([0,0,-wall_height/2 + board_z + spacer])
	board();

	translate([0,0,-wall_height/2])
	bottom();

	color("blue") 
	translate([0,harbor_offset/2,0])
	mirror([0,0,1])
	translate([main_x/2 -material_thickness/2 - harbor_offset,0, -material_thickness/2])
	rotate([90,0,-90])
	east_wall();

	color("orange")
	translate([0,harbor_offset/2,0])
	mirror([1,0,0])
	mirror([0,0,1])
	translate([main_x/2 -material_thickness/2 - harbor_offset, 0, -material_thickness/2])
	rotate([90,0,-90])
	%west_wall();

	color("grey")
	translate([0, main_y/2 - material_thickness/2, material_thickness/2])
	mirror([0,1,0])
	rotate([270,0,0])
	north_wall();

	color("brown")
	translate([0, -(main_y/2 - material_thickness/2 - harbor_offset), material_thickness/2])
	rotate([90,0,0])
	south_wall();
	
	translate([0,0,wall_height/2 + material_thickness])
	top();


}




module powerp_assembled()
{
	f_z = 3.5 + north_buffer;
	f_x = 9 + north_buffer;

	power_off_x = f_x/2 + 4.1;
	power_off_y = -f_z/2 + 4.2;
	
	translate([power_off_x, power_off_y, f_x/2 + board_z])
	translate([-board_x/2, board_y/2,0])
	translate([0,0,board_z/2])
	rotate([90,180,0])
	power_plug();

}

module power_cut(){

	f_x = 9 + north_buffer;
	power_off_x = f_x/2 + 4.1;
	translate([power_off_x, -material_thickness - board_z/2, - material_thickness])
	translate([-board_x/2, 0,0])
	power_plug();

}

module power_plug(){

	f_z = 3.5 + north_buffer;
	f_x = 9 + north_buffer;
	f_y = 11 + north_buffer;

	h_x = 9 + north_buffer;
	h_y = 6 + north_buffer;
	h_z = 10 + north_buffer;

	union(){
	cube([f_x, f_y, f_z], center = true);
	
	translate([0,(f_y - h_y)/2,h_z/2])
	cube([h_x, h_y, h_z], center = true);

	translate([0, -(h_y/2 - 3.3), h_z/2])
	cylinder(r=f_x/2, h= h_z, center = true, $fn = fn);	
	}

}
 
module usb_assembled()
{
	h_x = 7.7 + north_buffer;
	h_y = 3.7 + north_buffer;
	h_z = 10 + north_buffer;

	usb_off_x = h_x/2 + 29.2;
	usb_off_y = 0;

	translate([usb_off_x, usb_off_y, 0])
	translate([-board_x/2, board_y/2,0])
	translate([0,0,h_y/2 +board_z/2])
	rotate([90,180,0])
	usb_hole(h_x, h_y, h_z);

}

module usb_hole(h_x, h_y, h_z)
{
	cube([h_x, h_y, h_z], center = true);
}

module print_me()
{
	bottom();
	
	translate([mill_space,0,0])
	rotate([0,0,90])
	color("blue")
	east_wall();

	mirror([1,0,0])
	translate([mill_space,0,0])
	rotate([0,0,90])
	color("orange")
	east_wall();

	translate([0,-mill_space, 0])
	south_wall();

	translate([0,mill_space, 0])
	north_wall();

	translate([0, main_y/2 + wall_height + mill_space,0])
	top();

}

module mill_me()
{
	projection(cut = true){
	bottom();
	
	translate([mill_space,0,0])
	rotate([0,0,90])
	east_wall();

	mirror([1,0,0])
	translate([mill_space,0,0])
	rotate([0,0,90])
	east_wall();

	translate([0,-mill_space, 0])
	south_wall();

	translate([0,mill_space, 0])
	north_wall();

	translate([0, main_y/2 + wall_height + mill_space,0])
	top();
	}
	
}

module south_wall()
{
	pylons = [1,1,1,1]; 
	types = [1,0,1,0];

	south_x = main_x;
	south_y = wall_height;

	generate_cube([south_x,south_y,main_z], true, pylons, types);

}

module west_wall()
{

	east_wall();
}






module base_mount()
{
	diameter = 3;
	off_set = 0.5;

	//left side
	off_top = 30;
	off_middle = 17.3;
	off_sidey = 2.5;
	off_sidex = 9.7;
 
	//right side
	bottom_off = 9.7;
	bottom_middle = 17.3;
}


module large_header(){
	
	translate([2.5/2,-(2.5*12/2),0]){
	
	gen_header(3,4);
	
	translate([-2.5,2.5 * 4, 0])
	gen_header(3,4);
	
	translate([0,2.5 * 8, 0])
	gen_header(3,4);
	
	translate([-2.5,2.5 * 12, 0])
	gen_header(3,4);
	}
}

module small_header(){

	translate([0,-(2.5*12/2),0]){
	translate([2.5/2,0,0])
	gen_header(1,4);
	translate([0,2.5 * 4,0])
	gen_header(2,4);
	translate([2.5/2,2.5 * 8,0])
	gen_header(1,4);
	translate([0,2.5 * 12,0])
	gen_header(2,4);
	}

}


module retro_base()
{

	x = 114.3;
	y = 80;
	z = 1.6;

	holes = 2.8;
	y_off = 1.6;
	x_off = 1.6;

	special_x = 7.9;
	special_y  = 26.4;	

}




