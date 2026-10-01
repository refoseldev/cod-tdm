if engine.ActiveGamemode() != "cod_custom" then return end

hook.Add("InitLoadAnimations", "wOS.DynaBase.GTDM", function()
    wOS.DynaBase:RegisterSource({
        Name = "CoD TDM Player Animations",
        Type = WOS_DYNABASE.EXTENSION,
        Male = "models/tdmg/cod_player_anims.mdl",
        Female = "models/tdmg/cod_player_anims.mdl",
        Zombie = "models/tdmg/cod_player_anims.mdl",
    })

    hook.Add("PreLoadAnimations", "wOS.DynaBase.GTDM", function(gender)
        if gender == WOS_DYNABASE.SHARED then
            IncludeModel("models/tdmg/cod_player_anims.mdl")
        end
    end)
end)