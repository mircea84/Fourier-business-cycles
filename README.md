# Fourier-business-cycles

This piece of code started from an attempt to learn R programming by doing something meaningful. Don't take it too seriously and think it is a tool for forecasting economy recessions! Analysts and policymakers (the main actors interested in understanding and anticipating business cycles) rely on more complicated economic models (Dynamic Stochastic General Equilibrium - DSGE).

Business cycles can be seen from periodic variations of economic output, as well as other macroeconomic variables. Fourier transform is a great tool for spotting variations in time-series, regardless of the underlying measure. An alternative that considers variations is periodicity is wavelet transform.

The chosen macroeconomic variable studied is unemployment rate from 1992 to 2019, provided by INSSE (www.insse.ro). 
![Alt text](doc/fig1_Unempl_Rate.jpg?raw=true "Unemployment rate Romania")
Figure 1 - Unemployment rate Romania

For Fourier transform to work, the signal has to be stationary - statistical proprieties such as mean, variance, auto-correlation have to be constant over a particular time-frame. It's easy to spot the downward trend in the above pic, so our time-series needs to be "stationarized". A common method is differentiation - calculate the increase or decrease in the unemployment rate compared to the previous month.
![Alt text](doc/fig2_Change_in_unempl_rate.jpg?raw=true "Change in unemployment rate")
Figure 2 - Change in unemployment rate (differentiation)

Periodicity of one year can be observed in both charts. Following 2015, fluctuations decrease considerably. If we overlap the data for each year, we notice that the unemployment rate is lower in Q3. 
![Alt text](doc/fig3_Unempl_Rate_overlap.jpg?raw=true "Overlapped unemployment rate")
Figure 3 - Yearly overlapped change in unemployment rate

Finally, let's apply the Fourier analysis and create a view of all patterns being present in the unemployment rate.
![Alt text](doc/fig4_Fourier_unempl_rate.jpg?raw=true "Spectogram")
Figure 4 - Unemployment rate spectogram

X-axis represents the frequencies of each cycle and Y-axis is the impact of a particular cycle on the analyzed data - we could say that the higher the amplitude, the stronger that particular pattern is.
Top 5 amplitude peaks and their respective frequencies are below. The corresponding duration of the cycle (derived from fft_freq column) is on the right of the table.
     fft_freq         main_fft_coef   cycle duration
     (cycles/moth)    (amplitude)     (years)
6    0.01818182       0.1116425       0.9482759
27   0.08181818       0.1062799       0.9821429
28   0.08484848       0.1675955       0.4910714
29   0.08787879       0.2415176       4.5833333
56   0.16969697       0.1406687       1.0185185

The first three peaks show what was visible from the time chart - one-year periodicity. Fourier analysis discovered a 4th peak, too - four and a half year periodicity in analyzed data. 

In trying to understand what caused the patterns and changes mentioned above, I've extracted the industry contribution to GDP. Check below. However, I'll leave comments and conclusions for later.
![Alt text](doc/fig5_Industry_contrib_GDP.png?raw=true "Industry contribution to GDP")
Figure 5 - Industry contribution to GDP (CON106E - Produsul intern brut trimestrial - serie bruta CAEN Rev.2, preturi medii ale anului 2000)

Thanks for reading and I hope it helps. Comments and ideas are welcome.
