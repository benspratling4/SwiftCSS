# SwiftCSS
Parse CSS and evaluate the cascade
The goal is to be able to parse all CSS, and be able to evaluate an arbitrary property name in a cascade
WIP Feel free to contribute.  

Status: Basic selector parsing without siblings combinators, only a single attribute on a selector, does not handle `!important` or at-statements.

Does not handle style attributes in Elements, does not handle "inherit", "unset" or "revert" values.

Can interpret color values except currentcolor.


## RuleSet Scanning

Neglecting at-statements, a CSS document is an array of "rule sets", represented by `RuleSet`.

`let css:String = ....`

`let ruleSet:[RuleSet] = [RuleSet](css: css)`



## Cascade Evaluation

Parse all your css strings to create `[RuleSet]`.  Then take your `SwiftCSS.Element` stack (or an array with a single `Element`) and evaluate the rule sets.

```
let css:String = """
p.black {
	background-color:#000000;
}
p {
	background-color:#FFFFFF;
}
"""
let ruleSets:[RuleSet] = [RuleSet](css: css)
let elementStack = [Element(name: "p", attributes: ["class":"black"])]
let decls = elementStack.evaluateCascade(rules: ruleSets, inlineStyle: [])

//decls[0].name == "background-color"
//decls[0].value == "#FFFFFF"
```

Inline styles always override.

Values are always strings, you can then attempt to interpret them as the data type you're looking for.



## Value Interpretation

WIP

### Color

Scanning a color value is working for all forms of colors, hex, rgb, rgba, hsl, hsla, named colors, and "currentcolor".

`let color:CSSColor? = Scanner(string:"#5A7B8C")`


All colors except "currentcolor" can be resolved into 8-bit RGBA bytes:

`let anyColor:CSSColor = ...`

`if let rgbaBytes:[UInt8] = anyColor.resolvedRGBA() { ... `
