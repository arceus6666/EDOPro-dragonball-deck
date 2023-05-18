-- xeno gogeta

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  
  c:FusionDance(id, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU)
end

s.listed_names = { CARD_FUSION_DANCE, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU }
s.material_setcode = ARCHETYPES.SAIYAN
s.fusion_dance = true