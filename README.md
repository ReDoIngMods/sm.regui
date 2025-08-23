<img alt="Thumbnail" src="preview.png" style="width: 100%; height: auto;" />

---

<h1 align="center">A Community-Based GUI Library for Scrap Mechanic</h1>

`sm.regui` is a [**Scrap Mechanic**](https://store.steampowered.com/app/387990/Scrap_Mechanic/) dependency mod that allows modders to create graphical user interfaces that are normally not possible with `sm.gui`.

> [!NOTE]
> Funfact: This is the first **GUI Library** (based around with MyGui) ever in the **Scrap Mechanic Modding Community**

> [!CAUTION]
> The mod is currently *nearly* complete and is technically usable. **However**, the Fullscreen GUI feature is still unfinished. Everything else should work as expected.

With `sm.regui`, you can:
- **Create, destroy, and fully control widgets**
- Use a flexible template system
- Support fullscreen GUIs (allowing widgets to be placed anywhere on the screen and adapt to all in-game resolutions)
- Reimplement several unimplemented functions (e.g., `GuiInterface:setData`)
- Easily translate text with a built-in translation system

For examples, check out the [Examples](/Examples/) directory!  
For documentation, refer to the [ReGuiDef.lua](/ReGuiDef.lua) definition file.

---

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
> `sm.regui` uses a custom layout file structure that is not only incompatible with the LayoutEditor, but it's also written in JSON!
> 
> To create layout files, you must either write them manually or use an editor like ~~[MyGui.net For SM](https://github.com/ReDoIngMods/MyGui.net-For-SM)~~ *(Note: MyGui.net For SM does **not** support this yet, but support is planned.)*
