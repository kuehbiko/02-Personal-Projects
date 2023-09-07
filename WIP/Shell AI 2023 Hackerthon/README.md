# Shell.ai Hackathon 2023

### Waste to energy
Max. score: 100

![image](https://github.com/kuehbiko/shell_ai_hackerthon/assets/88494428/2ce0f4f9-efbe-496f-8bac-33fc72e2a3f1)

Let’s try to understand the ‘Waste-to-Energy’ problem using the map shown in Figure 1. It corresponds to the yearly residual biomass available in the state of Gujarat in western India. The geographic region is divided into grid blocks of equal size and the average biomass production of each grid block is represented on the color scale. The spatial distribution will change year after year and the biomass available in these grid blocks will serve as feedstock to biofuel production plants that is biorefineries.

The biomass feedstock needs to be optimally collected and transported to the biorefineries’ gate and the grid blocks in Figure 1 that is the Harvesting Sites serve as the starting point in the supply chain. At each Harvesting Site, biomass availability can be forecasted using historical data. External parameters such as weather, rainfall, government regulation, etc. may also influence biomass production. Bales of biomass will be collected from these Harvesting Sites and transported to the pre-processing Depots for densification and pelletization. The pellets will then be transported from each of these Depots to each Biorefinery, in quantities that cater to each Biorefinery’s demand. The locations of the Depot and the Biorefinery will remain constant. The schematic of this supply chain is shown in Figure 2.

![image](https://github.com/kuehbiko/shell_ai_hackerthon/assets/88494428/9b2572f3-3c09-48c6-afb6-30eba2dda286)

Your solution should accurately forecast the spatial distribution of biomass availability in the given region and select the optimal location for all the assets in the supply chain that is the preprocessing depots and biorefineries, such that the supply chain is robust while satisfying practical objectives and constraints.

### Task

You are asked to create a solution that identifies optimal locations for the different assets across the waste-to-energy supply chain, from the harvesting sites to the biorefineries. Based on the data provided, you will forecast the spatial distribution of biomass in a region, while meeting practical objectives and constraints.

### Dataset description

The dataset contains the following:

Biomass_History.csv:  A time-series of biomass availability in the state of Gujarat from year 2010 to 2017. We have considered arable land as a map of 2418 equisized grid blocks (harvesting sites). For ease of use, we have flattened the map and provided location index, latitude, longitude, and year wise biomass availability for each harvesting site \
Distance_Matrix.csv:  The travel distance from source grid block to destination grid block, provided as a 2418 x 2418 matrix. Note that this is not a symmetric matrix due to U-turns, one-ways etc. that may result into different distances for ‘to’ and ‘fro’ journey between source and destination. \
sample_submission.csv: Contains sample format for submission \
The columns provided in the dataset are as follows:

|Column name |Description|
|---|---|
|year| 2018, 2019, 20182019|
|data_type|	depot_location, refinery_location, biomass_forecast, biomass_demand_supply, pellet_demand_supply|
|source_index|	Within 0 to 2417|
|destination_index|	Within 0 to 2417|
|value|	Any value following problem constraints|

### Evaluation metric

There will be 2 rounds of evaluation which are as follows:
Public \
Private 

The score generated for the public round will be visible on the leaderboard till the first round is over.

The first year (2018) of your solution will be kept for the public leaderboard. You can test your solution any time and see how it ranks. The second year (2019) of your solution will be kept for the private leaderboard and it will be used to determine the finalists. 

#### Note: Error scores - if the candidate gets any integer score between 0-18, it means it encountered an error during evaluation.
0 - Format error: solution.csv not following the correct format. Check the sample solution file for reference.
1 - Constraint 1 violated \
2 - Constraint 2 violated \
3 - Constraint 3 violated \
4 - Constraint 4 violated \
5 - Constraint 5 violated \
6 - Constraint 6 violated \
7 - Constraint 7 violated \
8 - Constraint 8 violated \
9 - Index error: Harvesting site location index should be an integer value between 0 and 2417 \
10 - Index error: Depot location index must be an integer value between 0 and 2417 \
11 - Index error: Biorefinery location index must be an integer value between 0 and 2417 \
12 - Index error: Harvesting site location index out of bound in biomass demand-supply matrix \
13 - Index error: Depot location index out of bound in biomass demand-supply matrix \
14 - Index error: Depot location index out of bound in pellet demand-supply matrix \
15 - Index error: Biorefinery location index out of bound in pellet demand-supply matrix \
16 - Index error: You can only specify one value of biomass forecast per location. Multiple found. \
17 - Index error: You can only place one depot per location. Multiple found. \
18 - Index error: You can only place one biorefinery per location. Multiple found. \

### Result submission guidelines

Note: Ensure that your submission file contains the following:

Correct index values as per the files given. \
Correct names of columns as provided in the sample_submission.csv file
