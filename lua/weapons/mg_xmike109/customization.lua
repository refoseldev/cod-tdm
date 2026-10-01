AddCSLuaFile()

function SWEP:doSuppressorStats()
    self.Primary.Sound = Sound("weap_xmike109_sup_plr")
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

function SWEP:doDBStats()
end

SWEP.Customization = {
    {"att_perk", "attachment_vm_sn_xmike109_perk_soh", "att_perk_steadywalk", "att_perk_nodrop", "att_perk_scopesway"}, 

    {"attachment_vm_sn_xmike109_stock", "attachment_vm_sn_xmike109_stockl", 
    "attachment_vm_sn_xmike109_stocks"},

    {"attachment_vm_sn_xmike109_mag",  "attachment_vm_sn_xmike109_calcust1", "attachment_vm_sn_xmike109_calcust2"},
   
    {"attachment_vm_sn_xmike109_barrel", "attachment_vm_sn_xmike109_barlong", 
    "attachment_vm_sn_xmike109_barshort", "attachment_vm_sn_xmike109_barhvy"},

    {"att_muzzle", "att_vm_hdromeo_compensator01", "att_vm_hdromeo_flashhider01", "att_vm_hdromeo_muzzlebrake01", 
    "att_vm_hdromeo_muzzlebrake02", "att_vm_hdromeo_silencer01", "att_vm_hdromeo_silencer02", 
    "att_vm_hdromeo_silencer03", "attachment_vm_sn_xmike109_brake", "attachment_vm_sn_xmike109_silencerlrg"}, 

    {"attachment_vm_sn_xmike109_irons", "att_vm_2x_west02_holo", "att_vm_2x_west02", "att_vm_reflex_02", "attachment_vm_sn_xmike109_scope",
    "att_vm_minireddot01_tall", "att_vm_minireddot02_tall", "att_vm_minireddot03_tall",
    "att_vm_holo_west01", "att_vm_holo_west02", "att_vm_holo_east01", "att_vm_reflex_east01",
    "att_vm_reflex_east02_tall", "att_vm_reflex_west02_tall", "att_vm_reflex_west03",
    "att_vm_thermal_east01", "att_vm_thermal_west01", "att_vm_thermal_east01_hybrid",
    "att_vm_hybrid_west01", "att_vm_hybrid_west03", "att_vm_4x_east01_tall", "att_vm_2x_west01",
    "att_vm_4x_west01_tall", "att_vm_4x_west02_tall", "att_vm_reflex_west04",
    "att_vm_scope_xmike109", "att_vm_scope_vz"},

    {"att_laser", "attachment_vm_sn_xmike109_laser01", "attachment_vm_sn_xmike109_laser02", 
    "attachment_vm_sn_xmike109_laser03"},
}

--NECESSARY: it loads custom attachments from other authors
require("mw_utils")
mw_utils.LoadInjectors(SWEP)   