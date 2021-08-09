--- **Ops** - Brigade Platoon.
--
-- **Main Features:**
--
--    * Set parameters like livery, skill valid for all platoon members.
--    * Define modex and callsigns.
--    * Define mission types, this platoon can perform (see Ops.Auftrag#AUFTRAG).
--    * Pause/unpause platoon operations.
--
-- ===
--
-- ### Author: **funkyfranky**
-- @module Ops.Platoon
-- @image OPS_Platoon.png


--- PLATOON class.
-- @type PLATOON
-- @field #string ClassName Name of the class.
-- @field #number verbose Verbosity level.
-- @extends Ops.Cohort#COHORT

--- *Some cool cohort quote* -- Known Author
--
-- ===
--
-- # The PLATOON Concept
-- 
-- A PLATOON is essential part of an BRIGADE.
--
--
--
-- @field #PLATOON
PLATOON = {
  ClassName      = "PLATOON",
  verbose        =     0,
}

--- PLATOON class version.
-- @field #string version
PLATOON.version="0.0.1"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: A lot!

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new PLATOON object and start the FSM.
-- @param #PLATOON self
-- @param #string TemplateGroupName Name of the template group.
-- @param #number Ngroups Number of asset groups of this platoon. Default 3.
-- @param #string PlatoonName Name of the platoon, e.g. "VFA-37".
-- @return #PLATOON self
function PLATOON:New(TemplateGroupName, Ngroups, PlatoonName)

  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, COHORT:New(TemplateGroupName, Ngroups, PlatoonName)) -- #PLATOON


  return self
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  -- TODO: Platoon specific user functions.

--- Set brigade of this platoon.
-- @param #PLATOON self
-- @param Ops.Brigade#BRIGADE Brigade The brigade.
-- @return #PLATOON self
function PLATOON:SetBrigade(Brigade)
  self.legion=Brigade
  return self
end

--- Get brigade of this platoon.
-- @param #PLATOON self
-- @return Ops.Brigade#BRIGADE The brigade.
function PLATOON:GetBrigade()
  return self.legion
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Start & Status
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- On after Start event. Starts the FLIGHTGROUP FSM and event handlers.
-- @param #PLATOON self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function PLATOON:onafterStart(From, Event, To)

  -- Short info.
  local text=string.format("Starting PLATOON %s", self.name)
  self:I(self.lid..text)

  -- Start the status monitoring.
  self:__Status(-1)
end

--- On after "Status" event.
-- @param #PLATOON self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function PLATOON:onafterStatus(From, Event, To)

  if self.verbose>=1 then

    -- FSM state.
    local fsmstate=self:GetState()
  
    local callsign=self.callsignName and UTILS.GetCallsignName(self.callsignName) or "N/A"
    local modex=self.modex and self.modex or -1
    local skill=self.skill and tostring(self.skill) or "N/A"
    
    local NassetsTot=#self.assets
    local NassetsInS=self:CountAssets(true)
    local NassetsQP=0 ; local NassetsP=0 ; local NassetsQ=0  
    if self.brigade then
      NassetsQP, NassetsP, NassetsQ=self.brigade:CountAssetsOnMission(nil, self)
    end
    
    -- Short info.
    local text=string.format("%s [Type=%s, Call=%s, Modex=%d, Skill=%s]: Assets Total=%d, Stock=%d, Mission=%d [Active=%d, Queue=%d]", 
    fsmstate, self.aircrafttype, callsign, modex, skill, NassetsTot, NassetsInS, NassetsQP, NassetsP, NassetsQ)
    self:I(self.lid..text)
    
    -- Check if group has detected any units.
    self:_CheckAssetStatus()
    
  end  
  
  if not self:IsStopped() then
    self:__Status(-60)
  end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Misc Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: Misc functions.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
