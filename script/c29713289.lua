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
	-- Special Summon 2 Level 8 Dragon monsters from Deck in Defense Position with 0 ATK/DEF and add 1 Rank-Up-Magic
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,{id,3})
	e5:SetTarget(s.spdragtg)
	e5:SetOperation(s.spdragop)
	c:RegisterEffect(e5)
	 -- Send up to 2 Dragon monsters to GY, increase levels
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LVCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,{id,4})
	e6:SetTarget(s.sendtogytg)
	e6:SetOperation(s.sendtogyop)
	c:RegisterEffect(e6)

	-- Xyz Summon: Target 1 Dragon in GY, Special Summon and add 1 "Galaxy-Eyes" and 1 "Tachyon" card
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,5))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{id,5})
	e7:SetCondition(s.xyzcon)
	e7:SetTarget(s.xyztg)
	e7:SetOperation(s.xyzop)
	c:RegisterEffect(e7)
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
-- Effect 4: Special Summon 2 Level 8 Dragons from Deck, then add 1 Rank-Up-Magic card
function s.spdragtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.level8dragonfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function s.spdragop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.SelectMatchingCard(tp,s.level8dragonfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
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
		local sg=Duel.SelectMatchingCard(tp,s.rankupfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.level8dragonfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(0)
end
function s.rankupfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end

-- Effect 5: Send up to 2 Dragon monsters to GY, increase levels of all monsters you control
function s.sendtogytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dragonfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.sendtogyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.dragonfilter,tp,LOCATION_DECK,0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local ct=#g
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(ct)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- Effect 6: If Xyz Summon, Special Summon 1 Dragon from GY, add 1 "Galaxy-Eyes" and 1 "Tachyon" card
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsRace,1,nil,RACE_DRAGON)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.galaxyfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tachyonfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local g1=Duel.SelectMatchingCard(tp,s.galaxyfilter,tp,LOCATION_DECK,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,s.tachyonfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g1>0 and #g2>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1+g2)
		end
	end
end
function s.spfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(0)
end
