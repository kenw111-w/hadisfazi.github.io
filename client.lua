local ITEMS = { "Player", "Weapon", "Server", "Combat", "Vehicle", "Visual", "Miscellaneous", "Settings" }
local DUI_W, DUI_H = 400, 520
local URL = ('nui://%s/html/index.html'):format(GetCurrentResourceName())

local Hadis = { dui = nil, open = false, index = 1 }

function Hadis:Debug(msg)
    print(('[hadis_dui] %s'):format(msg))
end

function Hadis:Initialize()
    self.dui = CreateDui(URL, DUI_W, DUI_H)
    if not self.dui then
        self:Debug('Failed to create DUI')
        return
    end
    local txd = CreateRuntimeTxd('hadis_txd')
    CreateRuntimeTextureFromDuiHandle(txd, 'hadis_tex', GetDuiHandle(self.dui))
    self:Debug('DUI created')
end

function Hadis:Render()
    SendDuiMessage(self.dui, json.encode({ items = ITEMS, index = self.index }))
end

function Hadis:Destroy()
    if self.dui then DestroyDui(self.dui) self.dui = nil end
end

RegisterCommand('hadisdui', function()
    Hadis.open = not Hadis.open
    if Hadis.open then Hadis:Render() end
end, false)
RegisterKeyMapping('hadisdui', 'Toggle Hadis DUI menu', 'keyboard', 'F5')

CreateThread(function()
    Hadis:Initialize()
    while true do
        if Hadis.open and Hadis.dui then
            local resX, resY = GetActiveScreenResolution()
            local w, h = DUI_W / resX, DUI_H / resY
            DrawSprite('hadis_txd', 'hadis_tex', 0.02 + w / 2, 0.08 + h / 2, w, h, 0.0, 255, 255, 255, 255)

            if IsControlJustPressed(0, 173) then      -- arrow down
                Hadis.index = Hadis.index % #ITEMS + 1
                Hadis:Render()
            elseif IsControlJustPressed(0, 172) then  -- arrow up
                Hadis.index = (Hadis.index - 2) % #ITEMS + 1
                Hadis:Render()
            elseif IsControlJustPressed(0, 176) then  -- enter
                Hadis:Debug(('selected "%s"'):format(ITEMS[Hadis.index]))
            elseif IsControlJustPressed(0, 177) then  -- backspace
                Hadis.open = false
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then Hadis:Destroy() end
end)
