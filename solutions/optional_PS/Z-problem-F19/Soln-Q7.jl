# Packages -
using DataFrames

# setup some constants from the problem
Tc = 425.2      # K
Pc = 37.9       # bar
R = 8.314e-2    # L bar mol^{-1} K^{-1}
omega = 0.199   # dimensionless

# -------------------------------------------------------------- #
# compute the Z using the given model  
# (T,P) -> (Tr,Pr,B0,B1,Z0,Z1,Z)
# -------------------------------------------------------------- #
function compute_compressibility(T::Float64,P::Float64)

    # compute Tr, Pr -
    Tr = T/Tc
    Pr = P/Pc

    # compute B0, B1 -
    B0 = 0.083 - 0.422*(Tr)^(-1.6)
    B1 = 0.139 - 0.172*(Tr)^(-4.2)

    # compute Z -
    Z0 = 1+(Pr/Tr)*B0
    Z1 = (Pr/Tr)*B1
    Z = Z0+omega*Z1

    # return -
    return (Tr,Pr,B0,B1,Z0,Z1,Z)
end

# -------------------------------------------------------------- #
# compute the residual volume
# (T,P,Z) -> VI,VR
# -------------------------------------------------------------- #
function compute_residual_volume(T::Float64,P::Float64,Z::Float64)

    # Compute: V^{R} = (RT/P)*(Z-1)
    # compute VI -
    VI = (R*T)/P

    # compute VR -
    VR = VI*(Z-1)

    # return -
    return (VI,VR)
end

function main(T::Float64,P::Float64)

    # compute the Z et al at (T,P)
    (Tr,Pr,B0,B1,Z0,Z1,Z) = compute_compressibility(T,P)

    # compute the residual volume -
    (VI,VR) = compute_residual_volume(T,P,Z)

    # compute actual volume -
    V = VR+VI

    # return -
    return (Tr,Pr,B0,B1,Z0,Z1,Z,VI,VR,V)
end

# execute -
T = 510.0 # K
P = 25.0  # bar
(Tr,Pr,B0,B1,Z0,Z1,Z,VI,VR,V) = main(T,P);
