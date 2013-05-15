use <write/Write.scad> 
///////////////////
// Will Wheaton said 'Make it so' and the internet obliged.
///////////////////////


///////////////////////
// Configuration
///////////////////////

words = "Special Blend";
default = "Wil O Licious";
handle_id = 10;
bottom_pillar_height = 30;
handle_height = 150;
handle_diameter = 25;


//////////////////////////
//Variables
//////////////////////////

fn = 100;
inner_od = handle_id + 10;


main();
////////////////////////////////////////////////////////


module main()
{
	color("grey")
	handle();
	color("black")
	writing();

}

module handle()
{
	hull()
	{
	translate([0,0,handle_height + bottom_pillar_height])
	sphere(r=20, $fn=fn);

	translate([0,0.5,0])
	writing();
	translate([0,0,bottom_pillar_height])
	linear_extrude(height=20)
	{
	circle(handle_diameter, $fn=fn);
	}
	}

	linear_extrude(height=bottom_pillar_height)
	{
	difference()
	{
		circle(inner_od, $fn=fn);
		circle(handle_id, $fn=fn);
	}
	}
}


module writing()
{
	total_height = bottom_pillar_height + handle_height;
	writecylinder(words,[0,0,total_height/2 + bottom_pillar_height], handle_diameter, bottom_pillar_height, h=10, rotate=90,center=true); 
	//writecylinder(default,[0,0,bottom_pillar_height/2], inner_od, bottom_pillar_height,rotate=45,center=true); 
	
}




module testing()
{
translate([0,0,0])
%cylinder(r=20,h=40,center=true);
color([1,0,0])
writecylinder("rotate=90",[0,0,0],20,40,center=true,down=0,rotate=90);
writecylinder("rotate = 30,east = 90",[0,0,0],20,40,center=true,down=0,rotate=30,east=90);
writecylinder("ccw = true",[0,0,0],20,40,center=true,down=0,face="top",ccw=true);
writecylinder("middle = 8",[0,0,0],20,40,h=3,center=true,down=0,face="top",middle=8);
writecylinder("face = top",[0,0,0],20,40,center=true,down=0,face="top");
writecylinder("east=90",[0,0,0],20,40,h=3,center=true,down=0,face="top",east=90);
writecylinder("west=90",[0,0,0],20,40,h=3,center=true,down=0,face="top",ccw=true,west=90);
writecylinder("face = bottom",[0,0,0],20,40,center=true,down=0,face="bottom"); 
	
}