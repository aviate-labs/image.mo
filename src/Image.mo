import Array "mo:base/Array";

import C "color/Color";
import P "Point";
import R "Rectangle";

module {
    public type Image = {
        colorModel()         : C.Model;
        bounds()             : R.Rectangle;
        at(x : Nat, y : Nat) : C.Color;
    };

    public class RGBA(
        rect : R.Rectangle,
    ) : Image {
        private let stride : Nat         = 4 * R.dx(rect);
        private let pixels : [var Nat8]  = Array.init<Nat8>(pixelBufferSize(4, rect), 0);


        public func colorModel() : C.Model { C.rgbaModel() };

        public func bounds() : R.Rectangle { rect };

        public func at(x : Nat, y : Nat) : C.Color {
            if (not R.inside((x, y), rect)) return (0, 0, 0, 0);
            let i = pixelOffset(x, y);
            let r = pixels[i];
            let g = pixels[i+1];
            let b = pixels[i+2];
            let a = pixels[i+3];
            (r, g, b, a);
        };

        private func pixelOffset(x : Nat, y : Nat) : Nat {
            ((y - rect.0.1) * stride + (x - rect.0.0) * 4);
        };

        public func set(x : Nat, y : Nat, (r, g, b, a) : C.Color) {
            if (not R.inside((x, y), rect)) return;
            let i = pixelOffset(x, y);
            pixels[i] := r;
            pixels[i+1] := g;
            pixels[i+2] := b;
            pixels[i+3] := a;
        };
    };

    private func pixelBufferSize(bytesPerPixel : Nat, r : R.Rectangle) : Nat {
        bytesPerPixel * R.dx(r) * R.dy(r);
    };
};