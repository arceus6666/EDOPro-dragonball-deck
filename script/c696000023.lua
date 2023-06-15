-- xeno trunks ssj

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:TransformSSJ(SAIYAN.XENO_TRUNKS)
end

s.listed_names = { SAIYAN.XENO_TRUNKS }
