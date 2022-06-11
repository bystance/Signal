-- // [[Module]] \\ --
local Signal = {}
Signal.__index = Signal
Signal.__type = "Signal"
Signal.ClassName = "Signal"

local Connection = {}
Connection.__index = Connection
Connection.__type = "Connection"
Connection.ClassName = "Connection"

function Connection.new(Signal: table, Callback: any): table
    local SignalType = typeof(Signal)
    assert(SignalType == "table" and Signal.ClassName == "Signal", ":bad argument #1 to 'new' (Signal expected, got " .. SignalType .. ")")
    local CallbackType = typeof(Callback)
    assert(CallbackType == "function", ":bad argument #2 to 'new' (function expected, got " .. CallbackType .. ")")
    
    local self = setmetatable({}, Connection)
    self.Function = Callback
    self.State = true
    self.Signal = Signal
    return self
end

function Connection.Enable(self: table): nil
    self.State = true
end

function Connection.Disable(self: table): nil
    self.State = false
end

function Connection.Disconnect(self: table): nil
    local Connections = self.Signal.Connections
    local selfTableCheck = table.find(Connections, self)
    table.remove(Connections, selfTableCheck)
end
Connection.disconnect = Connection.Disconnect

function Signal.new(Name: string): table
    local NameType = typeof(Name)
    assert(NameType == "string", ":bad argument #1 for 'new' (string expected, got " .. NameType .. ")")
    
    local self = setmetatable({}, Signal)
    self.Name = Name
    self.Connections = {}
    return self
end

function Signal.Connect(self: table, Callback: any): table
    local CallbackType = typeof(Callback)
    assert(CallbackType == "function", ":bad argument #1 to 'Connect' (function expected, got " .. CallbackType .. ")")
    local Connection = Connection.new(self, Callback)
    table.insert(self.Connections, Connection)
    return Connection
end
Signal.connect = Signal.Connect

function Signal.Fire(self: table, ...): nil
    for _,Connection in ipairs(self.Connections) do
        if not (Connection.State) then
            continue
        end
        coroutine.wrap(Connection.Function)(...)
    end
end
Signal.fire = Signal.Fire

function Signal.Wait(self: table, Timelapse: number): any
    Timelapse = Timelapse or (1/0)
    local returnValues = {}
    local Fired = false
    local Connection = self:Connect(function(...)
        returnValues = {...}
        Fired = true
    end)
    local TimeElapsed = tick()
    while (true) do
        task.wait()
        TimeElapsed = tick() - TimeElapsed
        if not (Fired or TimeElapsed > Timelapse) then
            continue
        end
        break
    end
    Connection:Disconnect()
    return unpack(returnValues)
end
Signal.wait = Signal.Wait

function Signal.Destroy(self: table): nil
    self = nil
end
Signal.destroy = Signal.Destroy

return Signal
