# STM Analysis Library

The `STMAnalysis` library is a small Python package for analysis of STM data. Built on [Nanonispy](https://github.com/underchemist/nanonispy) for data importing, it extends this library to do common analysis in the STM field.

## Installation

To install, simply download the repository from this github page. The library is dependent on the following packages:

* [Nanonispy](https://github.com/underchemist/nanonispy) for importing data from .sxm files.
* [Numpy](www.numpy.org) for manipulation of data
* [Matplotlib](https://matplotlib.org) for plotting
* [Pint](https://pint.readthedocs.io/en/latest/) for unit conversion

In the future, I will put the package PyPI so that you can download using `pip install STMAnalysis`.

## Tutorial

STM experiments mainly consist of 2D scans of a surface or electronic spectra. Ther objects in the `STMAnalysis` library that describe these measurements are `Scan` and `Spectrum` respectively. By creating a variable that is one of these object, and providing the required file path, the data is automatically read in to the objects. You can then view the data. For example

```python
sc = Scan('test_files/06-08-2018_blg001.sxm')
sc.view()
```

will plot the following scan data.

[ExampleScan]: images/example_scan.png "Dirty Gold"
