--Blue-Eyes Synchronization Dragon
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(Card.IsSetCard,0xdd),1,99)
	c:EnableReviveLimit()

	--Special Summon from GY on Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--Negate activation
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)

	--Special Summon Level 1 LIGHT Tuners
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.tntg)
	e3:SetOperation(s.tnop)
	c:RegisterEffect(e3)

	--Inflict battle damage effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(s.batcon)
	e4:SetTarget(s.battg)
	e4:SetOperation(s.batop)
	c:RegisterEffect(e4)

	--Revive from GY
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.grcon)
	e5:SetTarget(s.grtg)
	e5:SetOperation(s.grop)
	c:RegisterEffect(e5)

	--Effect on Banished
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetTarget(s.bantg)
	e6:SetOperation(s.banop)
	c:RegisterEffect(e6)

	--Protection Effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetTarget(s.prottg)
	e7:SetOperation(s.protop)
	c:RegisterEffect(e7)
end

-- Condition check and effects here
--Synchro Summon Condition
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

--Target 1 Level 1 Monster and 1 Blue-Eyes in GY
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,1)
		and Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xdd)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

-- Special Summon Operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectTarget(tp,Card.IsLevel,tp,LOCATION_GRAVE,0,1,1,nil,1)
	local g2=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0xdd)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- Negate Condition
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

-- Negate Target
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

-- Negate Operation
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

-- Special Summon Level 1 LIGHT Tuners from Deck or GY
function s.tntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- Special Summon Operation
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsLevel,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,1)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Battle Damage Condition
function s.batcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

--Battle Damage Target
function s.battg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

--Battle Damage Operation
function s.batop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsLevel,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,1)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--GY Condition Check
function s.grcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,0xdd)
end

--Revive from GY Target
function s.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Revive from GY Operation
function s.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

--On Banish Special Summon Level 1 monster and add Blue-Eyes to hand
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_DECK,0,1,nil,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

--Banish Effect Operation
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsLevel,tp,LOCATION_DECK,0,1,1,nil,1)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,0xdd)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	end
end

--Protection from Destruction
function s.prottg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	return Duel.SelectYesNo(tp,aux.Stringid(id,1))
end

--Protection from Destruction Operation
function s.protop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
