-- fusion test

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  c:FusionDance(id, 696000005, 696000006)
end

s.listed_names = { CARD_FUSION_DANCE, 696000005, 696000006 }
s.material_setcode = 0
s.fusion_dance = true
