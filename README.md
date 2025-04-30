<h1> Mortality Rate Calculator - Violent Injuries</h1>

<h2>Description</h2>
This project calculates injury mortality rates adjusted by sex, race, and ethnicity for Florida to support visualization on a Tableau dashboard. Using Tidyverse packages in R, mortality data from an Excel flat file were cleaned and reshaped, then merged with population estimates from the U.S. Census for accurate rate calculations.  
<br />


<h2>Languages and Utilities Used</h2>

- <b> R </b> 
- <b> Tidyverse Package</b>
- <b> Tidycensus Package</b>


<h2>Environments Used</h2>

- <b>RStudio</b> (4.4.1)

<h2>Program walk-through:</h2>

<p align="center">
Load Packages and Connect to US Census API <br/>
<img src="https://i.imgur.com/HIGfLqz.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<br />
<br />
Import Population Data from US Census <br/>
<img src="https://i.imgur.com/2WCG08t.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<img src="https://i.imgur.com/7DO2lO7.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<br />
<br />
Create a template df for the mortality data, then merge it with the population df <br/>
<img src="https://i.imgur.com/cj8YBd2.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<br />
<br />
Calculate the rates, then export <br/>
<img src="https://i.imgur.com/ArUPV4Y.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<img src="https://i.imgur.com/OkWGkzt.png" height="80%" width="80%" alt="Motaility Rate Calculator Steps"/>
<br />
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
