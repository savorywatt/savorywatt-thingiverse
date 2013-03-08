include <place_retaining_nut.scad>;
include <headers.scad>;

material_thickness = 1.5;
fn = 30;

wall_height = 25;
north_buffer = 1;

mill_space = 70;

board_x = 114.5;
board_y = 79.96;
board_z = 1.6;

spacer = 1.8;
 
main_buffer = 10;
main_x = board_x + material_thickness + main_buffer;
main_y = board_y + material_thickness + main_buffer/2;
main_z = material_thickness;

//top();
//color("red")
//top_cut();
//mill_me();
assembled();  
//print_me();
//board();
//bottom();
//north_wall();
//west_wall();

module top_cut(){

	translate([main_x/2 - 10, 1, 0])
	mirror([1,0,0])
	east_cut();

	//west
	translate([-main_x/2 + 10, 1 ,0 ])
	east_cut();
	
	translate([main_x/2 - 10, - main_y/2 - 3, 0])
	north_cut();
	
}
module midi_assembled()
{
	h_x = 62 + north_buffer;
	h_y = 19.5 + north_buffer;
	h_z = 12;

	usb_off_x = h_x/2 + 8.5;
	usb_off_y = 0;

	translate([usb_off_x, usb_off_y, 0])
	translate([-board_x/2, board_y/2,0])
	translate([0,-h_y/2 + 4,h_y/2 +board_z/2])
	rotate([-90,0,0])
	midi_connectors();

}
module west_wall()
{

	west_x = main_y - material_thickness * 3;
	west_y = wall_height;

	pylons = [2,1,2,1]; 
	types = [1,1,1,1];
	offset = main_x - west_x;
	offsets = [offset -30, 0, 50 + offset, 0];
	offcenters = [material_thickness/3 * 2,0,material_thickness/3 * 2,0];
	difference(){
	generate_cube([west_x,west_y,main_z], true, pylons, types, offsets, offcenters);
	translate([0,-3,0])
	rotate([0,0,-90])
	west_cut();
	translate([0,-2,0])
	rotate([0,0,-90])
	color("red")
	west_sd();
	}
}

module west_cut(){

	w_x = 10;
	w_y = 42;
		
	translate([w_x/2, 0, 0])
	mirror([1,0,0])
	rounded_square([w_x, w_y, material_thickness]);

}

module west_sd(){
	mirror([0,1,0])
	translate([-wall_height/2,-material_thickness,-(board_x/2 + material_thickness/2) ])
	rotate([0,90,0])
	board();

}




module custom_span(){

	//NE
	translate([-7,13,0])
	cylinder(r = 3/2, h = 5, center = true, $fn = fn);

	//SE
	translate([0,-board_y/2 + 3,0])
	cylinder(r = 3/2, h = 5, center = true, $fn = fn);

}


module bottom()
{
	pylons = [0,2,2,2]; 
	types = [0,0,0,0];
	west_x = main_y - material_thickness * 3;

	offset = main_x - west_x;
	offsets = [0, 0, 0, -offset + 14];

	difference(){
	generate_cube([main_x,main_y,main_z], true, pylons, types, offsets);
	mounting_holes();
	translate([0,0,-4])
	headers();
	}
}


module sd_assembled(){
	
	sd_hole = 9;
	circle = 1;
	edge = 4;
	usb_off_x = sd_hole/4;
	usb_off_y = sd_hole/2 + edge + circle;

	translate([usb_off_x, usb_off_y, 0])
	translate([-board_x/2, -board_y/2, sd_hole/4 + board_z/2 + circle])

	rotate([0,90,0])
	sd_slot([sd_hole/2, sd_hole, sd_hole], circle, true);

}

module sd_slot(dim, circle, cen){

	$fn = fn;
	linear_extrude(height = dim[2], center = true)
	minkowski()
	{
		square([dim[0], dim[1]], center = true);
		circle(circle, center = true);
	}


}

module midi_connectors(){

	c_x = 19.5 + north_buffer;
	c_y = 19.5 + north_buffer;
	c_z = 12 + north_buffer;

	buffer = 2;

	connector_diameter = 16 + north_buffer;

	connector_holes_cut(connector_diameter, [c_x, c_y, c_z], material_thickness * 2, 2, 3 );
	connector_holes(15, [c_x, c_y, c_z], material_thickness, 2, 3 );
}



module mounting_holes(){
	offset =  0;
	//1mm from edge, hole width;
	side_width = board_y - 5;//79.5;
	translate([0,0,0])
	union(){
	
	//west
	translate([-(board_x/2) + 2, offset,0])
	mounting_span(75.5);
	
	//east 
	translate([(board_x/2 - 3),0,0])
	custom_span();
	}
}

module print_me()
{
	bottom();
	
	translate([mill_space + 10,0,0])
	rotate([0,0,90])
	color("blue")
	east_wall();

	mirror([1,0,0])
	translate([mill_space + 10,0,0])
	rotate([0,0,90])
	color("orange")
	west_wall();

	translate([0,-mill_space, 0])
	south_wall();

	translate([0,mill_space -10, 0])
	mirror([1,0,0])
	north_wall();

	translate([0, main_y/2 + wall_height + mill_space - 10,0])
	top();

}

module mill_me()
{
	translate([main_x/2 + wall_height + 10, main_y/2 + wall_height + 10, 0])
	projection(cut = true){
	bottom();
	
	translate([mill_space + 10,0,0])
	rotate([0,0,90])
	east_wall();

	mirror([1,0,0])
	translate([mill_space + 10,0,0])
	rotate([0,0,90])
	west_wall();

	translate([0,-mill_space + 10, 0])
	south_wall();

	translate([0,mill_space - 10, 0])
	mirror([1,0,0])
	north_wall();

	translate([0, main_y/2 + wall_height/2 +  mill_space,0])
	top();
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
	west_wall();

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

module stereo_assembled(){

	h_x = 40 + north_buffer;
	h_y = 14 + north_buffer;
	h_z = 12;

	usb_off_x = h_x/2 + 73;
	usb_off_y = 0;

	translate([usb_off_x, usb_off_y, 0])
	translate([-board_x/2, board_y/2,0])
	//translate([0,-h_y/2,h_y/2 +board_z/2])
	translate([0, -(26 + north_buffer)/2,h_y/2 + board_z/2])
	rotate([-90,0,0])
	stereo_connectors();
}

module stereo_connectors(){

	c_x = 18 + north_buffer;
	c_y = 14 + north_buffer;
	c_z = 26 + north_buffer;

	buffer = 2;

	connector_diameter = 12 + north_buffer;

	connector_holes_cut(connector_diameter, [c_x, c_y, c_z], material_thickness * 2, 2, 2 );
	connector_holes(11, [c_x, c_y, c_z], material_thickness, 2, 2 );

}

module board()
{

	//MIDI hole
	color("white")
	midi_assembled();
	color("grey")
	sd_assembled();
	color("blue")
	stereo_assembled();
	//headers
	translate([0,0,-9])
	color("grey") 
	headers();
	//board
	color("green")
	difference(){
	cube([board_x, board_y, board_z], center = true);
	mounting_holes();
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

	translate([0,wall_height/2  - spacer - board_z/2, -board_y/2 - material_thickness/2])
	rotate([90,0,0])
	board();
	}

}

module north_cut(){

	n_x = 16;
	n_y = 8;
	n_off = 10;
	//translate([n_x/2 + n_off,- n_y/2, 0 ])
	translate([-n_x/2,+n_y/2,0])
	round_square([n_x, n_y, material_thickness]);
}

module connector_holes_cut(con_d, dim, m_z, con_space, num){

	offset = ((dim[0] + con_space) * (num-1))/2;
	
	hull(){
	translate([-offset,0,0])
	for ( i = [0 : num-1] )
	{
		translate([(dim[0] + con_space) * i, 0,0])
		connector_hole_cut(con_d, dim, m_z);
	}
	}

}

module connector_hole_cut(con_d, dim, m_z){

	//cube(dim, center = true);
	translate([0,0,dim[2]/2 + m_z])
	//color("black")
	cylinder(r=con_d/2, h = m_z * 2, center = true, $fn = fn);

}

module connector_holes(con_d, dim, m_z, con_space, num){

	offset = ((dim[0] + con_space) * (num-1))/2;

	translate([-offset,0,0])
	for ( i = [0 : num-1] )
	{
		translate([(dim[0] + con_space) * i, 0,0])
		connector_hole(con_d, dim, m_z);
	}

}

module connector_hole(con_d, dim, m_z){

	cube(dim, center = true);
	translate([0,0,dim[2]/2 + m_z])
	//color("black")
	cylinder(r=con_d/2, h = m_z * 2, center = true, $fn = fn);

}

module east_cut(){

	e_x = 10;
	e_y = 42;

	translate([-e_x/2,0,0])
	rounded_square([e_x, e_y, material_thickness]);
}

module rounded_square(dim)
{

	cy_r = dim[0]/4;
	cy_x = dim[0]/2 - cy_r;
	cy_y = dim[1]/2;

	c_x = cy_r * 2;
	c_y = cy_r * 2;
	c_z = dim[2];

	//color("black")
	//cube(dim, center = true);
	hull(){
	
	//NE
	translate([cy_x , cy_y-c_y/2, 0])
	cylinder(r = cy_r, h = dim[2], center = true, $fn=fn);

	//NW
	translate([cy_x ,-cy_y +c_y/2,0])
	cylinder(r = cy_r, h = dim[2], center = true, $fn=fn);

	//SE
	translate([-cy_x , cy_y - c_y/2, 0])
	color("blue")
	cube([c_x, c_y, c_z], center = true);

	//SW
	translate([-cy_x , -cy_y + c_y/2, 0])
	color("red")
	cube([c_x, c_y, c_z], center = true);

	}

}

module round_square(dim)
{
	
	cube(dim, center = true);
	translate([0,dim[1]/2,0])
	cylinder(r = dim[0]/2, h = dim[2], center = true, $fn=fn);
}

module south_wall()
{
	pylons = [2,1,2,1]; 
	types = [1,0,1,0];

	south_x = main_x;
	south_y = wall_height;
	difference(){
	generate_cube([south_x,south_y,main_z], true, pylons, types);
	translate([main_x/2 - 10, wall_height/2 + 6,0])
	color("red")
	mirror([0,1,0])
	north_cut();
	}

}


module east_wall()
{
	
	east_x = main_y - material_thickness * 3;
	east_y = wall_height;

	pylons = [2,1,2,1]; 
	types = [1,1,1,1];
	offset = main_x - east_x;
	offsets = [offset, 0, 50 + offset, 0];
	offcenters = [material_thickness/3 * 2,0,material_thickness/3 * 2,0];
	difference(){
	generate_cube([east_x,east_y,main_z], true, pylons, types, offsets, 	offcenters);
	translate([0,-3,0])
	rotate([0,0,90])
	color("red")
	east_cut();
	}
}

module top(){

	pylons = [0,2,2,2]; 
	types = [0,0,0,0];
	offset = 50;
	offsets = [0, offset, 0, offset];

	bottom_x = main_x;
	bottom_y = main_y;

	difference(){
	generate_cube([main_x, main_y, material_thickness], true, pylons, types, offsets);
	top_cut();
	}

}


module bottom_cut(){

	translate([0,0,-5])
	headers();

}

module headers()
{
	s_board_x = 68.6;	
	s_board_y = 85.1;
	s_board_z = 1.6;

	x_off = s_board_x/2;
	y_off = s_board_y/2;
	z_off = s_board_z/2;

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

module mounting_span(n=0){
	
	span_distance = n;
	translate([0,-span_distance/2,0])
	union(){
	cylinder(r = 3/2, h = material_thickness * 2, center = true, $fn = fn);
	translate([0,span_distance,0])
	cylinder(r = 3/2, h = material_thickness * 2, center = true, $fn = fn);
	}


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




