-- test ritual spell

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  if not s.ritual_matching_function then
    s.ritual_matching_function = {}
  end
  s.ritual_matching_function[c] = aux.FilterEqualFunction(Card.IsCode,
    XENO_TRUNKS_GOD)
end

local XENO_TRUNKS_GOD = 696400000

s.listed_names = { SAIYAN.XENO_TRUNKS, XENO_TRUNKS_GOD }

function s.filter(c, e, tp, lp)
  return c:IsCode(XENO_TRUNKS_GOD)
end

function s.gygroup(tp)
  return Duel.GetMatchingGroup(function(c)
    return
        not Duel.IsPlayerAffectedByEffect(c:GetControler(), 69832741)
        and c:IsCode(SAIYAN.XENO_TRUNKS)
        and c:IsAbleToRemove()
  end, tp, LOCATION_HAND + LOCATION_MZONE, 0, nil)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    local lp = Duel.GetLP(tp)
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        s.gygroup(tp):GetCount() > 0 and
        Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil,
          e, tp, lp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end

  local gyg = s.gygroup(tp)
  if gyg:GetCount() < 1 then return end

  local lp = Duel.GetLP(tp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local tg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND,
    0, 1, 1, nil, e, tp, lp)
  local tc = tg:GetFirst()
  if tc then
    -- TODO: maybe "remove" can be improved with a selection box
    -- Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_GRAVE)
    -- local gp = gyg:FilterSelect(tp, s.filter, 1, 1, false, nil)
    -- Duel.Remove(gp, LOCATION_GRAVE, 0, tp)
    mustpay = true
    Duel.Remove(gyg:GetFirst(), LOCATION_GRAVE, 0, tp)
    mustpay = false
    tc:SetMaterial(nil)
    Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, true, false, POS_FACEUP)
    tc:CompleteProcedure()
  end
end
