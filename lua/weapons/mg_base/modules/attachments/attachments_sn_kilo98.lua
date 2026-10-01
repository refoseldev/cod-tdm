AddCSLuaFile()

MW_ATT_KEYS["attachment_vm_sn_kilo98_barrel"] = {
    Name = "Default",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barrel.mdl"),
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_barlong"] = {
    Name = "FSS 24.0 Factory",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barlong.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_barlong.vmt"),
    Stats = function(self)
        self.Bullet.Damage[1] = self.Bullet.Damage[1] * 1.3
        self.Bullet.Damage[2] = self.Bullet.Damage[2] * 1.3
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 0.9
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 0.9
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 0.9
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 0.9
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 0.9
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 0.9
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_barmid"] = {
    Name = "FSS 20.0 Factory",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barmid.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_barmid.vmt"),
    Stats = function(self)
        self.Bullet.Damage[1] = self.Bullet.Damage[1] * 1.15
        self.Bullet.Damage[2] = self.Bullet.Damage[2] * 1.15
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 0.96
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 0.96
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 0.96
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 0.96
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 0.94
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_nostrippers"] = {
    Name = "No Stripper Clips",
    Stats = function(self)
       
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_barshort"] = {
    Name = "FSS 18.0 Factory",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barshort.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_barshort.vmt"),
    Stats = function(self)
        self.Bullet.Damage[1] = self.Bullet.Damage[1] * 1.18
        self.Bullet.Damage[2] = self.Bullet.Damage[2] * 1.075
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 1.1
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 1.1
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 1.1
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 1.1
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 1.25
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 1.25
    end
}

MW_ATT_KEYS["weapon_vm_scope_kilo98"] = {
    Name = "Scope",
    Model = Model("models/viper/mw/attachments/kilo98/weapon_vm_scope_kilo98.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_scope_kilo98.vmt"),
    Optic = {
        LensHideMaterial = Material("viper/mw/weapons/kilo98/weapon_vm_sn_kilo98_scopeglass.vmt"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 750, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
    },
    Reticle = {
        Material = Material("viper/mw/reticles/reticle_16.vmt"),
        Size = 1000,
        Color = Color(255, 255, 255, 255),
        Attachment = "reticle"
    },
    Stats = function(self)
        self.Animations.Rechamber = self.Animations.rechamber_scope
        self.Bullet.EffectiveRange = self.Bullet.EffectiveRange * 1.5
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 0.92
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 0.92
        self.Zoom.ViewModelFovMultiplier = 0.95
        self.Zoom.FovMultiplier = 0.8
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_stock_tactical"] = {
    Name = "MK2 Ultralight Hollow",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stock_tactical.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stock_tactical.vmt"),
    Stats = function(self)
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 0.92
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 0.92
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 0.92
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 0.92
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 1.1
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 1.1
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_stocks"] = {
    Name = "FSS MK2 Sport Comb",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stocks.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stocks.vmt"),
    Stats = function(self)
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 0.85
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 0.85
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 0.85
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 0.85
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 0.94
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 0.94
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_stockl"] = {
    Name = "FSS MK2 Precision Comb",
    Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stockl.mdl"),
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stockl.vmt"),
    Stats = function(self)
        self.Recoil.Vertical[1] = self.Recoil.Vertical[1] * 0.95
        self.Recoil.Vertical[2] = self.Recoil.Vertical[2] * 0.95
        self.Recoil.Horizontal[1] = self.Recoil.Horizontal[1] * 0.95
        self.Recoil.Horizontal[2] = self.Recoil.Horizontal[2] * 0.95
        self.Animations.Ads_In.Fps = self.Animations.Ads_In.Fps * 1.25
        self.Animations.Ads_Out.Fps = self.Animations.Ads_Out.Fps * 1.25
    end
}

MW_ATT_KEYS["attachment_vm_sn_kilo98_sling"] = {
    Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_sling.vmt"),
    Name = "Sling",
    Stats = function(self)
    end
}