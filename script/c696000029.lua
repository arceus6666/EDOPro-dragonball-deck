-- xeno gohanks ssj3

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:TransformSSJ(SAIYAN.XENO_GOHANKS)
end

s.listed_names = { SAIYAN.XENO_GOHANKS }
