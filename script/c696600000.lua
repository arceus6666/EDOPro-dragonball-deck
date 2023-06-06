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
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
end

s.listed_series = { 0x10a2 }
function s.tgfilter(c, e, tp)
  -- Debug.Message("selected", c:GetCode())
  -- target monster to sacrifice
  return c:IsFaceup()
      -- and c:IsSetCard(0x10a2)
      and c:IsCanBeSaiyanGod()
      -- and c:IsCanBeFusionMaterial()
      and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp, c)
end

function s.spfilter(c, e, tp, mc)
  -- monster to summon

  -- local cc = Duel.GetLocationCount(tp, LOCATION_MZONE, tp)
  -- local ex = Duel.GetLocationCountFromEx(tp, tp, mc, c)
  -- Debug.Message("ex", ex, "-----", "cc", cc, "-----")
  if Duel.GetLocationCount(tp, LOCATION_MZONE, tp) <= 0 then return false end

  -- local mustg = aux.GetMustBeMaterialGroup(tp, nil, tp, c, nil, REASON_FUSION)
  -- return c:IsType(TYPE_FUSION) and c:ListsCodeAsMaterial(mc:GetCode()) and
  --     c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
  --     and (#mustg == 0 or (#mustg == 1 and mustg:IsContains(mc)))
  -- if c:GetCode() == SAIYAN.TRANSFORMED_GODS[mc:GetCode()] then
  --   Debug.Message(c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, true, false))
  -- end

  return c:GetCode() == SAIYAN.TRANSFORMED_GODS[mc:GetCode()]
      and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, true, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc == 0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc, e, tp) end

  if chk == 0 then return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp) end

  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
  Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
  -- Debug.Message("target selected")
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp, tc)
    local sc = sg:GetFirst()
    -- Debug.Message("god selected", sc:GetCode())
    if sc then
      -- sc:SetMaterial(Group.FromCards(tc))
      Duel.SendtoGrave(tc, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
      Duel.BreakEffect()
      Duel.SpecialSummon(sc, SUMMON_TYPE_SPECIAL, tp, tp, true, false, POS_FACEUP)
      sc:CompleteProcedure()
    end
  end
end
