player = {

	x = start.x,
	y = start.y,
	width = 23,
	height = 28,
	color = { 155, 150, 150 },
	
	drawx = start.x,
	drawy = start.y,
	
	left = false,
	right = true,

	illegalx = false,
	illegaly = false,
	
	reverseX = false,
	reverseY = false,
	reverse = false,
	
	correctionX = 0,
	correctionY = 0,
	
	sectionx = 0,
	sectiony = 0,
	
	speed = 0,
	acc = 0,
	yacc = 0,
	yspeed = 0,
	maxspeed = 500,
	maxyspeed = 1000,
	
	moving = false,
	jumped = false
}

function player:gravity(dt)

	if(self.onground)then
	
		self.yspeed = 0
		self.yacc = 0
	
	else
		
		self.yacc = 25
		
		if(self.yspeed > self.maxyspeed)then

			self.yacc = 0
			self.yspeed = self.maxyspeed

		end
	
	end
	
end

function player:whichSection()
	player.sectionx = player.drawx/1100
	player.sectiony = player.drawy/500
end

function player:checkKeys(dt)

 	if love.keyboard.isDown('left') then
 	
		if(self.speed > 0)then
			self.speed = self.speed - 10
		end
 
		self.moving = true
  
		self.acc = -5
		if(self.speed > - 200)then
			self.acc = - 40
		end
		if(self.speed < -self.maxspeed)then
			self.acc = 0
			self.speed = -self.maxspeed

		end
		
		if(self.jumped)then
			
			self.maxspeed = 1000
			
		else
		
			self.maxspeed = 500
			
		end
				
		qleftanim:update(dt)   
	  
		self.right = false
		self.left = true

	end  
  	if love.keyboard.isDown('right') then
  
		if(self.speed < 0)then
			self.speed = self.speed + 10
		end
	
		self.moving = true

		self.acc = 5
		if(self.speed < 200)then
			self.acc = 40
		end
		if(self.speed > self.maxspeed)then
			self.acc = 0
			self.speed = self.maxspeed
		end
		
		if(self.jumped)then
			
			self.maxspeed = 1000
			
		else
		
			self.maxspeed = 500
			
		end
		
	
		qrightanim:update(dt)   
	
		self.right = true
		self.left = false

	end

 	if love.keyboard.isDown('down') then
    	self.y = self.y + 300 * dt
    
 	end
 	
 	if love.keyboard.isDown('up') then
		self:jump()    
 	end
  
  	if((love.keyboard.isDown('right') == false) and (love.keyboard.isDown('left') == false))then
  
  		self:noKeys(dt)
	
  	end

end

function player:move(dt)

  	if(self.onground)then
		
		if(self.moving == false)then
			if(self.speed < 0)then
				self.speed = self.speed + 30
			end
			if(self.speed > 0)then
				self.speed = self.speed - 30
			end
			if((self.speed >= -30 and self.speed < 0) or (self.speed <= 30 and self.speed > 0))then
				self.speed = 0
			end
	
		end
	end
  	
  	self.speed = self.speed + self.acc
	self.x = self.x + self.speed * dt
    
    self.yspeed = self.yspeed + self.yacc
	self.y = self.y + self.yspeed * dt
	
    self.reverseX, self.correctionX = self:checkX()
    self.reverseY, self.correctionY = self:checkY()


end

function player:noKeys(dt)

	self.moving = false
		self.acc = 0
  	
		if(self.speed > 0)then
			qrightanim:update(dt)
		end
		if(self.speed < 0)then
			qleftanim:update(dt)
		end
		if(self.speed == 0)then
			qleftanim:seek(2)
			qrightanim:seek(2)
		end
end


function player:checkMovement()
    
    if(self.reverseX)then
    	self.drawx = self.drawx + self.correctionX
    	self.x = self.drawx
    	
    			
		if(self.speed > 0)then
		
			self.speed = self.speed - 10
		
		elseif(self.speed < 0)then
		
			self.speed = self.speed + 10
			
		end
		
		if((self.speed < 0 and self.speed > -10) or (self.speed > 0 and self.speed < 10))then
		
			self.speed = 0
			
		end

    else
    	self.drawx = self.x

    end
    
    if(self.reverseY)then
       	if(self.correctionY < 0)then
    		if(self.y > self.drawy)then
    			self.onground = true
    		end
    	end
    
        self.drawy = self.drawy + self.correctionY
		self.y = self.drawy
		
		if(self.yspeed > 0)then
		
			self.yspeed = self.yspeed - 10
		
		elseif(self.yspeed < 0)then
		
			self.yspeed = self.yspeed + 10
			
		end
		
		if((self.yspeed < 0 and self.yspeed > -10) or (self.yspeed > 0 and self.yspeed < 10))then
		
			self.yspeed = 0
			
		end

    else
		self.drawy = self.y
		self.onground = false

    end

end


function player:checkX()

		self.reverse = false

		for i = 1, #sections do
			if(sections[i]:collide(player, 'x'))then
				self.reverse, correctionX = sections[i]:collide(player, 'x')
			end
		end
		
		if(self.reverse)then
				
			return true, correctionX

		else
			return false, 0 
		end
end

function player:checkY()

		self.reverse = false

		for i = 1, #sections do
			if(sections[i]:collide(player, 'y'))then
				self.reverse, correctionY = sections[i]:collide(player, 'y')
				
			end
		end
		
		for i = 1, #sections do
			if(sections[i]:onTop(player))then
			
				self.onground = true
				self.jumped = false
			end
		end
		
		if(self.reverse)then
				
			return true, correctionY

		else
			return false, 0
		end
		
		

end

function player:animate()

	if(self.right and self.jumped == false)then

		qrightanim:draw(player.drawx, player.drawy)
	
	
	end
	
	if(self.left and self.jumped == false)then
	
		qleftanim:draw(player.drawx, player.drawy)
	
	end
	
	if(self.jumped)then
		if(self.left)then
			qleftanim:seek(3)
			qleftanim:draw(player.drawx, player.drawy)

		end
		if(self.right)then
			qrightanim:seek(3)
			qrightanim:draw(player.drawx, player.drawy)
		end
	end
end

function player:jump()

	if(self.onground)then
	 	self.yspeed = self.yspeed - 600
	 	self.jumped = true
	end
	
end
