# clear all variables
rm(list=ls())

require(RCurl)
library(TSA)
library(ggplot2)

#link <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vRW2t0dNlynd9pTXSEtwYuKNiS944FJPq9Zc5_PpWf_jBP5lFCpJmj2-qT0Q41j2e0_Sop3XUCqTJjh/pub?output=csv"
link <- "https://raw.githubusercontent.com/mircea84/Fourier-business-cycles/master/RO_unempl_rate_data.csv"
url <- getURL( link )
con <- textConnection( url )
data <- read.csv( con )

# Construct the chart with 3 rows and 1 column. x11() not necessary
# par(mfrow=c(2,1))

Index = data$Index
Unem = data$Valoare
ChangeUnem = data$Delta
Time <- paste(data$IdLuna,data$Ani, sep="_")

# Plot of unemployment rate
ggplot ( data, aes(Index, Unem) ) + 
  geom_line() +
  scale_x_continuous(name = "Month_Year", breaks = Index[seq(1,length(Index),6)], labels = Time[seq(1,length(Time),6)] ) +
  scale_y_continuous(name="Unemployment Rate") +
  theme ( axis.text.x = element_text (angle=90, vjust=0.5))
x11()

# Plot of yearly overlapped unemployment rate
subdata <- subset (data, data$Index<241) # construct subset of values from 1992 to 2011
ggplot ( subdata, aes(subdata$IdLuna, subdata$Valoare) ) + 
  geom_line(aes(group=subdata$Ani, colour=as.factor(subdata$Ani))) +
  scale_x_continuous( name = "Month", breaks = subdata$IdLuna, labels = subdata$IdLuna ) +
  scale_y_continuous( name = "Yearly Overlapped Unemployment Rate") +
  theme( axis.text.x = element_text (angle=90, vjust=0.5)) + 
  labs(colour="Year") 
x11()

# Plot change in unemployment rate (month over month)
ggplot ( data, aes(Index, ChangeUnem) ) + 
  geom_line() +
  scale_x_continuous(name = "Month_Year", breaks = Index[seq(1,length(Index),6)], labels = Time[seq(1,length(Time),6)] ) +
  scale_y_continuous(name="Change in unemployment rate") +
  theme ( axis.text.x = element_text (angle=90, vjust=0.5))
x11()

# p <- periodogram(Unem)
# p <- periodogram(ChangeUnem)
# spectrum(ChangeUnem[1:length(ChangeUnem)-1])
# x11()

# Delta has 330 points, we excluded the last point which is NA
N = length(ChangeUnem)

fft = fft(ChangeUnem);
fft_coef = abs(fft); 
# plot (fft_coef, type="h"); 
norm_fft_coef = fft_coef / (N/2);
main_fft_coef = norm_fft_coef[1:(N/2)];
fft_freq = (c(1:(N/2)) * 1) / N ;
f <- data.frame(fft_freq, main_fft_coef)

ggplot ( f, aes(f$fft_freq, f$main_fft_coef) ) + 
  geom_bar(stat="identity") +
  scale_x_continuous(name = "Cycles/Month", breaks = f$fft_freq[seq(1,length(f$fft_freq),1)], labels = round(f$fft_freq[seq(1,length(f$fft_freq),1)], 3) ) +
  scale_y_continuous(name="Magnitude") +
  theme ( axis.text.x = element_text (angle=90, vjust=0.5))
x11()

# The heights of the bars commonly represent one of two things: either a count of cases in each group, or the values in a column of the data frame. 
# By default, geom_bar uses stat="bin". This makes the height of each bar equal to the number of cases in each group, and it is incompatible with mapping values to the y aesthetic. 
# If you want the heights of the bars to represent values in the data, use stat="identity" and map a value to the y aesthetic.


#try to get the max values' index value
# head(sort(main_fft_coef), 5)
# which(f$main_fft_coef > .14) #  6 27 28 29 56

subset(f, f$main_fft_coef>.1)
f[ which( f$main_fft_coef > .10 ),1 ]
#[1] 0.01818182 0.08181818 0.08484848 0.08787879 0.16969697
(1 / (f[ which( f$main_fft_coef > .10 ),1 ]) ) / 12
#[1] 4.5833333 1.0185185 0.9821429 0.9482759 0.4910714

# Bibliography
# Book Time Series Analysis and Its Applications - https://www.stat.pitt.edu/stoffer/tsa4/tsa4.pdf
# spectral analysis in R - https://ms.mcmaster.ca/~bolker/eeid/2010/Ecology/Spectral.pdf
# Using Google Drive as an R Data Repository - https://rodneydyer.com/2018/07/19/using-google-drive-as-an-r-data-repository/
# Unemployment: Its Measurement and Types - https://www.rba.gov.au/education/resources/explainers/unemployment-its-measurement-and-types.html
# THE ANALYSIS OF THE UNEMPLOYMENT SEASONALITY IN ROMANIA - http://steconomiceuoradea.ro/anale/volume/2008/v2-economy-and-business-administration/149.pdf
# Periodic unobservedcycles in seasonal time series with an application to USuneployment - https://ec.europa.eu/eurostat/documents/3888793/5841769/KS-DT-06-014-EN.PDF/2bef7a0b-2340-4cef-b668-11f3e8b404ca
# R graphics with ggplot2 workshop notes - https://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
# The Fast Fourier Transform (FFT) explained - without formulae - with an example in R - http://www.abstractnew.com/2014/04/the-fast-fourier-transform-fft-without.html
# https://math.stackexchange.com/questions/1002/fourier-transform-for-dummies
# excel FFT - Applying Discrete Fourier Transforms - https://flylib.com/books/en/2.22.1/applying_discrete_fourier_transforms.html


# Stuff to read
# Forecasting unemployment by @ellis2013nz - https://www.r-bloggers.com/forecasting-unemployment-by-ellis2013nz/
# !! Romania Poverty Monitoring Analytical and AdvisoryAssistance Program: - http://siteresources.worldbank.org/INTDEBTDEPT/Resources/468980-1218567884549/5289593-1224797529767/RomaniaDFSG01.pdf
# Fourier Analysis of Signals - https://www.audiolabs-erlangen.de/content/05-fau/professor/00-mueller/04-bookFMP/2015_Mueller_FundamentalsMusicProcessing_Springer_Section2-1_SamplePages.pdf
# !! Wavelet Analysis - https://www.cosmos.esa.int/documents/1655127/1655136/Torrence_1998_Wavelet_Guide_BAMS.pdf/001d8327-b255-3024-a2f0-ce02e33ac98f
# Wavelet - http://www.hs-stat.com/WaveletComp/
# FFT youtube https://www.youtube.com/channel/UC33qFpcu7eHFtpZ6dp3FFXw
