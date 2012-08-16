Game = class("Game", World)

function Game:initialize()
  World.initialize(self)
  ammo.camera = GameCamera:new()
  self:add(
    Interface:new(),
    Group:new(25, 300, 300, 400, 300),
    Group:new(10, 600, 100, 400, 300),
    Group:new(25, 800, 400, 400, 300),
    Group:new(10, 600, 800, 400, 300)
  )
end
