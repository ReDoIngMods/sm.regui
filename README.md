<img alt="Thumbnail" src="preview.png" style="width: 100%; height: auto;" />

---

<h1 align="center">A Community-Based GUI Library for Scrap Mechanic</h1>

`sm.regui` is a [**Scrap Mechanic**](https://store.steampowered.com/app/387990/Scrap_Mechanic/) library mod that allows modders to create graphical user interfaces that are normally not possible with `sm.gui`.

> [!NOTE]
> This is the first **GUI Library** (based around with MyGui) ever in the **Scrap Mechanic Modding Community**!

With `sm.regui`, you can:
- **Create, destroy, and fully control widgets**
- Use a flexible template system
- Support fullscreen GUIs (allowing widgets to be placed anywhere on the screen and adapt to all in-game resolutions)
- Use functions that are now implemented! (e.g., `GuiInterface:setData`)
- Easily translate text with a built-in translation system
- Draw any font you desire in any rotation*
- Create lists with the flexible widgets API.
- Play high-quality compressed 720p video.

For examples, check out the [Examples](/Examples/) directory!  
For documentation, refer to the [ReGuiDef.lua](/ReGuiDef.lua) definition file ~~or inside the [Scrap Mechanic Tools](https://example.com) website!~~ (That's a todo at the time of writing this)

---
<h3 align="center">Notes about this library:</h3>

> [!IMPORTANT]
> This GUI library uses a GUI exploit that allows modders to create MyGui Layout Files! As a result, the library may break in future game updates.

> [!CAUTION]
> **Consider optimization if you're using `sm.regui` for animations, etc.**
>   
> The GUI exploit being used may result in bloated files that **cannot be deleted without user assistance**.  
> 
> For example, Anything related for positioning and resizing (as a animation) should be done with controllers to reduce bloat.

> [!NOTE]
> The latest known version that works with this library is: `Scrap Mechanic BETA Ver 0.7.3 Build 776`

> [!WARNING]
> **Not Supported in MyGui LayoutEditor**
> 
> `sm.regui` uses a custom layout file structure (called relayout with the .relayout extension) that wont work with the **MyGui Layout** editor at all!
> 
> If you want to create `relayout` files, you only got a few choices:
> -  Use a editor like ~~[MyGui.net For SM](https://github.com/ReDoIngMods/MyGui.net-For-SM)~~ *(Note: MyGui.net For SM does **not** support this yet, but support is planned.)*
> - Write the relayout file manually.
> - Use a `.layout` to `.relayout` converter. (One provided in DevTools/LayoutToRelayout/)