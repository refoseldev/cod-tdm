AddCSLuaFile()

include("shared.lua")

MWBASE_STENCIL_REFVALUE = 69

CreateClientConVar("mgbase_rig", "chands", true, false, "Change first person arms rig.")
CreateClientConVar("mgbase_rig_skin", "0", true, false, "Change first person arms rig skin.", 0)
CreateClientConVar("mgbase_gloves", "", true, false, "Change first person arms gloves.")
CreateClientConVar("mgbase_gloves_skin", "0", true, false, "Change first person arms gloves.", 0)
CreateClientConVar("mgbase_toggleaim", "0", true, true, "Hold to aim.", 0, 1)
CreateClientConVar("mgbase_autoreload", "1", true, true, "Toggle auto reload.", 0, 1)
CreateClientConVar("mgbase_aimassist", "1", true, true, "Toggle aim assist.", 0, 1)
CreateClientConVar("mgbase_manualrechamber", "0", true, true, "Toggle manual rechambering.", 0, 1)
CreateClientConVar("mgbase_fx_blur", "1", true, false, "Toggle first person blur.", 0, 1)
CreateClientConVar("mgbase_fx_smoke", "1", true, false, "Toggle barrel smoke.", 0, 1)
CreateClientConVar("mgbase_fx_laser_weaponcolor", "0", true, false, "Toggle sandbox weapon color usage for lasers.", 0, 1)
CreateClientConVar("mgbase_fx_vmfov", "1", true, false, "Change viewmodel FOV.", 0.1, 2)
CreateClientConVar("mgbase_fx_vmfov_ads", "1", true, false, "Change viewmodel FOV (only when aiming).", 0.1, 2)
CreateClientConVar("mgbase_hud_xhaircolor", "255 255 255", true, false, "Crosshair color.", 0, 1)
CreateClientConVar("mgbase_hud_xhair", "1", true, false, "Toggle crosshair.", 0, 1)
CreateClientConVar("mgbase_hud_firemode", "1", true, false, "Toggle firemode HUD.", 0, 1)
CreateClientConVar("mgbase_hud_sights", "1", true, false, "Toggle sights HUD.", 0, 1)
CreateClientConVar("mgbase_hud_flashlight", "1", true, false, "Toggle flashlight HUD.", 0, 1) 
CreateClientConVar("mgbase_debug_freeview", "0", false, false, "Toggle debug free view.", 0, 1)
CreateClientConVar("mgbase_debug_crosshair", "0", false, false, "Toggle debug crosshair for ironsights.", 0, 1)
CreateClientConVar("mgbase_debug_disablebreathing", "0", false, false, "Toggle breathing.", 0, 1)
CreateClientConVar("mgbase_debug_vmrender", "1", false, false, "Toggle viewmodel render.", 0, 1)
CreateClientConVar("mgbase_debug_wmrender", "1", false, false, "Toggle worldmodel render.", 0, 1)
--CreateClientConVar("mgbase_debug_freezeanim", "0", false, false, "Freeze viewmodel animations.", 0, 1)
--CreateClientConVar("mgbase_debug_animdelta", "0", false, false, "Scrub the current animation on the viewmodel.", 0, 1)
CreateClientConVar("mgbase_presetspawnmethod", "0", true, false, "Spawn preset method: 0 = none, 1 = random, 2 = random default, 3 = random favorite")

--binds
local mbind, sbind, cbind, ibind, fbind = input.LookupBinding("+grenade2"), input.LookupBinding("+zoom"), input.LookupBinding("+menu_context"), input.LookupBinding("+reload"), input.LookupBinding("+grenade1")

CreateClientConVar("mgbase_binds_melee", mbind and input.GetKeyCode(mbind) or "0", true, true)
CreateClientConVar("mgbase_binds_switchsights", sbind and input.GetKeyCode(sbind) or "0", true, true)
CreateClientConVar("mgbase_binds_customize", cbind and input.GetKeyCode(cbind) or "0", true, true)
CreateClientConVar("mgbase_binds_safety", "0", true, true)
CreateClientConVar("mgbase_binds_inspect", ibind and input.GetKeyCode(ibind) or "0", true, true)
CreateClientConVar("mgbase_binds_firemode", fbind and input.GetKeyCode(fbind) or "0", true, true)
CreateClientConVar("mgbase_binds_holster", "0", true, true)

if (math.random(1, 100) == 1) then
    list.Set( "ContentCategoryIcons", "Modern Warfare", "vgui/bentler.png" )
   else
   list.Set( "ContentCategoryIcons", "Modern Warfare", "vgui/mw_logo.png" )

end

concommand.Add("mgbase_generatepreset", function(p, c, args)
    local w = p:GetActiveWeapon()

    if (args[1] == nil) then
        print("Missing name! Type a name in quotes (eg. \"The Gun\")")
        return
    end

    if (IsValid(w) && weapons.IsBasedOn(w:GetClass(), "mg_base")) then
        local attachmentList = ""

        for _, a in pairs(w:GetAllAttachmentsInUse()) do
            if (a.Index > 1) then
                attachmentList = attachmentList..", \""..a.ClassName.."\""
            end
        end

        attachmentList = string.sub(attachmentList, 3)

        local finalPrint = "PRESET.SWEP = \""..w:GetClass().."\"\n"
        finalPrint = finalPrint.."PRESET.Name = \""..args[1].."\"\n"
        finalPrint = finalPrint.."PRESET.Attachments = {"..attachmentList.."}"

        print("Here's your preset (copied to clipboard already)")
        print("Remember to put this in lua/weapons/mg_base/modules/presets")
        print("From there, create a .lua file with any name you want and paste the contents in there")
        print("=================")
        print(finalPrint)
        SetClipboardText(finalPrint)
    end
end)

net.Receive("mgbase_tpanim", function()
    local slot = net.ReadUInt(2)
    local anim = net.ReadInt(12)
    local ply = net.ReadEntity()
    
    if (ply == NULL) then
        return
    end
    
    ply:AnimRestartGesture(slot, anim, true)
end)