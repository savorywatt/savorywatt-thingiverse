include <place_retaining_nut.scad>
include <headers.scad>
material_thickness = 1.5;
fn = 30;

wall_height = 25;
north_buffer = 0.5;

mill_space = 45;

board_x = 118;
board_y = 75;
board_z = 1.6;
 
main_buffer = 10;
main_x = board_x+ material_thickness + main_buffer;
main_y = board_y + material_thickness + main_buffer/2;
main_z = material_thickness;

//bottom();

//south_wall();
print_me();

//mill_me();

//east_wall();

//north_wall();

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

module top_cut(){

	translate([main_x/2, 0, 0])
	east_cut();

	translate([-main_x/2, 0 ,0 ])
	west_cut();
	
	translate([-main_x/2, main_y/2, 0])
	north_cut();
	
}
module north_wall(){

	pylons = [2,1,2,1]; 
	types = [0,1,0,1];
	offset = 0;
	offsets = [0, 0, 0, 0];

	difference(){
//	generate_cube([main_x, wall_height, material_thickness], true, pylons, types, offsets);
	generate_cube([main_x, wall_height, 1.5], true, pylons, types, offsets);
	north_cut();
	}

}

module east_wall(){

	pylons = [2,0,2,0];  
	types = [1,0,1,0];
	offset = main_y* 1.8;
	offsets = [40, 0, 40, 0];

	east_x = main_y;
	east_y = wall_height;

	difference(){
	generate_cube([east_x, east_y, material_thickness], true, pylons, types, offsets);
	mirror([0,1,0])
	rotate([0,0,90])
	east_cut();
	}

}


module east_cut(){

	e_x = 16;
	e_y = 30;

	translate([- e_x/2,0,0])
	cube([e_x, e_y, material_thickness], center=true);

}


module top(){

	pylons = [2,2,2,2]; 
	types = [0,0,0,0];
	offset = main_x * 1.8;
	offsets = [offset, 0, 0, 0];

	bottom_x = main_x;
	bottom_y = main_y;

	difference(){
	generate_cube([main_x, main_y, material_thickness], true, pylons, types, offsets);
	top_cut();
	}

}





module west_cut(){

	w_x = 16;
	w_y = 40;
	
	 translate([w_x/2, 0, 0])
	cube([w_x, w_y, material_thickness], center=true);


}


module north_cut(){

	n_x = 15;
	n_y = 15;
	n_off = 10;
	translate([ n_x/2 + n_off,- n_y/2, 0 ])
	cube([n_x, n_y, material_thickness], center=true);
}



module bottom(){

	pylons = [1,2,1,2]; 
	types = [0,0,0,0];
	offset = material_thickness * 2;
	offsets = [-offset, 0, 0, -offset];

	bottom_x = main_x;
	bottom_y = main_y;

	difference(){
	generate_cube([main_x, main_y, material_thickness], true, pylons, types, offsets);

	bottom_cut();
	}

}



module print_me()
{
	bottom();
	
	translate([mill_space * 2,0,0])
	rotate([0,0,90])
	east_wall();

	mirror([1,0,0])
	translate([mill_space * 2,0,0])
	rotate([0,0,90])
	east_wall();

	translate([0,-mill_space, 0])
	south_wall();

	//translate([0,mill_space, 0])
	//north_wall();

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
