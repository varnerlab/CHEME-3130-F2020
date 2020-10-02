# === PRIVATE HELPER METHODS ============================================================= #
function _obj_function_volume_vdw(x, eos::CCBEVanDerWaalsEquationOfStateModel, P::Float64, T::Float64)

    # get R, a and b from the eos wrapper -
    R = eos.R
    a = eos.a
    b = eos.b

    # get x values -
    V = x[1]

    # compute terms -
    repulsion = (R*T)/(V-b)
    attraction = a/(V^2)

    # compute error -
    err = (P - repulsion + attraction)

    # penalty terms -
    p_term_1 = max(0,-1*V)
    p_term_2 = max(0,-1*(V-b))

    # return -
    return (err*err) + 10000.0*(p_term_1 + p_term_2)
end
# ======================================================================================== #

# === PUBLIC METHODS ===================================================================== #
function volume(model::CCBEVanDerWaalsEquationOfStateModel, pressure::Float64, temperature::Float64; volumeGuess::Float64 = 1.0)

    # setup the calculation -
    xinitial = [volumeGuess]
    OF(p) = _obj_function_volume_vdw(p, model, pressure, temperature)
    
    # call the optimizer -
    opt_result = optimize(OF,xinitial,BFGS())
    
    # return -
    return Optim.minimizer(opt_result)[1]
end
# ======================================================================================== #