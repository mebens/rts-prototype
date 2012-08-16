GameCamera = class("GameCamera", Camera)
GameCamera.static.speed = 500
GameCamera.static.fastSpeed = 1250
GameCamera.static.zoomAmount = .1
GameCamera.static.maxZoom = 1
GameCamera.static.minZoom = .3
GameCamera.static.rotationSpeed = math.tau / 2

input.define("cameraLeft", "a", "left")
input.define("cameraRight", "d", "right")
input.define("cameraUp", "w", "up")
input.define("cameraDown", "s", "down")
input.define("cameraFastSpeed", "lshift", "rshift")
input.define{"cameraZoomIn", mouse = "wu"}
input.define{"cameraZoomOut", mouse = "wd"}
input.define("cameraRotateLeft", "e")
input.define("cameraRotateRight", "q")

function GameCamera:initialize(...)
  Camera.initialize(self, ...)
end

function GameCamera:update(dt)
  -- movement
  local speed = (input.down("cameraFastSpeed") and GameCamera.fastSpeed or GameCamera.speed) / self.zoom
  local left = input.down("cameraLeft")
  local right = input.down("cameraRight")
  local up = input.down("cameraUp")
  local down = input.down("cameraDown")
  local angle
  
  -- this covers eight-way movement
  if left and up then
    angle = math.tau * .125 - self.angle
  elseif left and down then
    angle = math.tau * .875 - self.angle
  elseif right and up then
    angle = math.tau * .375 - self.angle
  elseif right and down then
    angle = math.tau * .625 - self.angle
  elseif left then
    angle = -self.angle
  elseif right then
    angle = math.tau * .5 - self.angle
  elseif up then
    angle = math.tau * .25 - self.angle
  elseif down then
    angle = math.tau * .75 - self.angle
  end
  
  -- this is to make sure the movement axes are unaffected by rotation
  if angle then
    self.x = self.x - speed * dt * math.cos(angle)
    self.y = self.y - speed * dt * math.sin(angle)
  end
  
  -- zoom
  if input.pressed("cameraZoomIn") then
    self.zoom = math.min(self.zoom + GameCamera.zoomAmount, GameCamera.maxZoom)
  end
  
  if input.pressed("cameraZoomOut") then
    self.zoom = math.max(self.zoom - GameCamera.zoomAmount, GameCamera.minZoom)
  end
  
  -- rotation
  if input.down("cameraRotateLeft") then self.angle = self.angle + GameCamera.rotationSpeed * dt end
  if input.down("cameraRotateRight") then self.angle = self.angle - GameCamera.rotationSpeed * dt end
end
