-- test ritual spell

Duel.LoadScript("functions696.lua")
local s, id = GetID()

-- function s.initial_effect(c)
--   --Activate
--   local e1 = Effect.CreateEffect(c)
--   e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
--   e1:SetType(EFFECT_TYPE_ACTIVATE)
--   e1:SetCode(EVENT_FREE_CHAIN)
--   e1:SetTarget(s.e1Target)
--   e1:SetOperation(s.e1Operation)
--   c:RegisterEffect(e1)

--   if not s.ritual_matching_function then
--     s.ritual_matching_function = {}
--   end
--   s.ritual_matching_function[c] = aux.FilterEqualFunction(Card.IsCode,
--     XENO_TRUNKS_GOD)
-- end

-- local XENO_TRUNKS_GOD = 696400000

-- s.listed_names = { SAIYAN.XENO_VEGETA, SAIYAN.XENO_VEGETA, SAIYAN.XENO_TRUNKS, XENO_TRUNKS_GOD }

-- function s.filter(c, e, tp, lp)
--   return c:IsCode(XENO_TRUNKS_GOD)
-- end

-- function s.gyfilter(c, e, tp, lp)
--   return c:IsCode(SAIYAN.XENO_TRUNKS)
-- end

-- function s.gygroup(tp)
--   return Duel.GetMatchingGroup(function(c)
--     return
--         not Duel.IsPlayerAffectedByEffect(c:GetControler(), 69832741)
--         and c:IsCode(SAIYAN.XENO_TRUNKS)
--         and c:IsAbleToRemove()
--   end, tp, LOCATION_HAND + LOCATION_MZONE, 0, nil)
-- end

-- function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
--   Debug.Message("target")
--   if chk == 0 then
--     local lp = Duel.GetLP(tp)
--     return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
--         s.gygroup(tp):GetCount() > 0 and
--         Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil,
--           e, tp, lp)
--   end
--   Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
-- end

-- function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
--   if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end

--   -- Debug.Message("pre gyg")
--   -- local gyg = s.gygroup(tp)
--   local gyg = Duel.SelectMatchingCard(tp, s.gyfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, 1, nil, e, tp, lp)
--   -- Debug.Message("post gyg")
--   -- local gtc = gyg:GetFirst()

--   if not #gyg then return end

--   local lp = Duel.GetLP(tp)
--   Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
--   -- Debug.Message("pre select")
--   local tg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND,
--     0, 1, 1, nil, e, tp, lp)
--   -- Debug.Message("post select")
--   local tc = tg:GetFirst()

--   if tc then
--     -- TODO: maybe "remove" can be improved with a selection box
--     -- Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_GRAVE)
--     -- local gp = gyg:FilterSelect(tp, s.filter, 1, 1, false, nil)
--     -- Duel.Remove(gp, LOCATION_GRAVE, 0, tp)
--     -- mustpay = true
--     -- Duel.Remove(gyg:GetFirst(), LOCATION_GRAVE, 0, tp)
--     Duel.SendtoGrave(gyg:GetFirst(), REASON_EFFECT + REASON_MATERIAL + REASON_RITUAL)
--     -- mustpay = false
--     tc:SetMaterial(nil)
--     Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, true, false, POS_FACEUP)
--     tc:CompleteProcedure()
--   end
-- end

function s.initial_effect(c)
  local e1 = RitualCopy({
    handler = c,
    lvtype = RITPROC_EQUAL,
    location = LOCATION_HAND,
    -- location = LOCATION_DECK,
    matfilter = s.mfilter,
    stage2 = s.stage2,
    filter = aux.FilterBoolFunction(Card.IsGod),
    lv = 8
  })
  e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  c:RegisterEffect(e1)
  -- local e1 = Ritual.CreateProc({
  --   handler = c,
  --   lvtype = RITPROC_EQUAL,
  --   location = LOCATION_DECK,
  --   matfilter = s.mfilter,
  --   stage2 = s.stage2
  -- })
  -- e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  -- c:RegisterEffect(e1)
end

function s.mfilter(c)
  -- Debug.Message(c:GetCode())
  -- Debug.Message(c.saiyan_god)
  -- what to tribute
  return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_NORMAL)
  -- return c:IsLocation(LOCATION_HAND)
end

function s.stage2(mat, e, tp, eg, ep, ev, re, r, rp, tc)
  -- Debug.Message("stage2")
  -- Debug.Message(mat)
  tc:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END + RESET_OPPO_TURN,
    EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 1))
  local e1 = Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE + PHASE_END)
  e1:SetCountLimit(1)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetLabelObject(tc)
  e1:SetReset(RESET_PHASE + PHASE_END + RESET_OPPO_TURN)
  e1:SetCondition(s.tdcon)
  e1:SetOperation(s.tdop)
  Duel.RegisterEffect(e1, tp)
end

function s.tdcon(e, tp, eg, ep, ev, re, r, rp)
  return Duel.IsTurnPlayer(1 - tp) and e:GetLabelObject():GetFlagEffect(id) > 0
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
  local sc = e:GetLabelObject()
  Duel.SendtoDeck(sc, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
end
