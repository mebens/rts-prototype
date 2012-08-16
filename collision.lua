local t = {}

function t.pointToCircle(px, py, cx, cy, cr)
  return math.abs(math.distance(px, py, cx, cy)) <= cr
end

function t.pointToRect(px, py, rx, ry, rw, rh)
  return px >= rx and py >= ry and px <= rx + rw and py <= ry + rh
end

function t.rectToRect(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 + w1 >= x2 and y1 + h1 >= y2 and x1 <= x2 + w2 and y1 <= y2 + h2
end

return t
