Measured Dust Extinction Curves
===============================

Code to read in the measured interstellar dust extinction curves.

Both python and IDL versions of code are provided.  The IDL version was the
original, with the python more recent as I switch my scripting to python.  Both
should work, but errors are possible.  Please provide feedback via an issue or
an email to me kgordon@stsci.edu.

Data
----

The measured extinction curves are provide in FITS files with mulitple
extensions.  The different extensions give the measured extinction curves
based on one type of observation.  There should also be a BANDEXT extension
with the optical/NIR photometric extinction curve.  Examples of other
extensions are IUEEXT and FUSEEXT based on IUE and FUSE data, respectively.

The FITS files with the measured extinction curves can be found at:

https://stsci.box.com/v/measuredextcurves

Valencic, Clayton, & Gordon (2004, ApJ, 616, 912):
  - 450+ curves with IUE & optical/NIR photometry
  - units are E(lambda-V)
  - spectral based extinction regions binned
  - val04_iueext_update.tar.gz

Gordon, Cartledge, & Clayton (2009, ApJ, 705, 1320):
  - 75 curves with FUSE, IUE, & optical/NIR photometry
  - units are A(lambda)/A(V)
  - spectral based extinction regions binned and at native resolution
  - gor09_fuseext.tar.gz

Development
-----------

All are welcome to contribute.

Contributors
------------
Karl Gordon

License
-------

This code is licensed under a 3-clause BSD style license (see the
``LICENSE`` file).

