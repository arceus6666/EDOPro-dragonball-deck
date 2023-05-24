-- potara

Duel.LoadScript("functions696.lua")
local s, id = GetID()

function s.initial_effect(c)
	-- --Activate
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_ACTIVATE)
	-- e1:SetCode(EVENT_FREE_CHAIN)
	-- c:RegisterEffect(e1)
  
	aux.AddEquipProcedure(c,0)
end
