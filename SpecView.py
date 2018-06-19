import numpy as np
import STMAnalysis.Measurements as meas




class PointSpectrum(object):

    def __init__(self, point, spectrum):
        self.pos = point
        self.spectrum = spectrum 
        self.highlight, = ax.plot( [point[0]], [point[1]], marker='o', 
                                ms=12, alpha=0.4, color='yellow', visible=False )
        self.graph, = ax2.plot(spectrum.signals['Bias calc'], 
                                spectrum.signals['LI Demod 1 X']['forward'], visible=False )

    def show(self):
        self.highlight.set_visible(True)
        self.graph.set_visible(True)

    def hide(self):
        self.highlight.set_visible(False)
        self.graph.set_visible(False)


class PointBrowser(object):
    """
    Click on a point to select and highlight it -- the data that
    generated the point will be shown in the lower axes.  Use the 'n'
    and 'p' keys to browse through the next and previous points
    """

    def __init__(self, data):
        self.lastind = 0
        self.data = data


    def onpick(self, event):
        if event.artist != line:
            return True

        N = len(event.ind)
        if not N:
            return True

        # the click location
        x = event.mouseevent.xdata
        y = event.mouseevent.ydata

        distances = np.hypot(x - xs[event.ind], y - ys[event.ind])
        indmin = distances.argmin()
        dataind = event.ind[indmin]

        self.lastind = dataind
        self.update()

    def update(self):
        if self.lastind is None:
            return

        dataind = self.lastind

        if selectedPoint.highlight.get_visible():
            selectedPoint.hide()

        else:
            selectedPoint.show()

#       self.text.set_text('selected: %d' % dataind)
        fig.canvas.draw()

def withinBox(point, center, width, height):
    if ((center[0] - width) < point[0] < (center[0] + height)) and ((center[1] - height) < point[1] < (center[1] + height)):
        return True 
    return False  

if __name__ == '__main__':
    import matplotlib as mpl 
    import matplotlib.pyplot as plt
    from tkinter import Tk
    from tkinter.filedialog import askopenfilename
    import glob, os 
    
    # Dialogue window to open desired .sxm file. For now will just feed in test file.

    #Tk().withdraw() # we don't want a full GUI, so keep the root window from appearing
    #sxmfile = askopenfilename() # show an "Open" dialog box and return the path to the selected file
    #print(sxmfile)
    #print(os.path.dirname(sxmfile))

    fig, (ax, ax2) = plt.subplots(1, 2)

    masterlist = []
    xs = np.array([])
    ys = np.array([])


    sxmfile = "/Users/zkrebs/brarlab/STMAnalysis/testing/4-20-18_BLG_on_HBN004.sxm"
    sxm = meas.Scan(sxmfile)
    header = sxm.scan.header

    center= np.array(header['scan_offset'])
    extent = np.array(header['scan_range'])
    pixelSize = np.array(header['scan_pixels'])

    #print(center)
    #print(extent)
    #print(pixelSize)

    os.chdir(os.path.dirname(sxmfile))
    for specfile in glob.glob("*.dat"):
        spec = meas.Spectrum(specfile)
        if withinBox(spec.coords, center, extent[0]/2.0, extent[1]/2.0):
            location = pixelSize * ((spec.coords - center) / extent  + 0.5  )
            xs = np.append(xs,int(location[0]))
            ys = np.append(ys,int(location[1]))
            datapoint = PointSpectrum(location, spec)
            masterlist.append(datapoint)


    # Extract the 2D scan data from the file as background
    X = sxm.signals['Z']['average']
    ax.imshow(X)

    ax.set_title('Click on point to view spectrum')
    line, = ax.plot(xs, ys, 'o', picker=5) 

    # Initialize interactive clicking
    browser = PointBrowser(masterlist)
    fig.canvas.mpl_connect('pick_event', browser.onpick)

    
    plt.show()




