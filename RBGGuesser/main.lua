
local colorToGuess = {0.5, 0.5, 0.5}
local guessedColor = {0, 0, 0}
local guessedValue = ""
local guessingPhase = 1

local nextColorTimer = 0

local highscore = 0


-- ###########################################
--           Love base Functions
-- ###########################################

function love.load()
    SetRandomColor()
end

function love.keypressed(key)
    if nextColorTimer > 0 then return end

    if key == '1' or
     key == '2' or
     key == '3' or
     key == '4' or
     key == '5' or
     key == '6' or
     key == '7' or
     key == '8' or
     key == '9' or
     key == '0' then
        guessedValue = guessedValue .. key
    end

    if key == 'backspace' then
        guessedValue = string.sub(guessedValue, 1, string.len(guessedValue) - 1)
    end

    if key == 'return' then
        if guessingPhase < 4 then
            guessedColor[guessingPhase] = RGBToDecimal(math.min(255, tonumber(guessedValue)))
            guessedValue = ''
            guessingPhase = guessingPhase + 1
            if guessingPhase == 4 then
                nextColorTimer = 5
            end
        end
    end

    if key == 'escape' then
        love.event.quit(0)
    end
end

function love.update(dt)
    if nextColorTimer > 0 then 
        nextColorTimer = nextColorTimer - dt 
    elseif guessingPhase > 3 then
        guessingPhase = 1
        SetRandomColor()
    end
end

function love.draw()
    love.graphics.setBackgroundColor(colorToGuess)

    --love.graphics.setColor(1 - colorToGuess[1], 1 - colorToGuess[2], 1 - colorToGuess[3])
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(guessedValue, 10, 10)

    -- highScore
    love.graphics.print("Highscore: " .. highscore, 300, 10)

    love.graphics.print("R: " .. DecimalToRGB(guessedColor[1]), 10, 40)
    love.graphics.print("G: " .. DecimalToRGB(guessedColor[2]), 10, 70)
    love.graphics.print("B: " .. DecimalToRGB(guessedColor[3]), 10, 100)

    if guessingPhase > 3 then
        local score = {}
        score[1], score[2], score[3] = CalcScore()
        love.graphics.print(DecimalToRGB(colorToGuess[1]), 60, 40)
        love.graphics.print(DecimalToRGB(colorToGuess[2]), 60, 70)
        love.graphics.print(DecimalToRGB(colorToGuess[3]), 60, 100) 

        -- Final Score
        local finalScore =(((255 * 3) - (DecimalToRGB(score[1]) + DecimalToRGB(score[2]) + DecimalToRGB(score[3]))) / (255 * 3)) * 100
        finalScore = math.floor(finalScore)
        if finalScore > highscore then highscore = finalScore end
        love.graphics.print("Score: " .. finalScore, 60, 160)
    end    
end



-- ############################################
--              Other functions
-- ############################################

function SetRandomColor()
    for i = 1, 3 do
        colorToGuess[i] = RGBToDecimal(love.math.random(0, 255))
        guessedColor[i] = 0
    end
    print("Colors: " .. DecimalToRGB(colorToGuess[1]) .. " " .. DecimalToRGB(colorToGuess[2]) .. " " .. DecimalToRGB(colorToGuess[3]))
end

function CalcScore()
    return math.abs(guessedColor[1] - colorToGuess[1]), math.abs(guessedColor[2] - colorToGuess[2]), math.abs(guessedColor[3] - colorToGuess[3]) 
end

function RGBToDecimal(num)
    return num / 255
end

function DecimalToRGB(num)
    return num * 255
end