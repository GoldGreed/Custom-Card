--Crimson-Eyes Silver Dragon
local s,id=GetID()
function s.initial_effect(c)
	--This card is always treated as a "Blue-Eyes" card.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetValue(0xdd) -- "Blue-Eyes" archetype ID
	c:RegisterEffect(e0)
	
	-- Special Summon this card by sending 1 "Blue-Eyes" monster to GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- Name becomes "Blue-Eyes White Dragon" on field or in GY
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(CARD_BLUEEYES_W_DRAGON)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	c:RegisterEffect(e2)
	
	-- Add 2 "Blue-Eyes" monsters to hand, then discard 1 card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	-- Special Summon 1 "Blue-Eyes" monster from GY and boost ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,{id,1})
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)
	
	-- Special Summon this card if sent to the GY
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,{id,2})
	e6:SetCondition(s.spcon2)
	e6:SetTarget(s.sptg2)
	e6:SetOperation(s.spop3)
	c:RegisterEffect(e6)
	
	-- Quick Effect: Fusion Summon a Fusion Monster using "Blue-Eyes"
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{id,3})
	e7:SetTarget(s.fusiontg)
	e7:SetOperation(s.fusionop)
	c:RegisterEffect(e7)
end

-- Special Summon by sending 1 "Blue-Eyes" monster to the GY
function s.spfilter(c)
	return c:IsSetCard(0xdd) and c:IsAbleToGrave()
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

-- Add 2 "Blue-Eyes" monsters to hand, then discard 1 card
function s.thfilter(c)
	return c:IsSetCard(0xdd) and c:IsMonster() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

-- Special Summon 1 "Blue-Eyes" monster from GY and boost ATK
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			local atk=sc:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

-- Special Summon this card if sent to GY
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

-- Fusion Summon using materials from hand, field, or GY
function s.fusionfilter(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsType(TYPE_FUSION)
end
function s.fusiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fusionop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.fusionfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		local mat=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,tc.material_count(),tc.material_count(),nil)
		if #mat>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			Duel.FusionSummon(tp,tc,mat)
		end
	end
end