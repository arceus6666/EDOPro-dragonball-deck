-- test potara fusion

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --spsummon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(aux.fuslimit)
  c:RegisterEffect(e1)

  --spsummon
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetRange(LOCATION_EXTRA)
  e2:SetCondition(s.hspcon)
  e2:SetTarget(s.hsptg)
  e2:SetOperation(s.hspop)
  c:RegisterEffect(e2)
end

function s.filtercon(c, tp, sc)
  return c:IsType(TYPE_NORMAL, sc, MATERIAL_FUSION, tp)
      and c:GetEquipGroup():IsExists(aux.FilterBoolFunction(Card.IsCode, POTARA_EARING), 1, nil)
      and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0
end

function s.hspfilter(c, tp, sc)
  return c:IsCode(SAIYAN.XENO_VEGETA) and s.filtercon(c, tp, sc)
end

function s.hspfilter2(c, tp, sc)
  return c:IsCode(SAIYAN.XENO_GOKU) and s.filtercon(c, tp, sc)
end

function s.checkcon(c, f)
  local tp = c:GetControler()
  return Duel.CheckReleaseGroup(tp, f, 1, false, 1, true, c, tp, nil, false, nil, tp, c)
end

function s.hspcon(e, c)
  if c == nil then return true end
  -- return Duel.CheckReleaseGroup(tp, s.hspfilter, 1, false, 1, true, c, tp, nil, false, nil, tp, c)
  return s.checkcon(c, s.hspfilter) and s.checkcon(c, s.hspfilter2)
end

function s.hsptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
  local g = Duel.SelectReleaseGroup(tp, s.hspfilter, 1, 1, false, true, true, c, nil, nil, false, nil, tp, c)
  local h = Duel.SelectReleaseGroup(tp, s.hspfilter2, 1, 1, false, true, true, c, nil, nil, false, nil, tp, c)
  g = g:AddCard(h)
  if g then
    g:KeepAlive()
    e:SetLabelObject(g)
    return true
  end
  return false
end

function s.hspop(e, tp, eg, ep, ev, re, r, rp, c)
  local g = e:GetLabelObject()
  if not g then return end
  Duel.Release(g, REASON_COST)
  g:DeleteGroup()
end
