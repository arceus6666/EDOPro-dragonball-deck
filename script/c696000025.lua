-- xeno trunks god

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  -- god saiyan summon
  c:TransformSaiyanGod(SAIYAN.XENO_TRUNKS)
end

s.listed_names = { SAIYAN.XENO_TRUNKS }
s.listed_series = { ARCHETYPES696.SAIYAN }
