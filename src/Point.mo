import Nat "mo:base/Nat";

module {
    // Point is an X, Y coordinate pair.
    // The axes increase right and down.
    public type Point = (Nat, Nat);

    public func toText((x, y) : Point) : Text {
        "(" # Nat.toText(x) # "," # Nat.toText(y) # ")"
    };

    // p + q
    public func add((x, y) : Point, (v, w) : Point) : Point {
        (x + v, y + w);
    };

    // p - q
    public func sub((x, y) : Point, (v, w) : Point) : Point {
        (x - v, y - w);
    };

    // p * k
    public func mult((x, y) : Point, k : Nat) : Point {
        (x * k, y * k);
    };

    // p / k
    public func div((x, y) : Point, k : Nat) : Point {
        (x / k, y / k);
    };

    public func equal((x, y) : Point, (v, w) : Point) : Bool {
        x == v and y == w;
    };
};
