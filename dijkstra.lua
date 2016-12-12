local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.ox = false
aux.oy = false
aux.sx = false
aux.sy = false

aux.grid = false

aux.matrice = {}
aux.front = {}
aux.frontHash	= {}

function aux.createMatrice(x2, y2)
	local mat = {}
	for y = 1, y2 do
		mat[y] = {}
		for x = 1, x2 do
			mat[y][x] = {distance = -1, r = 0, g = 0, b = 0}
		end
	end
	return mat
end

function mod.generateMatrice(x1, y1, x2, y2, grid, sx, sy)
	aux.width, aux.height, aux.ox, aux.oy = x2, y2, x1, y1
	aux.sx, aux.sy = sx, sy
	aux.grid = grid
	aux.matrice = aux.createMatrice(x2, y2)
	aux.dijkstra()
	return aux.matrice
end

function aux.hashKey(x, y)
	return x * aux.height + (y - 1)
end

function aux.deHashKey(value)
	return math.floor(value/aux.height), value%aux.height + 1
end

function aux.updateFront(x, y)
	local front = {}

	-- print(aux.grid[y-1][x].bottom_wall)
	if y - 1 >= aux.oy and aux.matrice[y-1][x].distance == -1 and not aux.frontHash[aux.hashKey(x, y - 1)] and not aux.grid[y-1][x].bottom_wall then
		front[#front+1] = "UP" 
		aux.frontHash[aux.hashKey(x, y-1)] = #aux.front+1
		aux.front[#aux.front+1] = {x = x, y = y - 1}
	end

	if y + 1 <= aux.height and aux.matrice[y+1][x].distance == -1 and not aux.frontHash[aux.hashKey(x, y + 1)] and not aux.grid[y][x].bottom_wall then
		front[#front+1] = "DOWN" 
		aux.frontHash[aux.hashKey(x, y + 1)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x, y = y + 1}
	end

	if x + 1 <= aux.width and aux.matrice[y][x+1].distance == -1 and not aux.frontHash[aux.hashKey(x + 1, y)] and not aux.grid[y][x].right_wall then
		front[#front+1] = "RIGHT" 
		aux.frontHash[aux.hashKey(x + 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x + 1, y = y}
	end

	if x - 1 >= aux.ox and aux.matrice[y][x-1].distance == -1 and not aux.frontHash[aux.hashKey(x - 1, y)] and not aux.grid[y][x-1].right_wall then
		front[#front+1] = "LEFT" 
		aux.frontHash[aux.hashKey(x - 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x - 1, y = y}
	end

	return front
end

--[[
1. Set starting poing with 0
2. Get front cells and set them with 1
3. Go randomly to front cell and set next front cells with currentNumber+1
4. Repeat 3 until all cells are wisited
]]

function aux.dijkstra()
	local ix, iy = aux.sx, aux.sy
	
	aux.matrice[iy][ix].distance = 0
	aux.matrice[iy][ix].b = 255

	local front = aux.updateFront(ix, iy)

	while #aux.front ~= 0 do
		for _, v in pairs(front) do
			if v == "UP" and iy - 1 >= aux.oy then
				aux.matrice[iy - 1][ix].distance = aux.matrice[iy][ix].distance + 1
				aux.matrice[iy - 1][ix].b = aux.matrice[iy][ix].b - 0.065
				aux.matrice[iy - 1][ix].r = aux.matrice[iy][ix].r + 0.065
			elseif v == "DOWN" and iy + 1 <= aux.height then 
				aux.matrice[iy + 1][ix].distance = aux.matrice[iy][ix].distance + 1
				aux.matrice[iy + 1][ix].b = aux.matrice[iy][ix].b - 0.065
				aux.matrice[iy + 1][ix].r = aux.matrice[iy][ix].r + 0.065
			elseif v == "RIGHT" and ix + 1 <= aux.width then 
				aux.matrice[iy][ix + 1].distance = aux.matrice[iy][ix].distance + 1
				aux.matrice[iy][ix + 1].b = aux.matrice[iy][ix].b - 0.065
				aux.matrice[iy][ix + 1].r = aux.matrice[iy][ix].r + 0.065
			elseif v == "LEFT" and ix - 1 >= aux.ox then 
				aux.matrice[iy][ix - 1].distance = aux.matrice[iy][ix].distance + 1
				aux.matrice[iy][ix - 1].b = aux.matrice[iy][ix].b - 0.065
				aux.matrice[iy][ix - 1].r = aux.matrice[iy][ix].r + 0.065
			end
		end

		local value = table.remove(aux.front, math.random(1, #aux.front))
		ix, iy = value.x, value.y
		aux.frontHash[aux.hashKey(ix, iy)] = nil
		front = aux.updateFront(ix, iy)
	end
end
return mod
