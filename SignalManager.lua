-- // [[Dependencies]] \\ --
local SignalBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/bystance/Signal/main/SignalBase.lua"))()

-- // [[Module]] \\ --
local SignalManager = {}
SignalManager.__index = SignalManager

do
    function SignalManager.new()
        local self = setmetatable({}, SignalManager)
        self.Signals = {}
        return self
    end

    function SignalManager.Get(self, SignalName)
        return self.Signals[SignalName]
    end

    function SignalManager.Add(self, Signal)
        if (typeof(Signal) == "string") then
            Signal = SignalBase.new(Signal)
        end
        self.Signals[Signal.Name] = Signal
    end

    function SignalManager.Remove(self, SignalName)
        self.Signals[SignalName] = nil
    end

    SignalManager.Create = SignalManager.Add
    function SignalManager.Fire(self, SignalName, ...)
        local Signal = self:Get(SignalName)
        assert(Signal, ": signal does not exist.")
        return Signal:Fire(...)
    end

    function SignalManager.Connect(self, SignalName, ...)
        local Signal = self:Get(SignalName)
        assert(Signal, ": signal does not exist.")
        return Signal:Connect(...)
    end

    function SignalManager.Wait(self, SignalName, Timelapse)
        local Signal = self:Get(SignalName)
        assert(Signal, ": signal does not exist.")
        return Signal:Wait(Timelapse)
    end
end

return SignalManager
