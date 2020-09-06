function compute_pressure(model::CCBEVanDerWaalsEquationOfStateModel, operatingPoint::CCBEOperatingPoint)::CCBEResult

    # get vdw parameters -
    a = model.a
    b = model.b
    R = model.R

    # TODO: check if T and V are nothing?
    if (isnothing(operatingPoint.volume) == true || isnothing(operatingPoint.temperature) == true)
        error_message = "Missing operating values: Either the volume or temperature is missing"
        return CCBEError{ArgumentError}(ArgumentError(error_message))
    end
    
    # get state -
    T = operatingPoint.temperature
    V = operatingPoint.volume
    
    # compute -
    repulsion_term = (R*T)/(V - b)
    attraction_term = a/V^2

    # pressure -
    pressure = repulsion_term - attraction_term

    # create new operating point -
    operatingPoint = CCBEOperatingPoint(pressure, V, T)

    # return -
    return CCBEResult{CCBEOperatingPoint}(operatingPoint)
end