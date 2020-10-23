# compute Zc and w for 1,4-dioxane
Tc = 587.2
Pc = 52.27
Vc = 0.239
R = 8.314e-2 # L bar K−1 mol−1
Zc = (Pc*Vc)/(R*Tc)

# compute PSat -
T = 0.7*Tc # K
A = 4.58
B = 1570.1
C = -31.297
value = A - (B)/(T+C)
PSAT = 10^(value)   # bar

# compute wc for 1,4-dioxane
PR_sat = PSAT/Pc
w = -1 - log10(PR_sat)
