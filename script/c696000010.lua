-- Xeno Gohanks

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:FusionDance(id, SAIYAN.XENO_GOHAN, SAIYAN.XENO_TRUNKS)
end

s.listed_names = { CARD_FUSION_DANCE, SAIYAN.XENO_GOHAN, SAIYAN.XENO_TRUNKS }
s.material_setcode = ARCHETYPES.SAIYAN
s.fusion_dance = true
