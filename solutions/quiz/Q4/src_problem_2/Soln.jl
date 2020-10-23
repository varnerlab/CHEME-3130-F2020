# include -
using PyPlot
using DataFrames

# constants -
R = 0.08314 # L bar mol^-1 K^-1

function _data_table()

    # setup -
    df = DataFrame()

    df.Tc = [536.4,587.2,0.0]
    df.Pc = [54.72,52.27,0.0]
    df.Vc = [0.239,0.239,0.0]
    df.Zc = [0.293,0.256,0.0]
    df.wc = [0.222,0.272,0.0]
    df.B = [0.0,0.0,0.0]

    # return -
    return df
end

function _compute_state(data_table::DataFrame)

    # T -
    T11 = data_table[!,:Tc][1]
    T22 = data_table[!,:Tc][2]
    Tc_12 = (T11*T22)^(1/2)
    data_table[!,:Tc][3] = Tc_12

    # Z -
    Z11 = data_table[!,:Zc][1]
    Z22 = data_table[!,:Zc][2]
    Zc_12 = 0.5*(Z11+Z22)
    data_table[!,:Zc][3] = Zc_12

    # w -
    w11 = data_table[!,:wc][1]
    w22 = data_table[!,:wc][2]
    wc_12 = 0.5*(w11+w22)
    data_table[!,:wc][3] = wc_12

    # Vc -
    V11 = data_table[!,:Vc][1]
    V22 = data_table[!,:Vc][2]
    Vc_12 = (((V11)^(1/3)+(V22)^(1/3))/(2))^(3)
    data_table[!,:Vc][3] = Vc_12

    # Compute P -
    Pc_12 = (Zc_12*R*Tc_12)/(Vc_12)
    data_table[!,:Pc][3] = Pc_12

    # return -
    return data_table
end

function _eval_abbott_model(Tr::Float64,w::Float64)

    B0 = 0.083 - 0.422/((Tr)^1.6)
    B1 = 0.139 - 0.172/((Tr)^(4.2))

    return (B0+w*B1)
end

function _compute_B(data_table::DataFrame,T_K::Float64,P_K::Float64)

    # B11 -
    Tc_11 = data_table[!,:Tc][1]
    Pc_11 = data_table[!,:Pc][1]
    wc_11 = data_table[!,:wc][1]
    Tr_11 = T_K/Tc_11
    B11 = ((R*Tc_11)/(Pc_11))*(_eval_abbott_model(Tr_11,wc_11))

    # B22 -
    Tc_22 = data_table[!,:Tc][2]
    Pc_22 = data_table[!,:Pc][2]
    wc_22 = data_table[!,:wc][2]
    Tr_22 = T_K/Tc_22
    B22 = ((R*Tc_22)/(Pc_22))*(_eval_abbott_model(Tr_22,wc_22))

    # B12 -
    Tc_12 = data_table[!,:Tc][3]
    Pc_12 = data_table[!,:Pc][3]
    wc_12 = data_table[!,:wc][3]
    Tr_12 = T_K/Tc_12
    B12 = ((R*Tc_12)/(Pc_12))*(_eval_abbott_model(Tr_12,wc_12))

    # add to table -
    data_table[!,:B][1] = B11
    data_table[!,:B][2] = B22
    data_table[!,:B][3] = B12

    # return -
    return data_table
end

function _compute_fugacity_coeff(y1::Float64,data_table::DataFrame,T_K::Float64,P_bar::Float64)

    # get B's -
    B11 = data_table[!,:B][1]
    B22 = data_table[!,:B][2]
    B12 = data_table[!,:B][1]

    # compute delta -
    d12 = 2*B12 - B11 - B22

    # compute fugacity coeff -
    y2 = 1 - y1
    ln_fc_1 = ((P_bar)/(R*T_K))*(B11 - d12*(y2^2))
    ln_fc_2 = ((P_bar)/(R*T_K))*(B22 - d12*(y1^2))

    # return -
    return (exp(ln_fc_1),exp(ln_fc_2))
end

function solve(y1::Float64,T_K::Float64,P_bar::Float64)

    # initialize the data table -
    data_table = _data_table()

    # compute all the critical properties -
    data_table = _compute_state(data_table)

    # compute the B's -
    data_table = _compute_B(data_table,T_K,P_bar)

    # compute fugacity coeff -
    (f_hat_1, f_hat_2) = _compute_fugacity_coeff(y1,data_table,T_K,P_bar)

    return (f_hat_1,f_hat_2,data_table)
end
