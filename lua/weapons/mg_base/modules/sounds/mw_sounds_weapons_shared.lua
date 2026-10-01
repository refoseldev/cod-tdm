AddCSLuaFile()

sound.Add({
    name =          "MW.Explosion",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    level =  140,
    sound =  "^viper/shared/rocket_expl_body_01.wav"
})

sound.Add({
    name =          "MW.ExplosiveRounds",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    level = 140,
    soundlevel =  SNDLVL_GUNFIRE,
    sound =             {
    "viper/shared/frag_expl_body_01.ogg",
    "viper/shared/frag_expl_body_02.ogg",
    "viper/shared/frag_expl_body_03.ogg",
    "viper/shared/frag_expl_body_04.ogg"} 
})

sound.Add({
    name =          "MW.Rocket_Fly_Loop",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    soundlevel =   SNDLVL_NONE,
    sound =             {
    "^viper/shared/move_rpapa7_proj_flame_cls.wav"}
})
