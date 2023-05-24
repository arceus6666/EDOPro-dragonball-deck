-- test special

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --special summon condition
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)

  --special summon
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.spcon)
  e1:SetTarget(s.sptg)
  e1:SetOperation(s.spop)
  c:RegisterEffect(e1)
end

s.listed_series = { ARCHETYPES.SAIYAN }

local code = ARCHETYPES.SAIYAN + 0

function s.cfilter(c)
  return c:IsSetCard(code) and c:IsReleasable()
end

function s.spcon(e, c)
  if c == nil then return true end
  local tp = e:GetHandlerPlayer()
  local rg = Duel.GetMatchingGroup(s.cfilter, tp, LOCATION_MZONE, 0, nil)
  return #rg > 0 and aux.SelectUnselectGroup(rg, e, tp, 2, 2, aux.ChkfMMZ(1), 0)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
  local rg = Duel.GetMatchingGroup(s.cfilter, tp, LOCATION_MZONE, 0, nil)
  local g = aux.SelectUnselectGroup(rg, e, tp, 2, 2, aux.ChkfMMZ(1), 1, tp, HINTMSG_RELEASE, nil, nil, true)
  if #g > 0 then
    g:KeepAlive()
    e:SetLabelObject(g)
    return true
  end
  return false
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
  local g = e:GetLabelObject()
  if not g then return end
  Duel.Release(g, REASON_COST)
  g:DeleteGroup()
end
