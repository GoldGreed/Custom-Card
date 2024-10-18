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
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{id,5})
	e7:SetCondition(s.xyzcon)
	e7:SetTarget(s.xyztg)
	e7:SetOperation(s.xyzop)
	c:RegisterEffect(e7)

	-- If a Dragon Xyz Monster battles: Attach this card as material
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,6))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DAMAGE_STEP_END)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.matcon)
	e8:SetTarget(s.mattg)
	e8:SetOperation(s.matop)
	c:RegisterEffect(e8)

	-- If sent to GY, Special Summon this card
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,7))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCountLimit(1,{id,7})
	e9:SetCondition(s.spsentcon)
	e9:SetTarget(s.spsenttg)
	e9:SetOperation(s.spsentop)
	c:RegisterEffect(e9)

	-- If detached from Xyz monster: Add 1 Dragon monster from Deck to hand
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,8))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_DETACH_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCountLimit(1,{id,8})
	e10:SetTarget(s.detachtg)
	e10:SetOperation(s.detachop)
	c:RegisterEffect(e10)

	-- While in GY, add 1 "Seventh" card to hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,9))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCountLimit(1,{id,9})
	e11:SetTarget(s.seventhtg)
	e11:SetOperation(s.seventhop)
	c:RegisterEffect(e11)

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
	return c:IsSetCard(SET_TACHYON) and c:IsAbleToHand()
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
	return c:IsRace(RACE_DRAGON) and c:IsLevel(8)
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
	local tc=eg:GetFirst()
	return tc:IsSummonType(SUMMON_TYPE_XYZ) and tc:IsControler(tp)
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
	return c:IsRace(RACE_DRAGON)
end

-- Effect 7: Attach this card to a Dragon Xyz Monster as material during battle
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or not bc then return false end
	if bc:IsControler(tp) and bc:IsType(TYPE_XYZ) and bc:IsRace(RACE_DRAGON) then
		e:SetLabelObject(bc)
		return true
	elseif at:IsControler(tp) and at:IsType(TYPE_XYZ) and at:IsRace(RACE_DRAGON) then
		e:SetLabelObject(at)
		return true
	else
		return false
	end
end

-- Target: Select this card to attach as Xyz material
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
end

-- Operation: Attach this card to the Dragon Xyz Monster as material
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and c:IsRelateToEffect(e) then
		Duel.Overlay(bc,Group.FromCards(c))
	end
end

-- Effect 8: If sent to the GY, Special Summon this card
function s.spsentcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT~=0
end
function s.spsenttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spsentop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

-- Effect 9: If detached from Xyz monster, add 1 Dragon-Type monster from Deck to hand
function s.detachtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dragonfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.detachop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.dragonfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- Effect 10: While in GY, add 1 "Seventh" card from Deck to hand
function s.seventhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.seventhfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.seventhop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.seventhfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.seventhfilter(c)
	return c:IsSetCard(0x177)
end