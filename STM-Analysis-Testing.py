from STMAnalysis.Measurements import Spectrum, Scan


#scan_data = 'test_files\\06-08-2018_blg001.sxm'
#sc = Scan(scan_data)

#sc.view(signal='Current',direction='average')

spec_data = 'test_files\\Au11100034.dat'
sp = Spectrum(spec_data)
sp.view()