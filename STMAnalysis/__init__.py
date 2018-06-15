name = "STMAnalysis"    # For PyPI

import nanonispy as nap # For uploading data from Nanonis Software
import numpy as np 		# For manipulating data
import matplotlib.pyplot as plt # For plotting data

# For easily converting units
from pint import UnitRegistry
ureg = UnitRegistry()
Q_ = ureg.Quantity

ureg.setup_matplotlib() # Allows easier unit conversion when plotting
