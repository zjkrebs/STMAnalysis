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
        self.selected, = ax.plot([xs[0]], [ys[0]], 'o', ms=12, alpha=0.4,
                                 color='yellow', visible=False)

    def onpress(self, event):
        if self.lastind is None:
            return
        if event.key not in ('n', 'p'):
            return
        if event.key == 'n':
            inc = 1
        else:
            inc = -1

        self.lastind += inc
        self.lastind = np.clip(self.lastind, 0, len(xs) - 1)
        self.update()

    def onpick(self, event):

        if event.artist != line:
            return True

        print(event.ind)
        N = len(event.ind)
        if not N:
            return True

        # the click locations
        x = event.mouseevent.xdata
        y = event.mouseevent.ydata
        print(x,y)

        distances = np.hypot(x - xs[event.ind], y - ys[event.ind])
        indmin = distances.argmin()
        dataind = event.ind[indmin]

        self.lastind = dataind
        self.update()

    def update(self):
        if self.lastind is None:
            return

        dataind = self.lastind
        print(dataind)
        print(X[dataind])

        ax2.cla()
        #ax2.plot(X[dataind])

        self.selected.set_visible(True)
        self.selected.set_data(xs[dataind], ys[dataind])

        self.text.set_text('selected: %d' % dataind)
        fig.canvas.draw()


if __name__ == '__main__':
    #import matplotlib as mpl 
    import matplotlib.pyplot as plt

    # Example
    #np.random.seed(19680801)
    #X = np.random.rand(100, 200)


    # Choose .sxm file 
    sxmfile = "/Users/zkrebs/brarlab/STMAnalysis/test_files/4-20-18_BLG_on_HBN007.sxm"
    # Extract the 2D scan data from the file 
    scan = meas.Scan(sxmfile)
    X = scan.signals['Z']['average']
    specfile= "/Users/zkrebs/brarlab/STMAnalysis/test_files/Au11100034.dat"
    dat = meas.Spectrum(specfile)

    xs = np.array([500])
    ys = np.array([500])
    

    fig, (ax, ax2) = plt.subplots(1, 2)
    ax.imshow(X)

   
    ax.set_title('Click on point to view spectrum')
    line, = ax.plot(xs, ys, 'o', picker=5) 

    browser = PointBrowser()

    fig.canvas.mpl_connect('pick_event', browser.onpick)
    fig.canvas.mpl_connect('key_press_event', browser.onpress)

    

    plt.show()




