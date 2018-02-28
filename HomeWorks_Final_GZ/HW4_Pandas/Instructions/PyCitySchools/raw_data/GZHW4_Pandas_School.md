

```python
import pandas as pd
import numpy as np

```


```python
schlfile="schools_complete.csv"
stufile = "students_complete.csv"

schldf=pd.read_csv(schlfile)
studf=pd.read_csv(stufile)

```


```python
##Section 1: District Summary

totalschl= schldf["School ID"].count()
totalstu=studf["Student ID"].count()
totalbudget= schldf["budget"].sum()
mathsum = studf["math_score"].sum()
math_average = studf["math_score"].sum()/totalstu
read_average = studf["reading_score"].sum()/totalstu

#pd.to_numeric(studf["math_score"]
mathpassdf=studf[studf["math_score"]>=60]#.count()
# can this be done without creating another dataframe?
#type(mathpassdf) #dataframe

mathpasspercent = mathpassdf["Student ID"].count()/totalstu
#type(mathpasspercent) #numpy.float64
#type(totalstu)
```




    numpy.int32




```python
readpassdf = studf[studf["reading_score"]>=60]
readpasspercent = readpassdf["Student ID"].count()/totalstu
overallpassrate = (readpasspercent + mathpasspercent)/2

summary_df=pd.DataFrame()
#summary_df=({"Total Schools":totalschl ,"Total Students":totalstu,"Total Budget":totalbudget,"Average Math Score":math_average })
summary_df["Total Schools"] = [totalschl]
summary_df["Total Students"] = [totalstu]
summary_df["Total Budget"] = [totalbudget]
summary_df["Average Math Score"] = [math_average]
summary_df["Average Reading Score"] = [read_average]
summary_df["% Passing Math"] = [mathpasspercent]
summary_df["% Passing Reading"] = [readpasspercent]
summary_df["% Overall Passing Rate"] = [overallpassrate]
summary_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Schools</th>
      <th>Total Students</th>
      <th>Total Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>15</td>
      <td>39170</td>
      <td>24649428</td>
      <td>78.985371</td>
      <td>81.87784</td>
      <td>0.924457</td>
      <td>1.0</td>
      <td>0.962229</td>
    </tr>
  </tbody>
</table>
</div>




```python
totalschl
```




    15




```python
##Section 2: School Summary

#student df group by school
stubyschl_df = studf.groupby(["school"])

#total stu count by school
stucountbyschl = stubyschl_df["Student ID"].count()
#stucountbyschl
#type(stucountbyschl)

math_ave_by_schl= stubyschl_df["math_score"].sum()/stucountbyschl
read_ave_by_schl= stubyschl_df["reading_score"].sum()/stucountbyschl
#pd.to_numeric(stubyschl_df["math_score"])

#% passing math --
#pass math stu rows by schl
math_pass_by_schl = mathpassdf.groupby(["school"])
math_pass_count_by_schl=math_pass_by_schl["Student ID"].count()
math_pass_count_by_schl.rename(columns={"school": "school name"}, inplace=True)
math_pass_by_schl_percent = math_pass_by_schl["Student ID"].count()/stucountbyschl*100

#% passing reading --
read_pass_by_schl = readpassdf.groupby(["school"])
read_pass_count_by_schl=read_pass_by_schl["Student ID"].count()
read_pass_count_by_schl.rename(columns={"school": "school name"}, inplace=True)
read_pass_by_schl_percent = read_pass_by_schl["Student ID"].count()/stucountbyschl*100

#overall passing rate
overall_pass_rate=(math_pass_by_schl_percent+read_pass_by_schl_percent)/2

```


```python
schl_summary_df=schldf
schl_summary_df.rename(columns = {"name":"school"}, inplace=True)
schl_summary_df
#schl_summary_df["total students"] = stucountbyschl
stu_count_by_schl_df= stucountbyschl.to_frame().rename(columns={"Student ID":"stu count"})
stu_count_by_schl_df
schl_summary_df["stu count"]=stu_count_by_schl_df["stu count"]
#schl_summary_df.merge(stu_count_by_schl_df , on = "school", left_index=True, right_index=True)
schl_summary_df

#per student budget
#per_stu_budget=schl_summary_df["budget"]/schl_summary_df["size"]
#schl_summary_df["Per Student Budget"] = "$"+str(per_stu_budget)
schl_summary_df["Per Student Budget"] = schl_summary_df["budget"]/schl_summary_df["size"]

#Average Math Score
math_ave_by_schl_df = math_ave_by_schl.to_frame().reset_index()
math_ave_by_schl_df.columns =["school","Average Math Score"]
schl_summary_df["Average Math Score"]=math_ave_by_schl_df["Average Math Score"]

#Average Reading Score
read_ave_by_schl_df = read_ave_by_schl.to_frame().reset_index()
read_ave_by_schl_df.columns =["school","Average Reading Score"]
schl_summary_df["Average Reading Score"]=read_ave_by_schl_df["Average Reading Score"]

#% Passing Math
math_pass_by_schl_percent_df=math_pass_by_schl_percent.to_frame().reset_index()
math_pass_by_schl_percent_df.columns =["school","% Passing Math"]
schl_summary_df["% Passing Math"]=math_pass_by_schl_percent_df["% Passing Math"]

#% Passing Reading
read_pass_by_schl_percent_df=read_pass_by_schl_percent.to_frame().reset_index()
read_pass_by_schl_percent_df.columns =["school","% Passing Reading"]
schl_summary_df["% Passing Reading"]=read_pass_by_schl_percent_df["% Passing Reading"]

#% Overall Passing Rate
overall_pass_rate_df=overall_pass_rate.to_frame().reset_index()
overall_pass_rate_df.columns =["school","% Overall Passing Rate"]
schl_summary_df["% Overall Passing Rate"]=overall_pass_rate_df["% Overall Passing Rate"]
schl_summary_df.pop("stu count")
schl_summary_df=schl_summary_df.reset_index(drop=True)
#schl_summary_df.pop("School ID")

schl_summary_df2 = schl_summary_df.rename(columns={"School":" ","type":"School Type","size":"Total Students"})
schl_summary_df2 = schl_summary_df2.rename(columns={"budget":"Total School Budget"})#:, .0f
schl_summary_df2["Total School Budget2"]=schl_summary_df2["Total School Budget"].map(lambda x: "\${}".format(x))
del schl_summary_df2["School ID"]
schl_summary_df2=schl_summary_df2.rename(columns={"school": " "})##??????right wayset index
schl_summary_df2
#Section 2 end
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>School Type</th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Per Student Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
      <th>Total School Budget2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>655.0</td>
      <td>77.048432</td>
      <td>81.033963</td>
      <td>89.529743</td>
      <td>100.0</td>
      <td>94.764871</td>
      <td>\$1910635</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Figueroa High School</td>
      <td>District</td>
      <td>2949</td>
      <td>1884411</td>
      <td>639.0</td>
      <td>83.061895</td>
      <td>83.975780</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$1884411</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Shelton High School</td>
      <td>Charter</td>
      <td>1761</td>
      <td>1056600</td>
      <td>600.0</td>
      <td>76.711767</td>
      <td>81.158020</td>
      <td>88.436758</td>
      <td>100.0</td>
      <td>94.218379</td>
      <td>\$1056600</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Hernandez High School</td>
      <td>District</td>
      <td>4635</td>
      <td>3022020</td>
      <td>652.0</td>
      <td>77.102592</td>
      <td>80.746258</td>
      <td>89.302665</td>
      <td>100.0</td>
      <td>94.651333</td>
      <td>\$3022020</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Griffin High School</td>
      <td>Charter</td>
      <td>1468</td>
      <td>917500</td>
      <td>625.0</td>
      <td>83.351499</td>
      <td>83.816757</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$917500</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Wilson High School</td>
      <td>Charter</td>
      <td>2283</td>
      <td>1319574</td>
      <td>578.0</td>
      <td>77.289752</td>
      <td>80.934412</td>
      <td>89.083064</td>
      <td>100.0</td>
      <td>94.541532</td>
      <td>\$1319574</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Cabrera High School</td>
      <td>Charter</td>
      <td>1858</td>
      <td>1081356</td>
      <td>582.0</td>
      <td>83.803279</td>
      <td>83.814988</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$1081356</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Bailey High School</td>
      <td>District</td>
      <td>4976</td>
      <td>3124928</td>
      <td>628.0</td>
      <td>76.629414</td>
      <td>81.182722</td>
      <td>88.858416</td>
      <td>100.0</td>
      <td>94.429208</td>
      <td>\$3124928</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Holden High School</td>
      <td>Charter</td>
      <td>427</td>
      <td>248087</td>
      <td>581.0</td>
      <td>77.072464</td>
      <td>80.966394</td>
      <td>89.182945</td>
      <td>100.0</td>
      <td>94.591472</td>
      <td>\$248087</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Pena High School</td>
      <td>Charter</td>
      <td>962</td>
      <td>585858</td>
      <td>609.0</td>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$585858</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Wright High School</td>
      <td>Charter</td>
      <td>1800</td>
      <td>1049400</td>
      <td>583.0</td>
      <td>76.842711</td>
      <td>80.744686</td>
      <td>88.547137</td>
      <td>100.0</td>
      <td>94.273568</td>
      <td>\$1049400</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Rodriguez High School</td>
      <td>District</td>
      <td>3999</td>
      <td>2547363</td>
      <td>637.0</td>
      <td>83.359455</td>
      <td>83.725724</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$2547363</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Johnson High School</td>
      <td>District</td>
      <td>4761</td>
      <td>3094650</td>
      <td>650.0</td>
      <td>83.418349</td>
      <td>83.848930</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$3094650</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Ford High School</td>
      <td>District</td>
      <td>2739</td>
      <td>1763916</td>
      <td>644.0</td>
      <td>83.274201</td>
      <td>83.989488</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$1763916</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Thomas High School</td>
      <td>Charter</td>
      <td>1635</td>
      <td>1043130</td>
      <td>638.0</td>
      <td>83.682222</td>
      <td>83.955000</td>
      <td>100.000000</td>
      <td>100.0</td>
      <td>100.000000</td>
      <td>\$1043130</td>
    </tr>
  </tbody>
</table>
</div>




```python
##Section 3: Top 5 Performing Schools -- By Passing Rate
#Print ("Top 5 Performing Schools -- By Passing Rate:")
 
schl_summary_df2.nlargest(5, "% Overall Passing Rate")
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>School Type</th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Per Student Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>Figueroa High School</td>
      <td>District</td>
      <td>2949</td>
      <td>1884411</td>
      <td>639.0</td>
      <td>83.061895</td>
      <td>83.975780</td>
      <td>100.0</td>
      <td>100.0</td>
      <td>100.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Griffin High School</td>
      <td>Charter</td>
      <td>1468</td>
      <td>917500</td>
      <td>625.0</td>
      <td>83.351499</td>
      <td>83.816757</td>
      <td>100.0</td>
      <td>100.0</td>
      <td>100.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Cabrera High School</td>
      <td>Charter</td>
      <td>1858</td>
      <td>1081356</td>
      <td>582.0</td>
      <td>83.803279</td>
      <td>83.814988</td>
      <td>100.0</td>
      <td>100.0</td>
      <td>100.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Pena High School</td>
      <td>Charter</td>
      <td>962</td>
      <td>585858</td>
      <td>609.0</td>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>100.0</td>
      <td>100.0</td>
      <td>100.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Rodriguez High School</td>
      <td>District</td>
      <td>3999</td>
      <td>2547363</td>
      <td>637.0</td>
      <td>83.359455</td>
      <td>83.725724</td>
      <td>100.0</td>
      <td>100.0</td>
      <td>100.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
##Section 4: Bottom 5 Performing schools -- By Passing Rate:
 
schl_summary_df2.nsmallest(5, "% Overall Passing Rate")
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>School Type</th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Per Student Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>Shelton High School</td>
      <td>Charter</td>
      <td>1761</td>
      <td>1056600</td>
      <td>600.0</td>
      <td>76.711767</td>
      <td>81.158020</td>
      <td>88.436758</td>
      <td>100.0</td>
      <td>94.218379</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Wright High School</td>
      <td>Charter</td>
      <td>1800</td>
      <td>1049400</td>
      <td>583.0</td>
      <td>76.842711</td>
      <td>80.744686</td>
      <td>88.547137</td>
      <td>100.0</td>
      <td>94.273568</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Bailey High School</td>
      <td>District</td>
      <td>4976</td>
      <td>3124928</td>
      <td>628.0</td>
      <td>76.629414</td>
      <td>81.182722</td>
      <td>88.858416</td>
      <td>100.0</td>
      <td>94.429208</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Wilson High School</td>
      <td>Charter</td>
      <td>2283</td>
      <td>1319574</td>
      <td>578.0</td>
      <td>77.289752</td>
      <td>80.934412</td>
      <td>89.083064</td>
      <td>100.0</td>
      <td>94.541532</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Holden High School</td>
      <td>Charter</td>
      <td>427</td>
      <td>248087</td>
      <td>581.0</td>
      <td>77.072464</td>
      <td>80.966394</td>
      <td>89.182945</td>
      <td>100.0</td>
      <td>94.591472</td>
    </tr>
  </tbody>
</table>
</div>




```python
##Section 5: Math Scores by Grade
stu_by_schl_grade_df = studf.groupby(["school","grade"])
math_by_grade_df = stu_by_schl_grade_df["math_score"].sum()/stu_by_schl_grade_df["Student ID"].count()
math_by_grade_df
```




    school                 grade
    Bailey High School     10th     76.996772
                           11th     77.515588
                           12th     76.492218
                           9th      77.083676
    Cabrera High School    10th     83.154506
                           11th     82.765560
                           12th     83.277487
                           9th      83.094697
    Figueroa High School   10th     76.539974
                           11th     76.884344
                           12th     77.151369
                           9th      76.403037
    Ford High School       10th     77.672316
                           11th     76.918058
                           12th     76.179963
                           9th      77.361345
    Griffin High School    10th     84.229064
                           11th     83.842105
                           12th     83.356164
                           9th      82.044010
    Hernandez High School  10th     77.337408
                           11th     77.136029
                           12th     77.186567
                           9th      77.438495
    Holden High School     10th     83.429825
                           11th     85.000000
                           12th     82.855422
                           9th      83.787402
    Huang High School      10th     75.908735
                           11th     76.446602
                           12th     77.225641
                           9th      77.027251
    Johnson High School    10th     76.691117
                           11th     77.491653
                           12th     76.863248
                           9th      77.187857
    Pena High School       10th     83.372000
                           11th     84.328125
                           12th     84.121547
                           9th      83.625455
    Rodriguez High School  10th     76.612500
                           11th     76.395626
                           12th     77.690748
                           9th      76.859966
    Shelton High School    10th     82.917411
                           11th     83.383495
                           12th     83.778976
                           9th      83.420755
    Thomas High School     10th     83.087886
                           11th     83.498795
                           12th     83.497041
                           9th      83.590022
    Wilson High School     10th     83.724422
                           11th     83.195326
                           12th     83.035794
                           9th      83.085578
    Wright High School     10th     84.010288
                           11th     83.836782
                           12th     83.644986
                           9th      83.264706
    dtype: float64




```python
##Section 6: reading scores by grade
read_by_grade_df = stu_by_schl_grade_df["reading_score"].sum()/stu_by_schl_grade_df["Student ID"].count()
read_by_grade_df
```




    school                 grade
    Bailey High School     10th     80.907183
                           11th     80.945643
                           12th     80.912451
                           9th      81.303155
    Cabrera High School    10th     84.253219
                           11th     83.788382
                           12th     84.287958
                           9th      83.676136
    Figueroa High School   10th     81.408912
                           11th     80.640339
                           12th     81.384863
                           9th      81.198598
    Ford High School       10th     81.262712
                           11th     80.403642
                           12th     80.662338
                           9th      80.632653
    Griffin High School    10th     83.706897
                           11th     84.288089
                           12th     84.013699
                           9th      83.369193
    Hernandez High School  10th     80.660147
                           11th     81.396140
                           12th     80.857143
                           9th      80.866860
    Holden High School     10th     83.324561
                           11th     83.815534
                           12th     84.698795
                           9th      83.677165
    Huang High School      10th     81.512386
                           11th     81.417476
                           12th     80.305983
                           9th      81.290284
    Johnson High School    10th     80.773431
                           11th     80.616027
                           12th     81.227564
                           9th      81.260714
    Pena High School       10th     83.612000
                           11th     84.335938
                           12th     84.591160
                           9th      83.807273
    Rodriguez High School  10th     80.629808
                           11th     80.864811
                           12th     80.376426
                           9th      80.993127
    Shelton High School    10th     83.441964
                           11th     84.373786
                           12th     82.781671
                           9th      84.122642
    Thomas High School     10th     84.254157
                           11th     83.585542
                           12th     83.831361
                           9th      83.728850
    Wilson High School     10th     84.021452
                           11th     83.764608
                           12th     84.317673
                           9th      83.939778
    Wright High School     10th     83.812757
                           11th     84.156322
                           12th     84.073171
                           9th      83.833333
    dtype: float64




```python
##section 7: Scores by School Spending
budget_bins=[0, 585, 615, 645, 675]
bins_labels =["<$585","$585-615","$615-645","$645-675"]

schl_summary_df4 = schl_summary_df2.loc[:, ("school","Average Math Score","Average Reading Score", "% Passing Math", "% Passing Reading", "% Overall Passing Rate","Per Student Budget")]
#schl_summary_df4 = schl_summary_df2[["school","Average Math Score","Average Reading Score", "% Passing Math", "% Passing Reading", "% Overall Passing Rate","Per Student Budget"]]
schl_summary_df4["Spending Ranges (Per Student)"]=pd.cut(schl_summary_df4["Per Student Budget"], budget_bins, labels=bins_labels)
schl_summary_df5=schl_summary_df4.groupby(["Spending Ranges (Per Student)"])

schl_summary_df6=pd.DataFrame()
schl_summary_df6["Average Math Score"] = schl_summary_df5["Average Math Score"].mean()
schl_summary_df6["Average Reading Score"] = schl_summary_df5["Average Reading Score"].mean()
schl_summary_df6["% Passing Math"] = schl_summary_df5["% Passing Math"].mean()
schl_summary_df6["% Passing Reading"] = schl_summary_df5["% Passing Reading"].mean()
schl_summary_df6["% Overall Passing Rate"] = schl_summary_df5["% Overall Passing Rate"].mean()
schl_summary_df6
##Section 7 ends
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>Spending Ranges (Per Student)</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;$585</th>
      <td>78.752051</td>
      <td>81.615120</td>
      <td>91.703286</td>
      <td>100.0</td>
      <td>95.851643</td>
    </tr>
    <tr>
      <th>$585-615</th>
      <td>80.275842</td>
      <td>82.601359</td>
      <td>94.218379</td>
      <td>100.0</td>
      <td>97.109190</td>
    </tr>
    <tr>
      <th>$615-645</th>
      <td>82.226447</td>
      <td>83.440912</td>
      <td>98.143069</td>
      <td>100.0</td>
      <td>99.071535</td>
    </tr>
    <tr>
      <th>$645-675</th>
      <td>79.189791</td>
      <td>81.876383</td>
      <td>92.944136</td>
      <td>100.0</td>
      <td>96.472068</td>
    </tr>
  </tbody>
</table>
</div>




```python
##section 8: Scores by School Size
budget_bins=[0, 1000, 2000, 5000]
bins_labels =["small (<1000)","Medium (1000-2000)","Large (2000-5000)"]

schl_summary_df7 = schl_summary_df2.loc[:, ("school","Average Math Score","Average Reading Score", "% Passing Math", "% Passing Reading", "% Overall Passing Rate","Per Student Budget","Total Students")]
schl_summary_df7["School Size"]=pd.cut(schl_summary_df7["Total Students"], budget_bins, labels=bins_labels)
schl_summary_df8=schl_summary_df7.groupby(["School Size"])

schl_summary_df9=pd.DataFrame()
schl_summary_df9["Average Math Score"] = schl_summary_df8["Average Math Score"].mean()
schl_summary_df9["Average Reading Score"] = schl_summary_df8["Average Reading Score"].mean()
schl_summary_df9["% Passing Math"] = schl_summary_df8["% Passing Math"].mean()
schl_summary_df9["% Passing Reading"] = schl_summary_df8["% Passing Reading"].mean()
schl_summary_df9["% Overall Passing Rate"] = schl_summary_df8["% Overall Passing Rate"].mean()
schl_summary_df9
##Section 8 ends
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>School Size</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>small (&lt;1000)</th>
      <td>80.456190</td>
      <td>82.505546</td>
      <td>94.591472</td>
      <td>100.0</td>
      <td>97.295736</td>
    </tr>
    <tr>
      <th>Medium (1000-2000)</th>
      <td>80.878295</td>
      <td>82.697890</td>
      <td>95.396779</td>
      <td>100.0</td>
      <td>97.698390</td>
    </tr>
    <tr>
      <th>Large (2000-5000)</th>
      <td>80.148011</td>
      <td>82.429660</td>
      <td>94.596736</td>
      <td>100.0</td>
      <td>97.298368</td>
    </tr>
  </tbody>
</table>
</div>




```python
##section 9: Scores by School Type

schl_summary_df10 = schl_summary_df2.loc[:, ("school","Average Math Score","Average Reading Score", "% Passing Math", "% Passing Reading", "% Overall Passing Rate","School Type")]
schl_summary_df11=schl_summary_df10.groupby(["School Type"])

schl_summary_df12=pd.DataFrame()
schl_summary_df12["Average Math Score"] = schl_summary_df11["Average Math Score"].mean()
schl_summary_df12["Average Reading Score"] = schl_summary_df11["Average Reading Score"].mean()
schl_summary_df12["% Passing Math"] = schl_summary_df11["% Passing Math"].mean()
schl_summary_df12["% Passing Reading"] = schl_summary_df11["% Passing Reading"].mean()
schl_summary_df12["% Overall Passing Rate"] = schl_summary_df11["% Overall Passing Rate"].mean()
schl_summary_df12
##Section 9 ends
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>School Type</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Charter</th>
      <td>80.324201</td>
      <td>82.429369</td>
      <td>94.406238</td>
      <td>100.0</td>
      <td>97.203119</td>
    </tr>
    <tr>
      <th>District</th>
      <td>80.556334</td>
      <td>82.643266</td>
      <td>95.384403</td>
      <td>100.0</td>
      <td>97.692202</td>
    </tr>
  </tbody>
</table>
</div>


