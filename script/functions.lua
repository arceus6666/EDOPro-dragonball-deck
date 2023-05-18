Duel.LoadScript("constants.lua")

function Card.FusionProc(c, ...)
  Fusion.AddProcMix(c, true, true, ...)
end

function Auxiliary.MetamoranLimit(e, se, sp, st)
  return se:GetHandler():IsCode(CARD_FUSION_DANCE)
      -- return se:GetHandler():IsCode(CARD_DARK_FUSION)
      -- or (Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_METAMOR)
      or (Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_SUPREME_CASTLE) -- TODO: change card to metamor
        and st & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION)
end

-- Fusion Dance --

function FusionProc(c, ...)
  Fusion.AddProcMix(c, true, true, ...)
end

function Fsodfilter(c, e, tp, cd)
  return c:IsCode(cd)
      and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
end

function Card.FusionDanceSpSummon(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCode(EFFECT_SPSUMMON_CONDITION)
  e:SetValue(aux.MetamoranLimit)
  c:RegisterEffect(e)
end

function Card.FusionDanceLizard(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetCode(CARD_CLOCK_LIZARD)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_SUPREME_CASTLE)
  end)
  e:SetValue(1)
  c:RegisterEffect(e)
  return e
end

function Card.FusionSummonOnDeath(c, mat1, mat2)
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
  end)
  e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
      return
          not Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT)
          and Duel.GetLocationCount(tp, LOCATION_MZONE) > 2
          and Duel.IsExistingMatchingCard(Fsodfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mat1)
          and Duel.IsExistingMatchingCard(Fsodfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mat2)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
  end)
  e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
    if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
    local g1 = Duel.GetMatchingGroup(Fsodfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, mat1)
    local g2 = Duel.GetMatchingGroup(Fsodfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, mat2)
    if #g1 > 0 and #g2 > 0 then
      Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
      local sg1 = g1:Select(tp, 1, 1, nil)
      Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
      local sg2 = g2:Select(tp, 1, 1, nil)
      sg1:Merge(sg2)
      Duel.SpecialSummon(sg1, 0, tp, tp, true, false, POS_FACEUP)
    end
  end)
  c:RegisterEffect(e1)
end

function Card.FusionDance(c, mat1, mat2)
  c:FusionProc(mat1, mat2)
  c:FusionDanceLizard()
  c:FusionDanceSpSummon()
  c:FusionSummonOnDeath(c, mat1, mat2)
end

-- Fusion Dance --
