--Galaxy-Eyes Tachyon Evolution Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon from hand by sending 1 "Galaxy-Eyes" or "Tachyon" monster from Deck to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id, 0})
	e1:SetTarget(s.sphandtg)
	e1:SetOperation(s.sphandop)
	c:RegisterEffect(e1)

	-- Special Summon from GY if a Dragon is on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id, 1})
	e2:SetCondition(s.spgycon)
	e2:SetTarget(s.spgytg)
	e2:SetOperation(s.spgyop)
	c:RegisterEffect(e2)
	-- On Normal/Special Summon: Add 1 "Galaxy" and 1 "Tachyon" card, then send 2 Dragons to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{id, 2})
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	-- Register the effect for Special Summon as well
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
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

-- Effect 3: On Normal/Special Summon: Add 1 "Galaxy" and 1 "Tachyon" card, then send 2 Dragons to GY

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.galaxyfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.tachyonfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.dragonfilter,tp,LOCATION_DECK,0,2,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,s.galaxyfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,s.tachyonfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 and #g2>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1+g2)
		local g3=Duel.SelectMatchingCard(tp,s.dragonfilter,tp,LOCATION_DECK,0,2,2,nil)
		if #g3>0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
end

-- Filter function for "Galaxy" cards
function s.galaxyfilter(c)
	return c:IsSetCard(0x107b) and c:IsAbleToHand()
end

-- Filter function for "Tachyon" cards
function s.tachyonfilter(c)
	return c:IsSetCard(0x307b) and c:IsAbleToHand()
end

-- Filter function for Dragon monsters with different names
function s.dragonfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end