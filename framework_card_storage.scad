include <BOSL/constants.scad>
use <BOSL/masks.scad>
use <BOSL/transforms.scad>
use <BOSL/metric_screws.scad>
use <hinge.scad>

walls = 2;

fwc_w = 31;		// 30.65mm
fwc_d = 32;		// 32.468mm
fwc_h = 7;		// 6.909mm
fwce_d = 50;
fwce_h = 13.5;		// higher part
usbc_w = 8.7;		// 8.636mm
usbc_d = 7;		// 8.128mm
usbc_h = 2.8;		// 2.743mm
usbc_off = 2.01;	// offset from the bottom

/* screw driver */
sd_h = 14.4;
sd_w = 140.8;
sd_d = 9.8;

logo_w = 30;
logo_d = 30;

fwc_td = fwc_d + usbc_d;
fwce_td = fwce_d + usbc_d;

base_w = sd_w + 2 * walls;
/* it's the highest piece */
base_h = sd_h / 2 + walls;
hinge_d = base_h/2;
base_d = fwc_td * 2 + sd_d + 4 * walls + hinge_d;

magnet_r = 3;
magnet_h = 6;

fillet_r = 1.5;

/*
applyHinges([[0,0,0]], [0], 7/2, 7, 70, 6, 0.5)
  union() {
    translate([0,0.5,0])
    cube([70,60,7]);

  }
*/

module fwc() {
    union() {
	cube([fwc_w, fwc_d, fwc_h]);
	back(fwc_d) right(fwc_w/2 - usbc_w/2) cube([usbc_w, usbc_d, fwc_h]);
    }
}

module fwce() {
    union() {
	/* sideways */
	back(fwc_w/2 - usbc_w/2) cube([usbc_d, usbc_w, fwce_h]);
	right(usbc_d) cube([fwce_d, fwc_w, fwce_h]);
    }
}

module base() {

    difference() {
	cube([base_w, base_d, base_h]);
	back(hinge_d + walls) right((base_w - 5*walls - 4*fwc_w)/2) up(base_h - fwc_h/2) union() {
	    right(walls) fwc();
	    right(walls*2 + fwc_w) fwc();
	    right (walls*3 + fwc_w*2) fwc();
	    right (walls*4 + fwc_w*3) fwc();
	}
	back(hinge_d + walls*2 + fwc_d + usbc_d) right(walls) up(base_h - sd_h/2)
	    cube([sd_w, sd_d, sd_h/2]);
	back(hinge_d + walls*3 + fwc_d + usbc_d + sd_d)
	    right((base_w - 4*walls - 2*fwc_w - fwce_d)/2)
	    union() {
		up(base_h - fwc_h/2) fwc();
		up(base_h - fwc_h/2) right(walls + fwc_w) fwc();
		right(2*walls + fwc_w*2) up(base_h - fwce_h/2) fwce();
	    }
	up(base_h - magnet_h/2) right(walls+magnet_r) back(base_d - walls - magnet_r) cylinder(h=magnet_h, r=magnet_r);
	up(base_h - magnet_h/2) right(base_w - walls - magnet_r) back(base_d - walls - magnet_r) cylinder(h=magnet_h, r=magnet_r);
	fillet_mask_x(l=base_w, r=fillet_r, align=V_RIGHT);
	back(base_d) fillet_mask_x(l=base_w, r=fillet_r, align=V_RIGHT);
	up(base_h) back(base_d) fillet_mask_x(l=base_w, r=fillet_r, align=V_RIGHT);
	fillet_mask_y(l = base_d, r=fillet_r, align=V_BACK);
	right(base_w) fillet_mask_y(l = base_d, r=fillet_r, align=V_BACK);
	up(base_h) fillet_mask_y(l = base_d, r=fillet_r, align=V_BACK);
	up(base_h) right(base_w) fillet_mask_y(l = base_d, r=fillet_r, align=V_BACK);
	back(base_d) fillet_mask_z(l = base_h, r = fillet_r, align=V_UP);
	right(base_w) back(base_d) fillet_mask_z(l = base_h, r = fillet_r, align=V_UP);
    }
}


applyHinges([[0,0,0]], [0], hinge_d, base_h, base_w, 6, 0.5)
    union() {
	back(0.5) base();
	difference() {
	    forward(0.5) mirror([0, 1, 0]) base();
	    right(base_w/2 - logo_w/2) forward(base_d/2 + 0.5 + logo_d/2) linear_extrude(1) resize([logo_w, logo_d, 0]) import("logo.svg");
	}
    }
