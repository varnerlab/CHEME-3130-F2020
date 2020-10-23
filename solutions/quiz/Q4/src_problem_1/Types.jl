mutable struct DataObject

    A::Float64
    B::Float64
    C::Float64
    Tc::Float64
    w::Float64

    function DataObject()
        return new()
    end
end

struct GammaParameters

    A12::Float64
    A21::Float64
    C::Float64

end