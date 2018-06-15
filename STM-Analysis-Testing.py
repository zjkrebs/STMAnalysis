from STMAnalysis.Measurements import Spectrum, Scan
from STMAnalysis.SpecView import PointBrowser

import matplotlib.pyplot as plt
import numpy as np



scan_data = 'test_files\\4-20-18_BLG_on_HBN007.sxm'
sc = Scan(scan_data)

for key in sc.scan.header.keys():
	print(key)
# sc.view()
# import matplotlib.pyplot as plt 
# import numpy as np
# fft = sc.get_FFT()
# print( fft.max() )

# plt.imshow(fft, vmax=100)
# plt.show()






#spec_data = 'test_files\\Au11100034.dat'
#sp = Spectrum(spec_data)
#sp.view()