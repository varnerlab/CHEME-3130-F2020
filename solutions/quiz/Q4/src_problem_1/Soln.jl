# includes -
include("Include.jl")
include("Problem.jl")

# Answer -
# a) T = -30C or 243.15

function compute_flash_T(data_dictionary::Dict{String,Any})

    # let's get the data objects -
    data_object_1 = data_dictionary["data_object_1"]
    data_object_2 = data_dictionary["data_object_2"]

    # we solve the Antoine's equation in reverse -
    P1SAT = 15.9 # bar

    # compute the T -
    A = data_object_1.A
    B = data_object_1.B
    C = data_object_1.C
    T = (B/(A - log10(P1SAT))) - C

    # return T -
    return T
end

function solve()

    # feed -
    z1_feed = 0.42
    z2_feed = 1.0 - z1_feed
    P_flash = 10.5      # bar -
    F_dot = 10.0        # mol/t

    # load data_dictionary -
    data_dictionary = build_data_dictionary()

    # compute the T -
    T_estimate_K = compute_flash_T(data_dictionary)
    
    # compute ideal Pxy data -
    dt_ideal = compute_ideal_VLE_pxy_data_table(T_estimate_K)

    # we need to find the Pxy data at P = P_flash
    idx_pressure = findlast(x->x<=P_flash,dt_ideal[!,:P])
    x1_eq = dt_ideal[!,:x1][idx_pressure]
    y1_eq = dt_ideal[!,:y1][idx_pressure]
    #@show (x1_eq,y1_eq)

    # l and v -
    l = (y1_eq - z1_feed)
    v = (z1_feed - x1_eq)
    alpha = l/v
    V_dot = F_dot/(1.0+alpha)
    L_dot = (V_dot)*alpha
    #@show (F_dot,L_dot,V_dot)

    # what are my real PSATs?
    P1SAT_actual = compute_saturation_pressure(T_estimate_K,data_dictionary["data_object_1"])
    P2SAT_actual = compute_saturation_pressure(T_estimate_K,data_dictionary["data_object_2"])
    #@show (P1SAT_actual,P2SAT_actual)

    # test -
    P1SAT = 15.9    # estimated 
    P2SAT = 7.50    # estimated -
    test_value = z1_feed*(((P1SAT/P_flash)*(V_dot/F_dot)+(L_dot/F_dot))^-1)+z2_feed*(((P2SAT/P_flash)*(V_dot/F_dot)+(L_dot/F_dot))^-1)
    #@show test_value

    # put everything in dictionary -
    soln_dictionary = Dict()
    soln_dictionary["F_dot"] = F_dot
    soln_dictionary["L_dot"] = L_dot
    soln_dictionary["V_dot"] = V_dot
    soln_dictionary["x1_eq"] = x1_eq
    soln_dictionary["y1_eq"] = y1_eq
    soln_dictionary["T_estimate_K"] = T_estimate_K
    soln_dictionary["test_value"] = test_value
    soln_dictionary["z1_feed"] = z1_feed
    soln_dictionary["z2_feed"] = z2_feed

    # return -
    return soln_dictionary
end

soln = solve()