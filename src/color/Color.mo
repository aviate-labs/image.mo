import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";

module {
    public type Color = {
        #RGBA    : RGBA;
        #RGBA64  : RGBA64;
        #NRGBA   : NRGBA;
        #NRGBA64 : NRGBA64;
        #Alpha   : Alpha;
        #Alpha16 : Alpha16;
        #Gray    : Gray;
        #Gray16  : Gray16;
    };

    public type RGBA    = (Nat8, Nat8, Nat8, Nat8);
    public type RGBA64  = (Nat16, Nat16, Nat16, Nat16);
    public type NRGBA   = (Nat8, Nat8, Nat8, Nat8);
    public type NRGBA64 = (Nat16, Nat16, Nat16, Nat16);
    public type Alpha   = Nat8;
    public type Alpha16 = Nat16;
    public type Gray    = Nat8;
    public type Gray16  = Nat16;

    public func toAlphaPreMultiplied(c : Color) : (Nat32, Nat32, Nat32, Nat32) {
        switch (c) {
            case (#RGBA(c)) {
                var r = Nat32.fromNat(Nat8.toNat(c.0));
                r |= r << 8;
                var g = Nat32.fromNat(Nat8.toNat(c.1));
                g |= g << 8;
                var b = Nat32.fromNat(Nat8.toNat(c.2));
                b |= b << 8;
                var a = Nat32.fromNat(Nat8.toNat(c.3));
                a |= a << 8;
                (r, g, b, a);
            };
            case (#RGBA64(r, g, b, a)) {
                (
                    Nat32.fromNat(Nat16.toNat(r)),
                    Nat32.fromNat(Nat16.toNat(g)),
                    Nat32.fromNat(Nat16.toNat(b)),
                    Nat32.fromNat(Nat16.toNat(a)),
                );
            };
            case (#NRGBA(c)) {
                var a = Nat32.fromNat(Nat8.toNat(c.3));
                var r = Nat32.fromNat(Nat8.toNat(c.0));
                r |= r << 8; r *= a; r /= 0xff;
                var g = Nat32.fromNat(Nat8.toNat(c.1));
                g |= g << 8; g *= a; g /= 0xff;
                var b = Nat32.fromNat(Nat8.toNat(c.2));
                b |= b << 8; b *= a; b /= 0xff;
                a |= a << 8;
                (r, g, b, a);
            };
            case (#NRGBA64(c)) {
                let a = Nat32.fromNat(Nat16.toNat(c.3));
                var r = Nat32.fromNat(Nat16.toNat(c.0));
                r *= a; r /= 0xffff;
                var g = Nat32.fromNat(Nat16.toNat(c.1));
                g *= a; g /= 0xffff;
                var b = Nat32.fromNat(Nat16.toNat(c.2));
                b *= a; b /= 0xffff;
                (r, g, b, a);
            };
            case (#Alpha(c)) {
                var a = Nat32.fromNat(Nat8.toNat(c));
                a |= a << 8;
                (a, a, a, a);
            };
            case (#Alpha16(c)) {
                let a = Nat32.fromNat(Nat16.toNat(c));
                (a, a, a, a);
            };
            case (#Gray(c)) {
                var g = Nat32.fromNat(Nat8.toNat(c));
                g |= g << 8;
                (g, g, g, 0xffff);
            };
            case (#Gray16(c)) {
                let g = Nat32.fromNat(Nat16.toNat(c));
                (g, g, g, 0xffff);
            };
        };
    };

    // Converts any Color to another color type from its own color model.
    public type Model = (c : Color) -> Color;

    public let rgbaModel : Model = func(c : Color) : Color {
        switch (c) {
            case (#RGBA(_)) c;
            case (_) {
                let (r, g, b, a) = toAlphaPreMultiplied(c);
                #RGBA(
                    Nat8.fromNat(Nat32.toNat(r >> 8)),
                    Nat8.fromNat(Nat32.toNat(g >> 8)),
                    Nat8.fromNat(Nat32.toNat(b >> 8)),
                    Nat8.fromNat(Nat32.toNat(a >> 8)),
                );
            };
        };
    };


    public let rgba64Model : Model = func(c : Color) : Color {
        switch (c) {
            case (#RGBA64(_)) c;
            case (_) {
                let (r, g, b, a) = toAlphaPreMultiplied(c);
                #RGBA64(
                    Nat16.fromNat(Nat32.toNat(r)),
                    Nat16.fromNat(Nat32.toNat(g)),
                    Nat16.fromNat(Nat32.toNat(b)),
                    Nat16.fromNat(Nat32.toNat(a)),
                );
            };
        };
    };

    public let nrgbaModel : Model = func(c : Color) : Color {
        switch (c) {
            case (#NRGBA(_)) c;
            case (_) {
                let (r, g, b, a) = toAlphaPreMultiplied(c);
                switch (a) {
                    case (0xffff) {
                        #NRGBA(
                            Nat8.fromNat(Nat32.toNat(r >> 8)),
                            Nat8.fromNat(Nat32.toNat(g >> 8)),
                            Nat8.fromNat(Nat32.toNat(b >> 8)),
                            Nat8.fromNat(0xff),
                        );
                    };
                    case (0) {
                        #NRGBA(0, 0, 0, 0);
                    };
                    case (_) {
                        #NRGBA(
                            Nat8.fromNat(Nat32.toNat(((r * 0xffff) / a) >> 8)),
                            Nat8.fromNat(Nat32.toNat(((g * 0xffff) / a) >> 8)),
                            Nat8.fromNat(Nat32.toNat(((b * 0xffff) / a) >> 8)),
                            Nat8.fromNat(Nat32.toNat(a >> 8)),
                        );
                    };
                };
            };
        };
    };

    public let nrgba64Model : Model = func(c : Color) : Color {
        switch (c) {
            case (#NRGBA64(_)) c;
            case (_) {
                let (r, g, b, a) = toAlphaPreMultiplied(c);
                switch (a) {
                    case (0xffff) {
                        #NRGBA64(
                            Nat16.fromNat(Nat32.toNat(r)),
                            Nat16.fromNat(Nat32.toNat(g)),
                            Nat16.fromNat(Nat32.toNat(b)),
                            Nat16.fromNat(0xffff),
                        );
                    };
                    case (0) {
                        #NRGBA64(0, 0, 0, 0);
                    };
                    case (_) {
                        #NRGBA64(
                            Nat16.fromNat(Nat32.toNat((r * 0xffff) / a)),
                            Nat16.fromNat(Nat32.toNat((g * 0xffff) / a)),
                            Nat16.fromNat(Nat32.toNat((b * 0xffff) / a)),
                            Nat16.fromNat(Nat32.toNat(a)),
                        );
                    };
                };
            };
        };
    };

    public let alphaModel : Model = func(c : Color) : Color {
        switch (c) {
            case (#Alpha(_)) c;
            case (_) {
                let (_, _, _, a) = toAlphaPreMultiplied(c);
                #Alpha(Nat8.fromNat(Nat32.toNat(a >> 8)));
            };
        };
    };

    public let alpha16Model : Model = func(c : Color) : Color {
        switch (c) {
            case (#Alpha16(_)) c;
            case (_) {
                let (_, _, _, a) = toAlphaPreMultiplied(c);
                #Alpha16(Nat16.fromNat(Nat32.toNat(a)));
            };
        };
    };

    public let grayModel : Model = func(c : Color) : Color {
        switch (c) {
            case (#Gray(_)) c;
            case (_) {
                let (r, g, b, _) = toAlphaPreMultiplied(c);
                // Reference: JFIF/JPEG spec.
                let gr = (19595 * r + 38470 * g + 7471 * b + 1 << 15) >> 24;
                #Gray(Nat8.fromNat(Nat32.toNat(gr)));
            };
        };
    };

    public let gray16Model : Model = func(c : Color) : Color {
        switch (c) {
            case (#Gray16(_)) c;
            case (_) {
                let (r, g, b, _) = toAlphaPreMultiplied(c);
                let gr = (19595 * r + 38470 * g + 7471 * b + 1 << 15) >> 16;
                #Gray16(Nat16.fromNat(Nat32.toNat(gr)));
            };
        };
    };
};
