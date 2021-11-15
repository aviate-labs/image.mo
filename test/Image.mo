import Iter "mo:base/Iter";

import C "../src/color/Color";
import R "../src/Rectangle";
import Image "../src/Image";

import Debug "mo:base/Debug";

let red : C.Color  = #RGBA(255, 0, 0, 0);
let blue : C.Color = #RGBA(0, 0, 255, 0);

let r : R.Rectangle = ((0, 0), (3, 3));
let i = Image.RGBA(r, null);

assert(i.bounds() == r);
for (x in Iter.range(0, 2)) {
    for (y in Iter.range(0, 2)) {
        assert(i.at(x, y) == ?#RGBA(0, 0, 0, 0));
        i.set(x, y, switch (x, y) {
            case (1, 1) blue;
            case (_, _) red;
        });
    };
};
assert(i.at(1, 1) == ?blue);
