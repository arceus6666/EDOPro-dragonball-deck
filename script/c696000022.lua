-- xeno vegito ssj4

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:TransformSSJ(SAIYAN.XENO_VEGITO_SSJ3)
end

s.listed_names = { SAIYAN.XENO_VEGITO_SSJ3 }
