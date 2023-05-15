-- xeno gogeta

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Fusion materials
  Fusion.AddProcMix(c, true, true, SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU)

  --special summon
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(s.condition)
  e1:SetTarget(s.target)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)
end

s.listed_names = { SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU }

function s.condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.filter(c, e, tp)
  return (c:IsCode(SAIYAN.XENO_VEGETA) or c:IsCode(SAIYAN.XENO_GOKU)) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
end


-- Card.IsCanBeSpecialSummoned(Card c, Effect e, int sumtype, int sumplayer, bool nocheck, bool nolimit[, int sumpos=POS_FACEUP, int target_player=sumplayer])

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then return false end
    if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return false end
    -- local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp)
    -- return g:GetClassCount(Card.GetCode) >= 2
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_GRAVE, 0, 2, 2, false, e)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end

  -- Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)

  local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp)

  if #g == 0 then return end

  local sg = aux.SelectUnselectGroup(g, e, tp, 2, 2, aux.dncheck, 1, tp, HINTMSG_SPSUMMON)
  if #sg > 0 then
    Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
  end
end
