AddCSLuaFile()

function SWEP:doSuppressorStats()
    self.Primary.Sound = Sound("weap_delta_fire_plr_sup")
    self.Reverb = {
        RoomScale = 50000,
        Sounds = {
            Outside = {
                Layer = Sound("Atmo_Sniper_Sup.Outside"),
                Reflection = Sound("Reflection_Sniper.Outside")
            },
    
            Inside = { 
                Layer = Sound("Atmo_DMR_Sup.Inside"),
                Reflection = Sound("Reflection_ARSUP.Inside")
            }
        }
    }
    self.ParticleEffects.MuzzleFlash = "mw_fas2_muzzleflash_suppressed"
end

SWEP.Customization = {
    {"att_perk", "attachment_vm_sn_delta_perk_soh", "att_perk_steadywalk", "attachment_vm_ar_delta_perk_fullauto", "att_perk_scopesway"}, 

    {"attachment_vm_sn_delta_receiver"}, 

    {"attachment_vm_sn_delta_stock", "attachment_vm_sn_delta_stock_short", 
    "attachment_vm_sn_delta_stock_light", "att_vm_stock_heavy01", 
    "att_vm_stock_heavy02", "att_vm_stock_light01", "att_vm_stock_medium01", "att_vm_stock_no"},

    {"attachment_vm_sn_delta_mag",  "attachment_vm_sn_delta_xmags", "attachment_vm_sn_delta_xmags2"},
   
    {"attachment_vm_sn_delta_barrel", "attachment_vm_sn_delta_barlong", 
    "attachment_vm_sn_delta_barshort"},

    {"att_muzzle", "att_vm_breacher01", "att_vm_breacher02", "att_vm_compensator01", 
    "att_vm_compensator02", "att_vm_flashhider01", "att_vm_flashhider02", 
    "att_vm_flashhider03", "att_vm_flashhider04", "att_vm_muzzlebrake01",
    "att_vm_muzzlebrake02", "att_vm_muzzlebrake03",
    "att_vm_silencer01", "att_vm_silencer02", "att_vm_silencer03",
    "att_vm_silencer04", "att_vm_silencer05", "att_vm_silencer06"}, 

    {"attachment_vm_sn_delta_irons", "att_vm_2x_west02_holo", "att_vm_2x_west02", "att_vm_reflex_02", "attachment_vm_sn_delta_scope", "attachment_vm_thermalsnpr_west01_delta_v3",
    "att_vm_minireddot01_tall", "att_vm_minireddot02_tall", "att_vm_minireddot03_tall",
    "att_vm_holo_west01", "att_vm_holo_west02", "att_vm_holo_east01", "att_vm_reflex_east01",
    "att_vm_reflex_east02_tall", "att_vm_reflex_west02_tall", "att_vm_reflex_west03",
    "att_vm_thermal_east01", "att_vm_thermal_west01", "att_vm_thermal_east01_hybrid",
    "att_vm_hybrid_west01", "att_vm_hybrid_west03", "att_vm_4x_east01_tall", "att_vm_2x_west01",
    "att_vm_4x_west01_tall", "att_vm_4x_west02_tall", "att_vm_reflex_west04"},

    {"att_laser", "attachment_vm_sn_delta_laser01", "attachment_vm_sn_delta_laser02", 
    "attachment_vm_sn_delta_laser03"},
}

--NECESSARY: it loads custom attachments from other authors
require("mw_utils")
mw_utils.LoadInjectors(SWEP)   