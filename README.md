# U.S. Immigrants Have Highly Heterogeneous Perceptions of How Selected They Are

## Introduction
Here, we provide the data and code required for replicating the findings presented in the data visualization below. The visualization illustrates immigrants' heterogeneous perceptions of their health in comparison to the country of origin. We visualize these patterns by self-reported health status for top-five immigrant sending countries included in the New Immigrant Survey (NIS). 

![Visualization](Figure_1_new.jpg)

## Data 
### Data are from the in the New Immigrant Survey - Sections [A (Demographics)](https://nis.princeton.edu/downloads/codebook/Adult/A-adult-codebook.pdf) and [D (Health)](https://nis.princeton.edu/downloads/codebook/Adult/D-adult-codebook.pdf)

Data can be accessed through: https://nis.princeton.edu/
* While the data are publicly available, the user will need to sign up using their e-mail.

## Process 
* Respondents are from top-five sending countries (A9Amo).
* We stratify by self-reported health (d1).
* We show the distribution of Health compared to those in home country (d112).
* Sampling weights were applied to produce nationally representative estimates (niswgtsamp1).

## Code
The [code](Visualization_ImmigrantHealth_Code_06022022.R) included in this repository can be used to replicate our data visualization. Data should be requested from the NIS Repository (as described above). 

## Supplemental Figure
The figure with the original comparative self-reported health items is presented below, and is included in the replication code. 

![Visualization2](Supp_Figure_1.jpg)

## Correspondence
For any issue with the functionality of this script please [create an issue](https://github.com/alexisrsantos/immigrant_selection/issues).

## License
The data collected and presented is licensed under the [Creative Commons Attribution 3.0 license](http://creativecommons.org/licenses/by/3.0/us/deed.en_US), and the underlying code used to format, analyze and display that content is licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).
