Duel.LoadScript("constants.lua")

function Card.FusionProc(c, ...)
  Fusion.AddProcMix(c, false, false, ...)
end

function Auxiliary.MetamoranLimit(e, se, sp, st)
  return se:GetHandler():IsCode(CARD_FUSION_DANCE)
      -- or (Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_METAMOR)
      or (Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(), EFFECT_SUPREME_CASTLE)
        and st & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION)
end
