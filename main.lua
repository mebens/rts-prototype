require("ammo.init")
require("ammo.input.init")
key = input.key
mouse = input.mouse

require("lib.strong.init")
collision = require("collision")

require("GameCamera")
require("worlds.Game")
require("entities.Interface")
require("entities.Unit")
require("entities.Group")

function love.load()
  love.mouse.switchToRotated()
  ammo.world = Game:new()
end

function love.update(dt)
  ammo.update(dt)
  input.update()
end

function love.draw()
  ammo.draw()
  love.graphics.print(love.timer.getFPS(), 2, 2)
end
