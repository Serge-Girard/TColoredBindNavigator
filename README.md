# TColoredBindNavigator
TBindNavigator Delphi FMX component with glyphs colors

TBindNavigator is a little sad, all buttons glyph have the same color (TText.Font.Color). 
![Capture_1](https://github.com/user-attachments/assets/530fff4c-0c29-4d73-beb3-dbf9bc730ff6)
![Capture_2](https://github.com/user-attachments/assets/6f9e0972-9d7c-43cd-a47e-b48a7e60d6f5)

Let me give some colors as VCL.Navigator.

![Capture_3](https://github.com/user-attachments/assets/8ecfc5dc-8870-444b-b373-6fb6ca4827ef)

As extra, you shall be able to :
- Change background color. (OverrideBackGround property, a TBrush) 
- Add Hints. (used only if component.ShowHints = True)
- Return to default color (NavigatorGlyphColors.UseColors property)
- If you are a Dark/Light force side fan an NavigatorGlyphColors.ThemeSensitive property is included
  to brigthen colors without changing the defined colors.  
