Data exploration for World of Warcraft Mythic+ Season 1 Thundering data.  Quantifying risk and reward

Original wowhead article here: https://www.wowhead.com/news/thundering-seasonal-affix-statistics-quantifying-risk-and-reward-332527 \
Processed data here: https://docs.google.com/spreadsheets/d/1XV8xRJ6jY3r72r3ZVqdeZe0vOclFpp6reESXzZfQE9U/edit?usp=sharing \
API call: https://pastebin.com/Fwb9vkHt

Setting:
This is a review of Dragonflight Season 1.

Let's say the stakeholders (game devs) want to know how well Thundering performed as an affix. Was it a good affix? Was it a bad affix?

How do we quantify what is 'good' or bad'?

Thundering is what's known as a 'kiss/curse' affix. It gives the player a buff (kiss) but if the player fails to execute the proper mechanics, it will also harm them (curse).

We are going to find out if the 'kiss' outweighs the 'curse', and if the 'kiss' buff is as significant as the devs designed it to be

If not, we can conclude that the affix *did not* function as intended.



Plan table of contents:
1. Data Acquisition (import libraries, load data, .info(), .describe())
3. Data Cleaning and Pre-processing (create new calculation columns, rename columns, missing/duplicated values)
4. Exploratory Data Analysis (explore trends within the data. we are looking explicitly for variables that may affect the amount of damage done with thundering. pick out the variables)
6. Data Visualization (explore the relationships of these variables with thundering-buffed damage. also consider the deadliness of thundering)
7. Hypothesis Testing (null: thundering buff did not contribute to damage (<= damage without the buff). alt: thundering *did* contribute to damage (> damage w/o buff))
8. Conclusion (is it an effective affix? what else could have been done to make it a better affix? what are some considerations and limitations of our data?)


Data Exploration
1. Values counts of keystone levels
2. `.describe()`
3. categorical comparisons: top damage and uptime by spec, dungeon
4. top deaths by spec, dungeon
5. Deaths to primal overload stuns vs deaths to lightning strike stuns -> drop lightning strike stuns as a useful variable

Data Visualizations (comparisons of damage, deaths and keystone timer)
1. Distribution of keystone levels (Bar chart)
2. box plot of bonus damage/uptime overall, and by keystone level
3. Scatter plot to determine correlation between bonus damage and uptime, coloured by keystone level
4. box plot of deaths overall, by keystone level
5. bar chart of deaths within 2, 5, 10s of primal overload stuns
6. scatter plot of #stuns vs #deaths within 10s, coloured by keystone level
7. scatter plot of keys timed (1) vs untimed (0) against # of thundering stuns
8. mean and median of keystone completion timers (is the distribution skewed or not, lets us know to use median or mean)
9. heatmap of average/median % dungeon timer completion by keystone level and # of thundering stuns
11. correlation heat map right at the end of all the numerical variables, expected:
    - positive: uptime vs bonus dmg
    - positive: # of stuns vs deaths
    - positive: # of stuns vs keystone timer
    - negative: bonus dmg vs keystone timer
    - negative # of stuns vs keystone level

Hypothesis testing (quantifying the buff: normal dmg vs buffed dmg)
- histogram to check if damage/bonus damage is normally distributed
- may have to normalise data
- we are looking for difference between 2 means (mean of dmg) vs (mean of bonus dmg with thundering)
- null hypothesis: means are the same/bonus dmg mean is less
- alternative hypothesis: bonus dmg mean is significantly greater than dmg mean
- this is a one-sided hypothesis test (only testing the difference in 1 direction)
- tests for total, test per keystone level, test per spec???? test per dungeon

Hypothesis testing (quantifying risk: do you gain more if you gamble for higher uptime/more dmg?)
- linear regression?
- % of dungeon timer against uptime (going to have cases where 5 ppl have the same dungeon timer but different buff uptime bc dungeons are run in groups of 5)
- bonus damage against uptime?????
- by using uptime we also include bad players with a higher risk appetite.
