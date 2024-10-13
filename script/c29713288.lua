--Custom Xyz Monster
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon procedure (for example, generic Rank 8, adjust as necessary)
	Xyz.AddProcedure(c,nil,8,5) --requires 5 Level 8 monsters as materials
	c:EnableReviveLimit()

	--Custom effect: If both players have a different number of cards in their deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,0})
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- Condition: Each player must have a different number of cards in their Deck
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local p1_deck=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local p2_deck=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	return p1_deck~=p2_deck
end

-- Cost: Detach 5 materials from this card
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,REASON_COST)
end

-- Operation: Attach the top half of the largest deck to this card as materials
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1_deck=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local p2_deck=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local half_deck_group=nil

	if p1_deck>p2_deck then
		half_deck_group=Duel.GetDecktopGroup(tp,math.ceil(p1_deck/2))
	else
		half_deck_group=Duel.GetDecktopGroup(1-tp,math.ceil(p2_deck/2))
	end

	if half_deck_group and #half_deck_group>0 then
		Duel.Overlay(c,half_deck_group)
	end
end