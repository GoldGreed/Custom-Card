--Armored Pilot Engager
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--You can only Special Summon "Dingirsu, the Orcust of the Evening Star(s)" once per turn
	c:SetSPSummonOnce(id)
	--Xyz Summon Procedure
	Xyz.AddProcedure(c,nil,8,2,s.ovfilter,aux.Stringid(id,0))
	--Detach 1 material from this card instead of a card(s) you control being destroyed by battle or card effect
end
s.listed_names={id}
s.listed_series={SET_ORCUST}
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL,xyzc,SUMMON_TYPE_XYZ,tp)
end