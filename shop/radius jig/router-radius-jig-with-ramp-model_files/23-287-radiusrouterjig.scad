include<ub.scad>; //⇒ v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
designVersion="1.0";
designer="Ulrich Bär";
license="CC0";
useVersion=23.285;//(sites.google.com/site/ulrichbaer)
assert(Version>=useVersion,str("lib version ",Version," detected, include ",useVersion," ub.scad library‼ ⇒http://v.gd/ubaer"));
/*[Basics]*/
nozzle=.2;
bed=false;
pPos=[0,0];
info=true;
name=undef;


/*[Router Rig]*/
size=50;
rad=15;

T(printPos){
//Tz(.1)color("skyblue",alpha=.15)RR(r=10);
RR(rad=rad);
}
if($preview){
$info=0;
  Tz(5.1)color("BurlyWood",.5)cube([50,60,20]);
  Tz(-.1)color("black",0.25)cube([50,60,.2]);
  T(-4,rad+5,-1){
    color("fuchsia")Pfeil(4,1,center=[+0,1]);
    T(+4,-8)mirror([0,0,0])Text(text="radius",h=.1,cx=-1,size=3);
    T(+4,-3)mirror([0,0,0])Text(text="overlap",h=.1,cx=-1,size=3);
    T(3,5)mirror([0,0,0])Text(text="ramp",h=.1,cx=-1,size=3);
    }
  T(0,rad)color("aqua")Pfeil(3,1,center=[-1,1]);
}

module RR(rad=10,dicke=5,size=size,offset=(17-12.7)/2*0){
lap=5;// straight overshoot after radius
deg=-2;// in out ramp
r=max(0,rad-offset);
block=[20,5,5+dicke];
$info=0;
size=is_list(size)?vMax(size,r+lap+block.x+10):[1,1]*max(r+lap+block.x+10,size);

assert(r>=2,"rad too small");
Echo("Kopierring offset",color="warning",condition=offset);
//square(size);
points=[
[0,size.y],
[tan(deg)*(size.y-r-lap),size.y],
[0,r+lap],
each arc(r=r,deg=90,rot=180,t=[r,r]),
[r+lap,0],
[size.x,tan(deg)*(size.x-r-lap)],
[size.x,0]
];

centerL=((size.x+size.y)/4)*sqrt(2)-(r*sqrt(2)-r+dicke);

  difference(){
    color("skyblue")Roof(dicke,[1,1]*.5)Rund(block.y/3,2){
        Rand(-dicke)polygon(points);
        rotate(45)T(r*sqrt(2)-r+dicke/2+1.5)square([centerL-1.5,dicke]);// diagonal
        T(size.x-block.x)mirror([0,1])square(block.xy+[0,offset]);// block X
        T(y=size.y-block.x)rotate(90)square(block.xy+[0,offset]); // block Y
      }
//text
      color("lime")Tz(dicke/2)MKlon(tz=-dicke/2-.01)Roof(h=.25){
      rotate(45)T(r*sqrt(2)-r+dicke/2+centerL/2,.5)mirror([$idx?0:1,0])Text(str(rad),size=dicke,cx=true);
      rotate(45)T((size.x+size.y)/4*sqrt(2)-.5)mirror([0,$idx?0:1])Text(str(r,offset?str("+ ofs=",offset):""),size=dicke,cx=true,rot=90);
      }
// radius marker
    Tz(-.5){
      T(r,.5)R(-90)LinEx(dicke-1,1,grad=45,$d=2)circle($r,$fn=4);
      T(.5,r)R(0,90)LinEx(dicke-1,1,grad=45,$d=2)circle($r,$fn=4);
    }
// center marker
    T(r,r)rotate(45)cylinder(50,d=1,$fn=4);
  }
  color("skyblue"){
    T(size.x-block.x,-offset)mirror([0,1])Prisma(block,center=[0,0,0],r=block.y/3);
    T(-offset,size.y-block.x)rotate(90)Prisma(block,center=[0,0,0],r=block.y/3);
  }

}

// version Info
if(string2num(designVersion[2])>0)T(1,-1)color("navy")linear_extrude(.1)Seg7(str(designVersion),h=1,spiel=0.01,b=.05,ratio=0.5,center=true,name=0);