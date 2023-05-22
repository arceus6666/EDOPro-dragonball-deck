-- Xeno Vegeks

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:PotaraFusion(SAIYAN.XENO_VEGETA, SAIYAN.XENO_TRUNKS)
end
