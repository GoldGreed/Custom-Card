--Serena, the Melodious Guitairist
function c210000000.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,210000000+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c210000000.cost)
	e1:SetTarget(c210000000.thtg)
	e1:SetOperation(c210000000.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(210000000,ACTIVITY_SUMMON,c210000000.counterfilter)
	Duel.AddCustomActivityCounter(210000000,ACTIVITY_SPSUMMON,c210000000.counterfilter)
end

function c210000000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(210000000,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(210000000,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)

	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c210000000.sumlimit)
end

function c210000000.filter(c)
	return c:IsCode(11493868) or c:IsCode(09113513) or c:IsSetCard(0x9b) and not c:IsCode(210000000) and c:IsAbleToHand()
end
function c210000000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210000000.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210000000.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210000000.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c210000000.counterfilter(c)
	return c:IsSetCard(0x9b)
end

function c210000000.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xb)
end