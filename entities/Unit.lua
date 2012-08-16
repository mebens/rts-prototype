Unit = class("Unit", Entity)
Unit.static.width = 24
Unit.static.height = 24
Unit.static.speed = 125

-- graphics generated via code; obviously they're temporary
if love.graphics.isSupported("canvas") then
  local imgCanvas = love.graphics.newCanvas(Unit.width, Unit.height)
  local ghostCanvas = love.graphics.newCanvas(Unit.width, Unit.height)
  local activeCanvas = love.graphics.newCanvas(Unit.width + 10, Unit.height + 10)

  imgCanvas:renderTo(function()
    love.graphics.circle("fill", Unit.width / 2, Unit.height / 2, Unit.width / 2, 20)
  end)

  ghostCanvas:renderTo(function()
    love.graphics.pushColor(20, 80, 240, 200)
    love.graphics.circle("fill", Unit.width / 2, Unit.height / 2, Unit.width / 2, 20)
    love.graphics.popColor()
    
    love.graphics.setLineWidth(2)
    love.graphics.pushColor(20, 90, 255)
    love.graphics.circle("line", Unit.width / 2, Unit.height / 2, Unit.width / 2 - 1, 20)
    love.graphics.popColor()
    love.graphics.setLineWidth(1)
  end)

  activeCanvas:renderTo(function()
    local halfWidth = activeCanvas:getWidth() / 2
    love.graphics.setLineWidth(3)
    love.graphics.pushColor(20, 255, 40, 240)
    love.graphics.circle("line", halfWidth, activeCanvas:getHeight() / 2, halfWidth - 2, 25)
    love.graphics.popColor()
    love.graphics.setLineWidth(1)
  end)

  Unit.static.image = love.graphics.newImage(imgCanvas:getImageData())
  Unit.static.ghostImage = love.graphics.newImage(ghostCanvas:getImageData())
  Unit.static.activeImage = love.graphics.newImage(activeCanvas:getImageData())
else
  Unit.static.image = love.graphics.newImage("assets/images/unit.png")
  Unit.static.ghostImage = love.graphics.newImage("assets/images/unit-ghost.png")
  Unit.static.activeImage = love.graphics.newImage("assets/images/unit-active.png")
end

function Unit:initialize(x, y)
  Entity.initialize(self, x, y)
  self:setSize(Unit.width, Unit.height)
  self.radius = self.width / 2
  self.energy = 100
  self.moving = false
  self.destination = Vector:new()
end

function Unit:update(dt)
  if input.released("select") and not self.parent.selected
  and collision.pointToCircle(mouse.x, mouse.y, self.x, self.y, self.radius)
  then
    Interface.id:activate(self.parent)
  end
  
  if self.moving then
    self.x = self.x + math.cos(self.direction) * Unit.speed * dt
    self.y = self.y + math.sin(self.direction) * Unit.speed * dt
    self.distanceTravelled = self.distanceTravelled + Unit.speed * dt
    
    if self.distanceTravelled >= self.distance then
      self.x = self.destination.x
      self.y = self.destination.y
      self.moving = false
    end
  end
end

function Unit:draw()
  love.graphics.draw(Unit.image, self.x - self.width / 2, self.y - self.height / 2)

  if self.parent.selected then
    love.graphics.draw(
      Unit.activeImage,
      self.x - Unit.activeImage:getWidth() / 2,
      self.y - Unit.activeImage:getHeight() / 2
    )
  end
end

function Unit:moveTo(x, y)
  self.direction = math.angle(self.x, self.y, x, y)
  self.distance = math.distance(self.x, self.y, x, y)
  self.distanceTravelled = 0
  self.destination:set(x, y)
  self.moving = true
end
