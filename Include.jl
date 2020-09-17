# Pre-condition - paths need to be loaded

# do we start in the examples directory?
# Yes: then cd .. to get into the root
_tmp_path_dirname = pwd()
if (occursin("example",_tmp_path_dirname) == true)
    # go up one dir -
    cd("..")
end

# Setup the paths -
const _PATH_TO_ROOT = pwd()
const _PATH_TO_SRC = "$(_PATH_TO_ROOT)/src"
const _PATH_TO_DATA = "$(_PATH_TO_ROOT)/data"

# need to use the package manager, to activate this project -
import Pkg
Pkg.activate(_PATH_TO_ROOT);

# include external packages -
using Pluto
using DataFrames
using CSV
using Gadfly
using Cairo
using Fontconfig

# include my codes -
include("$(_PATH_TO_SRC)/base/Types.jl")
include("$(_PATH_TO_SRC)/base/Factory.jl")
include("$(_PATH_TO_SRC)/base/Pressure.jl")
include("$(_PATH_TO_SRC)/base/Estimate.jl")