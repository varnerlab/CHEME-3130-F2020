# declare some path constants -
const _PATH_TO_ROOT = pwd()
const _PATH_TO_SRC = "$(_PATH_TO_ROOT)/src"
const _PATH_TO_DATA = "$(_PATH_TO_ROOT)/data"

# include external packages -
using Pluto

# include my codes -
include("$(_PATH_TO_SRC)/Types.jl")
include("$(_PATH_TO_SRC)/Factory.jl")
include("$(_PATH_TO_SRC)/Pressure.jl")