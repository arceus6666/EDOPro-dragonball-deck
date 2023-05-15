-- xeno gogeta

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Fusion materials
  Fusion.AddProcMix(c, true, true, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU)

  --lizard check
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(CARD_CLOCK_LIZARD)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e0:SetCondition(s.lizcon)
  e0:SetValue(1)
  c:RegisterEffect(e0)

  --Special Summon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(aux.EvilHeroLimit)
  c:RegisterEffect(e1)
end

s.listed_names = { SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU }

function s.lizcon(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_SUPREME_CASTLE)
end
