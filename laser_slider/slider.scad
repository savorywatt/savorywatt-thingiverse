
material_height = 3;
rod_diameter = 8;
linear_diameter = 15;
f = 30;

main();

module main(){

    side();

}


module side()
{
    side_x = 100;
    side_y = 60;
    cube([side_x, side_y, material_height], center=true);

    rod_holder();
}


module rod_holder()
{
    linear_extrude(height=material_height)
    circle(r=rod_diameter/2, center=true);
}

