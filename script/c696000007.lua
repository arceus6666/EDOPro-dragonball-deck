-- fusion test

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Fusion materials
  c:FusionProc(696000005, 696000006)

  --lizard check
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(CARD_CLOCK_LIZARD)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e0:SetCondition(s.lizcon)
  e0:SetValue(1)
  c:RegisterEffect(e0)

  -- Special Summon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(aux.MetamoranLimit)
  c:RegisterEffect(e1)

  --special summon on death
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

s.listed_names = { CARD_FUSION_DANCE, 696000005, 696000006 }
s.material_setcode = ARCHETYPES.SAIYAN
s.fusion_dance = true

function s.lizcon(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_SUPREME_CASTLE)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.filter(c, e, tp, code)
  return c:IsCode(code)
      and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
  -- if chk == 0 then
  --   if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then return false end
  --   if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return false end
  --   local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp)
  --   return g:GetClassCount(Card.GetCode) >= 2
  -- end
  if chk == 0 then
    return
        not Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT)
        and Duel.GetLocationCount(tp, LOCATION_MZONE) > 2
        and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, 696000005)
        and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, 696000006)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end

  -- Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)

  -- local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp)
  local g1 = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp, 696000005)
  local g2 = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil, e, tp, 696000006)

  -- if #g == 0 then return end

  -- local sg = aux.SelectUnselectGroup(g, e, tp, 2, 2, aux.dncheck, 1, tp, HINTMSG_SPSUMMON)
  -- if #sg > 0 then
  --   Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
  -- end

  if #g1 > 0 and #g2 > 0 then
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg1 = g1:Select(tp, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg2 = g2:Select(tp, 1, 1, nil)
    sg1:Merge(sg2)
    Duel.SpecialSummon(sg1, 0, tp, tp, true, false, POS_FACEUP)
  end
end
