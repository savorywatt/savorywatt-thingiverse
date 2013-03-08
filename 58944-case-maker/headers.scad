//headers(6,6);

///////////////////////////
//	Global Variables	//
///////////////////////////

width = 2.8;
height = 8.5;
inner_width = 1.5;

///////////////////////////

module gen_header(xnum, ynum){

	translate([-(xnum * width)/2 + width/2, -(ynum * width)/2 + width/2 , 0])
	union(){
	for ( i = [0 : xnum - 1])
	{
		translate([i * width, 0, 0])
		for(i = [0 : ynum - 1])
		{
			translate([0, i * width, 0])
			header();
		}
	}}
}

module header(){

	translate([0,0,height/2])
	difference(){
	cube([width, width, height], center = true);
	translate([0,0,height/2 * 2])
	cube([inner_width, inner_width, height], center = true);
	}


}