function buildVanDerWaalsEquationOfState(fluid::CCBESingleComponentWorkingFluid)::CCBEVanDerWaalsEquationOfStateModel

    # compute the analytical vdw parameters -
    # get the critical parameters -
    Tc = fluid.Tc
    Pc = fluid.Pc
    Vc = fluid.Vc
    R = fluid.R

    # compute a, b from the critical parameters -
    a = (27/64)*((R^2)*(Tc^2))/(Pc)
    b = (1/8)*(R)*(Tc/Pc)

    # build a vdw EOS model -
    eos_model = CCBEVanDerWaalsEquationOfStateModel(a,b;R=R)

    # return -
    return eos_model
end
