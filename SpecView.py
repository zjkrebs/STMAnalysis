import numpy as np
import STMAnalysis.Measurements as meas



class PointBrowser(object):
    """
    Click on a point to select and highlight it -- the data that
    generated the point will be shown in the lower axes.  Use the 'n'
    and 'p' keys to browse through the next and previous points
    """

    def __init__(self):
        self.lastind = 0

        self.text = ax.text(0.05, 0.95, 'selected: none',
                            transform=ax.transAxes, va='top')
        self.selected, = ax.plot([], [], 'o', ms=12, alpha=0.4,
                                 color='yellow', visible=False)

#    Key functionality - probably not needed 
#    def onpress(self, event):
#        if self.lastind is None:
#            return
#        if event.key not in ('n', 'p'):
#            return
#        if event.key == 'n':
#            inc = 1
#        else:
#            inc = -1
#
#        self.lastind += inc
#        self.lastind = np.clip(self.lastind, 0, len(xs) - 1)
#        self.update()

    def onpick(self, event):
        if event.artist != line:
            return True

        N = len(event.ind)
        if not N:
            return True

        # the click locations
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

        #print(dataind)
        #print(X[dataind])

        ax2.cla()
        ax2.plot(spec.signals['Bias calc'],spec.signals['LI Demod 1 X']['forward'])

        currX = self.selected.get_xdata()
        currY = self.selected.get_ydata()

        currXY = list(zip(currX, currY))
        newXY = (xs[dataind], ys[dataind])

        if newXY in currXY:
            currXY.remove(newXY)
            if not currXY:
                updatedX = []
                updatedY = []
            else:
                updatedX = [list(t) for t in zip(*currXY)][0]
                updatedY = [list(t) for t in zip(*currXY)][1]

        else: 
            updatedX = np.append(currX,newXY[0])
            updatedY = np.append(currY,newXY[1])


        self.selected.set_data(updatedX, updatedY)
        self.selected.set_visible(True)
 #       self.text.set_text('selected: %d' % dataind)
        fig.canvas.draw()


if __name__ == '__main__':
    import matplotlib as mpl 
    import matplotlib.pyplot as plt
    from tkinter import Tk
    from tkinter.filedialog import askopenfilename
    import glob, os 
    
    # Dialogue window to open desired .sxm file. For now will just feed in test file.

    #Tk().withdraw() # we don't want a full GUI, so keep the root window from appearing
    #filename = askopenfilename() # show an "Open" dialog box and return the path to the selected file
    #print(filename)
    #print(os.path.dirname(filename))

    # Choose .sxm file 
    sxmfile = "/Users/zkrebs/brarlab/STMAnalysis/test_files/4-20-18_BLG_on_HBN007.sxm"
    os.chdir(os.path.dirname(sxmfile))
    for specfile in glob.glob("*.dat"):
        spec = meas.Spectrum(specfile)
        print(spec.coords) 

    # Extract the 2D scan data from the file 
    sxm = meas.Scan(sxmfile)
    #print(sxm.scan.header)
    X = sxm.signals['Z']['average']

    xs = np.array([500, 600, 700])
    ys = np.array([500, 600, 700])
    

    fig, (ax, ax2) = plt.subplots(1, 2)
    ax.imshow(X)

   
    ax.set_title('Click on point to view spectrum')
    line, = ax.plot(xs, ys, 'o', picker=5) 

    browser = PointBrowser()

    fig.canvas.mpl_connect('pick_event', browser.onpick)
    #fig.canvas.mpl_connect('key_press_event', browser.onpress)

    
    plt.show()




