# SwiftCSS
Parse CSS and evaluate the cascade


WIP Feel free to contribute.  

The goal is to be able to parse all CSS, and be able to evaluate an arbitrary property name in a cascade


## Primitive Scanning

### Color

Scanning a color value is working for all forms of colors, hex, rgb, rgba, hsl, hsla, named colors, and "currentcolor".

`let color:CSSColor? = Scanner(string:"#5A7B8C")`


All colors except "currentcolor" can be resolved into 8-bit RGBA bytes:


`let anyColor:CSSColor = ...`

`if let rgbaBytes:[UInt8] = anyColor.resolvedRGBA() { ... `
