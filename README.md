<img src="preview.jpg" alt="preview" width="100%" />


<h1 align="center">
    <code>SM.REGUI</code> | Remaking MyGui in MyGui, while being better
</h1>

sm.regui (or simply just call it *ReGui*) is a GUI library built on top of JsonGui from Scrap Mechanic, designed to make it stupidly easy to make quality GUIs for your mods. Originally made on-top of the outdated system of GuiInterface's via a unintended workaround, now is built with JsonGui's.

## TODO

> [!NOTE]
> Anything marked with a star (`*`) means it may be scrapped!

> [!IMPORTANT]
> There may be more to than what's listed here, but this is the main list of things that need to be done.

- [ ] Implement widget system
    - [ ] Implement renderer
    - [ ] Implement being able to create widget types out of pure code
    - [ ] Inheritance system for widgets

- [ ] Basic Widgets
    - [ ] Widget
    - [ ] Label (inherits: `Widget`)
    - [ ] Button (inherits: `Label`)
    - [ ] Image (inherits: `Widget`)
    - [ ] EditBox (inherits: `TextBox`)
    - [ ] ProgressBar (inherits: `Widget`)

- [ ] Advanced Widgets
    - [ ] VideoWidget (inherits: `Widget`)
    - [ ] RichTextBox (inherits: `TextBox`)
    - [ ] RichEditBox (inherits: `RichTextBox`)

- [ ] UI Components
    - [ ] UIAspectRatioConstraint
    - [ ] UISizeConstraint
    - [ ] UIFlexItem
    - [ ] UIGridLayout
    - [ ] UIListLayout
    - [ ] UIPageLayout
    - [ ] UITableLayout*
    - [ ] UIPadding
    - [ ] UIMargin

- [ ] Layout System
    - [ ] Create a compact version of .relayout to save space
    - [ ] Implement loading .relayout files
    - [ ] Implement saving .relayout files
    - [ ] Implement loading/saving raw JsonGui files

- [ ] Rendering Pipelines
    - [ ] 3D Renderer (why the fuck not)
    - [ ] 2D Renderer
