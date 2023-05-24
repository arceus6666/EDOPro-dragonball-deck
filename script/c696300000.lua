-- test synchro

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  --synchro summon
  -- Synchro.AddProcedure(c,
  --   Synchro.NonTunerEx(Card.IsCode, SAIYAN.XENO_TRUNKS),
  --   1, 1,
  --   Synchro.NonTunerEx(Card.IsSetCard, ARCHETYPES.SAIYAN),
  --   4, 4
  -- )
  c:EnableReviveLimit()

  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e1)

  --Special Summon procedure (from the Extra Deck)
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_EXTRA)
  e2:SetCondition(s.sprcon)
  e2:SetTarget(s.sprtg)
  e2:SetOperation(s.sprop)
  c:RegisterEffect(e2)
end
