# abstract types -
abstract type CCBEAbstractEquationOfState end
abstract type CCBEAbstractOperatingPoint end
abstract type CCBEAbstractWorkingFluid end

# concrete types -
struct CCBEResult{T}
    value::T
end

struct CCBEError <: Exception
    message::String
end

struct CCBEVanDerWaalsEquationOfStateModel <: CCBEAbstractEquationOfState

    # parameters -
    a::Float64
    b::Float64
    R::Float64  # default units: L kPA K^-1 mol^-1

    # constructor -
    function CCBEVanDerWaalsEquationOfStateModel(a::Float64, b::Float64; R::Float64 = 8.314)
        this = new(a,b,R)
    end
end

mutable struct CCBEOperatingPoint <: CCBEAbstractOperatingPoint

    # state -
    pressure::Union{Float64,Nothing}
    volume::Union{Float64,Nothing}
    temperature::Union{Float64,Nothing}

    # constructor -
    function CCBEOperatingPoint(pressure::Union{Float64,Nothing}, volume::Union{Float64,Nothing}, temperature::Union{Float64,Nothing})
        this = new(pressure, volume, temperature)
    end
end

mutable struct CCBESingleComponentWorkingFluid <: CCBEAbstractWorkingFluid

    # data -
    Tc::Float64 # units: K
    Pc::Float64 # units: MPa
    Vc::Float64 # units: L
    ω::Float64  # units: dimensionless
    R::Float64  # units: MPa L mol^-1 K^-1 

    function CCBESingleComponentWorkingFluid(Tc::Float64, Pc::Float64, Vc::Float64, ω::Float64; R=0.008314)
        this = new(Tc,Pc,Vc,ω,R)
    end
end