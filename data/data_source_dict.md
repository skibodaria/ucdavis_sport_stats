# Data Sources & Data Dictionary for This Project


## Data Source
The data for this project comes from a course provider -- UCDAVIS -- with a direct link to a [Dropbox folder](https://www.dropbox.com/scl/fo/idnc4sbvj9cmefwl51ruy/AFmpaGLav_ZytNbFRs-Iwcw?rlkey=u3y8qw3hsza4jhg3pnqnwcxct&e=2&dl=0). 

The original source of this data is the work of [Randi Griffin](https://www.linkedin.com/in/randigriffin/), also published on [Kaggle](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results). Here are the two files:

* `athlete_events.csv.zip` -- a `.zip` archive which can be unpacked to a flat table with multiple records, represented in `.csv` format; contains information about Olympic Games participations; consists of 271116 rows and 15 columns (see below in the "Data Dictionary" explanations); this file also had quite somd duplicates, so they all were dropped;
* `noc_regions.csv` -- a text file which contains information about local teams and National Olympic Commitees; consists of 230 rows and 3 columns; didn't have any duplicates.

## Data Dictionary
The first step in the course of this assignment was to **explore** the data and make sense of it. To perform the first quick analysis, the files were loaded to Jupyter Notebook with `pandas` library. The file can be found in `analysis_sport/`. Resulting data dictionaries for both files:

### `athlete_events.csv`
|No.|Column Name|Data Type|Null Values|Meaning|Comments|
|-|-|-|-|----------------|---------------------|
|1|`id`|integer|no|unique identifier of an athlete|not unique|
|2|`name`|string|no|full name of an athlete|not unique|
|3|`sex`| string|no|biological sex of an athlete|two values (`M` for male and `F` for female)|no|
|4|`age`|float|yes|age of an athlete at a particular year|changes from one entry to another even for one athlete|
|5|`height`|float|yes|height of an athlete at a particular year|changes from one entry to another even for one athlete|
|6|`weight`|float|yes|height of an athlete at a particular year|changes from one entry to another even for one athlete|
|7|`team`|string|no|country a particular athlete was a team-member of|can change from year to year; dataset has 1184 unique values for teams|
|8|`noc`|string|no|stands for "National Olympic Committee"|doesn't fully represent the team: there are 230 unique values for NOC; my assumption is that it's also a dynamic measure for an athlete|
|9|`games`|string|no|name of particular Olympic games|the dataset has 51 unique values for games; format is '1992 Summer' or '1998 Winter', so it combines year + season; there are 29 summer games and 22 winter games in the dataset|
|10|`year`|integer|no|year of participation in Olympic games|25 unique years from 1896 to 2016|
|11|`season`|string|no|stands for "winter" and "summer" games|n/a|
|12|`city`|string|no|location where the games took place|42 unique values|
|13|`sport`|string|no|sport discipline a particular athlete was performing in|66 unique values|
|14|`event`|string|no|type/name of the event the athlete took part in|765 unique events in the dataset; format: "Judo Men's Extra-Lightweight" or "Speed Skating Women's 500 metres"|
|15|`medal`|string|yes|an award an athlete received|values: "Gold", "Silver", "Bronze"|

### `noc_regions.csv`
|No.|Column|Meaning|Comments|
|-|-|-----------|---|
|1|`noc`|stands for "National Olympic Committee; format: "AFG" or "BOH"|230 unique values|
|2|`region`|stands for a country/territory name|206 unique values|
|3|`notes`|additional information about team/country title|n/a|