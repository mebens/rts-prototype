Interface = class("Interface", Entity)

function Interface:initialize()
  Entity.initialize(self)
  Interface.static.id = self
  self.visible = false
  
  -- state variables
  self.draggingSelect = false
  self.draggingForm = false
  self.initialDragPos = Vector:new()
  self.finalDragPos = Vector:new()
  
  -- constants
  self.ghostFormMinDist = Unit.width * 2 -- minimum distance that the user must drag to declare a formation
  
  -- input definitions
  input.define{"select", mouse = "l"}
  input.define{"move", mouse = "r"}
end

function Interface:update(dt)
  if input.released("select") then self:deactivate() end
  
  if self.activeGroup then
    if input.pressed("move") then
      self.draggingForm = true
      self.initialDragPos.x = mouse.x
      self.initialDragPos.y = mouse.y
    elseif input.released("move") then
      self.draggingForm = false
      
      if self:getDragDistClearance() then
        self.activeGroup:applyFormation()
      else
        self.activeGroup:moveTo(mouse.x, mouse.y)
      end
    end
    
    if self.draggingForm then
      self.finalDragPos.x = mouse.x
      self.finalDragPos.y = mouse.y
      
      if self:getDragDistClearance() then
        self.activeGroup:drawGhostFormation(
          self.initialDragPos.x,
          self.initialDragPos.y,
          self.finalDragPos.x,
          self.finalDragPos.y
        )
      end
    end
  end
end

function Interface:activate(group)
  self:deactivate()
  group.selected = true
  self.activeGroup = group
end

function Interface:deactivate()
  if self.activeGroup then self.activeGroup.selected = false end
  self.activeGroup = nil
end

function Interface:getDragDistClearance()
  local dist = math.distance(
    self.initialDragPos.x,
    self.initialDragPos.y,
    self.finalDragPos.x,
    self.finalDragPos.y
  )
  
  return dist >= self.ghostFormMinDist
end
