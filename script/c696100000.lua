--test ritual

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  local e1 = Ritual.CreateProc({
    handler = c,
    lvtype = RITPROC_GREATER,
    filter = s.ritualfil,
    extrafil = s.extrafil,
    -- extraop = s.extraop,
    matfilter = s.forcedgroup,
    location = LOCATION_HAND
  })
  e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
  c:RegisterEffect(e1)
end

function s.ritualfil(c)
	return c:IsSetCard(RACE_SAIYAN)
end

function s.exfilter0(c)
	return c:IsSetCard(RACE_SAIYAN) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end

function s.extrafil(e, tp, eg, ep, ev, re, r, rp, chk)
  if Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0 and Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) > 1 then
    return Duel.GetMatchingGroup(s.exfilter0, tp, LOCATION_EXTRA, 0, nil)
  end
end

-- function s.extraop(mg, e, tp, eg, ep, ev, re, r, rp)
--   local mat2 = mg:Filter(Card.IsLocation, nil, LOCATION_EXTRA)
--   mg:Sub(mat2)
--   Duel.ReleaseRitualMaterial(mg)
--   Duel.SendtoGrave(mat2, REASON_EFFECT + REASON_MATERIAL + REASON_RITUAL)
-- end

function s.forcedgroup(c, e, tp)
  return c:IsSetCard(RACE_SAIYAN)
      and c:IsLocation(LOCATION_HAND + LOCATION_ONFIELD)
end
