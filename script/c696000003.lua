-- fusion dance

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Fusion summon 1 fiend fusion monster
  --Using monsters from hand or field as material
  local b = aux.FilterBoolFunction(Card.ISSetCard, ARCHETYPES.SAIYAN)
  Debug.Message(ARCHETYPES.SAIYAN)
  Debug.Message(b)
  c:RegisterEffect(Fusion.CreateSummonEff({
    handler = c,
    fusfilter = aux.FilterBoolFunction(Card.ISSetCard, ARCHETYPES.SAIYAN),
    stage2 = s.stage2
  }))
  -- Card.IsSetCard(Card c, int setname[, Card scard|nil, int sumtype = 0, int playerid = PLAYER_NONE])
  -- Card.IsRace   (Card c, int race[, Card scard|nil, int sumtype = 0, int playerid = PLAYER_NONE])
end

function s.stage2(e, tc, tp, sg, chk)
  if chk == 1 then
    --Cannot be targeted by opponent's card effects
    local e1 = Effect.CreateEffect(e:GetHandler())
    -- e1:SetDescription(3061)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    e1:SetValue(aux.tgoval)
    tc:RegisterEffect(e1)
  end
end
