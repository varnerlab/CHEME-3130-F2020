### CHEME 3130 Fall 2020 Cornell University
Example notebooks used in lecture are contained in the ``root`` folder.

### How do I download the example notebooks?
You can download the examples by cloning this repository (from the command line):

```
    $ git clone https://github.com/varnerlab/CHEME-3130-F2020.git
```

or by cloning the repository using the [GitHub desktop app](https://desktop.github.com). 
Alternatively, you can download the examples and code as zip file by hitting the green Code button in the upper right corner of the screen, and selecting the zip option.   

### How do I run the examples?
The examples presented in the CHEME 3130 lectures are available as [Jupyter notebooks](http://jupyter.org)
encoded in the [Julia](https://julialang.org) programming language. [Jupyter notebooks](http://jupyter.org)
require [Python](https://www.python.org). All of these technologies are platform independent and open source,
and can be easily installed on your local machine.

* See [here](http://jupyter.org/install.html) to install [Jupyter notebooks](http://jupyter.org) on your local machine.
[Jupyter notebooks](http://jupyter.org) require a working [Python](https://www.python.org) installation.
We __highly__ recommend the [Anaconda distribution](https://www.anaconda.com/download/#macos) implementation.
Once you have [Jupyter notebooks](http://jupyter.org) installed, see [here](https://jupyter.readthedocs.io/en/latest/running.html#running) for help running a notebook.

* See [here](https://julialang.org/downloads/) to install [Julia](https://julialang.org) locally.
However, for an easy all in one installation, please consider downloading/installing [JuliaPro](https://juliacomputing.com/products/juliapro); it comes with many common packages, and is already integrated with the [Juno](https://junolab.org) integrated development environment (IDE).

Once [Julia](https://julialang.org) has been installed, you'll need to add the [IJulia](https://github.com/JuliaLang/IJulia.jl) package to run [Julia](https://julialang.org) code in a [Jupyter notebook](http://jupyter.org).
To install [IJulia](https://github.com/JuliaLang/IJulia.jl), first [start Julia](https://docs.julialang.org/en/stable/manual/getting-started/) and then issue the command at the REPL prompt:

```
  julia> using Pkg; Pkg.add("IJulia")
```



### How do I view static versions of the example notebooks, quiz or prelim solutions?
You can view static versions of the example notebooks using [NBViewer](https://nbviewer.jupyter.org). Just click on an example below, and enjoy!

#### NBViewer links for the Examples:
* [Present Future Value example](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/Example-Present-Future-Value.ipynb)

* [Net Present Value example](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/Example-NetPresentValue-Calculation.ipynb)

* [Flow calorimeter example](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/Example-FlowCalorimeter.ipynb)

* [Turbine lost work example](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/Example-Turbine.ipynb)


#### NBViewer links for the problem set solutions:
* [PS1 Fall 2020 solution](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/solutions/quiz/Q1/Q1-Soln-CHEME-3130-F20.ipynb)


#### NBViewer links for optional problem set solutions 
* [CCornellium Z problem Quiz 7 F19](https://nbviewer.jupyter.org/github/varnerlab/CHEME-3130-F2020/blob/master/solutions/optional_PS/Z-problem-F19/Solution.ipynb)


