-- Xeno Vegito

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  -- potara fusion
  c:PotaraFusion(SAIYAN.XENO_GOKU, SAIYAN.XENO_VEGETA)

  --cannot be target
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(s.efilter)
  c:RegisterEffect(e1)

  --cannot be destroyed
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetValue(s.efilter)
  c:RegisterEffect(e2)
end

function s.efilter(e, re, rp)
  return re:IsActiveType(TYPE_EFFECT)
end
