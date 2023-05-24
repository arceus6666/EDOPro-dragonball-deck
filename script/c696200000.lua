--test ritual monster
Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --spsummon
  local e3 = Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCondition(s.spcon)
  e3:SetTarget(s.sptg)
  e3:SetOperation(s.spop)
  c:RegisterEffect(e3)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsReason(REASON_BATTLE + REASON_EFFECT)
end

function s.spfilter(c, e, tp)
  return c:IsSetCard(RACE_SAIYAN) and c:IsRitualMonster() and not c:IsCode(id) and
  c:IsCanBeSpecialSummoned(e, 0, tp, true,
    false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) < 1 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
  if #g > 0 then
    Duel.SpecialSummon(g, 0, tp, tp, true, false, POS_FACEUP)
  end
end
