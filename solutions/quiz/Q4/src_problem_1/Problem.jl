# load files and packages -
include("Include.jl")

# Setup some constants -
R = 0.08134 # L bar mol^-1 K^-1
# A12 = -0.3771
# A21 = -0.5404
# C = 0.076

function compute_virial_coefficient(T_K::Float64,data_object::DataObject)::Float64

    T_cr_K = data_object.Tc
    w = data_object.w

    # Reduced T -
    Tr = T_K/T_cr_K

    # compute the Abbott correlations -
    B0 = 0.083 - (0.422/(Tr^(1.6)))
    B1 = 0.139 - (0.172/(Tr^(4.2)))

    # compute Bii -
    return (B0+w*B1)
end

function compute_saturation_pressure(T_K::Float64,data_object::DataObject)::Float64

    A = data_object.A
    B = data_object.B
    C = data_object.C

    log_10_PSAT = A - (B/(C+T_K))
    return (10^log_10_PSAT)
end

function compute_fugacity_coefficient(T_K::Float64,P_bar::Float64,Bii::Float64)::Float64

    # compute the fugacity coefficient -
    ln_f_i = ((P_bar)/(R*T_K))*Bii

    # return exp -
    return exp(ln_f_i)
end

function compute_activity_coefficient(x1::Float64,gamma_parameter_object::GammaParameters)::Tuple{Float64,Float64}

    A12 = gamma_parameter_object.A12
    A21 = gamma_parameter_object.A21
    C = gamma_parameter_object.C

    # compute x2 -
    x2 = 1 - x1

    # compute ln_gamma_i -
    ln_gamma_1 = (x2^2)*(A12+2*(A21-A12-C)*x1+3*C*x1^2)
    ln_gamma_2 = (x1^2)*(A21+2*(A12-A21-C)*x2+3*C*x2^2)

    # return -
    return (exp(ln_gamma_1),exp(ln_gamma_2))
end

function _obj_function(P_guess::Float64,T_K::Float64,x1::Float64,data_dictionary::Dict{String,Any})

    # get the data objects -
    data_object_1 = data_dictionary["data_object_1"]
    data_object_2 = data_dictionary["data_object_2"]
    gamma_parameter_object = data_dictionary["gamma_parameter_object"]

    # compute the phi sat -
    P1SAT = compute_saturation_pressure(T_K,data_object_1)
    P2SAT = compute_saturation_pressure(T_K,data_object_2)

    # compute Bii -
    B11 = compute_virial_coefficient(T_K,data_object_1)
    B22 = compute_virial_coefficient(T_K,data_object_2)

    # compute phi_i_sat -
    phi_1_sat = compute_fugacity_coefficient(T_K,P1SAT,B11)
    phi_2_sat = compute_fugacity_coefficient(T_K,P2SAT,B22)

    # compute phi_i
    phi_1 = compute_fugacity_coefficient(T_K,P_guess,B11)
    phi_2 = compute_fugacity_coefficient(T_K,P_guess,B22)

    # compute gamma -
    (gamma_1, gamma_2) = compute_activity_coefficient(x1,gamma_parameter_object)

    # compute P_model -
    P_model = ((gamma_1*phi_1_sat)/(phi_1))*x1*P1SAT + ((gamma_2*phi_2_sat)/(phi_2))*(1-x1)*P2SAT

    # compute obj value -
    obj_value = (P_guess - P_model)^2

    # return -
    return obj_value
end

function compute_pressure(x1::Float64,T_K::Float64,data_dictionary::Dict{String,Any})

    # setup the objective function -
    f(P) = _obj_function(P,T_K,x1,data_dictionary)

    # setup call -
    data_object_1 = data_dictionary["data_object_1"]
    data_object_2 = data_dictionary["data_object_2"]
    P1SAT = compute_saturation_pressure(T_K,data_object_1)
    P2SAT = compute_saturation_pressure(T_K,data_object_2)
    result = optimize(f,P2SAT,P1SAT)

    # return P -
    return Optim.minimizer(result)
end

function build_data_dictionary()

    # setup gamma_parameter_object -
    A21 = -0.5404
    A12 = -0.3771
    C = 0.076
    gamma_parameter_object = GammaParameters(A12,A21,C);

    # setup data objects -
    # 1 -
    A = 4.45
    B = 718.1
    C = -22.01
    Tc = 306
    w = 0.264
    data_object_1 = DataObject()
    data_object_1.A = A
    data_object_1.B = B
    data_object_1.C = C
    data_object_1.Tc = Tc
    data_object_1.w = w

    # 2 -
    A = 3.98
    B = 677.1
    C = -24.51
    Tc = 293
    w = 0.256
    data_object_2 = DataObject()
    data_object_2.A = A
    data_object_2.B = B
    data_object_2.C = C
    data_object_2.Tc = Tc
    data_object_2.w = w

    # pacjage -
    data_dictionary = Dict{String,Any}()
    data_dictionary["gamma_parameter_object"] = gamma_parameter_object
    data_dictionary["data_object_1"] = data_object_1
    data_dictionary["data_object_2"] = data_object_2

    # return -
    return data_dictionary
end

function compute_ideal_VLE_pxy_data_table(T_K::Float64)

    # initialize -
    df = DataFrame()

    # build the data dictionary -
    data_dictionary = build_data_dictionary()
    gamma_parameter_object = data_dictionary["gamma_parameter_object"]
    data_object_1 = data_dictionary["data_object_1"]
    data_object_2 = data_dictionary["data_object_2"]

    # composition array -
    x1_array = collect(0:0.001:1.0)

    # compute the saturation pressures -
    P1SAT = compute_saturation_pressure(T_K,data_object_1)
    P2SAT = compute_saturation_pressure(T_K,data_object_2)

    # initialize storage -
    y1_array = Float64[]
    P_array = Float64[]
    
    # main loop -
    for x1_value in x1_array

        # compute P -
        P_value = x1_value*P1SAT+(1-x1_value)*P2SAT

        # compute y1 -
        y1_value = (1/P_value)*(x1_value)*P1SAT

        # cache -
        push!(y1_array,y1_value)
        push!(P_array, P_value)
    end

    # attach -
    df.x1 = x1_array
    df.y1 = y1_array
    df.P = P_array

    # return -
    return df
end

function compute_full_VLE_Pxy_data_table(T_K::Float64)

    # initialize -
    df = DataFrame()

    # build the data dictionary -
    data_dictionary = build_data_dictionary()
    gamma_parameter_object = data_dictionary["gamma_parameter_object"]
    data_object_1 = data_dictionary["data_object_1"]
    data_object_2 = data_dictionary["data_object_2"]

    # initialize storage -
    y1_array = Float64[]
    P_array = Float64[]
    phi_1_array = Float64[]
    phi_2_array = Float64[]
    gamma_1_array = Float64[]
    gamma_2_array = Float64[]

    # compute the saturation pressures -
    P1SAT = compute_saturation_pressure(T_K,data_object_1)
    P2SAT = compute_saturation_pressure(T_K,data_object_2)

    # composition array -
    x1_array = collect(0:0.1:1.0)

    # main loop -
    for x1_value in x1_array

        # compute the pressure -
        P_value = compute_pressure(x1_value, T_K, data_dictionary)

        # compute activity coefficients -
        (gamma_1,gamma_2) = compute_activity_coefficient(x1_value, gamma_parameter_object)

        # compute phi_i -
        B11 = compute_virial_coefficient(T_K,data_object_1)
        B22 = compute_virial_coefficient(T_K,data_object_2)
        phi_1_value = compute_fugacity_coefficient(T_K,P_value,B11)
        phi_2_value = compute_fugacity_coefficient(T_K,P_value,B22)

        # compute saturation phi -
        phi_1_sat = compute_fugacity_coefficient(T_K,P1SAT,B11)
        phi_2_sat = compute_fugacity_coefficient(T_K,P2SAT,B11)

        # compute the y compostion -
        y1 = ((gamma_1*phi_1_sat)/(phi_1_value))*x1_value*P1SAT*(1/P_value)

        # cache -
        push!(y1_array,y1)
        push!(P_array, P_value)
        push!(gamma_1_array, gamma_1)
        push!(gamma_2_array, gamma_2)
        push!(phi_1_array, phi_1_value)
        push!(phi_2_array, phi_2_value)
    end

    # attach -
    df.x1 = x1_array
    df.y1 = y1_array
    df.P = P_array
    df.gamma_1 = gamma_1_array
    df.gamma_2 = gamma_2_array
    df.phi_1 = phi_1_array
    df.phi_2 = phi_2_array

    # return -
    return df
end