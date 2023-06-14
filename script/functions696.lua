Duel.LoadScript("constants696.lua")

function Card.IsCanBeSaiyanGod(c)
  return c:IsCode(SAIYAN.GODS)
end

RitualCopy = aux.FunctionWithNamedArgs(
  function(c, _type, filter, lv, desc, extrafil, extraop, matfilter, stage2, location, forcedselection, customoperation,
           specificmatfilter, requirementfunc, sumpos, extratg)
    Debug.Message("copy", c:GetCode(), lv)
    --lv can be a function (like GetLevel/GetOriginalLevel), fixed level, if nil it defaults to GetLevel
    if filter and type(filter) == "function" then
      local mt = c.__index
      if not mt.ritual_matching_function then
        mt.ritual_matching_function = {}
      end
      mt.ritual_matching_function[c] = filter
    end
    local e1 = Effect.CreateEffect(c)
    if desc then
      e1:SetDescription(desc)
    else
      e1:SetDescription(1171)
    end
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(function(e)
      Debug.Message(e)
      return Ritual.Target(filter, _type, lv, extrafil, extraop, matfilter, stage2, location, forcedselection,
        specificmatfilter, requirementfunc, sumpos, extratg)
    end)
    e1:SetOperation(Ritual.Operation(filter, _type, lv, extrafil, extraop, matfilter, stage2, location, forcedselection,
      customoperation, specificmatfilter, requirementfunc, sumpos))
    return e1
  end, "handler", "lvtype", "filter", "lv", "desc", "extrafil", "extraop", "matfilter", "stage2", "location",
  "forcedselection", "customoperation", "specificmatfilter", "requirementfunc", "sumpos", "extratg")

-- Fusion Dance --

function Auxiliary.MetamoranLimit(e, se, sp, st)
  return se:GetHandler():IsCode(CARD_FUSION_DANCE)
      or (Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_METAMOR)
        and st & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION)
end

function Card.CanFusionDance(c)
  return c.fusion_dance == true
end

function Card.FusionProc(c, ...)
  Fusion.AddProcMix(c, true, true, ...)
end

local function fsodfilter(c, e, tp, cd)
  return c:IsCode(cd)
      and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
end

-- lizard check
function Card.FusionDanceLizard(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetCode(CARD_CLOCK_LIZARD)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_METAMOR)
  end)
  e:SetValue(1)
  c:RegisterEffect(e)
  return e
end

-- Special Summon condition
function Card.FusionDanceSpSummon(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCode(EFFECT_SPSUMMON_CONDITION)
  e:SetValue(aux.MetamoranLimit)
  c:RegisterEffect(e)
end

-- Special summon on death
function Card.FusionSummonOnDeath(c, id, mat1, mat2)
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
          and Duel.IsExistingMatchingCard(fsodfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mat1)
          and Duel.IsExistingMatchingCard(fsodfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mat2)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
  end)
  e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
    if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
    local g1 = Duel.GetMatchingGroup(fsodfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, mat1)
    local g2 = Duel.GetMatchingGroup(fsodfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, mat2)
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

function Card.FusionDance(c, id, mat1, mat2)
  c:FusionProc(mat1, mat2)
  c:FusionDanceLizard()
  c:FusionDanceSpSummon()
  c:FusionSummonOnDeath(id, mat1, mat2)
end

-- Fusion Dance --

-- Potara Fusion --

function Card.PotaraSpecialSummonCondition(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCode(EFFECT_SPSUMMON_CONDITION)
  e:SetValue(aux.fuslimit)
  c:RegisterEffect(e)
end

local function checkcon(c, f)
  local tp = c:GetControler()
  return Duel.CheckReleaseGroup(tp, f, 1, false, 1, true, c, tp, nil, false, nil, tp, c)
end

local function filtercon(c, tp, sc)
  return c:IsType(TYPE_NORMAL, sc, MATERIAL_FUSION, tp)
      and c:GetEquipGroup():IsExists(aux.FilterBoolFunction(Card.IsCode, CARD_POTARA_EARING), 1, nil)
      and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0
end

local function hspfilter(mat)
  return function(c, tp, sc)
    return c:IsCode(mat) and filtercon(c, tp, sc)
  end
end

local function hspsrg(c, tp, mat)
  return Duel.SelectReleaseGroup(tp, hspfilter(mat), 1, 1, false, true, true, c, nil, nil, false, nil, tp, c)
end

function Card.PotaraSpecialSummon(c, mat1, mat2)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_FIELD)
  e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e:SetCode(EFFECT_SPSUMMON_PROC)
  e:SetRange(LOCATION_EXTRA)
  e:SetCondition(function(e, c)
    if c == nil then return true end
    return checkcon(c, hspfilter(mat1)) and checkcon(c, hspfilter(mat2))
  end)
  e:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, c)
    -- local g = Duel.SelectReleaseGroup(tp, hspfilter(mat1), 1, 1, false, true, true, c, nil, nil, false, nil, tp, c)
    -- local h = Duel.SelectReleaseGroup(tp, hspfilter(mat2), 1, 1, false, true, true, c, nil, nil, false, nil, tp, c)
    local g = hspsrg(c, tp, mat1):AddCard(hspsrg(c, tp, mat2))
    -- g = g:AddCard(h)
    if g then
      g:KeepAlive()
      e:SetLabelObject(g)
      return true
    end
    return false
  end)
  e:SetOperation(function(e, tp, eg, ep, ev, re, r, rp, c)
    local g = e:GetLabelObject()
    if not g then return end
    Duel.Release(g, REASON_COST)
    g:DeleteGroup()
  end)
  c:RegisterEffect(e)
end

function Card.PotaraFusion(c, mat1, mat2)
  c:PotaraSpecialSummonCondition()
  c:PotaraSpecialSummon(mat1, mat2)
end

-- Potara Fusion --

-- Special Summon SSJ --

function Card.CannotSpecialSummon(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetCode(EFFECT_SPSUMMON_CONDITION)
  e:SetValue(aux.FALSE)
  c:RegisterEffect(e)
end

function Card.SpecialSummonSSJ(c, base)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_FIELD)
  e:SetCode(EFFECT_SPSUMMON_PROC)
  e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e:SetRange(LOCATION_HAND)
  e:SetCondition(function(e, c)
    if c == nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(), Card.IsCode, 1, false, 1, true, c, c:GetControler(), nil, false, nil,
      base)
  end)
  e:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, c)
    local g = Duel.SelectReleaseGroup(tp, Card.IsCode, 1, 1, false, true, true, c, nil, nil, false, nil, base)
    if g then
      g:KeepAlive()
      e:SetLabelObject(g)
      return true
    end
    return false
  end)
  e:SetOperation(function(e, tp, eg, ep, ev, re, r, rp, c)
    local g = e:GetLabelObject()
    if not g then return end
    Duel.Release(g, REASON_COST)
    g:DeleteGroup()
  end
  )
  c:RegisterEffect(e)
end

function Card.TransformSSJ(c, base)
  c:CannotSpecialSummon()
  c:SpecialSummonSSJ(base)
end

-- Special Summon SSJ --

-- God Saiyan Summon --

local function rescon(base)
  return function(sg, e, tp, mg)
    return aux.ChkfMMZ(1)(sg, e, tp, mg)
        and sg:IsExists(
          function(c, sg)
            return c:IsCode(base)
                and sg:IsExists(Card.IsSetCard, 4, c, ARCHETYPES696.SAIYAN)
          end,
          1, nil, sg)
  end
end

function Card.TransformSaiyanGod(c, base)
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)

  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(function(e, c)
    if c == nil then return true end
    local tp = c:GetControler()
    local rg = Duel.GetReleaseGroup(tp)
    local g1 = rg:Filter(Card.IsCode, nil, base)
    local g2 = rg:Filter(Card.IsSetCard, nil, ARCHETYPES696.SAIYAN)
    local g = g1:Clone()
    g:Merge(g2)
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > -2
        and #g1 > 0
        and #g2 > 0
        and #g > 1
        and aux.SelectUnselectGroup(g, e, tp, 5, 5, rescon(base), 0)
  end)
  e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, c)
    local rg = Duel.GetReleaseGroup(tp)
    local g1 = rg:Filter(Card.IsCode, nil, base)
    local g2 = rg:Filter(Card.IsSetCard, nil, ARCHETYPES696.SAIYAN)
    g1:Merge(g2)
    local sg = aux.SelectUnselectGroup(g1, e, tp, 5, 5, rescon(base), 1,
      tp, HINTMSG_RELEASE, nil, nil, true)
    if #sg > 0 then
      sg:KeepAlive()
      e:SetLabelObject(sg)
      return true
    end
    return false
  end)
  e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp, c)
    local g = e:GetLabelObject()
    if not g then return end

    local atk = 0
    local def = 0
    local iter = g:Iter()
    for gc in iter do
      atk = atk + gc:Attack()
      def = def + gc:Defense()
      -- Debug.Message(gc)
    end

    Duel.Release(g, REASON_COST)

    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE - RESET_TOFIELD)
    e:GetHandler():RegisterEffect(e1)

    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(def)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE - RESET_TOFIELD)
    e:GetHandler():RegisterEffect(e2)

    g:DeleteGroup()
  end)
  c:RegisterEffect(e1)
end

-- God Saiyan Summon --
