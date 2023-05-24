-- xeno vegeta ssj1

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:TransformSSJ(SAIYAN.XENO_VEGETA)
end

s.listed_names = { SAIYAN.XENO_VEGETA }
