-- test special

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  c:TransformSaiyanGod(SAIYAN.XENO_TRUNKS)

  --special summon condition
  -- local e0 = Effect.CreateEffect(c)
  -- e0:SetType(EFFECT_TYPE_SINGLE)
  -- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  -- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  -- c:RegisterEffect(e0)

  --special summon
  -- local e1 = Effect.CreateEffect(c)
  -- e1:SetType(EFFECT_TYPE_FIELD)
  -- e1:SetCode(EFFECT_SPSUMMON_PROC)
  -- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  -- e1:SetRange(LOCATION_HAND)
  -- e1:SetCondition(s.spcon)
  -- e1:SetTarget(s.sptg)
  -- e1:SetOperation(s.spop)
  -- c:RegisterEffect(e1)
end

-- function s.chk(c, sg)
--   -- dracoslayer / Dracoverlord
--   -- return c:IsSetCard(0xc7) and sg:IsExists(Card.IsSetCard, 1, c, 0xda)
--   return c:IsCode(SAIYAN.XENO_TRUNKS) and sg:IsExists(Card.IsSetCard, 2, c, ARCHETYPES.SAIYAN)
-- end

-- function s.rescon(sg, e, tp, mg)
--   return aux.ChkfMMZ(1)(sg, e, tp, mg) and sg:IsExists(s.chk, 1, nil, sg)
-- end

-- function s.spcon(e, c)
--   if c == nil then return true end
--   local tp = c:GetControler()
--   local rg = Duel.GetReleaseGroup(tp)
--   local g1 = rg:Filter(Card.IsCode, nil, SAIYAN.XENO_TRUNKS)
--   local g2 = rg:Filter(Card.IsSetCard, nil, ARCHETYPES.SAIYAN)
--   local g = g1:Clone()
--   g:Merge(g2)
--   return Duel.GetLocationCount(tp, LOCATION_MZONE) > -2
--       and #g1 > 0
--       and #g2 > 0
--       and #g > 1
--       and aux.SelectUnselectGroup(g, e, tp, 3, 3, s.rescon, 0)
-- end

-- function s.sptg(e, tp, eg, ep, ev, re, r, rp, c)
--   local rg = Duel.GetReleaseGroup(tp)
--   local g1 = rg:Filter(Card.IsCode, nil, SAIYAN.XENO_TRUNKS)
--   local g2 = rg:Filter(Card.IsSetCard, nil, ARCHETYPES.SAIYAN)
--   g1:Merge(g2)
--   local sg = aux.SelectUnselectGroup(g1, e, tp, 3, 3, s.rescon, 1, tp, HINTMSG_RELEASE, nil, nil, true)
--   if #sg > 0 then
--     sg:KeepAlive()
--     e:SetLabelObject(sg)
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
