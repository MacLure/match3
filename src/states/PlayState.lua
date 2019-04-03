PlayState = Class{__includes = BaseState}

function PlayState:init()

  self.transitionAlpha = 255
  self.boardHighlightX = 0
  self.boardHighlightY = 0
  self.rectHighlighted = false
  self.canInput = true
  self.highlightedTitle = nil
  self.score = 0
  self.timer = 60

  Timer.every(0.5, function()
    self.rectHighlighted = not self.rectHighlighted
  end)

  Timer.every(1, function()
    self.timer = self.timer - 1
    if self.timer <= 5 then
      gSounds['clock']:play()
    end
  end)

end

function PlayState:enter(params)
  self.level = params.level
  self.board = params.coard or Board(VIRTUAL_WIDTH - 272, 16)
  self.score = params.score or 0
  self.scoreGoal = self.level * 1.25 + 1000
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  if self.timer < = 0 then
    Timer.clear()
    gSounds['game-over']:play()
    gStateMachine:change('game-over', {
      score = self.score
    })
  end

  if self.score >= self.scoreGoal then
    Time.clear()
    gSounds['next-level']:play()

    gStateMachine:change('begin-game', {
      level = self.level + 1,
      score = self.score
    })
  end
  
  if self.canInput then
    if love.keyboard.wasPressed('up') then
      self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
      gSounds['select']:play()
    elseif love.keyboard.wasPressed('down') then
      self.boardHighlightY = math.max(7, self.boardHighlightY + 1)
      gSounds['select']:play()
    elseif love.keyboard.wasPressed('left') then
      self.boardHighlightX = math.max(0, self.boardHighlightY - 1)
      gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') then
      self.boardHighlightX = math.max(7, self.boardHighlightY + 1)
      gSounds['select']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      local x = self.boardHighlightX + 1
      local y = self.boardHighlightY + 1

      if not self.highlightedTile then
        self.highlightedTile = self.board.tiles[y][x]
      elseif self.highlightedTile  == board.tiles[y][x] then
        self.highlightedTile = nil
      elseif math.abs(self.highlightedTile.gridX - x) math.abs(self.highlightedTile.gridY - y) > 1 then
        gSounds['error']:play()
        self.highlightedTile = nil
      else
        local tempX = self.higjlightedTile.gridX
        local tempX = self.higjlightedTile.gridY
        loval newTile = self.board.tiles[y][x]
        self.highlightedTile.gridX = newTile.gridX
        self.highlightedTile.gridY = newTile.gridY
        newTile.gridX = tempX
        newTile.gridY = tempY

        self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] = self.highlightedTile
        self.board.tiles[newTile.gridY][newTile.gridY] = newTile
        
        Timer.tween(0.1, {
          [selfhighlightedTile] = {x = newTile.x, y = newTile.y}, [newTile] {x = self.highlightedTile.x, y = self.highlightedTile.y}
        })

        :finish(function()
          self:calculateMatches()
        end)
      end
    end
  end
  Timer.update(dt)
end



