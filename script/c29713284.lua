--The White Stone of Blue-Eyes
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon from hand or GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- Add 1 Level 1 Tuner and send 1 Dragon monster to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	-- Special Summon 2 "Blue-Eyes" monsters with 0 ATK/DEF
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,2})
	e4:SetCondition(s.spcon2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
	
	-- Add "Chaos Form" or "Ultimate Fusion" when sent to GY
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,{id,3})
	e5:SetTarget(s.thtg2)
	e5:SetOperation(s.thop2)
	c:RegisterEffect(e5)

	-- Special Summon 1 "Blue-Eyes" monster from Deck when sent to GY
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,{id,4})
	e6:SetTarget(s.sptg3)
	e6:SetOperation(s.spop3)
	c:RegisterEffect(e6)

	-- Banish to add 1 "Blue-Eyes" from GY to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,5))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1,{id,5})
	e7:SetCost(aux.bfgcost)
	e7:SetTarget(s.thtg3)
	e7:SetOperation(s.thop3)
	c:RegisterEffect(e7)

	-- Special Summon a monster when this card is banished
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,6))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e8:SetCode(EVENT_REMOVE)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,{id,6})
	e8:SetTarget(s.sptg4)
	e8:SetOperation(s.spop4)
	c:RegisterEffect(e8)
end

-- Effect 1: Special Summon from hand or GY
function s.spfilter(c)
	return c:IsSetCard(0xdd) -- Blue-Eyes archetype
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetLocationCount(tp,LOCATION_GRAVE)>0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	-- No cost, just Special Summon it.
end

-- Effect 2: Add 1 Level 1 Tuner from deck, then send 1 Dragon to GY
function s.tunerfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsLevel(1) and c:IsAbleToHand()
end
function s.dragonfilter(c)
	return c:IsType(TYPE_DRAGON) and c:IsAbleToGrave()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tunerfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.dragonfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.tunerfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,s.dragonfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end

-- Effect 3: Special Summon 2 "Blue-Eyes" monsters with 0 ATK/DEF
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,e,tp)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_DEFENSE)
			-- Set ATK/DEF to 0
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end

-- Effect 4: Add "Chaos Form" or "Ultimate Fusion" when sent to GY
function s.filter(c)
	return c:IsCode(21082832,71143015) and c:IsAbleToHand()
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- Effect 5: Special Summon 1 "Blue-Eyes" from Deck in Defense Position when sent to GY
function s.spfilter3(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function s.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_DEFENSE)
	end
end

-- Effect 6: Banish this card to add 1 "Blue-Eyes" from GY to hand
function s.thfilter2(c)
	return c:IsSetCard(0xdd) and c:IsAbleToHand()
end
function s.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- Effect 7: If this card is banished, Special Summon 1 monster from GY
function s.spfilter4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,s.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_DEFENSE)
	end
end
