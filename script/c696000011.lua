-- xeno vegeta ssj1

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  c:TransformSSJ(SAIYAN.XENO_VEGETA)

  -- --cannot special summon
  -- local e1 = Effect.CreateEffect(c)
  -- e1:SetType(EFFECT_TYPE_SINGLE)
  -- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  -- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  -- e1:SetValue(aux.FALSE)
  -- c:RegisterEffect(e1)

  -- --special summon
  -- local e2 = Effect.CreateEffect(c)
  -- e2:SetType(EFFECT_TYPE_FIELD)
  -- e2:SetCode(EFFECT_SPSUMMON_PROC)
  -- e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  -- e2:SetRange(LOCATION_HAND)
  -- e2:SetCondition(s.spcon)
  -- e2:SetTarget(s.sptg)
  -- e2:SetOperation(s.spop)
  -- c:RegisterEffect(e2)
end

s.listed_names = { SAIYAN.XENO_VEGETA }

-- function s.spcon(e, c)
--   if c == nil then return true end
--   return Duel.CheckReleaseGroup(c:GetControler(), Card.IsCode, 1, false, 1, true, c, c:GetControler(), nil, false, nil,
--     SAIYAN.XENO_VEGETA)
-- end

-- function s.sptg(e, tp, eg, ep, ev, re, r, rp, c)
--   local g = Duel.SelectReleaseGroup(tp, Card.IsCode, 1, 1, false, true, true, c, nil, nil, false, nil, SAIYAN
--   .XENO_VEGETA)
--   if g then
--     g:KeepAlive()
--     e:SetLabelObject(g)
--     return true
--   end
--   return false
-- end

-- function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
--   local g = e:GetLabelObject()
--   if not g then return end
--   Duel.Release(g, REASON_COST)
--   g:DeleteGroup()
-- end
