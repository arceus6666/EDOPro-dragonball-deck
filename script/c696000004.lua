-- Xeno Gogeta

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  
  c:FusionDance(id, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU)
end

s.listed_names = { CARD_FUSION_DANCE, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU }
s.material_setcode = ARCHETYPES696.SAIYAN
s.fusion_dance = true