--Galaxy-Eyes Tachyon Evolution Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon from hand by sending 1 "Galaxy-Eyes" or "Tachyon" monster from Deck to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sphandtg)
	e1:SetOperation(s.sphandop)
	c:RegisterEffect(e1)

	-- Special Summon from GY if a Dragon is on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.spgycon)
	e2:SetTarget(s.spgytg)
	e2:SetOperation(s.spgyop)
	c:RegisterEffect(e2)
-- Effect 1: Special Summon from hand by sending "Galaxy-Eyes" or "Tachyon" monster to the GY
function s.sphandtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.galaxyeyestachyonfilter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sphandop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(Duel.SelectMatchingCard(tp,s.galaxyeyestachyonfilter,tp,LOCATION_DECK,0,1,1,nil),REASON_EFFECT)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.galaxyeyestachyonfilter(c)
	return (c:IsSetCard(0x107b) or c:IsSetCard(0x10bc)) and c:IsType(TYPE_MONSTER)
end

-- Effect 2: Special Summon from GY if a Dragon is on the field
function s.spgycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.spgytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spgyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end