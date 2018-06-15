from . import * # import everything from __init__.py

class Scan:
	"""
	Class of 2D Scan data. Automatically converts all data to
	unitful data using the ureg 'UnitRegistry' object from the 'pint' package.

	Parameters
	----------
	fname: str
		Name of .sxm file containing scan data. Required.

	Attributes
	----------
	fname	:	.sxm file where data was retrieved.
	
	scan 	: 	nanonispy 'Scan' object

	signals : 	dict of 'forward' and 'backward' data for each channel
				e.g. 'Z', 'Current', 'LI_Demod_1_X', 'LI_Demod_1_Y'.

	range 	:	numpy array of length 2 containing range of scan
				in x and y directions, respectively.

	"""
	def __init__(self, fname):
		self.fname = fname
		self.scan = nap.read.Scan(fname) # Retrieve data from .sxm file
		self.signals = self.scan.signals # Extract 'Z', 'Current', 'LI_Demod_1_X', 'LI_Demod_1_Y'
		unit = [ureg.meter, ureg.ampere, ureg.siemens, ureg.siemens] # Units of the channels

		
		for i, key in enumerate(self.signals.keys()):
			# Flip the 'backward' channel to match 'forward'
			self.signals[key]['backward'] = self.signals[key]['backward'][:,::-1]
			self.signals[key]['forward'] = self.signals[key]['forward'] * unit[i]
			self.signals[key]['backward'] = self.signals[key]['backward'] * unit[i]

		self.range = self.scan.header['scan_range'] * ureg.meter


	def view(self,signal = 'Z', direction='average',zscale='nano',space='real'):
		"""
		Uses matplotlib.pyplot.imshow to plot self.signals.

		Parameters
		----------
		signal   :	Signal to plot from 'Z', 'Current', 'LI_Demod_1_X', 'LI_Demod_1_Y'
					Defaults to 'Z'.

		direction: 	One of 'forward', 'backward', or 'average'.
					Defaults to 'average'.

		zscale:		Scales units for plotting 3rd axis of data.
					Defaults to 'nano'.

		space:		Whether to plot in real or reciprocal space.
					Reciprocal space is found with a FFT.
					Defaults to 'real'.
		"""

		if direction == 'average':
			plot_title = 'Average {} of Forward and Backward Scans'.format(signal)
			# Take average of every corresponding point
			image = ( self.signals[signal]['forward'] + self.signals[signal]['backward']) / 2
		else:
			plot_title = '{} {} Scan'.format(direction.capitalize(),signal)
			image = self.signals[signal][direction]

		if signal == 'Z':
			image -= image[~np.isnan(image)].min() # shift Z so min value is zero

		# Choose xy scale. Only nm for now.
		extent = self.range.to('nanometer')

		# Choose third dimension scale
		z_unit = ureg.parse_expression( zscale + str(image.units) ).units
		image = image.to(z_unit)

		if space == 'reciprocal':
			image = np.fft.fft2(image.magnitude).real * image.units
			extent = 1 / extent
			print(extent.units)
			plot_title += ' (FFT)'

		# Create the figure
		fig, ax = plt.subplots()

		fig.canvas.set_window_title('From file:  '+ self.fname)

		im_ax = ax.imshow(	image,
							extent = [-extent[0].magnitude/2, extent[0].magnitude/2,
									-extent[1].magnitude/2, extent[1].magnitude/2]) 

		ax.set_xlabel('x ({:~})'.format(extent.units))
		ax.set_ylabel('y ({:~})'.format(extent.units))

		# Color Bar
		cbar = fig.colorbar(im_ax)
		cbar.set_label('{} ({:~})'.format(signal,image.units))
		ax.set_title(plot_title)
		plt.show()


class Spectrum:
	"""
	Class of Spectrum data. Automatically converts all data to
	unitful data using the ureg 'UnitRegistry' object from the pint' package.

	Parameters
	----------
	fname: str
		Name of .dat file containing spectrum data. Required.

	Attributes
	----------
	fname	:	.dat file where data was retrieved.

	spec 	: 	nanonispy 'Spec' object

	signals : 	dict of 'forward' and 'backward' data for each channel
				Exception is 'Bias calc' which has no 'forward' or 'backward',
				just an array.

	"""
	def __init__(self, fname):
		self.fname = fname
		self.spec = nap.read.Spec(fname)
		self.signals_temp = dict()
		self.signals = self.spec.signals

		# Signal names are returned differently for spectrum
		# 'Bias calc (V)' is special, it has no 'forward' and 'backward' data
		self.signals_temp['Bias calc'] = self.signals['Bias calc (V)'] * ureg.volt

		# Reparse data so it's the same format as Scan
		channels = [label for label in self.signals.keys() if label != 'Bias calc (V)']
		for label in channels:
			parsed = self.parse_signal_key(label)

			if parsed['Signal']not in self.signals_temp.keys():
				self.signals_temp[parsed['Signal']] = dict()

			self.signals_temp[parsed['Signal']][parsed['Direction']] = self.signals[label] * ureg.parse_expression(parsed['Unit'])

		self.signals = self.signals_temp

		del self.signals_temp

	def view(self,signal='LI Demod 1 X', direction='forward', yscale = 'pico', xscale='milli'):
		"""
		Uses matplotlib.pyplot.fig to plot self.signals.

		Parameters
		----------
		signal   :	Signal to plot. For 'dI/dV' use 'LI Demod 1 X' (default)

		direction: 	One of 'forward', 'backward', or 'average'.
					Defaults to 'average'.

		yscale:		Scales units for plotting signal data.
					Defaults to 'pico'.

		xscale:		Scale for plotting 'Bias calc' data.
					Defaults to 'milli' so that we plot in mV.
		"""
		if direction == 'average':
			plot_title = 'Average {} of Forward and Backward Spectra'.format(signal)
			# Take average of every corresponding point
			data = ( self.signals[signal]['forward'] + self.signals[signal]['backward']) / 2
		else:
			plot_title = '{} {} Spectrum'.format(direction.capitalize(),signal)
			data = self.signals[signal][direction]

		bias_units = ureg.parse_expression('milli'+'volt').units
		data_units = ureg.parse_expression(yscale + str(data.units)).units

		# Create the figure
		fig, ax = plt.subplots()

		fig.canvas.set_window_title('From file:  '+ self.fname)

		ax.plot(self.signals['Bias calc'], data)

		ax.yaxis.set_units(data_units)
		ax.xaxis.set_units(bias_units) # <--- Not scaling x axis?		

		ax.set_xlabel('Tip Bias ({:~})'.format(bias_units))
		ax.set_ylabel('{} ({:~})'.format(signal, data_units))
		ax.set_title(plot_title)

		plt.show()

	def parse_signal_key(self, signal_key):
		"""
		Parses the signal keys in the dict self.signals.
		For example:
		'Current (A)' -> 'Current', 'forward', 'A'
		'Current [bwd] (A)' -> 'Current', 'backward', 'A'
		"""
		if signal_key.find('[') == -1:
			direction = 'forward'
			name_end = signal_key.find('(')
		else:
			direction = 'backward'
			name_end = signal_key.find('[')

		unit_start = signal_key.find('(') 
		unit_end = signal_key.find(')')

		name = signal_key[:name_end-1]
		unit = signal_key[unit_start+1:unit_end]

		return {'Signal' : name, 'Direction': direction, 'Unit': unit}