Group = class("Group", Entity)
Group.static.padding = 10
Group.static.minUnitsPerRow = 2

function Group:initialize(units, x, y, unitX, unitY)
  Entity.initialize(self, x, y)
  
  if type(units) == "number" then
    for i = 1, units do self:add(Unit:new(unitX, unitY)) end
  else
    self:add(unpack(units))
  end
  
  self.formation = "line"
  self.formX = {}
  self.formY = {}
  self.ghostFormX = {}
  self.ghostFormY = {}
  self.drawGhostForm = false
  
  -- default to three rows, but make sure there's at least three units on each row
  local length = (Unit.width + Group.padding) * math.max((self.children.length + 3) / 3, 3) -- the +3 is needed to make it three rows for some reason
  self:applyFormation(x - length / 2, y, x + length / 2, y)
end

function Group:draw()
  if self.drawGhostForm or self.selected then
    for i = 1, self.children.length do
      love.graphics.draw(Unit.ghostImage, self.formX[i] - Unit.width / 2, self.formY[i] - Unit.height / 2)
    end
    
    self.drawGhostForm = false
  end
end

function Group:applyFormation(x1, y1, x2, y2)
  -- if there are no arguments, we won't recalculate
  if x1 then self:calculateFormation(x1, y1, x2, y2, self.formX, self.formY) end
  local i = 1
  
  for v in self.children:getIterator() do
    v:moveTo(self.formX[i], self.formY[i])
    i = i + 1
  end
end

function Group:drawGhostFormation(x1, y1, x2, y2)
  self.drawGhostForm = true
  self:calculateFormation(x1, y1, x2, y2, self.formX, self.formY)
end

function Group:moveTo(x, y)
  local angle = math.angle(self.x, self.y, x, y) - math.tau / 4 -- needs to be perpendicular to the current angle
  local cos = math.cos(angle)
  local sin = math.sin(angle)
  
  self:applyFormation(
    x + self.length / 2 * cos,
    y + self.length / 2 * sin,
    x - self.length / 2 * cos,
    y - self.length / 2 * sin
  )
end

function Group:calculateFormation(x1, y1, x2, y2, xTable, yTable)
  local func = self["calculate" .. self.formation:capitalize()]
  return func(self, x1, y1, x2, y2, xTable, yTable)
end

function Group:calculateLine(x1, y1, x2, y2, xTable, yTable)
  -- objects
  local xRet = xTable or {}
  local yRet = yTable or {}
  local units = self.children
  
  -- loop info
  local x = 0 -- units currently on the row
  local y = 0 -- the current row
  local i = 1
  local lackingDist = 0
  
  -- row info
  local angle = math.angle(x1, y1, x2, y2)
  local dist = math.distance(x1, y1, x2, y2)
  local unitsPerRow = math.floor((dist + Group.padding) / (Unit.width + Group.padding))
  
  -- make sure each has at least the minimum number of units
  if unitsPerRow < Group.minUnitsPerRow then
    unitsPerRow = Group.minUnitsPerRow
    dist = (Unit.width + Group.padding) * Group.minUnitsPerRow - Group.padding -- just to keep things consistent, this'll be updated too
  end
  
  for v in units:getIterator() do        
    local rowDist = (Unit.width + Group.padding) * x + Unit.width / 2 + lackingDist
    xRet[i] = x1 + math.cos(angle) * rowDist
    yRet[i] = y1 + math.sin(angle) * rowDist
    x = x + 1
    i = i + 1
    
    -- advance to the next row
    if x >= unitsPerRow then
      local perpendicular = angle + math.tau / 4
      local cosDist = math.cos(perpendicular) * (Unit.height + Group.padding)
      local sinDist = math.sin(perpendicular) * (Unit.height + Group.padding)
      x1 = x1 + cosDist
      y1 = y1 + sinDist
      x2 = x2 + cosDist
      y2 = y2 + sinDist
      x = 0
      y = y + 1
      
      if (units.length - i) < unitsPerRow then
        lackingDist = (Unit.width + Group.padding) * (unitsPerRow  - (units.length - i) - 1) / 2
      end
    end
  end
  
  -- store some values for later
  self.x = x1 + dist / 2 * math.cos(angle)
  self.y = y1 + dist / 2 * math.sin(angle)
  self.angle = angle
  self.length = dist
  return xRet, yRet
end
