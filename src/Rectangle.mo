import P "Point";

module {
    public let ZERO : Rectangle = ((0, 0), (0, 0));

    public type Rectangle = (P.Point, P.Point);

    public func toText((i, a) : Rectangle) : Text {
        P.toText(i) # "-" # P.toText(a);
    };

    public func inside((x, y) : P.Point, ((ix, iy), (ax, ay)) : Rectangle) : Bool {
        ix <= x and x < ax and iy <= y and y < ay;
    };

    public func intersect(r : Rectangle, s : Rectangle) : Rectangle {
        let ix = if (r.0.0 < s.0.0) { s.0.0 } else { r.0.0 };
        let iy = if (r.0.1 < s.0.1) { s.0.1 } else { r.0.1 };
        let ax = if (r.1.1 < s.1.1) { s.1.1 } else { r.1.1 };
        let ay = if (r.1.1 < s.1.1) { s.1.1 } else { r.1.1 };
        ((ix, iy), (ax, ay));
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

    public func empty(((ix, iy), (ax, ay)) : Rectangle) : Bool {
        ax <= ix or ay <= iy;
    };
};