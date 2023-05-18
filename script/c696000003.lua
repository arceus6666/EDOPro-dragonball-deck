-- fusion dance

Duel.LoadScript("functions.lua")
local s, id = GetID()

-- function s.initial_effect(c)
--   --Fusion summon 1 fiend fusion monster
--   --Using monsters from hand or field as material
--   local e1 = Fusion.CreateSummonEff({
--     handler = c,
--     fusfilter = aux.FilterBoolFunction(Card.IsSetCard, ARCHETYPES.SAIYAN),
--     stage2 = s.stage2
--   })
--   e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
--   c:RegisterEffect(e1)
-- end

-- function s.stage2(e, tc, tp, sg, chk)
--   if chk == 1 then
--     --Cannot be targeted by opponent's card effects
--     local e1 = Effect.CreateEffect(e:GetHandler())
--     e1:SetDescription(3061)
--     e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
--     e1:SetType(EFFECT_TYPE_SINGLE)
--     e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
--     e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
--     e1:SetValue(aux.tgoval)
--     tc:RegisterEffect(e1)
--   end
-- end

function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
end

function s.tgfilter(c, e, tp, rp)
  return c:IsCode(SAIYAN.XENO_VEGETA, SAIYAN.XENO_GOKU)
      and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, c:GetCode(), rp)
end

function s.xvfilter(c, e, tp, rp)
  return c:IsCode(SAIYAN.XENO_VEGETA)
end

function s.xgfilter(c, e, tp, rp)
  return c:IsCode(SAIYAN.XENO_GOKU)
end

function s.spfilter(c, e, tp, code, rp)
  return
  -- c:IsType(TYPE_FUSION)
      c:IsCode(SAIYAN.XENO_GOGETA)
      -- and c.material_trap
      and Duel.GetLocationCountFromEx(tp, rp, nil, c) > 0
      and c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
  -- and code == c.material_trap
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.tgfilter, tp,
      LOCATION_HAND + LOCATION_MZONE, 0, 1, nil, e, tp, rp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.eefilter(e, c)
  return c:IsImmuneToEffect(e)
end

function s.efilter(e)
  -- return s.eefilter(e)
  return function(c) return not c:IsImmuneToEffect(e) end
end

function s.lfilter(c)
  return c:IsLocation(LOCATION_GRAVE)
end

function s.pfilter(c)
  return c:IsPreviousLocation(LOCATION_MZONE)
      and c:IsPreviousPosition(POS_FACEUP)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)

  local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 2, 2, nil, e, tp, rp)
  -- local tc = g:GetFirst()

  -- local h = Duel.SelectMatchingCard(tp, s.xgfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, 1, nil, e, tp, rp)
  -- local tc2 = h:GetFirst()

  if (g and g:CheckSameProperty(s.efilter(e))) then
    Debug.Message("in if g")
    Duel.SendtoGrave(g, REASON_EFFECT)

    if (not g:CheckSameProperty(s.lfilter)) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)

    local sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0,
      1, 1, nil, e, tp, g)
    if (g:CheckSameProperty(s.pfilter)) then
      sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, g)
    end

    local sc = sg:GetFirst()
    if sc then
      Duel.BreakEffect()
      Duel.SpecialSummon(sc, 0, tp, tp, true, false, POS_FACEUP)
      sc:CompleteProcedure()
    end
  end

  -- if (tc and not tc:IsImmuneToEffect(e)) and (tc2 and not tc2:IsImmuneToEffect(e)) then
  --   if tc:IsOnField() and tc2:IsOnField() then
  --     Duel.ConfirmCards(1 - tp, Group.FromCards(tc, tc2))
  --   end
  --   Duel.SendtoGrave(tc, REASON_EFFECT)
  --   Duel.SendtoGrave(tc2, REASON_EFFECT)

  --   if (not tc:IsLocation(LOCATION_GRAVE)) or (not tc2:IsLocation(LOCATION_GRAVE)) then return end
  --   Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)

  --   local sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0,
  --     1, 1, nil, e, tp, tc:GetCode(), tc2:GetCode())
  --   if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsPreviousPosition(POS_FACEUP) and tc2:IsPreviousLocation(LOCATION_MZONE) and tc2:IsPreviousPosition(POS_FACEUP) then
  --     sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, tc:GetPreviousCodeOnField(),
  --       tc2:GetPreviousCodeOnField())
  --   end

  --   local sc = sg:GetFirst()
  --   if sc then
  --     Duel.BreakEffect()
  --     Duel.SpecialSummon(sc, 0, tp, tp, true, false, POS_FACEUP)
  --     sc:CompleteProcedure()
  --   end
  -- end
end
