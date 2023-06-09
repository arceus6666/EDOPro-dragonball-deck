-- test ritual spell

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  -- e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
end

s.listed_series = { ARCHETYPES696.SAIYAN }

function s.tgfilter(c, e, tp)
  return c:IsFaceup()
      and c:IsCanBeSaiyanGod()
      and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp, c)
end

function s.spfilter(c, e, tp, mc)
  if Duel.GetLocationCount(tp, LOCATION_MZONE, tp) <= 0 then return false end

  return c:GetCode() == SAIYAN.TRANSFORMED_GODS[mc:GetCode()]
      and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, true, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc == 0 then
    return chkc:IsLocation(LOCATION_MZONE)
        and chkc:IsControler(tp)
        and s.tgfilter(chkc, e, tp)
  end

  if chk == 0 then return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp) end

  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
  Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e)
      and tc:IsFaceup()
      and not tc:IsImmuneToEffect(e)
  then
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp, tc)
    local sc = sg:GetFirst()
    if sc then
      Duel.SendtoGrave(tc, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
      Duel.BreakEffect()
      Duel.SpecialSummon(sc, SUMMON_TYPE_SPECIAL, tp, tp, true, false, POS_FACEUP)
      sc:CompleteProcedure()
    end
  end
end
