AddCSLuaFile()
function SWEP:doSuppressorStats()
    self.Primary.Sound = Sound("weap_slima_sup_plr")
    self.Reverb = {
        RoomScale = 50000,
        Sounds = {
            Outside = {
                Layer = Sound("Atmo_AR_Sup.Outside"),
                Reflection = Sound("Reflection_ARSUP.Outside")
            },
    
            Inside = { 
                Layer = Sound("Atmo_AR_Sup.Inside"),
                Reflection = Sound("Reflection_ARSUP.Inside")
            }
        } 
    }
    self.ParticleEffects.MuzzleFlash = "mw_fas2_muzzleflash_suppressed"
end

function SWEP:doSmgStats()
    local bSup1 = self:HasAttachment("attachment_vm_silencer_east01")
    local bSup2 = self:HasAttachment("attachment_vm_silencer02")
    local bSup3 = self:HasAttachment("attachment_vm_silencer03")
    local bSup4 = self:HasAttachment("attachment_vm_silencer04")

    if (!bSup1 && !bSup2 && !bSup3 && !bSup4) then
        self.Primary.Sound = Sound("mw19.akilo47.smgcal.fire")
        self.Reverb = {
            RoomScale = 50000,
            Sounds = {
                Outside = {
                    Layer = Sound("Atmo_AR3.Outside"),
                    Reflection = Sound("Reflection_AR.Outside")
                },
        
                Inside = { 
                    Layer = Sound("Atmo_AR.Inside"),
                    Reflection = Sound("Reflection_AR.Inside")
                }
            }
        }
    end

    self.Shell = "mwb_shelleject_545"
end

SWEP.Customization = {
    {"att_perk", "attachment_vm_lm_slima_perk_soh", "att_perk_fmj", "att_perk_ricochet", "att_perk_headshot"}, 

    {"attachment_vm_lm_slima_stock", "attachment_vm_lm_slima_stockh", 
    "attachment_vm_lm_slima_stockl", "attachment_vm_lm_slima_stockno", "attachment_vm_lm_slima_stocks"},

    {"attachment_vm_lm_slima_mag", "attachment_vm_lm_slima_xmags", 
    "attachment_vm_lm_slima_smag"},

    {"attachment_vm_lm_slima_barrel", "attachment_vm_lm_slima_barlight", 
    "attachment_vm_lm_slima_barlong", "attachment_vm_lm_slima_barhvy"},

    {"att_muzzle", "att_vm_breacher01", "att_vm_breacher02", "att_vm_compensator01", 
    "att_vm_compensator02", "att_vm_flashhider01", "att_vm_flashhider02", 
    "att_vm_flashhider03", "att_vm_flashhider04", "att_vm_muzzlebrake01",
    "att_vm_muzzlebrake02", "att_vm_muzzlebrake03",
    "att_vm_silencer01", "att_vm_silencer02", "att_vm_silencer03",
    "att_vm_silencer04", "att_vm_silencer05", 'att_vm_silencer06'},

    {"att_sight", "att_vm_2x_west02_holo", "att_vm_2x_west02", "att_vm_reflex_02", "att_vm_minireddot01_tall", "att_vm_minireddot02_tall", "att_vm_minireddot03_tall",
    "att_vm_holo_west01", "att_vm_holo_west02", "att_vm_holo_east01", "att_vm_reflex_east01",
    "att_vm_reflex_east02_tall", "att_vm_reflex_west02_tall", "att_vm_reflex_west03",
    "att_vm_thermal_east01", "att_vm_thermal_west01", "att_vm_thermal_east01_hybrid",
    "att_vm_hybrid_west01", "att_vm_hybrid_west03", "att_vm_4x_east01_tall",
    "att_vm_4x_west01_tall", "att_vm_4x_west02_tall",
    "att_vm_scope_mike14", "att_vm_scope_vz"},

    {"att_laser", "attachment_vm_lm_slima_laser01", "attachment_vm_lm_slima_laser02", 
    "attachment_vm_lm_slima_laser03"},

    {"att_grip", "attachment_vm_lm_slima_bipod", "attachment_vm_lm_slima_gripside", "attachment_vm_lm_slima_gripside02", 
    "attachment_vm_lm_slima_gripside03"},
}

--NECESSARY: it loads custom attachments from other authors
require("mw_utils")
mw_utils.LoadInjectors(SWEP)   