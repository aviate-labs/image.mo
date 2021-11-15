import P "Point";

module {
    type Rectangle = (P.Point, P.Point);

    public func toText((i, a) : Rectangle) : Text {
        P.toText(i) # "-" # P.toText(a);
    };

    public func inside((x, y) : P.Point, ((ix, iy), (ax, ay)) : Rectangle) : Bool {
        ix <= x and x < ax and iy <= y and y < ay;
    };

    public func dx(((ix, _), (ax, _)) : Rectangle) : Nat {
        ax - ix;
    };

    public func dy(((_, iy), (_, ay)) : Rectangle) : Nat {
        ay - iy;
    };

    public func size(((ix, iy), (ax, ay)) : Rectangle) : P.Point {
        return (
            ax - ix,
            ay - iy,
        );
    };
};