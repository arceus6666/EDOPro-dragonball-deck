-- test synchro

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
  --synchro summon
  Synchro.AddProcedure(c,
    Synchro.NonTunerEx(Card.IsCode, SAIYAN.XENO_TRUNKS),
    1, 1,
    Synchro.NonTunerEx(Card.IsSetCard, ARCHETYPES.SAIYAN),
    4, 4
  )
  c:EnableReviveLimit()
end
