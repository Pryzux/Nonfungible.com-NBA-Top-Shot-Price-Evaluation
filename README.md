# Nonfungible.com-NBA-Top-Shot-Price-Evaluation
A fully automated system for evaluating the price of NBA Top Shot Nonfungible Tokens. Uses current market transactional data sourced by Nonfungible.com.

**Table of Contents**

-  [Purpose](#purpose)
-  [Description](#description)
-  [Getting Started](#getting-started)
-  [File Input](#file-input)
-  [Tech Stack](#tech-stack)

## Purpose

This project was developed for Nonfungible.com as apart of their mission statement "_to navigate through the highly volatile market of Nonfungible Tokens with confidence_". 

Nonfungible.com is a website that tracks NFT Market data. Using this data, a subset of their business model is to provide insight to clients about the current market value of their assets, to stay up to date with live market trends and make informed decisions. In line with this vision, The program was created to evaluate and monitor the price of a clients NBA Top Shot NFT's.

## Description

This program evaluates the price of all NBA Top Shot Cards based on historical transactional data ((Every sale and transfer of ownership between wallets), and evaluates the current estimate of ones personal collection of these assets. It provides a detailed breakdown of each individual assets estimated worth, as well as the total value of the collection. 

## Getting Started

![image](https://github.com/Pryzux/Nonfungible.com-NBA-Top-Shot-Price-Evaluation/assets/33528419/31069b92-81de-4ae3-854b-bd1713e28447)

To get started, download the "NBA Topshots Installer 2.0.exe" and download the required Matlab components (installer will determine if they are installed and automatically request to download them). Then simply run the program to get started. 

Once the download finishes and you run the program, a CMD window will open and you will be prompted to add two .csv files:

![image](https://github.com/Pryzux/Nonfungible.com-NBA-Top-Shot-Price-Evaluation/assets/33528419/d7d3f800-e0e7-4152-993e-5401f2f25a7e)

  ## File Input

  ![image](https://github.com/Pryzux/Nonfungible.com-NBA-Top-Shot-Price-Evaluation/assets/33528419/4c4da392-7e2a-4b23-af6d-ac98585995fd)

  The program takes two .csv files as input:

  1) The transactional data of all NBA Top Shot NFT's (see "sampleTransactionalData.csv" for a sample input)

  2) Another .csv of a list of NBA Top Shot assets you want to evaluate (see "sampleWalletData.csv for a sample input"). 


  **WARNING:** The current version of this program uses your RAM to temporarily store the .csv files while running the program. If the file size exceeds your RAM capacity, then the program will crash and likely cause a system reboot. Please ensure that the files you are inputting are less than the ram available on your system.  
  
Once you have inputted the files, wait 1-10 minutes depending on how large the transactional data file is (it's roughly 5 minutes per 20 million lines) and a file will automatically be exported to the installer location, that contains the assets requested and their newly calculated price. 
 
**For example:** 

Before:

  ![image](https://github.com/Pryzux/Nonfungible.com-NBA-Top-Shot-Price-Evaluation/assets/33528419/c0881978-e216-493c-8217-5471108e006e)

After:

![image](https://github.com/Pryzux/Nonfungible.com-NBA-Top-Shot-Price-Evaluation/assets/33528419/d5e835d1-4e1b-4741-9084-cf9e8c27a7ff)

## Tech Stack

This program uses MATLAB (https://www.mathworks.com/products/matlab.html), which is a proprietary multi-paradigm programming language and numeric computing environment developed by MathWorks. MATLAB allows matrix manipulations, plotting of functions and data, implementation of algorithms, creation of user interfaces, and interfacing with programs written in other languages.

