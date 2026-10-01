AddCSLuaFile()

MW_ATT_KEYS["attachment_vm_sn_mike14_barrel"] = {
    Name = "Default",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barrel.mdl"),
}

MW_ATT_KEYS["attachment_vm_sn_mike14_barlight"] = {
    Name = "FSS 24.0 Factory",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barlight.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_barlight.vmt"),
    Stats = function(self)
        weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 1.3
        weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.3
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.9
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.9
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.9
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.9
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_barlong"] = {
    Name = "FSS 20.0 Factory",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barlong.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_barlong.vmt"),
    Stats = function(self)
        weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 1.15
        weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.15
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.96
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.96
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.96
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.96
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.94
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_barlong2"] = {
    Name = "FSS 20.0 Factory",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barlong2.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_barlong2_v2.vmt"),
    Stats = function(self)
        weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 1.15
        weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.15
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.96
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.96
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.96
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.96
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.94
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_stock"] = {
    Name = "Default",
    Stats = function(self)
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_stock_v2_alt"] = {
    Name = "MK2 Ultralight Hollow",
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_v2.vmt"),
    Stats = function(self)
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.92
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.92
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.92
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.92
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.1
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.1
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_stock_v3"] = {
    Name = "FSS MK2 Sport Comb",
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_v3.vmt"),
    Stats = function(self)
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.85
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.85
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.85
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.85
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.94
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_stockcqb_alt"] = {
    Name = "FSS MK2 Precision Comb",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_stockcqb_alt.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stockcqb.vmt"),
    Stats = function(self)
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.95
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.95
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.95
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.95
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_stock_tactical"] = {
    Name = "FSS MK2 Precision Comb",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_stock_tactical.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_tactical.vmt"),
    Stats = function(self)
        weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.95
        weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.95
        weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.95
        weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.95
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_mag"] = {
    Name = "FSS MK2 Sport Comb",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_mag.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stocks.vmt"),
    Stats = function(self)
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.94
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_xmags"] = {
    Name = "FSS MK2 Precision Comb",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_xmags.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_xmags.vmt"),
    Stats = function(self)
        weapon.Animations.Reload = weapon.Animations.Reload_Xmag
        weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_Xmag
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    end
}

MW_ATT_KEYS["attachment_vm_sn_mike14_xmags2"] = {
    Name = "FSS MK2 Precision Comb",
    Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_xmags2.mdl"),
    Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_xmags2.vmt"),
    Stats = function(self)
        weapon.Animations.Reload = weapon.Animations.Reload_Xmag2
        weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_Xmag2
        weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
        weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    end
}