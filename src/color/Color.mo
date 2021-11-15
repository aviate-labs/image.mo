module {
    public type Color = (Nat8, Nat8, Nat8, Nat8);

    public type Model = {
        // Converts any Color to another color type from its own color model.
        convert(c : Color, typ : Text) : Color;
    };

    public func rgbaModel() : Model {
        {
            convert = func(c : Color, _ : Text) : Color {
                assert(false); // TODO;
                c;
            };
        };
    };
}