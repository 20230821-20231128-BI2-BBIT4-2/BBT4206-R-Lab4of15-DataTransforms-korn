Business Intelligence Project
================
korn
16/10/23

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [LAB 4](#lab-4)
  - [STEP 1. Installation of Packages](#step-1-installation-of-packages)
  - [STEP 2. Loading the Dataset](#step-2-loading-the-dataset)
  - [STEP 3. Applying a Scale Data Transform
    —-](#step-3-applying-a-scale-data-transform--)
  - [STEP 6. Apply a Normalize Data
    Transform](#step-6-apply-a-normalize-data-transform)
  - [STEP 7. Apply a Box-Cox Power
    Transform](#step-7-apply-a-box-cox-power-transform)
  - [STEP 8. Apply a Yeo-Johnson Power
    Transform](#step-8-apply-a-yeo-johnson-power-transform)
  - [STEP 9 PCA Linear Algebra Transform for Dimensionality
    Reduction](#step-9-pca-linear-algebra-transform-for-dimensionality-reduction)
  - [Scree Plot, Biplot and Cos2 Combined
    Plot](#scree-plot-biplot-and-cos2-combined-plot)
  - [ICA for Dimensionality
    Reduction](#ica-for-dimensionality-reduction)

# Student Details

<table>
<colgroup>
<col style="width: 53%" />
<col style="width: 46%" />
</colgroup>
<tbody>
<tr class="odd">
<td><strong>Student ID Numbers and Names of Group Members</strong></td>
<td><ol type="1">
<li><p>134644 - C - Sebastian Muramara</p></li>
<li><p>136675 - C - Bernard Otieno</p></li>
<li><p>131589 - C - Agnes Anyango</p></li>
<li><p>131582 - C - Njeri Njuguna</p></li>
<li><p>136009 - C- Sera Ndabari</p></li>
</ol></td>
</tr>
<tr class="even">
<td><strong>GitHub Classroom Group Name</strong></td>
<td>Korn</td>
</tr>
<tr class="odd">
<td><strong>Course Code</strong></td>
<td>BBT4206</td>
</tr>
<tr class="even">
<td><strong>Course Name</strong></td>
<td>Business Intelligence II</td>
</tr>
<tr class="odd">
<td><strong>Program</strong></td>
<td>Bachelor of Business Information Technology</td>
</tr>
<tr class="even">
<td><strong>Semester Duration</strong></td>
<td>21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023</td>
</tr>
</tbody>
</table>

# Setup Chunk

**Note:** the following KnitR options have been set as the global
defaults: <BR>
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

# LAB 4

## STEP 1. Installation of Packages

``` r
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: languageserver

``` r
# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: mlbench

``` r
## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: readr

``` r
## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: caret

    ## Loading required package: ggplot2

    ## Loading required package: lattice

``` r
## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: e1071

``` r
## factoextra --
if (require("factoextra")) {
  require("factoextra")
} else {
  install.packages("factoextra", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: factoextra

    ## Welcome! Want to learn more? See two factoextra-related books at https://goo.gl/ve3WBa

``` r
## FactoMineR ----
if (require("FactoMineR")) {
  require("FactoMineR")
} else {
  install.packages("FactoMineR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: FactoMineR

## STEP 2. Loading the Dataset

``` r
## STEP 2. Load the Datasets ----
student_performance_dataset <-
  readr::read_csv(
    "../data/20230412-20230719-BI1-BBIT4-1-StudentPerformanceDataset.CSV", # nolint
    col_types =
      readr::cols(
        class_group =
          readr::col_factor(levels = c("A", "B", "C")),
        gender = readr::col_factor(levels = c("1", "0")),
        YOB = readr::col_date(format = "%Y"),
        regret_choosing_bi =
          readr::col_factor(levels = c("1", "0")),
        drop_bi_now =
          readr::col_factor(levels = c("1", "0")),
        motivator =
          readr::col_factor(levels = c("1", "0")),
        read_content_before_lecture =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        anticipate_test_questions =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        answer_rhetorical_questions =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        find_terms_I_do_not_know =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        copy_new_terms_in_reading_notebook =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        take_quizzes_and_use_results =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        reorganise_course_outline =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        write_down_important_points =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        space_out_revision =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        studying_in_study_group =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        schedule_appointments =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        goal_oriented =
          readr::col_factor(levels =
                              c("1", "0")),
        spaced_repetition =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        testing_and_active_recall =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        interleaving =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        categorizing =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        retrospective_timetable =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        cornell_notes =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        sq3r = readr::col_factor(levels =
                                   c("1", "2", "3", "4")),
        commute = readr::col_factor(levels =
                                      c("1", "2",
                                        "3", "4")),
        study_time = readr::col_factor(levels =
                                         c("1", "2",
                                           "3", "4")),
        repeats_since_Y1 = readr::col_integer(),
        paid_tuition = readr::col_factor(levels =
                                           c("0", "1")),
        free_tuition = readr::col_factor(levels =
                                           c("0", "1")),
        extra_curricular = readr::col_factor(levels =
                                               c("0", "1")),
        sports_extra_curricular =
          readr::col_factor(levels = c("0", "1")),
        exercise_per_week = readr::col_factor(levels =
                                                c("0", "1",
                                                  "2",
                                                  "3")),
        meditate = readr::col_factor(levels =
                                       c("0", "1",
                                         "2", "3")),
        pray = readr::col_factor(levels =
                                   c("0", "1",
                                     "2", "3")),
        internet = readr::col_factor(levels =
                                       c("0", "1")),
        laptop = readr::col_factor(levels = c("0", "1")),
        family_relationships =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        friendships = readr::col_factor(levels =
                                          c("1", "2", "3",
                                            "4", "5")),
        romantic_relationships =
          readr::col_factor(levels =
                              c("0", "1", "2", "3", "4")),
        spiritual_wellnes =
          readr::col_factor(levels = c("1", "2", "3",
                                       "4", "5")),
        financial_wellness =
          readr::col_factor(levels = c("1", "2", "3",
                                       "4", "5")),
        health = readr::col_factor(levels = c("1", "2",
                                              "3", "4",
                                              "5")),
        day_out = readr::col_factor(levels = c("0", "1",
                                               "2", "3")),
        night_out = readr::col_factor(levels = c("0",
                                                 "1", "2",
                                                 "3")),
        alcohol_or_narcotics =
          readr::col_factor(levels = c("0", "1", "2", "3")),
        mentor = readr::col_factor(levels = c("0", "1")),
        mentor_meetings = readr::col_factor(levels =
                                              c("0", "1",
                                                "2", "3")),
        `Attendance Waiver Granted: 1 = Yes, 0 = No` =
          readr::col_factor(levels = c("0", "1")),
        GRADE = readr::col_factor(levels =
                                    c("A", "B", "C", "D",
                                      "E"))),
    locale = readr::locale())

View(student_performance_dataset)
```

## STEP 3. Applying a Scale Data Transform —-

``` r
# BEFORE
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1:11        
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00                
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.03                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:4.000                    1st Qu.:4.000                       
    ##  Median :5.000                    Median :5.000                       
    ##  Mean   :4.446                    Mean   :4.634                       
    ##  3rd Qu.:5.000                    3rd Qu.:5.000                       
    ##  Max.   :5.000                    Max.   :5.000                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:4.000                                                                                  
    ##  Median :4.000                                                                                  
    ##  Mean   :4.307                                                                                  
    ##  3rd Qu.:5.000                                                                                  
    ##  Max.   :5.000                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:4.000                                                                                    
    ##  Median :5.000                                                                                    
    ##  Mean   :4.693                                                                                    
    ##  3rd Qu.:5.000                                                                                    
    ##  Max.   :5.000                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:4.000                                      
    ##  Median :5.000                                      
    ##  Mean   :4.604                                      
    ##  3rd Qu.:5.000                                      
    ##  Max.   :5.000                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.000                                    
    ##  Mean   :4.069                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.000                                                     
    ##  Median :4.000                                                     
    ##  Mean   :4.337                                                     
    ##  3rd Qu.:5.000                                                     
    ##  Max.   :5.000                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:4.000                                          
    ##  Median :5.000                                          
    ##  Mean   :4.564                                          
    ##  3rd Qu.:5.000                                          
    ##  Max.   :5.000                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:4.000                     
    ##  Median :5.000                     
    ##  Mean   :4.535                     
    ##  3rd Qu.:5.000                     
    ##  Max.   :5.000                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :5.000                                    
    ##  Mean   :4.505                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:4.000                              
    ##  Median :5.000                              
    ##  Mean   :4.653                              
    ##  3rd Qu.:5.000                              
    ##  Max.   :5.000                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.000                                                                        
    ##  Median :4.000                                                                        
    ##  Mean   :4.208                                                                        
    ##  3rd Qu.:5.000                                                                        
    ##  Max.   :5.000                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.000                                                    
    ##  Median :4.000                                                    
    ##  Mean   :3.901                                                    
    ##  3rd Qu.:5.000                                                    
    ##  Max.   :5.000                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:4.000                            
    ##  Median :5.000                            
    ##  Mean   :4.545                            
    ##  3rd Qu.:5.000                            
    ##  Max.   :5.000                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:4.000                                                      
    ##  Median :5.000                                                      
    ##  Mean   :4.564                                                      
    ##  3rd Qu.:5.000                                                      
    ##  Max.   :5.000                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:4.000                                                                                                      
    ##  Median :5.000                                                                                                      
    ##  Mean   :4.505                                                                                                      
    ##  3rd Qu.:5.000                                                                                                      
    ##  Max.   :5.000                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.000                       
    ##  Median :4.000                       
    ##  Mean   :4.149                       
    ##  3rd Qu.:5.000                       
    ##  Max.   :5.000                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.04                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:4.000                        1st Qu.:4.000         
    ##  Median :4.000                        Median :5.000         
    ##  Mean   :4.129                        Mean   :4.554         
    ##  3rd Qu.:5.000                        3rd Qu.:5.000         
    ##  Max.   :5.000                        Max.   :5.000         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:4.000                                     
    ##  Median :5.000                                     
    ##  Mean   :4.554                                     
    ##  3rd Qu.:5.000                                     
    ##  Max.   :5.000                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:4.000                                                                                                                                                                                                                                                                                
    ##  Median :5.000                                                                                                                                                                                                                                                                                
    ##  Mean   :4.495                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:5.000                                                                                                                                                                                                                                                                                
    ##  Max.   :5.000                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.000                                                                                                                                                                   
    ##  Median :5.000                                                                                                                                                                   
    ##  Mean   :4.446                                                                                                                                                                   
    ##  3rd Qu.:5.000                                                                                                                                                                   
    ##  Max.   :5.000                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.000                           
    ##  Median :5.000                           
    ##  Mean   :4.287                           
    ##  3rd Qu.:5.000                           
    ##  Max.   :5.000                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.486                    Mean   :4.054                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.545                                    
    ##  Mean   :4.388                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.005                  Mean   : 62.39                  
    ##  3rd Qu.:1.000                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 0.000                   
    ##  1st Qu.:11.53                           1st Qu.: 7.000                   
    ##  Median :15.33                           Median : 9.000                   
    ##  Mean   :16.36                           Mean   : 9.342                   
    ##  3rd Qu.:19.63                           3rd Qu.:12.000                   
    ##  Max.   :31.25                           Max.   :15.000                   
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 0.00                         Min.   : 0.000                         
    ##  1st Qu.:10.17                         1st Qu.: 4.330                         
    ##  Median :13.08                         Median : 6.000                         
    ##  Mean   :13.11                         Mean   : 5.611                         
    ##  3rd Qu.:17.50                         3rd Qu.: 7.670                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.752                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:3.000                                                 
    ##  Median :4.850                                                 
    ##  Mean   :3.919                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:4.850                                                  
    ##  Median :4.850                                                  
    ##  Mean   :4.218                                                  
    ##  3rd Qu.:4.850                                                  
    ##  Max.   :5.000                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:2.850                                    
    ##  Median :4.850                                    
    ##  Mean   :3.636                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   : 0.00          Min.   :  0.00         
    ##  1st Qu.:57.89          1st Qu.:  0.00         
    ##  Median :68.42          Median : 52.00         
    ##  Mean   :66.65          Mean   : 43.06         
    ##  3rd Qu.:82.89          3rd Qu.: 68.00         
    ##  Max.   :97.36          Max.   :100.00         
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 0.00   
    ##  1st Qu.:20.44                1st Qu.:25.00   
    ##  Median :24.58                Median :33.00   
    ##  Mean   :24.53                Mean   :32.59   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72

``` r
# The code below converts column number 4 into unlisted and numeric data first
# so that a histogram can be plotted. Further reading:
student_performance_dataset_TOTAL <- as.numeric(unlist(student_performance_dataset[, 99]))
hist(student_performance_dataset_TOTAL, main = names(student_performance_dataset)[99])
```

![](Lab-Submission-Markdown_files/figure-gfm/Scale%20Transform-1.png)<!-- -->

``` r
model_of_the_transform <- preProcess(student_performance_dataset, method = c("scale"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - ignored (51)
    ##   - scaled (49)

``` r
student_performance_data_scale_transform <- predict(model_of_the_transform, student_performance_dataset)

# AFTER
summary(student_performance_data_scale_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :0.0000   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:0.0000   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :0.9482               
    ##  4:18          4:25   4   :28   4   : 4    Mean   :0.9623               
    ##                       NA's: 1   NA's: 1    3rd Qu.:1.4223               
    ##                                            Max.   :4.7409               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:5.396                    1st Qu.:5.934                       
    ##  Median :6.745                    Median :7.417                       
    ##  Mean   :5.997                    Mean   :6.874                       
    ##  3rd Qu.:6.745                    3rd Qu.:7.417                       
    ##  Max.   :6.745                    Max.   :7.417                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:5.101                                                                                  
    ##  Median :5.101                                                                                  
    ##  Mean   :5.493                                                                                  
    ##  3rd Qu.:6.377                                                                                  
    ##  Max.   :6.377                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:6.066                                                                                    
    ##  Median :7.582                                                                                    
    ##  Mean   :7.117                                                                                    
    ##  3rd Qu.:7.582                                                                                    
    ##  Max.   :7.582                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:5.435                                      
    ##  Median :6.794                                      
    ##  Mean   :6.256                                      
    ##  3rd Qu.:6.794                                      
    ##  Max.   :6.794                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.159                                    
    ##  Median :4.159                                    
    ##  Mean   :4.231                                    
    ##  3rd Qu.:5.198                                    
    ##  Max.   :5.198                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.903                                                     
    ##  Median :4.903                                                     
    ##  Mean   :5.316                                                     
    ##  3rd Qu.:6.129                                                     
    ##  Max.   :6.129                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:5.046                                          
    ##  Median :6.308                                          
    ##  Mean   :5.758                                          
    ##  3rd Qu.:6.308                                          
    ##  Max.   :6.308                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:5.594                     
    ##  Median :6.993                     
    ##  Mean   :6.342                     
    ##  3rd Qu.:6.993                     
    ##  Max.   :6.993                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:5.197                                    
    ##  Median :6.496                                    
    ##  Mean   :5.853                                    
    ##  3rd Qu.:6.496                                    
    ##  Max.   :6.496                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:5.722                              
    ##  Median :7.152                              
    ##  Mean   :6.657                              
    ##  3rd Qu.:7.152                              
    ##  Max.   :7.152                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.511                                                                        
    ##  Median :4.511                                                                        
    ##  Mean   :4.745                                                                        
    ##  3rd Qu.:5.639                                                                        
    ##  Max.   :5.639                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.180                                                    
    ##  Median :4.240                                                    
    ##  Mean   :4.135                                                    
    ##  3rd Qu.:5.300                                                    
    ##  Max.   :5.300                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:5.205                            
    ##  Median :6.507                            
    ##  Mean   :5.914                            
    ##  3rd Qu.:6.507                            
    ##  Max.   :6.507                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:5.306                                                      
    ##  Median :6.632                                                      
    ##  Mean   :6.055                                                      
    ##  3rd Qu.:6.632                                                      
    ##  Max.   :6.632                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:5.287                                                                                                      
    ##  Median :6.608                                                                                                      
    ##  Mean   :5.954                                                                                                      
    ##  3rd Qu.:6.608                                                                                                      
    ##  Max.   :6.608                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.109                       
    ##  Median :4.109                       
    ##  Mean   :4.261                       
    ##  3rd Qu.:5.136                       
    ##  Max.   :5.136                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.000                             
    ##  1st Qu.:3.749                             
    ##  Median :3.749                             
    ##  Mean   :3.786                             
    ##  3rd Qu.:4.686                             
    ##  Max.   :4.686                             
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:3.826                        1st Qu.:4.683         
    ##  Median :3.826                        Median :5.854         
    ##  Mean   :3.949                        Mean   :5.332         
    ##  3rd Qu.:4.782                        3rd Qu.:5.854         
    ##  Max.   :4.782                        Max.   :5.854         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:5.124                                     
    ##  Median :6.404                                     
    ##  Mean   :5.834                                     
    ##  3rd Qu.:6.404                                     
    ##  Max.   :6.404                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:5.030                                                                                                                                                                                                                                                                                
    ##  Median :6.287                                                                                                                                                                                                                                                                                
    ##  Mean   :5.652                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:6.287                                                                                                                                                                                                                                                                                
    ##  Max.   :6.287                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.889                                                                                                                                                                   
    ##  Median :6.111                                                                                                                                                                   
    ##  Mean   :5.433                                                                                                                                                                   
    ##  3rd Qu.:6.111                                                                                                                                                                   
    ##  Max.   :6.111                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.201                           
    ##  Median :5.251                           
    ##  Mean   :4.502                           
    ##  3rd Qu.:5.251                           
    ##  Max.   :5.251                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:7.102                    1st Qu.:4.310                            
    ##  Median :7.556                    Median :4.926                            
    ##  Mean   :7.457                    Mean   :4.993                            
    ##  3rd Qu.:8.160                    3rd Qu.:5.541                            
    ##  Max.   :8.311                    Max.   :6.157                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:5.981                                    
    ##  Median :6.797                                    
    ##  Mean   :6.561                                    
    ##  3rd Qu.:7.340                                    
    ##  Max.   :7.476                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :0.000                    Min.   :0.000                    
    ##  1st Qu.:3.521                    1st Qu.:2.151                    
    ##  Median :4.044                    Median :2.797                    
    ##  Mean   :3.811                    Mean   :2.360                    
    ##  3rd Qu.:4.282                    3rd Qu.:2.976                    
    ##  Max.   :4.758                    Max.   :3.585                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.0000                 Min.   :0.000                   
    ##  1st Qu.:0.0000                 1st Qu.:2.779                   
    ##  Median :0.0000                 Median :3.295                   
    ##  Mean   :0.5646                 Mean   :3.096                   
    ##  3rd Qu.:0.5618                 3rd Qu.:3.553                   
    ##  Max.   :2.8089                 Max.   :4.962                   
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :0.7302                          Min.   :0.000                    
    ##  1st Qu.:1.7724                          1st Qu.:2.089                    
    ##  Median :2.3565                          Median :2.686                    
    ##  Mean   :2.5144                          Mean   :2.788                    
    ##  3rd Qu.:3.0175                          3rd Qu.:3.581                    
    ##  Max.   :4.8038                          Max.   :4.476                    
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :0.000                         Min.   :0.000                          
    ##  1st Qu.:1.875                         1st Qu.:1.515                          
    ##  Median :2.411                         Median :2.099                          
    ##  Mean   :2.416                         Mean   :1.963                          
    ##  3rd Qu.:3.226                         3rd Qu.:2.684                          
    ##  Max.   :4.056                         Max.   :4.433                          
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :1.592                                  
    ##  1st Qu.:2.657                                  
    ##  Median :3.353                                  
    ##  Mean   :3.408                                  
    ##  3rd Qu.:3.951                                  
    ##  Max.   :5.775                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.429                                
    ##  Median :5.429                                
    ##  Mean   :5.160                                
    ##  3rd Qu.:5.429                                
    ##  Max.   :5.429                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:2.129                                                 
    ##  Median :3.441                                                 
    ##  Mean   :2.781                                                 
    ##  3rd Qu.:3.548                                                 
    ##  Max.   :3.548                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:3.322                                                  
    ##  Median :3.322                                                  
    ##  Mean   :2.889                                                  
    ##  3rd Qu.:3.322                                                  
    ##  Max.   :3.425                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:1.510                                    
    ##  Median :2.570                                    
    ##  Mean   :1.927                                    
    ##  3rd Qu.:2.650                                    
    ##  Max.   :2.650                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   :0.9221          
    ##  1st Qu.:0.000                        1st Qu.:3.6678          
    ##  Median :2.143                        Median :4.1444          
    ##  Mean   :1.459                        Mean   :4.1297          
    ##  3rd Qu.:2.143                        3rd Qu.:5.0355          
    ##  Max.   :2.143                        Max.   :5.1805          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :0.000          Min.   :0.000          
    ##  1st Qu.:2.878          1st Qu.:0.000          
    ##  Median :3.402          Median :1.471          
    ##  Mean   :3.313          Mean   :1.218          
    ##  3rd Qu.:4.121          3rd Qu.:1.924          
    ##  Max.   :4.840          Max.   :2.829          
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :0.0000        
    ##  1: 5                                       1st Qu.:0.8153        
    ##                                             Median :1.6295        
    ##                                             Mean   :1.6961        
    ##                                             3rd Qu.:2.4448        
    ##                                             Max.   :5.7049        
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   :1.200                Min.   :0.000   
    ##  1st Qu.:3.284                1st Qu.:1.941   
    ##  Median :3.949                Median :2.562   
    ##  Mean   :3.941                Mean   :2.530   
    ##  3rd Qu.:4.709                3rd Qu.:3.261   
    ##  Max.   :5.636                Max.   :4.347   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :0.475                          A:23  
    ##  1st Qu.:2.896                          B:25  
    ##  Median :3.732                          C:22  
    ##  Mean   :3.632                          D:25  
    ##  3rd Qu.:4.377                          E: 6  
    ##  Max.   :5.578

``` r
student_performance_dataset_TOTAL <- as.numeric(unlist(student_performance_data_scale_transform[, 99]))
hist(student_performance_dataset_TOTAL, main = names(student_performance_data_scale_transform)[99])
```

![](Lab-Submission-Markdown_files/figure-gfm/Scale%20Transform-2.png)<!-- -->
\## STEP 4. Apply a Centre Data Transform —-

``` r
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1:11        
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00                
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.03                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:4.000                    1st Qu.:4.000                       
    ##  Median :5.000                    Median :5.000                       
    ##  Mean   :4.446                    Mean   :4.634                       
    ##  3rd Qu.:5.000                    3rd Qu.:5.000                       
    ##  Max.   :5.000                    Max.   :5.000                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:4.000                                                                                  
    ##  Median :4.000                                                                                  
    ##  Mean   :4.307                                                                                  
    ##  3rd Qu.:5.000                                                                                  
    ##  Max.   :5.000                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:4.000                                                                                    
    ##  Median :5.000                                                                                    
    ##  Mean   :4.693                                                                                    
    ##  3rd Qu.:5.000                                                                                    
    ##  Max.   :5.000                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:4.000                                      
    ##  Median :5.000                                      
    ##  Mean   :4.604                                      
    ##  3rd Qu.:5.000                                      
    ##  Max.   :5.000                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.000                                    
    ##  Mean   :4.069                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.000                                                     
    ##  Median :4.000                                                     
    ##  Mean   :4.337                                                     
    ##  3rd Qu.:5.000                                                     
    ##  Max.   :5.000                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:4.000                                          
    ##  Median :5.000                                          
    ##  Mean   :4.564                                          
    ##  3rd Qu.:5.000                                          
    ##  Max.   :5.000                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:4.000                     
    ##  Median :5.000                     
    ##  Mean   :4.535                     
    ##  3rd Qu.:5.000                     
    ##  Max.   :5.000                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :5.000                                    
    ##  Mean   :4.505                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:4.000                              
    ##  Median :5.000                              
    ##  Mean   :4.653                              
    ##  3rd Qu.:5.000                              
    ##  Max.   :5.000                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.000                                                                        
    ##  Median :4.000                                                                        
    ##  Mean   :4.208                                                                        
    ##  3rd Qu.:5.000                                                                        
    ##  Max.   :5.000                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.000                                                    
    ##  Median :4.000                                                    
    ##  Mean   :3.901                                                    
    ##  3rd Qu.:5.000                                                    
    ##  Max.   :5.000                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:4.000                            
    ##  Median :5.000                            
    ##  Mean   :4.545                            
    ##  3rd Qu.:5.000                            
    ##  Max.   :5.000                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:4.000                                                      
    ##  Median :5.000                                                      
    ##  Mean   :4.564                                                      
    ##  3rd Qu.:5.000                                                      
    ##  Max.   :5.000                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:4.000                                                                                                      
    ##  Median :5.000                                                                                                      
    ##  Mean   :4.505                                                                                                      
    ##  3rd Qu.:5.000                                                                                                      
    ##  Max.   :5.000                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.000                       
    ##  Median :4.000                       
    ##  Mean   :4.149                       
    ##  3rd Qu.:5.000                       
    ##  Max.   :5.000                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.04                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:4.000                        1st Qu.:4.000         
    ##  Median :4.000                        Median :5.000         
    ##  Mean   :4.129                        Mean   :4.554         
    ##  3rd Qu.:5.000                        3rd Qu.:5.000         
    ##  Max.   :5.000                        Max.   :5.000         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:4.000                                     
    ##  Median :5.000                                     
    ##  Mean   :4.554                                     
    ##  3rd Qu.:5.000                                     
    ##  Max.   :5.000                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:4.000                                                                                                                                                                                                                                                                                
    ##  Median :5.000                                                                                                                                                                                                                                                                                
    ##  Mean   :4.495                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:5.000                                                                                                                                                                                                                                                                                
    ##  Max.   :5.000                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.000                                                                                                                                                                   
    ##  Median :5.000                                                                                                                                                                   
    ##  Mean   :4.446                                                                                                                                                                   
    ##  3rd Qu.:5.000                                                                                                                                                                   
    ##  Max.   :5.000                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.000                           
    ##  Median :5.000                           
    ##  Mean   :4.287                           
    ##  3rd Qu.:5.000                           
    ##  Max.   :5.000                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.486                    Mean   :4.054                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.545                                    
    ##  Mean   :4.388                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.005                  Mean   : 62.39                  
    ##  3rd Qu.:1.000                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 0.000                   
    ##  1st Qu.:11.53                           1st Qu.: 7.000                   
    ##  Median :15.33                           Median : 9.000                   
    ##  Mean   :16.36                           Mean   : 9.342                   
    ##  3rd Qu.:19.63                           3rd Qu.:12.000                   
    ##  Max.   :31.25                           Max.   :15.000                   
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 0.00                         Min.   : 0.000                         
    ##  1st Qu.:10.17                         1st Qu.: 4.330                         
    ##  Median :13.08                         Median : 6.000                         
    ##  Mean   :13.11                         Mean   : 5.611                         
    ##  3rd Qu.:17.50                         3rd Qu.: 7.670                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.752                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:3.000                                                 
    ##  Median :4.850                                                 
    ##  Mean   :3.919                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:4.850                                                  
    ##  Median :4.850                                                  
    ##  Mean   :4.218                                                  
    ##  3rd Qu.:4.850                                                  
    ##  Max.   :5.000                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:2.850                                    
    ##  Median :4.850                                    
    ##  Mean   :3.636                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   : 0.00          Min.   :  0.00         
    ##  1st Qu.:57.89          1st Qu.:  0.00         
    ##  Median :68.42          Median : 52.00         
    ##  Mean   :66.65          Mean   : 43.06         
    ##  3rd Qu.:82.89          3rd Qu.: 68.00         
    ##  Max.   :97.36          Max.   :100.00         
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 0.00   
    ##  1st Qu.:20.44                1st Qu.:25.00   
    ##  Median :24.58                Median :33.00   
    ##  Mean   :24.53                Mean   :32.59   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72

``` r
model_of_the_transform <- preProcess(student_performance_dataset, method = c("center"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - ignored (51)

``` r
student_performance_data_center_transform <- predict(model_of_the_transform, student_performance_dataset)
summary(student_performance_data_center_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1  paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-2.0297   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-2.0297   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :-0.0297               
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.0000               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.9703               
    ##                                            Max.   : 7.9703               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-4.4455                  Min.   :-4.6337                     
    ##  1st Qu.:-0.4455                  1st Qu.:-0.6337                     
    ##  Median : 0.5545                  Median : 0.3663                     
    ##  Mean   : 0.0000                  Mean   : 0.0000                     
    ##  3rd Qu.: 0.5545                  3rd Qu.: 0.3663                     
    ##  Max.   : 0.5545                  Max.   : 0.3663                     
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-4.3069                                                                                
    ##  1st Qu.:-0.3069                                                                                
    ##  Median :-0.3069                                                                                
    ##  Mean   : 0.0000                                                                                
    ##  3rd Qu.: 0.6931                                                                                
    ##  Max.   : 0.6931                                                                                
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-4.6931                                                                                  
    ##  1st Qu.:-0.6931                                                                                  
    ##  Median : 0.3069                                                                                  
    ##  Mean   : 0.0000                                                                                  
    ##  3rd Qu.: 0.3069                                                                                  
    ##  Max.   : 0.3069                                                                                  
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-4.604                                     
    ##  1st Qu.:-0.604                                     
    ##  Median : 0.396                                     
    ##  Mean   : 0.000                                     
    ##  3rd Qu.: 0.396                                     
    ##  Max.   : 0.396                                     
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-4.06931                                 
    ##  1st Qu.:-0.06931                                 
    ##  Median :-0.06931                                 
    ##  Mean   : 0.00000                                 
    ##  3rd Qu.: 0.93069                                 
    ##  Max.   : 0.93069                                 
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-4.3366                                                   
    ##  1st Qu.:-0.3366                                                   
    ##  Median :-0.3366                                                   
    ##  Mean   : 0.0000                                                   
    ##  3rd Qu.: 0.6634                                                   
    ##  Max.   : 0.6634                                                   
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-4.5644                                        
    ##  1st Qu.:-0.5644                                        
    ##  Median : 0.4356                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.4356                                        
    ##  Max.   : 0.4356                                        
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-4.5347                   
    ##  1st Qu.:-0.5347                   
    ##  Median : 0.4653                   
    ##  Mean   : 0.0000                   
    ##  3rd Qu.: 0.4653                   
    ##  Max.   : 0.4653                   
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-4.505                                   
    ##  1st Qu.:-0.505                                   
    ##  Median : 0.495                                   
    ##  Mean   : 0.000                                   
    ##  3rd Qu.: 0.495                                   
    ##  Max.   : 0.495                                   
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-4.6535                            
    ##  1st Qu.:-0.6535                            
    ##  Median : 0.3465                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.3465                            
    ##  Max.   : 0.3465                            
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-4.2079                                                                      
    ##  1st Qu.:-0.2079                                                                      
    ##  Median :-0.2079                                                                      
    ##  Mean   : 0.0000                                                                      
    ##  3rd Qu.: 0.7921                                                                      
    ##  Max.   : 0.7921                                                                      
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-3.90099                                                 
    ##  1st Qu.:-0.90099                                                 
    ##  Median : 0.09901                                                 
    ##  Mean   : 0.00000                                                 
    ##  3rd Qu.: 1.09901                                                 
    ##  Max.   : 1.09901                                                 
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-4.5446                          
    ##  1st Qu.:-0.5446                          
    ##  Median : 0.4554                          
    ##  Mean   : 0.0000                          
    ##  3rd Qu.: 0.4554                          
    ##  Max.   : 0.4554                          
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-4.5644                                                    
    ##  1st Qu.:-0.5644                                                    
    ##  Median : 0.4356                                                    
    ##  Mean   : 0.0000                                                    
    ##  3rd Qu.: 0.4356                                                    
    ##  Max.   : 0.4356                                                    
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-4.505                                                                                                     
    ##  1st Qu.:-0.505                                                                                                     
    ##  Median : 0.495                                                                                                     
    ##  Mean   : 0.000                                                                                                     
    ##  3rd Qu.: 0.495                                                                                                     
    ##  Max.   : 0.495                                                                                                     
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-4.1485                     
    ##  1st Qu.:-0.1485                     
    ##  Median :-0.1485                     
    ##  Mean   : 0.0000                     
    ##  3rd Qu.: 0.8515                     
    ##  Max.   : 0.8515                     
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-4.0396                           
    ##  1st Qu.:-0.0396                           
    ##  Median :-0.0396                           
    ##  Mean   : 0.0000                           
    ##  3rd Qu.: 0.9604                           
    ##  Max.   : 0.9604                           
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-4.1287                      Min.   :-4.5545       
    ##  1st Qu.:-0.1287                      1st Qu.:-0.5545       
    ##  Median :-0.1287                      Median : 0.4455       
    ##  Mean   : 0.0000                      Mean   : 0.0000       
    ##  3rd Qu.: 0.8713                      3rd Qu.: 0.4455       
    ##  Max.   : 0.8713                      Max.   : 0.4455       
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-4.5545                                   
    ##  1st Qu.:-0.5545                                   
    ##  Median : 0.4455                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.4455                                   
    ##  Max.   : 0.4455                                   
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-4.495                                                                                                                                                                                                                                                                               
    ##  1st Qu.:-0.495                                                                                                                                                                                                                                                                               
    ##  Median : 0.505                                                                                                                                                                                                                                                                               
    ##  Mean   : 0.000                                                                                                                                                                                                                                                                               
    ##  3rd Qu.: 0.505                                                                                                                                                                                                                                                                               
    ##  Max.   : 0.505                                                                                                                                                                                                                                                                               
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-4.4455                                                                                                                                                                 
    ##  1st Qu.:-0.4455                                                                                                                                                                 
    ##  Median : 0.5545                                                                                                                                                                 
    ##  Mean   : 0.0000                                                                                                                                                                 
    ##  3rd Qu.: 0.5545                                                                                                                                                                 
    ##  Max.   : 0.5545                                                                                                                                                                 
    ##  C - 12. The recordings of online classes
    ##  Min.   :-4.2871                         
    ##  1st Qu.:-0.2871                         
    ##  Median : 0.7129                         
    ##  Mean   : 0.0000                         
    ##  3rd Qu.: 0.7129                         
    ##  Max.   : 0.7129                         
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-4.48605                 Min.   :-4.05445                         
    ##  1st Qu.:-0.21335                 1st Qu.:-0.55446                         
    ##  Median : 0.05945                 Median :-0.05446                         
    ##  Mean   : 0.00000                 Mean   : 0.00000                         
    ##  3rd Qu.: 0.42305                 3rd Qu.: 0.44555                         
    ##  Max.   : 0.51395                 Max.   : 0.94554                         
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-4.3879                                  
    ##  1st Qu.:-0.3879                                  
    ##  Median : 0.1576                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.5212                                  
    ##  Max.   : 0.6121                                  
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-8.0109                  Min.   :-6.5822                  
    ##  1st Qu.:-0.6109                  1st Qu.:-0.5822                  
    ##  Median : 0.4891                  Median : 1.2178                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.9891                  3rd Qu.: 1.7178                  
    ##  Max.   : 1.9891                  Max.   : 3.4178                  
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-1.00495               Min.   :-62.392                 
    ##  1st Qu.:-1.00495               1st Qu.: -6.392                 
    ##  Median :-1.00495               Median :  4.008                 
    ##  Mean   : 0.00000               Mean   :  0.000                 
    ##  3rd Qu.:-0.00495               3rd Qu.:  9.208                 
    ##  Max.   : 3.99505               Max.   : 37.608                 
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-11.607                         Min.   :-9.3416                  
    ##  1st Qu.: -4.827                         1st Qu.:-2.3416                  
    ##  Median : -1.027                         Median :-0.3416                  
    ##  Mean   :  0.000                         Mean   : 0.0000                  
    ##  3rd Qu.:  3.273                         3rd Qu.: 2.6584                  
    ##  Max.   : 14.893                         Max.   : 5.6584                  
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-13.10782                     Min.   :-5.6109                        
    ##  1st Qu.: -2.93782                     1st Qu.:-1.2809                        
    ##  Median : -0.02782                     Median : 0.3891                        
    ##  Mean   :  0.00000                     Mean   : 0.0000                        
    ##  3rd Qu.:  4.39218                     3rd Qu.: 2.0591                        
    ##  Max.   :  8.89218                     Max.   : 7.0591                        
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-29.9592                               
    ##  1st Qu.:-12.3992                               
    ##  Median : -0.9092                               
    ##  Mean   :  0.0000                               
    ##  3rd Qu.:  8.9408                               
    ##  Max.   : 39.0308                               
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-4.7525                              
    ##  1st Qu.: 0.2475                              
    ##  Median : 0.2475                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2475                              
    ##  Max.   : 0.2475                              
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-3.9188                                               
    ##  1st Qu.:-0.9188                                               
    ##  Median : 0.9312                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 1.0812                                               
    ##  Max.   : 1.0812                                               
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-4.2176                                                
    ##  1st Qu.: 0.6324                                                
    ##  Median : 0.6324                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.6324                                                
    ##  Max.   : 0.7824                                                
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-3.6361                                  
    ##  1st Qu.:-0.7861                                  
    ##  Median : 1.2139                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 1.3639                                  
    ##  Max.   : 1.3639                                  
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-3.404                       Min.   :-61.916         
    ##  1st Qu.:-3.404                       1st Qu.: -8.916         
    ##  Median : 1.596                       Median :  0.284         
    ##  Mean   : 0.000                       Mean   :  0.000         
    ##  3rd Qu.: 1.596                       3rd Qu.: 17.484         
    ##  Max.   : 1.596                       Max.   : 20.284         
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-66.645        Min.   :-43.059        
    ##  1st Qu.: -8.755        1st Qu.:-43.059        
    ##  Median :  1.775        Median :  8.941        
    ##  Mean   :  0.000        Mean   :  0.000        
    ##  3rd Qu.: 16.245        3rd Qu.: 24.941        
    ##  Max.   : 30.715        Max.   : 56.941        
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-15.4155      
    ##  1: 5                                       1st Qu.: -8.0055      
    ##                                             Median : -0.6055      
    ##                                             Mean   :  0.0000      
    ##                                             3rd Qu.:  6.8045      
    ##                                             Max.   : 36.4345      
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)  
    ##  Min.   :-17.05604            Min.   :-32.5941  
    ##  1st Qu.: -4.08604            1st Qu.: -7.5941  
    ##  Median :  0.05396            Median :  0.4059  
    ##  Mean   :  0.00000            Mean   :  0.0000  
    ##  3rd Qu.:  4.78396            3rd Qu.:  9.4059  
    ##  Max.   : 10.55396            Max.   : 23.4059  
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-49.65                         A:23  
    ##  1st Qu.:-11.58                         B:25  
    ##  Median :  1.57                         C:22  
    ##  Mean   :  0.00                         D:25  
    ##  3rd Qu.: 11.71                         E: 6  
    ##  Max.   : 30.60

\##STEP 5. Applying a Standardize Data Transform

``` r
## STEP 5. Apply a Standardize Data Transform ----
# BEFORE
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1:11        
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00                
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.03                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:4.000                    1st Qu.:4.000                       
    ##  Median :5.000                    Median :5.000                       
    ##  Mean   :4.446                    Mean   :4.634                       
    ##  3rd Qu.:5.000                    3rd Qu.:5.000                       
    ##  Max.   :5.000                    Max.   :5.000                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:4.000                                                                                  
    ##  Median :4.000                                                                                  
    ##  Mean   :4.307                                                                                  
    ##  3rd Qu.:5.000                                                                                  
    ##  Max.   :5.000                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:4.000                                                                                    
    ##  Median :5.000                                                                                    
    ##  Mean   :4.693                                                                                    
    ##  3rd Qu.:5.000                                                                                    
    ##  Max.   :5.000                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:4.000                                      
    ##  Median :5.000                                      
    ##  Mean   :4.604                                      
    ##  3rd Qu.:5.000                                      
    ##  Max.   :5.000                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.000                                    
    ##  Mean   :4.069                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.000                                                     
    ##  Median :4.000                                                     
    ##  Mean   :4.337                                                     
    ##  3rd Qu.:5.000                                                     
    ##  Max.   :5.000                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:4.000                                          
    ##  Median :5.000                                          
    ##  Mean   :4.564                                          
    ##  3rd Qu.:5.000                                          
    ##  Max.   :5.000                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:4.000                     
    ##  Median :5.000                     
    ##  Mean   :4.535                     
    ##  3rd Qu.:5.000                     
    ##  Max.   :5.000                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :5.000                                    
    ##  Mean   :4.505                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:4.000                              
    ##  Median :5.000                              
    ##  Mean   :4.653                              
    ##  3rd Qu.:5.000                              
    ##  Max.   :5.000                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.000                                                                        
    ##  Median :4.000                                                                        
    ##  Mean   :4.208                                                                        
    ##  3rd Qu.:5.000                                                                        
    ##  Max.   :5.000                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.000                                                    
    ##  Median :4.000                                                    
    ##  Mean   :3.901                                                    
    ##  3rd Qu.:5.000                                                    
    ##  Max.   :5.000                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:4.000                            
    ##  Median :5.000                            
    ##  Mean   :4.545                            
    ##  3rd Qu.:5.000                            
    ##  Max.   :5.000                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:4.000                                                      
    ##  Median :5.000                                                      
    ##  Mean   :4.564                                                      
    ##  3rd Qu.:5.000                                                      
    ##  Max.   :5.000                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:4.000                                                                                                      
    ##  Median :5.000                                                                                                      
    ##  Mean   :4.505                                                                                                      
    ##  3rd Qu.:5.000                                                                                                      
    ##  Max.   :5.000                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.000                       
    ##  Median :4.000                       
    ##  Mean   :4.149                       
    ##  3rd Qu.:5.000                       
    ##  Max.   :5.000                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.04                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:4.000                        1st Qu.:4.000         
    ##  Median :4.000                        Median :5.000         
    ##  Mean   :4.129                        Mean   :4.554         
    ##  3rd Qu.:5.000                        3rd Qu.:5.000         
    ##  Max.   :5.000                        Max.   :5.000         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:4.000                                     
    ##  Median :5.000                                     
    ##  Mean   :4.554                                     
    ##  3rd Qu.:5.000                                     
    ##  Max.   :5.000                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:4.000                                                                                                                                                                                                                                                                                
    ##  Median :5.000                                                                                                                                                                                                                                                                                
    ##  Mean   :4.495                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:5.000                                                                                                                                                                                                                                                                                
    ##  Max.   :5.000                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.000                                                                                                                                                                   
    ##  Median :5.000                                                                                                                                                                   
    ##  Mean   :4.446                                                                                                                                                                   
    ##  3rd Qu.:5.000                                                                                                                                                                   
    ##  Max.   :5.000                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.000                           
    ##  Median :5.000                           
    ##  Mean   :4.287                           
    ##  3rd Qu.:5.000                           
    ##  Max.   :5.000                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.486                    Mean   :4.054                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.545                                    
    ##  Mean   :4.388                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.005                  Mean   : 62.39                  
    ##  3rd Qu.:1.000                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 0.000                   
    ##  1st Qu.:11.53                           1st Qu.: 7.000                   
    ##  Median :15.33                           Median : 9.000                   
    ##  Mean   :16.36                           Mean   : 9.342                   
    ##  3rd Qu.:19.63                           3rd Qu.:12.000                   
    ##  Max.   :31.25                           Max.   :15.000                   
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 0.00                         Min.   : 0.000                         
    ##  1st Qu.:10.17                         1st Qu.: 4.330                         
    ##  Median :13.08                         Median : 6.000                         
    ##  Mean   :13.11                         Mean   : 5.611                         
    ##  3rd Qu.:17.50                         3rd Qu.: 7.670                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.752                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:3.000                                                 
    ##  Median :4.850                                                 
    ##  Mean   :3.919                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:4.850                                                  
    ##  Median :4.850                                                  
    ##  Mean   :4.218                                                  
    ##  3rd Qu.:4.850                                                  
    ##  Max.   :5.000                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:2.850                                    
    ##  Median :4.850                                    
    ##  Mean   :3.636                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   : 0.00          Min.   :  0.00         
    ##  1st Qu.:57.89          1st Qu.:  0.00         
    ##  Median :68.42          Median : 52.00         
    ##  Mean   :66.65          Mean   : 43.06         
    ##  3rd Qu.:82.89          3rd Qu.: 68.00         
    ##  Max.   :97.36          Max.   :100.00         
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 0.00   
    ##  1st Qu.:20.44                1st Qu.:25.00   
    ##  Median :24.58                Median :33.00   
    ##  Mean   :24.53                Mean   :32.59   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72

## STEP 6. Apply a Normalize Data Transform

``` r
sapply(student_performance_dataset[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                               15.72533

``` r
model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - ignored (51)
    ##   - scaled (49)

``` r
student_perfromance_data_standardize_transform <- predict(model_of_the_transform, student_performance_dataset) # nolint

# AFTER
summary(student_perfromance_data_standardize_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1   paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-0.96227   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-0.96227   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :-0.01408               
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.00000               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.46001               
    ##                                            Max.   : 3.77866               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-5.997                   Min.   :-6.8735                     
    ##  1st Qu.:-0.601                   1st Qu.:-0.9400                     
    ##  Median : 0.748                   Median : 0.5434                     
    ##  Mean   : 0.000                   Mean   : 0.0000                     
    ##  3rd Qu.: 0.748                   3rd Qu.: 0.5434                     
    ##  Max.   : 0.748                   Max.   : 0.5434                     
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-5.4927                                                                                
    ##  1st Qu.:-0.3914                                                                                
    ##  Median :-0.3914                                                                                
    ##  Mean   : 0.0000                                                                                
    ##  3rd Qu.: 0.8839                                                                                
    ##  Max.   : 0.8839                                                                                
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-7.1168                                                                                  
    ##  1st Qu.:-1.0510                                                                                  
    ##  Median : 0.4654                                                                                  
    ##  Mean   : 0.0000                                                                                  
    ##  3rd Qu.: 0.4654                                                                                  
    ##  Max.   : 0.4654                                                                                  
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-6.2560                                    
    ##  1st Qu.:-0.8207                                    
    ##  Median : 0.5382                                    
    ##  Mean   : 0.0000                                    
    ##  3rd Qu.: 0.5382                                    
    ##  Max.   : 0.5382                                    
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-4.23072                                 
    ##  1st Qu.:-0.07206                                 
    ##  Median :-0.07206                                 
    ##  Mean   : 0.00000                                 
    ##  3rd Qu.: 0.96761                                 
    ##  Max.   : 0.96761                                 
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-5.3157                                                   
    ##  1st Qu.:-0.4126                                                   
    ##  Median :-0.4126                                                   
    ##  Mean   : 0.0000                                                   
    ##  3rd Qu.: 0.8131                                                   
    ##  Max.   : 0.8131                                                   
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-5.7582                                        
    ##  1st Qu.:-0.7120                                        
    ##  Median : 0.5496                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.5496                                        
    ##  Max.   : 0.5496                                        
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-6.3418                   
    ##  1st Qu.:-0.7477                   
    ##  Median : 0.6508                   
    ##  Mean   : 0.0000                   
    ##  3rd Qu.: 0.6508                   
    ##  Max.   : 0.6508                   
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-5.8527                                  
    ##  1st Qu.:-0.6560                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.6432                                  
    ##  Max.   : 0.6432                                  
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-6.6566                            
    ##  1st Qu.:-0.9347                            
    ##  Median : 0.4957                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.4957                            
    ##  Max.   : 0.4957                            
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-4.7453                                                                      
    ##  1st Qu.:-0.2345                                                                      
    ##  Median :-0.2345                                                                      
    ##  Mean   : 0.0000                                                                      
    ##  3rd Qu.: 0.8932                                                                      
    ##  Max.   : 0.8932                                                                      
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-4.1348                                                  
    ##  1st Qu.:-0.9550                                                  
    ##  Median : 0.1049                                                  
    ##  Mean   : 0.0000                                                  
    ##  3rd Qu.: 1.1649                                                  
    ##  Max.   : 1.1649                                                  
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-5.9140                          
    ##  1st Qu.:-0.7087                          
    ##  Median : 0.5927                          
    ##  Mean   : 0.0000                          
    ##  3rd Qu.: 0.5927                          
    ##  Max.   : 0.5927                          
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-6.0546                                                    
    ##  1st Qu.:-0.7486                                                    
    ##  Median : 0.5779                                                    
    ##  Mean   : 0.0000                                                    
    ##  3rd Qu.: 0.5779                                                    
    ##  Max.   : 0.5779                                                    
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-5.9540                                                                                                    
    ##  1st Qu.:-0.6674                                                                                                    
    ##  Median : 0.6543                                                                                                    
    ##  Mean   : 0.0000                                                                                                    
    ##  3rd Qu.: 0.6543                                                                                                    
    ##  Max.   : 0.6543                                                                                                    
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-4.2614                     
    ##  1st Qu.:-0.1526                     
    ##  Median :-0.1526                     
    ##  Mean   : 0.0000                     
    ##  3rd Qu.: 0.8747                     
    ##  Max.   : 0.8747                     
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-3.78607                          
    ##  1st Qu.:-0.03712                          
    ##  Median :-0.03712                          
    ##  Mean   : 0.00000                          
    ##  3rd Qu.: 0.90012                          
    ##  Max.   : 0.90012                          
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-3.9487                      Min.   :-5.3324       
    ##  1st Qu.:-0.1231                      1st Qu.:-0.6492       
    ##  Median :-0.1231                      Median : 0.5216       
    ##  Mean   : 0.0000                      Mean   : 0.0000       
    ##  3rd Qu.: 0.8333                      3rd Qu.: 0.5216       
    ##  Max.   : 0.8333                      Max.   : 0.5216       
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-5.8338                                   
    ##  1st Qu.:-0.7102                                   
    ##  Median : 0.5707                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.5707                                   
    ##  Max.   : 0.5707                                   
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-5.6521                                                                                                                                                                                                                                                                              
    ##  1st Qu.:-0.6225                                                                                                                                                                                                                                                                              
    ##  Median : 0.6349                                                                                                                                                                                                                                                                              
    ##  Mean   : 0.0000                                                                                                                                                                                                                                                                              
    ##  3rd Qu.: 0.6349                                                                                                                                                                                                                                                                              
    ##  Max.   : 0.6349                                                                                                                                                                                                                                                                              
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-5.4331                                                                                                                                                                 
    ##  1st Qu.:-0.5445                                                                                                                                                                 
    ##  Median : 0.6776                                                                                                                                                                 
    ##  Mean   : 0.0000                                                                                                                                                                 
    ##  3rd Qu.: 0.6776                                                                                                                                                                 
    ##  Max.   : 0.6776                                                                                                                                                                 
    ##  C - 12. The recordings of online classes
    ##  Min.   :-4.5022                         
    ##  1st Qu.:-0.3015                         
    ##  Median : 0.7486                         
    ##  Mean   : 0.0000                         
    ##  3rd Qu.: 0.7486                         
    ##  Max.   : 0.7486                         
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-7.45714                 Min.   :-4.99256                         
    ##  1st Qu.:-0.35465                 1st Qu.:-0.68274                         
    ##  Median : 0.09882                 Median :-0.06706                         
    ##  Mean   : 0.00000                 Mean   : 0.00000                         
    ##  3rd Qu.: 0.70324                 3rd Qu.: 0.54863                         
    ##  Max.   : 0.85434                 Max.   : 1.16432                         
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-6.5612                                  
    ##  1st Qu.:-0.5801                                  
    ##  Median : 0.2356                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7793                                  
    ##  Max.   : 0.9152                                  
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-3.8114                  Min.   :-2.3600                  
    ##  1st Qu.:-0.2907                  1st Qu.:-0.2087                  
    ##  Median : 0.2327                  Median : 0.4366                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.4706                  3rd Qu.: 0.6159                  
    ##  Max.   : 0.9464                  Max.   : 1.2255                  
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-0.564554              Min.   :-3.0961                 
    ##  1st Qu.:-0.564554              1st Qu.:-0.3172                 
    ##  Median :-0.564554              Median : 0.1989                 
    ##  Mean   : 0.000000              Mean   : 0.0000                 
    ##  3rd Qu.:-0.002781              3rd Qu.: 0.4569                 
    ##  Max.   : 2.244312              Max.   : 1.8662                 
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-1.7842                         Min.   :-2.7876                  
    ##  1st Qu.:-0.7420                         1st Qu.:-0.6988                  
    ##  Median :-0.1578                         Median :-0.1019                  
    ##  Mean   : 0.0000                         Mean   : 0.0000                  
    ##  3rd Qu.: 0.5032                         3rd Qu.: 0.7933                  
    ##  Max.   : 2.2894                         Max.   : 1.6885                  
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-2.416485                     Min.   :-1.9631                        
    ##  1st Qu.:-0.541600                     1st Qu.:-0.4482                        
    ##  Median :-0.005129                     Median : 0.1361                        
    ##  Mean   : 0.000000                     Mean   : 0.0000                        
    ##  3rd Qu.: 0.809717                     3rd Qu.: 0.7204                        
    ##  Max.   : 1.639312                     Max.   : 2.4698                        
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-1.81638                               
    ##  1st Qu.:-0.75175                               
    ##  Median :-0.05512                               
    ##  Mean   : 0.00000                               
    ##  3rd Qu.: 0.54207                               
    ##  Max.   : 2.36638                               
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-5.1605                              
    ##  1st Qu.: 0.2688                              
    ##  Median : 0.2688                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2688                              
    ##  Max.   : 0.2688                              
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-2.7806                                               
    ##  1st Qu.:-0.6519                                               
    ##  Median : 0.6607                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 0.7672                                               
    ##  Max.   : 0.7672                                               
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-2.8893                                                
    ##  1st Qu.: 0.4332                                                
    ##  Median : 0.4332                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.4332                                                
    ##  Max.   : 0.5360                                                
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-1.9268                                  
    ##  1st Qu.:-0.4166                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7227                                  
    ##  Max.   : 0.7227                                  
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-1.4592                      Min.   :-3.20757        
    ##  1st Qu.:-1.4592                      1st Qu.:-0.46190        
    ##  Median : 0.6842                      Median : 0.01471        
    ##  Mean   : 0.0000                      Mean   : 0.00000        
    ##  3rd Qu.: 0.6842                      3rd Qu.: 0.90576        
    ##  Max.   : 0.6842                      Max.   : 1.05081        
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-3.31328       Min.   :-1.2182        
    ##  1st Qu.:-0.43526       1st Qu.:-1.2182        
    ##  Median : 0.08824       Median : 0.2529        
    ##  Mean   : 0.00000       Mean   : 0.0000        
    ##  3rd Qu.: 0.80762       3rd Qu.: 0.7056        
    ##  Max.   : 1.52700       Max.   : 1.6110        
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-1.69613      
    ##  1: 5                                       1st Qu.:-0.88083      
    ##                                             Median :-0.06663      
    ##                                             Mean   : 0.00000      
    ##                                             3rd Qu.: 0.74867      
    ##                                             Max.   : 4.00877      
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)  
    ##  Min.   :-2.74036             Min.   :-2.53037  
    ##  1st Qu.:-0.65650             1st Qu.:-0.58955  
    ##  Median : 0.00867             Median : 0.03151  
    ##  Mean   : 0.00000             Mean   : 0.00000  
    ##  3rd Qu.: 0.76863             3rd Qu.: 0.73021  
    ##  Max.   : 1.69569             Max.   : 1.81707  
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-3.15733                       A:23  
    ##  1st Qu.:-0.73640                       B:25  
    ##  Median : 0.09983                       C:22  
    ##  Mean   : 0.00000                       D:25  
    ##  3rd Qu.: 0.74465                       E: 6  
    ##  Max.   : 1.94590

``` r
sapply(student_perfromance_data_standardize_transform[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                                      1

## STEP 7. Apply a Box-Cox Power Transform

``` r
# BEFORE
summary(student_perfromance_data_standardize_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1   paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-0.96227   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-0.96227   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :-0.01408               
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.00000               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.46001               
    ##                                            Max.   : 3.77866               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-5.997                   Min.   :-6.8735                     
    ##  1st Qu.:-0.601                   1st Qu.:-0.9400                     
    ##  Median : 0.748                   Median : 0.5434                     
    ##  Mean   : 0.000                   Mean   : 0.0000                     
    ##  3rd Qu.: 0.748                   3rd Qu.: 0.5434                     
    ##  Max.   : 0.748                   Max.   : 0.5434                     
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-5.4927                                                                                
    ##  1st Qu.:-0.3914                                                                                
    ##  Median :-0.3914                                                                                
    ##  Mean   : 0.0000                                                                                
    ##  3rd Qu.: 0.8839                                                                                
    ##  Max.   : 0.8839                                                                                
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-7.1168                                                                                  
    ##  1st Qu.:-1.0510                                                                                  
    ##  Median : 0.4654                                                                                  
    ##  Mean   : 0.0000                                                                                  
    ##  3rd Qu.: 0.4654                                                                                  
    ##  Max.   : 0.4654                                                                                  
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-6.2560                                    
    ##  1st Qu.:-0.8207                                    
    ##  Median : 0.5382                                    
    ##  Mean   : 0.0000                                    
    ##  3rd Qu.: 0.5382                                    
    ##  Max.   : 0.5382                                    
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-4.23072                                 
    ##  1st Qu.:-0.07206                                 
    ##  Median :-0.07206                                 
    ##  Mean   : 0.00000                                 
    ##  3rd Qu.: 0.96761                                 
    ##  Max.   : 0.96761                                 
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-5.3157                                                   
    ##  1st Qu.:-0.4126                                                   
    ##  Median :-0.4126                                                   
    ##  Mean   : 0.0000                                                   
    ##  3rd Qu.: 0.8131                                                   
    ##  Max.   : 0.8131                                                   
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-5.7582                                        
    ##  1st Qu.:-0.7120                                        
    ##  Median : 0.5496                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.5496                                        
    ##  Max.   : 0.5496                                        
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-6.3418                   
    ##  1st Qu.:-0.7477                   
    ##  Median : 0.6508                   
    ##  Mean   : 0.0000                   
    ##  3rd Qu.: 0.6508                   
    ##  Max.   : 0.6508                   
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-5.8527                                  
    ##  1st Qu.:-0.6560                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.6432                                  
    ##  Max.   : 0.6432                                  
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-6.6566                            
    ##  1st Qu.:-0.9347                            
    ##  Median : 0.4957                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.4957                            
    ##  Max.   : 0.4957                            
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-4.7453                                                                      
    ##  1st Qu.:-0.2345                                                                      
    ##  Median :-0.2345                                                                      
    ##  Mean   : 0.0000                                                                      
    ##  3rd Qu.: 0.8932                                                                      
    ##  Max.   : 0.8932                                                                      
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-4.1348                                                  
    ##  1st Qu.:-0.9550                                                  
    ##  Median : 0.1049                                                  
    ##  Mean   : 0.0000                                                  
    ##  3rd Qu.: 1.1649                                                  
    ##  Max.   : 1.1649                                                  
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-5.9140                          
    ##  1st Qu.:-0.7087                          
    ##  Median : 0.5927                          
    ##  Mean   : 0.0000                          
    ##  3rd Qu.: 0.5927                          
    ##  Max.   : 0.5927                          
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-6.0546                                                    
    ##  1st Qu.:-0.7486                                                    
    ##  Median : 0.5779                                                    
    ##  Mean   : 0.0000                                                    
    ##  3rd Qu.: 0.5779                                                    
    ##  Max.   : 0.5779                                                    
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-5.9540                                                                                                    
    ##  1st Qu.:-0.6674                                                                                                    
    ##  Median : 0.6543                                                                                                    
    ##  Mean   : 0.0000                                                                                                    
    ##  3rd Qu.: 0.6543                                                                                                    
    ##  Max.   : 0.6543                                                                                                    
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-4.2614                     
    ##  1st Qu.:-0.1526                     
    ##  Median :-0.1526                     
    ##  Mean   : 0.0000                     
    ##  3rd Qu.: 0.8747                     
    ##  Max.   : 0.8747                     
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-3.78607                          
    ##  1st Qu.:-0.03712                          
    ##  Median :-0.03712                          
    ##  Mean   : 0.00000                          
    ##  3rd Qu.: 0.90012                          
    ##  Max.   : 0.90012                          
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-3.9487                      Min.   :-5.3324       
    ##  1st Qu.:-0.1231                      1st Qu.:-0.6492       
    ##  Median :-0.1231                      Median : 0.5216       
    ##  Mean   : 0.0000                      Mean   : 0.0000       
    ##  3rd Qu.: 0.8333                      3rd Qu.: 0.5216       
    ##  Max.   : 0.8333                      Max.   : 0.5216       
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-5.8338                                   
    ##  1st Qu.:-0.7102                                   
    ##  Median : 0.5707                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.5707                                   
    ##  Max.   : 0.5707                                   
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-5.6521                                                                                                                                                                                                                                                                              
    ##  1st Qu.:-0.6225                                                                                                                                                                                                                                                                              
    ##  Median : 0.6349                                                                                                                                                                                                                                                                              
    ##  Mean   : 0.0000                                                                                                                                                                                                                                                                              
    ##  3rd Qu.: 0.6349                                                                                                                                                                                                                                                                              
    ##  Max.   : 0.6349                                                                                                                                                                                                                                                                              
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-5.4331                                                                                                                                                                 
    ##  1st Qu.:-0.5445                                                                                                                                                                 
    ##  Median : 0.6776                                                                                                                                                                 
    ##  Mean   : 0.0000                                                                                                                                                                 
    ##  3rd Qu.: 0.6776                                                                                                                                                                 
    ##  Max.   : 0.6776                                                                                                                                                                 
    ##  C - 12. The recordings of online classes
    ##  Min.   :-4.5022                         
    ##  1st Qu.:-0.3015                         
    ##  Median : 0.7486                         
    ##  Mean   : 0.0000                         
    ##  3rd Qu.: 0.7486                         
    ##  Max.   : 0.7486                         
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-7.45714                 Min.   :-4.99256                         
    ##  1st Qu.:-0.35465                 1st Qu.:-0.68274                         
    ##  Median : 0.09882                 Median :-0.06706                         
    ##  Mean   : 0.00000                 Mean   : 0.00000                         
    ##  3rd Qu.: 0.70324                 3rd Qu.: 0.54863                         
    ##  Max.   : 0.85434                 Max.   : 1.16432                         
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-6.5612                                  
    ##  1st Qu.:-0.5801                                  
    ##  Median : 0.2356                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7793                                  
    ##  Max.   : 0.9152                                  
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-3.8114                  Min.   :-2.3600                  
    ##  1st Qu.:-0.2907                  1st Qu.:-0.2087                  
    ##  Median : 0.2327                  Median : 0.4366                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.4706                  3rd Qu.: 0.6159                  
    ##  Max.   : 0.9464                  Max.   : 1.2255                  
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-0.564554              Min.   :-3.0961                 
    ##  1st Qu.:-0.564554              1st Qu.:-0.3172                 
    ##  Median :-0.564554              Median : 0.1989                 
    ##  Mean   : 0.000000              Mean   : 0.0000                 
    ##  3rd Qu.:-0.002781              3rd Qu.: 0.4569                 
    ##  Max.   : 2.244312              Max.   : 1.8662                 
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-1.7842                         Min.   :-2.7876                  
    ##  1st Qu.:-0.7420                         1st Qu.:-0.6988                  
    ##  Median :-0.1578                         Median :-0.1019                  
    ##  Mean   : 0.0000                         Mean   : 0.0000                  
    ##  3rd Qu.: 0.5032                         3rd Qu.: 0.7933                  
    ##  Max.   : 2.2894                         Max.   : 1.6885                  
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-2.416485                     Min.   :-1.9631                        
    ##  1st Qu.:-0.541600                     1st Qu.:-0.4482                        
    ##  Median :-0.005129                     Median : 0.1361                        
    ##  Mean   : 0.000000                     Mean   : 0.0000                        
    ##  3rd Qu.: 0.809717                     3rd Qu.: 0.7204                        
    ##  Max.   : 1.639312                     Max.   : 2.4698                        
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-1.81638                               
    ##  1st Qu.:-0.75175                               
    ##  Median :-0.05512                               
    ##  Mean   : 0.00000                               
    ##  3rd Qu.: 0.54207                               
    ##  Max.   : 2.36638                               
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-5.1605                              
    ##  1st Qu.: 0.2688                              
    ##  Median : 0.2688                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2688                              
    ##  Max.   : 0.2688                              
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-2.7806                                               
    ##  1st Qu.:-0.6519                                               
    ##  Median : 0.6607                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 0.7672                                               
    ##  Max.   : 0.7672                                               
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-2.8893                                                
    ##  1st Qu.: 0.4332                                                
    ##  Median : 0.4332                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.4332                                                
    ##  Max.   : 0.5360                                                
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-1.9268                                  
    ##  1st Qu.:-0.4166                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7227                                  
    ##  Max.   : 0.7227                                  
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-1.4592                      Min.   :-3.20757        
    ##  1st Qu.:-1.4592                      1st Qu.:-0.46190        
    ##  Median : 0.6842                      Median : 0.01471        
    ##  Mean   : 0.0000                      Mean   : 0.00000        
    ##  3rd Qu.: 0.6842                      3rd Qu.: 0.90576        
    ##  Max.   : 0.6842                      Max.   : 1.05081        
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-3.31328       Min.   :-1.2182        
    ##  1st Qu.:-0.43526       1st Qu.:-1.2182        
    ##  Median : 0.08824       Median : 0.2529        
    ##  Mean   : 0.00000       Mean   : 0.0000        
    ##  3rd Qu.: 0.80762       3rd Qu.: 0.7056        
    ##  Max.   : 1.52700       Max.   : 1.6110        
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-1.69613      
    ##  1: 5                                       1st Qu.:-0.88083      
    ##                                             Median :-0.06663      
    ##                                             Mean   : 0.00000      
    ##                                             3rd Qu.: 0.74867      
    ##                                             Max.   : 4.00877      
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)  
    ##  Min.   :-2.74036             Min.   :-2.53037  
    ##  1st Qu.:-0.65650             1st Qu.:-0.58955  
    ##  Median : 0.00867             Median : 0.03151  
    ##  Mean   : 0.00000             Mean   : 0.00000  
    ##  3rd Qu.: 0.76863             3rd Qu.: 0.73021  
    ##  Max.   : 1.69569             Max.   : 1.81707  
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-3.15733                       A:23  
    ##  1st Qu.:-0.73640                       B:25  
    ##  Median : 0.09983                       C:22  
    ##  Mean   : 0.00000                       D:25  
    ##  3rd Qu.: 0.74465                       E: 6  
    ##  Max.   : 1.94590

``` r
# Calculate the skewness before the Box-Cox transform
sapply(student_perfromance_data_standardize_transform[, 99],  skewness, type = 2)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                             -0.4713841

``` r
sapply(student_perfromance_data_standardize_transform[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                                      1

``` r
model_of_the_transform <- preProcess(student_perfromance_data_standardize_transform,
                                     method = c("BoxCox"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 51 variables
    ## 
    ## Pre-processing:
    ##   - ignored (51)

``` r
student_perfromance_data_box_cox_transform <- predict(model_of_the_transform,
                                       student_perfromance_data_standardize_transform)

# Calculate the skewness after the Box-Cox transform
sapply(student_perfromance_data_box_cox_transform[, 99],  skewness, type = 2)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                             -0.4713841

``` r
sapply(student_perfromance_data_box_cox_transform[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                                      1

## STEP 8. Apply a Yeo-Johnson Power Transform

``` r
# BEFORE
summary(student_perfromance_data_standardize_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1   paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-0.96227   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-0.96227   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :-0.01408               
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.00000               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.46001               
    ##                                            Max.   : 3.77866               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-5.997                   Min.   :-6.8735                     
    ##  1st Qu.:-0.601                   1st Qu.:-0.9400                     
    ##  Median : 0.748                   Median : 0.5434                     
    ##  Mean   : 0.000                   Mean   : 0.0000                     
    ##  3rd Qu.: 0.748                   3rd Qu.: 0.5434                     
    ##  Max.   : 0.748                   Max.   : 0.5434                     
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-5.4927                                                                                
    ##  1st Qu.:-0.3914                                                                                
    ##  Median :-0.3914                                                                                
    ##  Mean   : 0.0000                                                                                
    ##  3rd Qu.: 0.8839                                                                                
    ##  Max.   : 0.8839                                                                                
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-7.1168                                                                                  
    ##  1st Qu.:-1.0510                                                                                  
    ##  Median : 0.4654                                                                                  
    ##  Mean   : 0.0000                                                                                  
    ##  3rd Qu.: 0.4654                                                                                  
    ##  Max.   : 0.4654                                                                                  
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-6.2560                                    
    ##  1st Qu.:-0.8207                                    
    ##  Median : 0.5382                                    
    ##  Mean   : 0.0000                                    
    ##  3rd Qu.: 0.5382                                    
    ##  Max.   : 0.5382                                    
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-4.23072                                 
    ##  1st Qu.:-0.07206                                 
    ##  Median :-0.07206                                 
    ##  Mean   : 0.00000                                 
    ##  3rd Qu.: 0.96761                                 
    ##  Max.   : 0.96761                                 
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-5.3157                                                   
    ##  1st Qu.:-0.4126                                                   
    ##  Median :-0.4126                                                   
    ##  Mean   : 0.0000                                                   
    ##  3rd Qu.: 0.8131                                                   
    ##  Max.   : 0.8131                                                   
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-5.7582                                        
    ##  1st Qu.:-0.7120                                        
    ##  Median : 0.5496                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.5496                                        
    ##  Max.   : 0.5496                                        
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-6.3418                   
    ##  1st Qu.:-0.7477                   
    ##  Median : 0.6508                   
    ##  Mean   : 0.0000                   
    ##  3rd Qu.: 0.6508                   
    ##  Max.   : 0.6508                   
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-5.8527                                  
    ##  1st Qu.:-0.6560                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.6432                                  
    ##  Max.   : 0.6432                                  
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-6.6566                            
    ##  1st Qu.:-0.9347                            
    ##  Median : 0.4957                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.4957                            
    ##  Max.   : 0.4957                            
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-4.7453                                                                      
    ##  1st Qu.:-0.2345                                                                      
    ##  Median :-0.2345                                                                      
    ##  Mean   : 0.0000                                                                      
    ##  3rd Qu.: 0.8932                                                                      
    ##  Max.   : 0.8932                                                                      
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-4.1348                                                  
    ##  1st Qu.:-0.9550                                                  
    ##  Median : 0.1049                                                  
    ##  Mean   : 0.0000                                                  
    ##  3rd Qu.: 1.1649                                                  
    ##  Max.   : 1.1649                                                  
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-5.9140                          
    ##  1st Qu.:-0.7087                          
    ##  Median : 0.5927                          
    ##  Mean   : 0.0000                          
    ##  3rd Qu.: 0.5927                          
    ##  Max.   : 0.5927                          
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-6.0546                                                    
    ##  1st Qu.:-0.7486                                                    
    ##  Median : 0.5779                                                    
    ##  Mean   : 0.0000                                                    
    ##  3rd Qu.: 0.5779                                                    
    ##  Max.   : 0.5779                                                    
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-5.9540                                                                                                    
    ##  1st Qu.:-0.6674                                                                                                    
    ##  Median : 0.6543                                                                                                    
    ##  Mean   : 0.0000                                                                                                    
    ##  3rd Qu.: 0.6543                                                                                                    
    ##  Max.   : 0.6543                                                                                                    
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-4.2614                     
    ##  1st Qu.:-0.1526                     
    ##  Median :-0.1526                     
    ##  Mean   : 0.0000                     
    ##  3rd Qu.: 0.8747                     
    ##  Max.   : 0.8747                     
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-3.78607                          
    ##  1st Qu.:-0.03712                          
    ##  Median :-0.03712                          
    ##  Mean   : 0.00000                          
    ##  3rd Qu.: 0.90012                          
    ##  Max.   : 0.90012                          
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-3.9487                      Min.   :-5.3324       
    ##  1st Qu.:-0.1231                      1st Qu.:-0.6492       
    ##  Median :-0.1231                      Median : 0.5216       
    ##  Mean   : 0.0000                      Mean   : 0.0000       
    ##  3rd Qu.: 0.8333                      3rd Qu.: 0.5216       
    ##  Max.   : 0.8333                      Max.   : 0.5216       
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-5.8338                                   
    ##  1st Qu.:-0.7102                                   
    ##  Median : 0.5707                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.5707                                   
    ##  Max.   : 0.5707                                   
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-5.6521                                                                                                                                                                                                                                                                              
    ##  1st Qu.:-0.6225                                                                                                                                                                                                                                                                              
    ##  Median : 0.6349                                                                                                                                                                                                                                                                              
    ##  Mean   : 0.0000                                                                                                                                                                                                                                                                              
    ##  3rd Qu.: 0.6349                                                                                                                                                                                                                                                                              
    ##  Max.   : 0.6349                                                                                                                                                                                                                                                                              
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-5.4331                                                                                                                                                                 
    ##  1st Qu.:-0.5445                                                                                                                                                                 
    ##  Median : 0.6776                                                                                                                                                                 
    ##  Mean   : 0.0000                                                                                                                                                                 
    ##  3rd Qu.: 0.6776                                                                                                                                                                 
    ##  Max.   : 0.6776                                                                                                                                                                 
    ##  C - 12. The recordings of online classes
    ##  Min.   :-4.5022                         
    ##  1st Qu.:-0.3015                         
    ##  Median : 0.7486                         
    ##  Mean   : 0.0000                         
    ##  3rd Qu.: 0.7486                         
    ##  Max.   : 0.7486                         
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-7.45714                 Min.   :-4.99256                         
    ##  1st Qu.:-0.35465                 1st Qu.:-0.68274                         
    ##  Median : 0.09882                 Median :-0.06706                         
    ##  Mean   : 0.00000                 Mean   : 0.00000                         
    ##  3rd Qu.: 0.70324                 3rd Qu.: 0.54863                         
    ##  Max.   : 0.85434                 Max.   : 1.16432                         
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-6.5612                                  
    ##  1st Qu.:-0.5801                                  
    ##  Median : 0.2356                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7793                                  
    ##  Max.   : 0.9152                                  
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-3.8114                  Min.   :-2.3600                  
    ##  1st Qu.:-0.2907                  1st Qu.:-0.2087                  
    ##  Median : 0.2327                  Median : 0.4366                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.4706                  3rd Qu.: 0.6159                  
    ##  Max.   : 0.9464                  Max.   : 1.2255                  
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-0.564554              Min.   :-3.0961                 
    ##  1st Qu.:-0.564554              1st Qu.:-0.3172                 
    ##  Median :-0.564554              Median : 0.1989                 
    ##  Mean   : 0.000000              Mean   : 0.0000                 
    ##  3rd Qu.:-0.002781              3rd Qu.: 0.4569                 
    ##  Max.   : 2.244312              Max.   : 1.8662                 
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-1.7842                         Min.   :-2.7876                  
    ##  1st Qu.:-0.7420                         1st Qu.:-0.6988                  
    ##  Median :-0.1578                         Median :-0.1019                  
    ##  Mean   : 0.0000                         Mean   : 0.0000                  
    ##  3rd Qu.: 0.5032                         3rd Qu.: 0.7933                  
    ##  Max.   : 2.2894                         Max.   : 1.6885                  
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-2.416485                     Min.   :-1.9631                        
    ##  1st Qu.:-0.541600                     1st Qu.:-0.4482                        
    ##  Median :-0.005129                     Median : 0.1361                        
    ##  Mean   : 0.000000                     Mean   : 0.0000                        
    ##  3rd Qu.: 0.809717                     3rd Qu.: 0.7204                        
    ##  Max.   : 1.639312                     Max.   : 2.4698                        
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-1.81638                               
    ##  1st Qu.:-0.75175                               
    ##  Median :-0.05512                               
    ##  Mean   : 0.00000                               
    ##  3rd Qu.: 0.54207                               
    ##  Max.   : 2.36638                               
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-5.1605                              
    ##  1st Qu.: 0.2688                              
    ##  Median : 0.2688                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2688                              
    ##  Max.   : 0.2688                              
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-2.7806                                               
    ##  1st Qu.:-0.6519                                               
    ##  Median : 0.6607                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 0.7672                                               
    ##  Max.   : 0.7672                                               
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-2.8893                                                
    ##  1st Qu.: 0.4332                                                
    ##  Median : 0.4332                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.4332                                                
    ##  Max.   : 0.5360                                                
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-1.9268                                  
    ##  1st Qu.:-0.4166                                  
    ##  Median : 0.6432                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7227                                  
    ##  Max.   : 0.7227                                  
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-1.4592                      Min.   :-3.20757        
    ##  1st Qu.:-1.4592                      1st Qu.:-0.46190        
    ##  Median : 0.6842                      Median : 0.01471        
    ##  Mean   : 0.0000                      Mean   : 0.00000        
    ##  3rd Qu.: 0.6842                      3rd Qu.: 0.90576        
    ##  Max.   : 0.6842                      Max.   : 1.05081        
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-3.31328       Min.   :-1.2182        
    ##  1st Qu.:-0.43526       1st Qu.:-1.2182        
    ##  Median : 0.08824       Median : 0.2529        
    ##  Mean   : 0.00000       Mean   : 0.0000        
    ##  3rd Qu.: 0.80762       3rd Qu.: 0.7056        
    ##  Max.   : 1.52700       Max.   : 1.6110        
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-1.69613      
    ##  1: 5                                       1st Qu.:-0.88083      
    ##                                             Median :-0.06663      
    ##                                             Mean   : 0.00000      
    ##                                             3rd Qu.: 0.74867      
    ##                                             Max.   : 4.00877      
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)  
    ##  Min.   :-2.74036             Min.   :-2.53037  
    ##  1st Qu.:-0.65650             1st Qu.:-0.58955  
    ##  Median : 0.00867             Median : 0.03151  
    ##  Mean   : 0.00000             Mean   : 0.00000  
    ##  3rd Qu.: 0.76863             3rd Qu.: 0.73021  
    ##  Max.   : 1.69569             Max.   : 1.81707  
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-3.15733                       A:23  
    ##  1st Qu.:-0.73640                       B:25  
    ##  Median : 0.09983                       C:22  
    ##  Mean   : 0.00000                       D:25  
    ##  3rd Qu.: 0.74465                       E: 6  
    ##  Max.   : 1.94590

``` r
# Calculate the skewness before the Yeo-Johnson transform
sapply(student_perfromance_data_standardize_transform[, 99],  skewness, type = 2)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                             -0.4713841

``` r
sapply(student_perfromance_data_standardize_transform[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                                      1

``` r
model_of_the_transform <- preProcess(student_perfromance_data_standardize_transform,
                                     method = c("YeoJohnson"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 91 variables
    ## 
    ## Pre-processing:
    ##   - ignored (51)
    ##   - Yeo-Johnson transformation (40)
    ## 
    ## Lambda estimates for Yeo-Johnson transformation:
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  -1.547   1.329   1.808   1.715   2.262   2.986

``` r
student_perfromance_data_yeo_johnson_transform <- predict(model_of_the_transform, # nolint
                                           student_perfromance_data_standardize_transform)

# AFTER
summary(student_perfromance_data_yeo_johnson_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1   paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-1.32433   0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-1.32433   1:11        
    ##  3:38          3:30   3   :33   3   :12    Median :-0.01416               
    ##  4:18          4:25   4   :28   4   : 4    Mean   :-0.26472               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.39165               
    ##                                            Max.   : 1.80691               
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-1.9059                  Min.   :-6.8735                     
    ##  1st Qu.:-0.4683                  1st Qu.:-0.9400                     
    ##  Median : 1.0349                  Median : 0.5434                     
    ##  Mean   : 0.2914                  Mean   : 0.0000                     
    ##  3rd Qu.: 1.0349                  3rd Qu.: 0.5434                     
    ##  Max.   : 1.0349                  Max.   : 0.5434                     
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-2.4842                                                                                
    ##  1st Qu.:-0.3467                                                                                
    ##  Median :-0.3467                                                                                
    ##  Mean   : 0.2176                                                                                
    ##  3rd Qu.: 1.1423                                                                                
    ##  Max.   : 1.1423                                                                                
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-7.1168                                                                                  
    ##  1st Qu.:-1.0510                                                                                  
    ##  Median : 0.4654                                                                                  
    ##  Mean   : 0.0000                                                                                  
    ##  3rd Qu.: 0.4654                                                                                  
    ##  Max.   : 0.4654                                                                                  
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-6.2560                                    
    ##  1st Qu.:-0.8207                                    
    ##  Median : 0.5382                                    
    ##  Mean   : 0.0000                                    
    ##  3rd Qu.: 0.5382                                    
    ##  Max.   : 0.5382                                    
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-2.05259                                 
    ##  1st Qu.:-0.07019                                 
    ##  Median :-0.07019                                 
    ##  Mean   : 0.22383                                 
    ##  3rd Qu.: 1.29551                                 
    ##  Max.   : 1.29551                                 
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-2.0451                                                   
    ##  1st Qu.:-0.3522                                                   
    ##  Median :-0.3522                                                   
    ##  Mean   : 0.2592                                                   
    ##  3rd Qu.: 1.0997                                                   
    ##  Max.   : 1.0997                                                   
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-5.7582                                        
    ##  1st Qu.:-0.7120                                        
    ##  Median : 0.5496                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.5496                                        
    ##  Max.   : 0.5496                                        
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-1.3413                   
    ##  1st Qu.:-0.4966                   
    ##  Median : 0.9790                   
    ##  Mean   : 0.3741                   
    ##  3rd Qu.: 0.9790                   
    ##  Max.   : 0.9790                   
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-1.1893                                  
    ##  1st Qu.:-0.4407                                  
    ##  Median : 0.9986                                  
    ##  Mean   : 0.4093                                  
    ##  3rd Qu.: 0.9986                                  
    ##  Max.   : 0.9986                                  
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-6.6566                            
    ##  1st Qu.:-0.9347                            
    ##  Median : 0.4957                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.4957                            
    ##  Max.   : 0.4957                            
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-2.1505                                                                      
    ##  1st Qu.:-0.2158                                                                      
    ##  Median :-0.2158                                                                      
    ##  Mean   : 0.2317                                                                      
    ##  3rd Qu.: 1.1840                                                                      
    ##  Max.   : 1.1840                                                                      
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-2.6566                                                  
    ##  1st Qu.:-0.8111                                                  
    ##  Median : 0.1074                                                  
    ##  Mean   : 0.1499                                                  
    ##  3rd Qu.: 1.4230                                                  
    ##  Max.   : 1.4230                                                  
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-0.9656                          
    ##  1st Qu.:-0.4329                          
    ##  Median : 0.9645                          
    ##  Mean   : 0.4455                          
    ##  3rd Qu.: 0.9645                          
    ##  Max.   : 0.9645                          
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-0.8664                                                    
    ##  1st Qu.:-0.4296                                                    
    ##  Median : 0.9724                                                    
    ##  Mean   : 0.4813                                                    
    ##  3rd Qu.: 0.9724                                                    
    ##  Max.   : 0.9724                                                    
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-1.2787                                                                                                    
    ##  1st Qu.:-0.4551                                                                                                    
    ##  Median : 0.9971                                                                                                    
    ##  Mean   : 0.3898                                                                                                    
    ##  3rd Qu.: 0.9971                                                                                                    
    ##  Max.   : 0.9971                                                                                                    
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-1.8944                     
    ##  1st Qu.:-0.1436                     
    ##  Median :-0.1436                     
    ##  Mean   : 0.2561                     
    ##  3rd Qu.: 1.1858                     
    ##  Max.   : 1.1858                     
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-1.77298                          
    ##  1st Qu.:-0.03655                          
    ##  Median :-0.03655                          
    ##  Mean   : 0.26182                          
    ##  3rd Qu.: 1.22924                          
    ##  Max.   : 1.22924                          
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-1.6558                      Min.   :-5.3324       
    ##  1st Qu.:-0.1164                      1st Qu.:-0.6492       
    ##  Median :-0.1164                      Median : 0.5216       
    ##  Mean   : 0.2898                      Mean   : 0.0000       
    ##  3rd Qu.: 1.1621                      3rd Qu.: 0.5216       
    ##  Max.   : 1.1621                      Max.   : 0.5216       
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-5.8338                                   
    ##  1st Qu.:-0.7102                                   
    ##  Median : 0.5707                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.5707                                   
    ##  Max.   : 0.5707                                   
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-1.1439                                                                                                                                                                                                                                                                              
    ##  1st Qu.:-0.4213                                                                                                                                                                                                                                                                              
    ##  Median : 0.9922                                                                                                                                                                                                                                                                              
    ##  Mean   : 0.4120                                                                                                                                                                                                                                                                              
    ##  3rd Qu.: 0.9922                                                                                                                                                                                                                                                                              
    ##  Max.   : 0.9922                                                                                                                                                                                                                                                                              
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-1.3288                                                                                                                                                                 
    ##  1st Qu.:-0.4003                                                                                                                                                                 
    ##  Median : 1.0209                                                                                                                                                                 
    ##  Mean   : 0.3791                                                                                                                                                                 
    ##  3rd Qu.: 1.0209                                                                                                                                                                 
    ##  Max.   : 1.0209                                                                                                                                                                 
    ##  C - 12. The recordings of online classes
    ##  Min.   :-1.4650                         
    ##  1st Qu.:-0.2573                         
    ##  Median : 1.0934                         
    ##  Mean   : 0.3509                         
    ##  3rd Qu.: 1.0934                         
    ##  Max.   : 1.0934                         
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-1.9626                  Min.   :-2.81842                         
    ##  1st Qu.:-0.2999                  1st Qu.:-0.59015                         
    ##  Median : 0.1041                  Median :-0.06591                         
    ##  Mean   : 0.2361                  Mean   : 0.16670                         
    ##  3rd Qu.: 0.9747                  3rd Qu.: 0.62211                         
    ##  Max.   : 1.2561                  Max.   : 1.47389                         
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-2.0488                                  
    ##  1st Qu.:-0.4588                                  
    ##  Median : 0.2630                                  
    ##  Mean   : 0.2598                                  
    ##  3rd Qu.: 1.0783                                  
    ##  Max.   : 1.3274                                  
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-1.2808                  Min.   :-1.1123                  
    ##  1st Qu.:-0.2466                  1st Qu.:-0.1870                  
    ##  Median : 0.2678                  Median : 0.5478                  
    ##  Mean   : 0.3038                  Mean   : 0.3425                  
    ##  3rd Qu.: 0.6167                  3rd Qu.: 0.8386                  
    ##  Max.   : 1.5568                  Max.   : 2.1253                  
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-1.097227              Min.   :-1.8850                 
    ##  1st Qu.:-1.097227              1st Qu.:-0.2910                 
    ##  Median :-1.097227              Median : 0.2106                 
    ##  Mean   :-0.673328              Mean   : 0.1856                 
    ##  3rd Qu.:-0.002791              3rd Qu.: 0.5169                 
    ##  Max.   : 0.541816              Max.   : 2.7564                 
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-2.4418                         Min.   :-2.59032                 
    ##  1st Qu.:-0.8681                         1st Qu.:-0.68065                 
    ##  Median :-0.1640                         Median :-0.10147                 
    ##  Mean   :-0.1708                         Mean   : 0.03208                 
    ##  3rd Qu.: 0.4514                         3rd Qu.: 0.81697                 
    ##  Max.   : 1.6197                         Max.   : 1.78018                 
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-1.896073                     Min.   :-1.5558                        
    ##  1st Qu.:-0.501171                     1st Qu.:-0.4167                        
    ##  Median :-0.005125                     Median : 0.1395                        
    ##  Mean   : 0.115378                     Mean   : 0.1269                        
    ##  3rd Qu.: 0.905522                     3rd Qu.: 0.8060                        
    ##  Max.   : 1.991335                     Max.   : 3.2935                        
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-2.14298                               
    ##  1st Qu.:-0.81685                               
    ##  Median :-0.05553                               
    ##  Mean   :-0.09385                               
    ##  3rd Qu.: 0.50964                               
    ##  Max.   : 1.95555                               
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-5.1605                              
    ##  1st Qu.: 0.2688                              
    ##  Median : 0.2688                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2688                              
    ##  Max.   : 0.2688                              
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-1.1245                                               
    ##  1st Qu.:-0.4706                                               
    ##  Median : 0.9499                                               
    ##  Mean   : 0.3831                                               
    ##  3rd Qu.: 1.1597                                               
    ##  Max.   : 1.1597                                               
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-2.8893                                                
    ##  1st Qu.: 0.4332                                                
    ##  Median : 0.4332                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.4332                                                
    ##  Max.   : 0.5360                                                
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-0.7915                                  
    ##  1st Qu.:-0.3142                                  
    ##  Median : 1.0146                                  
    ##  Mean   : 0.4828                                  
    ##  3rd Qu.: 1.1975                                  
    ##  Max.   : 1.1975                                  
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-0.6467                      Min.   :-1.70773        
    ##  1st Qu.:-0.6467                      1st Qu.:-0.39710        
    ##  Median : 1.1724                      Median : 0.01479        
    ##  Mean   : 0.5864                      Mean   : 0.24373        
    ##  3rd Qu.: 1.1724                      3rd Qu.: 1.20235        
    ##  Max.   : 1.1724                      Max.   : 1.44698        
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-1.92377       Min.   :-1.15121       
    ##  1st Qu.:-0.38591       1st Qu.:-1.15121       
    ##  Median : 0.09071       Median : 0.25673       
    ##  Mean   : 0.19969       Mean   : 0.04647       
    ##  3rd Qu.: 1.00016       3rd Qu.: 0.73217       
    ##  Max.   : 2.17901       Max.   : 1.72921       
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-2.01500      
    ##  1: 5                                       1st Qu.:-0.97700      
    ##                                             Median :-0.06727      
    ##                                             Mean   :-0.09993      
    ##                                             3rd Qu.: 0.68536      
    ##                                             Max.   : 3.00415      
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)  
    ##  Min.   :-2.21224             Min.   :-2.02686  
    ##  1st Qu.:-0.60962             1st Qu.:-0.54755  
    ##  Median : 0.00868             Median : 0.03166  
    ##  Mean   : 0.09551             Mean   : 0.10263  
    ##  3rd Qu.: 0.83801             3rd Qu.: 0.79947  
    ##  Max.   : 1.99130             Max.   : 2.18644  
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-2.57529                       A:23  
    ##  1st Qu.:-0.68604                       B:25  
    ##  Median : 0.10099                       C:22  
    ##  Mean   : 0.08164                       D:25  
    ##  3rd Qu.: 0.80099                       E: 6  
    ##  Max.   : 2.26892

``` r
# Calculate the skewness after the Yeo-Johnson transform
sapply(student_perfromance_data_yeo_johnson_transform[, 99],  skewness, type = 2)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                            -0.03578989

``` r
sapply(student_perfromance_data_yeo_johnson_transform[, 99], sd)
```

    ## TOTAL = Coursework TOTAL + EXAM (100%) 
    ##                              0.9871513

## STEP 9 PCA Linear Algebra Transform for Dimensionality Reduction

``` r
## STEP 9.a. PCA Linear Algebra Transform for Dimensionality Reduction ----
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1:11        
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00                
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.03                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:4.000                    1st Qu.:4.000                       
    ##  Median :5.000                    Median :5.000                       
    ##  Mean   :4.446                    Mean   :4.634                       
    ##  3rd Qu.:5.000                    3rd Qu.:5.000                       
    ##  Max.   :5.000                    Max.   :5.000                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:4.000                                                                                  
    ##  Median :4.000                                                                                  
    ##  Mean   :4.307                                                                                  
    ##  3rd Qu.:5.000                                                                                  
    ##  Max.   :5.000                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:4.000                                                                                    
    ##  Median :5.000                                                                                    
    ##  Mean   :4.693                                                                                    
    ##  3rd Qu.:5.000                                                                                    
    ##  Max.   :5.000                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:4.000                                      
    ##  Median :5.000                                      
    ##  Mean   :4.604                                      
    ##  3rd Qu.:5.000                                      
    ##  Max.   :5.000                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.000                                    
    ##  Mean   :4.069                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.000                                                     
    ##  Median :4.000                                                     
    ##  Mean   :4.337                                                     
    ##  3rd Qu.:5.000                                                     
    ##  Max.   :5.000                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:4.000                                          
    ##  Median :5.000                                          
    ##  Mean   :4.564                                          
    ##  3rd Qu.:5.000                                          
    ##  Max.   :5.000                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:4.000                     
    ##  Median :5.000                     
    ##  Mean   :4.535                     
    ##  3rd Qu.:5.000                     
    ##  Max.   :5.000                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :5.000                                    
    ##  Mean   :4.505                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:4.000                              
    ##  Median :5.000                              
    ##  Mean   :4.653                              
    ##  3rd Qu.:5.000                              
    ##  Max.   :5.000                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.000                                                                        
    ##  Median :4.000                                                                        
    ##  Mean   :4.208                                                                        
    ##  3rd Qu.:5.000                                                                        
    ##  Max.   :5.000                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.000                                                    
    ##  Median :4.000                                                    
    ##  Mean   :3.901                                                    
    ##  3rd Qu.:5.000                                                    
    ##  Max.   :5.000                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:4.000                            
    ##  Median :5.000                            
    ##  Mean   :4.545                            
    ##  3rd Qu.:5.000                            
    ##  Max.   :5.000                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:4.000                                                      
    ##  Median :5.000                                                      
    ##  Mean   :4.564                                                      
    ##  3rd Qu.:5.000                                                      
    ##  Max.   :5.000                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:4.000                                                                                                      
    ##  Median :5.000                                                                                                      
    ##  Mean   :4.505                                                                                                      
    ##  3rd Qu.:5.000                                                                                                      
    ##  Max.   :5.000                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.000                       
    ##  Median :4.000                       
    ##  Mean   :4.149                       
    ##  3rd Qu.:5.000                       
    ##  Max.   :5.000                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.04                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:4.000                        1st Qu.:4.000         
    ##  Median :4.000                        Median :5.000         
    ##  Mean   :4.129                        Mean   :4.554         
    ##  3rd Qu.:5.000                        3rd Qu.:5.000         
    ##  Max.   :5.000                        Max.   :5.000         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:4.000                                     
    ##  Median :5.000                                     
    ##  Mean   :4.554                                     
    ##  3rd Qu.:5.000                                     
    ##  Max.   :5.000                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:4.000                                                                                                                                                                                                                                                                                
    ##  Median :5.000                                                                                                                                                                                                                                                                                
    ##  Mean   :4.495                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:5.000                                                                                                                                                                                                                                                                                
    ##  Max.   :5.000                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.000                                                                                                                                                                   
    ##  Median :5.000                                                                                                                                                                   
    ##  Mean   :4.446                                                                                                                                                                   
    ##  3rd Qu.:5.000                                                                                                                                                                   
    ##  Max.   :5.000                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.000                           
    ##  Median :5.000                           
    ##  Mean   :4.287                           
    ##  3rd Qu.:5.000                           
    ##  Max.   :5.000                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.486                    Mean   :4.054                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.545                                    
    ##  Mean   :4.388                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.005                  Mean   : 62.39                  
    ##  3rd Qu.:1.000                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 0.000                   
    ##  1st Qu.:11.53                           1st Qu.: 7.000                   
    ##  Median :15.33                           Median : 9.000                   
    ##  Mean   :16.36                           Mean   : 9.342                   
    ##  3rd Qu.:19.63                           3rd Qu.:12.000                   
    ##  Max.   :31.25                           Max.   :15.000                   
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 0.00                         Min.   : 0.000                         
    ##  1st Qu.:10.17                         1st Qu.: 4.330                         
    ##  Median :13.08                         Median : 6.000                         
    ##  Mean   :13.11                         Mean   : 5.611                         
    ##  3rd Qu.:17.50                         3rd Qu.: 7.670                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.752                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:3.000                                                 
    ##  Median :4.850                                                 
    ##  Mean   :3.919                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:4.850                                                  
    ##  Median :4.850                                                  
    ##  Mean   :4.218                                                  
    ##  3rd Qu.:4.850                                                  
    ##  Max.   :5.000                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:2.850                                    
    ##  Median :4.850                                    
    ##  Mean   :3.636                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   : 0.00          Min.   :  0.00         
    ##  1st Qu.:57.89          1st Qu.:  0.00         
    ##  Median :68.42          Median : 52.00         
    ##  Mean   :66.65          Mean   : 43.06         
    ##  3rd Qu.:82.89          3rd Qu.: 68.00         
    ##  Max.   :97.36          Max.   :100.00         
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 0.00   
    ##  1st Qu.:20.44                1st Qu.:25.00   
    ##  Median :24.58                Median :33.00   
    ##  Mean   :24.53                Mean   :32.59   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72

``` r
model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center", "pca"))
print(model_of_the_transform)
```

    ## Created from 100 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - ignored (51)
    ##   - principal component signal extraction (49)
    ##   - scaled (49)
    ## 
    ## PCA needed 26 components to capture 95 percent of the variance

``` r
student_performance_dataset_pca_dr <- predict(model_of_the_transform, student_performance_dataset)

summary(student_performance_dataset_pca_dr)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time paid_tuition free_tuition
    ##  1:19          1:18   1   :16   1   :45    0:90         0:74        
    ##  2:26          2:28   2   :23   2   :39    1:11         1:27        
    ##  3:38          3:30   3   :33   3   :12                             
    ##  4:18          4:25   4   :28   4   : 4                             
    ##                       NA's: 1   NA's: 1                             
    ##                                                                     
    ##  extra_curricular sports_extra_curricular exercise_per_week meditate pray  
    ##  0:48             0:65                    0:24              0:50     0: 9  
    ##  1:53             1:36                    1:49              1:35     1:24  
    ##                                           2:23              2: 7     2:19  
    ##                                           3: 5              3: 9     3:49  
    ##                                                                            
    ##                                                                            
    ##  internet laptop  family_relationships friendships romantic_relationships
    ##  0:14     0:  1   1   : 0              1   : 0     0:57                  
    ##  1:87     1:100   2   : 2              2   : 3     1: 0                  
    ##                   3   :18              3   :17     2: 6                  
    ##                   4   :39              4   :56     3:27                  
    ##                   5   :41              5   :24     4:11                  
    ##                   NA's: 1              NA's: 1                           
    ##  spiritual_wellnes financial_wellness  health   day_out night_out
    ##  1   : 1           1   :10            1   : 2   0:28    0:56     
    ##  2   : 8           2   :18            2   : 3   1:67    1:41     
    ##  3   :37           3   :41            3   :22   2: 5    2: 2     
    ##  4   :33           4   :21            4   :35   3: 1    3: 2     
    ##  5   :21           5   :10            5   :38                    
    ##  NA's: 1           NA's: 1            NA's: 1                    
    ##  alcohol_or_narcotics mentor mentor_meetings
    ##  0:69                 0:60   0:54           
    ##  1:30                 1:41   1:29           
    ##  2: 1                        2:15           
    ##  3: 1                        3: 3           
    ##                                             
    ##                                             
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No GRADE       PC1          
    ##  0:96                                       A:23   Min.   :-29.0802  
    ##  1: 5                                       B:25   1st Qu.: -1.2739  
    ##                                             C:22   Median :  0.8075  
    ##                                             D:25   Mean   :  0.0000  
    ##                                             E: 6   3rd Qu.:  2.3507  
    ##                                                    Max.   :  4.7761  
    ##       PC2               PC3               PC4               PC5         
    ##  Min.   :-6.0292   Min.   :-5.1743   Min.   :-4.6047   Min.   :-3.3220  
    ##  1st Qu.:-1.8224   1st Qu.:-0.9794   1st Qu.:-0.8211   1st Qu.:-1.1044  
    ##  Median :-0.1072   Median :-0.3059   Median :-0.1028   Median :-0.0842  
    ##  Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000  
    ##  3rd Qu.: 1.9745   3rd Qu.: 1.3337   3rd Qu.: 0.7405   3rd Qu.: 0.9675  
    ##  Max.   : 8.5920   Max.   : 3.4238   Max.   : 4.2739   Max.   : 3.8495  
    ##       PC6               PC7                PC8                PC9          
    ##  Min.   :-4.0445   Min.   :-3.45698   Min.   :-2.28482   Min.   :-3.15178  
    ##  1st Qu.:-0.7270   1st Qu.:-0.84643   1st Qu.:-0.72626   1st Qu.:-0.65504  
    ##  Median :-0.1041   Median : 0.01463   Median : 0.05503   Median : 0.06324  
    ##  Mean   : 0.0000   Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.00000  
    ##  3rd Qu.: 0.7777   3rd Qu.: 0.68178   3rd Qu.: 0.61259   3rd Qu.: 0.64827  
    ##  Max.   : 4.5666   Max.   : 2.70903   Max.   : 3.29926   Max.   : 2.86147  
    ##       PC10               PC11              PC12               PC13         
    ##  Min.   :-2.56428   Min.   :-2.3445   Min.   :-1.90652   Min.   :-2.60447  
    ##  1st Qu.:-0.72972   1st Qu.:-0.5604   1st Qu.:-0.65677   1st Qu.:-0.61294  
    ##  Median :-0.03854   Median :-0.1516   Median :-0.04625   Median :-0.08101  
    ##  Mean   : 0.00000   Mean   : 0.0000   Mean   : 0.00000   Mean   : 0.00000  
    ##  3rd Qu.: 0.62813   3rd Qu.: 0.4467   3rd Qu.: 0.49125   3rd Qu.: 0.64565  
    ##  Max.   : 3.02990   Max.   : 3.7255   Max.   : 2.49227   Max.   : 2.58209  
    ##       PC14                PC15               PC16               PC17        
    ##  Min.   :-2.253277   Min.   :-2.03227   Min.   :-1.72563   Min.   :-1.7175  
    ##  1st Qu.:-0.627053   1st Qu.:-0.54136   1st Qu.:-0.65440   1st Qu.:-0.5330  
    ##  Median :-0.001891   Median :-0.01767   Median :-0.02003   Median : 0.0202  
    ##  Mean   : 0.000000   Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.0000  
    ##  3rd Qu.: 0.550224   3rd Qu.: 0.53962   3rd Qu.: 0.56529   3rd Qu.: 0.5888  
    ##  Max.   : 2.818436   Max.   : 2.51132   Max.   : 1.81832   Max.   : 2.5265  
    ##       PC18               PC19               PC20              PC21        
    ##  Min.   :-1.95606   Min.   :-2.35602   Min.   :-1.3591   Min.   :-1.6233  
    ##  1st Qu.:-0.45285   1st Qu.:-0.47746   1st Qu.:-0.5072   1st Qu.:-0.4803  
    ##  Median :-0.03402   Median : 0.06024   Median :-0.0555   Median : 0.0253  
    ##  Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.0000   Mean   : 0.0000  
    ##  3rd Qu.: 0.51364   3rd Qu.: 0.48462   3rd Qu.: 0.3791   3rd Qu.: 0.4751  
    ##  Max.   : 1.93539   Max.   : 1.60045   Max.   : 2.0449   Max.   : 1.6955  
    ##       PC22               PC23               PC24               PC25          
    ##  Min.   :-1.99456   Min.   :-1.81797   Min.   :-1.62616   Min.   :-1.866701  
    ##  1st Qu.:-0.42794   1st Qu.:-0.36771   1st Qu.:-0.50413   1st Qu.:-0.391229  
    ##  Median : 0.06884   Median :-0.01832   Median :-0.03224   Median : 0.003037  
    ##  Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.00000   Mean   : 0.000000  
    ##  3rd Qu.: 0.43460   3rd Qu.: 0.44841   3rd Qu.: 0.52295   3rd Qu.: 0.415524  
    ##  Max.   : 1.30291   Max.   : 1.45093   Max.   : 1.21432   Max.   : 1.522001  
    ##       PC26         
    ##  Min.   :-1.71485  
    ##  1st Qu.:-0.24444  
    ##  Median : 0.02965  
    ##  Mean   : 0.00000  
    ##  3rd Qu.: 0.35199  
    ##  Max.   : 1.65921

``` r
dim(student_performance_dataset_pca_dr)
```

    ## [1] 101  77

``` r
## STEP 9.b. PCA Linear Algebra Transform for Feature Extraction ----

student_performance_dataset_fe <- princomp(cor(student_performance_dataset[, 98:99]))
summary(student_performance_dataset_fe)
```

    ## Importance of components:
    ##                            Comp.1 Comp.2
    ## Standard deviation     0.05349521      0
    ## Proportion of Variance 1.00000000      0
    ## Cumulative Proportion  1.00000000      1

## Scree Plot, Biplot and Cos2 Combined Plot

``` r
#### Scree Plot ----
# The Scree Plot shows that the 1st 2 principal components can cumulatively
# explain 92.8% of the variance, i.e., 87.7% + 5.1% = 92.8%.
factoextra::fviz_eig(student_performance_dataset_fe, addlabels = TRUE)
```

![](Lab-Submission-Markdown_files/figure-gfm/Scree%20Plot-1.png)<!-- -->

``` r
student_performance_dataset_fe$loadings[, 1:2]
```

    ##                                            Comp.1    Comp.2
    ## EXAM: x/60 (60%)                        0.7071068 0.7071068
    ## TOTAL = Coursework TOTAL + EXAM (100%) -0.7071068 0.7071068

``` r
factoextra::fviz_cos2(student_performance_dataset_fe, choice = "var", axes = 1:2)
```

![](Lab-Submission-Markdown_files/figure-gfm/Scree%20Plot-2.png)<!-- -->

``` r
factoextra::fviz_pca_var(student_performance_dataset_fe, col.var = "cos2",
                         gradient.cols = c("red", "orange", "green"),
                         repel = TRUE)
```

![](Lab-Submission-Markdown_files/figure-gfm/Scree%20Plot-3.png)<!-- -->

``` r
if (!is.element("fastICA", installed.packages()[, 1])) {
  install.packages("fastICA", dependencies = TRUE)
}
require("fastICA")
```

    ## Loading required package: fastICA

## ICA for Dimensionality Reduction

``` r
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0:90        
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1:11        
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00                
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.03                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0:74         0:48             0:65                    0:24             
    ##  1:27         1:53             1:36                    1:49             
    ##                                                        2:23             
    ##                                                        3: 5             
    ##                                                                         
    ##                                                                         
    ##  meditate pray   internet laptop  family_relationships friendships
    ##  0:50     0: 9   0:14     0:  1   1   : 0              1   : 0    
    ##  1:35     1:24   1:87     1:100   2   : 2              2   : 3    
    ##  2: 7     2:19                    3   :18              3   :17    
    ##  3: 9     3:49                    4   :39              4   :56    
    ##                                   5   :41              5   :24    
    ##                                   NA's: 1              NA's: 1    
    ##  romantic_relationships spiritual_wellnes financial_wellness  health   day_out
    ##  0:57                   1   : 1           1   :10            1   : 2   0:28   
    ##  1: 0                   2   : 8           2   :18            2   : 3   1:67   
    ##  2: 6                   3   :37           3   :41            3   :22   2: 5   
    ##  3:27                   4   :33           4   :21            4   :35   3: 1   
    ##  4:11                   5   :21           5   :10            5   :38          
    ##                         NA's: 1           NA's: 1            NA's: 1          
    ##  night_out alcohol_or_narcotics mentor mentor_meetings
    ##  0:56      0:69                 0:60   0:54           
    ##  1:41      1:30                 1:41   1:29           
    ##  2: 2      2: 1                        2:15           
    ##  3: 2      3: 1                        3: 3           
    ##                                                       
    ##                                                       
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.000                       
    ##  1st Qu.:4.000                    1st Qu.:4.000                       
    ##  Median :5.000                    Median :5.000                       
    ##  Mean   :4.446                    Mean   :4.634                       
    ##  3rd Qu.:5.000                    3rd Qu.:5.000                       
    ##  Max.   :5.000                    Max.   :5.000                       
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:4.000                                                                                  
    ##  Median :4.000                                                                                  
    ##  Mean   :4.307                                                                                  
    ##  3rd Qu.:5.000                                                                                  
    ##  Max.   :5.000                                                                                  
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:4.000                                                                                    
    ##  Median :5.000                                                                                    
    ##  Mean   :4.693                                                                                    
    ##  3rd Qu.:5.000                                                                                    
    ##  Max.   :5.000                                                                                    
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.000                                      
    ##  1st Qu.:4.000                                      
    ##  Median :5.000                                      
    ##  Mean   :4.604                                      
    ##  3rd Qu.:5.000                                      
    ##  Max.   :5.000                                      
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.000                                    
    ##  Mean   :4.069                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.000                                                     
    ##  1st Qu.:4.000                                                     
    ##  Median :4.000                                                     
    ##  Mean   :4.337                                                     
    ##  3rd Qu.:5.000                                                     
    ##  Max.   :5.000                                                     
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.000                                          
    ##  1st Qu.:4.000                                          
    ##  Median :5.000                                          
    ##  Mean   :4.564                                          
    ##  3rd Qu.:5.000                                          
    ##  Max.   :5.000                                          
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.000                     
    ##  1st Qu.:4.000                     
    ##  Median :5.000                     
    ##  Mean   :4.535                     
    ##  3rd Qu.:5.000                     
    ##  Max.   :5.000                     
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :5.000                                    
    ##  Mean   :4.505                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.000                              
    ##  1st Qu.:4.000                              
    ##  Median :5.000                              
    ##  Mean   :4.653                              
    ##  3rd Qu.:5.000                              
    ##  Max.   :5.000                              
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.000                                                                        
    ##  1st Qu.:4.000                                                                        
    ##  Median :4.000                                                                        
    ##  Mean   :4.208                                                                        
    ##  3rd Qu.:5.000                                                                        
    ##  Max.   :5.000                                                                        
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.000                                                    
    ##  1st Qu.:3.000                                                    
    ##  Median :4.000                                                    
    ##  Mean   :3.901                                                    
    ##  3rd Qu.:5.000                                                    
    ##  Max.   :5.000                                                    
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.000                            
    ##  1st Qu.:4.000                            
    ##  Median :5.000                            
    ##  Mean   :4.545                            
    ##  3rd Qu.:5.000                            
    ##  Max.   :5.000                            
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:4.000                                                      
    ##  Median :5.000                                                      
    ##  Mean   :4.564                                                      
    ##  3rd Qu.:5.000                                                      
    ##  Max.   :5.000                                                      
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:4.000                                                                                                      
    ##  Median :5.000                                                                                                      
    ##  Mean   :4.505                                                                                                      
    ##  3rd Qu.:5.000                                                                                                      
    ##  Max.   :5.000                                                                                                      
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.000                       
    ##  1st Qu.:4.000                       
    ##  Median :4.000                       
    ##  Mean   :4.149                       
    ##  3rd Qu.:5.000                       
    ##  Max.   :5.000                       
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.04                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.000                        Min.   :0.000         
    ##  1st Qu.:4.000                        1st Qu.:4.000         
    ##  Median :4.000                        Median :5.000         
    ##  Mean   :4.129                        Mean   :4.554         
    ##  3rd Qu.:5.000                        3rd Qu.:5.000         
    ##  Max.   :5.000                        Max.   :5.000         
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.000                                     
    ##  1st Qu.:4.000                                     
    ##  Median :5.000                                     
    ##  Mean   :4.554                                     
    ##  3rd Qu.:5.000                                     
    ##  Max.   :5.000                                     
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.000                                                                                                                                                                                                                                                                                
    ##  1st Qu.:4.000                                                                                                                                                                                                                                                                                
    ##  Median :5.000                                                                                                                                                                                                                                                                                
    ##  Mean   :4.495                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:5.000                                                                                                                                                                                                                                                                                
    ##  Max.   :5.000                                                                                                                                                                                                                                                                                
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.000                                                                                                                                                                   
    ##  1st Qu.:4.000                                                                                                                                                                   
    ##  Median :5.000                                                                                                                                                                   
    ##  Mean   :4.446                                                                                                                                                                   
    ##  3rd Qu.:5.000                                                                                                                                                                   
    ##  Max.   :5.000                                                                                                                                                                   
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.000                           
    ##  1st Qu.:4.000                           
    ##  Median :5.000                           
    ##  Mean   :4.287                           
    ##  3rd Qu.:5.000                           
    ##  Max.   :5.000                           
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.000                    Min.   :0.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.486                    Mean   :4.054                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.000                                    
    ##  1st Qu.:4.000                                    
    ##  Median :4.545                                    
    ##  Mean   :4.388                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.005                  Mean   : 62.39                  
    ##  3rd Qu.:1.000                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 0.000                   
    ##  1st Qu.:11.53                           1st Qu.: 7.000                   
    ##  Median :15.33                           Median : 9.000                   
    ##  Mean   :16.36                           Mean   : 9.342                   
    ##  3rd Qu.:19.63                           3rd Qu.:12.000                   
    ##  Max.   :31.25                           Max.   :15.000                   
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 0.00                         Min.   : 0.000                         
    ##  1st Qu.:10.17                         1st Qu.: 4.330                         
    ##  Median :13.08                         Median : 6.000                         
    ##  Mean   :13.11                         Mean   : 5.611                         
    ##  3rd Qu.:17.50                         3rd Qu.: 7.670                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.752                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                 
    ##  1st Qu.:3.000                                                 
    ##  Median :4.850                                                 
    ##  Mean   :3.919                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.000                                                  
    ##  1st Qu.:4.850                                                  
    ##  Median :4.850                                                  
    ##  Mean   :4.218                                                  
    ##  3rd Qu.:4.850                                                  
    ##  Max.   :5.000                                                  
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.000                                    
    ##  1st Qu.:2.850                                    
    ##  Median :4.850                                    
    ##  Mean   :3.636                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   : 0.00          Min.   :  0.00         
    ##  1st Qu.:57.89          1st Qu.:  0.00         
    ##  Median :68.42          Median : 52.00         
    ##  Mean   :66.65          Mean   : 43.06         
    ##  3rd Qu.:82.89          3rd Qu.: 68.00         
    ##  Max.   :97.36          Max.   :100.00         
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 0.00   
    ##  1st Qu.:20.44                1st Qu.:25.00   
    ##  Median :24.58                Median :33.00   
    ##  Mean   :24.53                Mean   :32.59   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72

``` r
model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center", "ica"),
                                     n.comp = 8)
print(model_of_the_transform)
```

    ## Created from 100 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - independent component signal extraction (49)
    ##   - ignored (51)
    ##   - scaled (49)
    ## 
    ## ICA used 8 components

``` r
student_performance_ica_dr <- predict(model_of_the_transform, student_performance_dataset)

summary(student_performance_ica_dr)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time paid_tuition free_tuition
    ##  1:19          1:18   1   :16   1   :45    0:90         0:74        
    ##  2:26          2:28   2   :23   2   :39    1:11         1:27        
    ##  3:38          3:30   3   :33   3   :12                             
    ##  4:18          4:25   4   :28   4   : 4                             
    ##                       NA's: 1   NA's: 1                             
    ##                                                                     
    ##  extra_curricular sports_extra_curricular exercise_per_week meditate pray  
    ##  0:48             0:65                    0:24              0:50     0: 9  
    ##  1:53             1:36                    1:49              1:35     1:24  
    ##                                           2:23              2: 7     2:19  
    ##                                           3: 5              3: 9     3:49  
    ##                                                                            
    ##                                                                            
    ##  internet laptop  family_relationships friendships romantic_relationships
    ##  0:14     0:  1   1   : 0              1   : 0     0:57                  
    ##  1:87     1:100   2   : 2              2   : 3     1: 0                  
    ##                   3   :18              3   :17     2: 6                  
    ##                   4   :39              4   :56     3:27                  
    ##                   5   :41              5   :24     4:11                  
    ##                   NA's: 1              NA's: 1                           
    ##  spiritual_wellnes financial_wellness  health   day_out night_out
    ##  1   : 1           1   :10            1   : 2   0:28    0:56     
    ##  2   : 8           2   :18            2   : 3   1:67    1:41     
    ##  3   :37           3   :41            3   :22   2: 5    2: 2     
    ##  4   :33           4   :21            4   :35   3: 1    3: 2     
    ##  5   :21           5   :10            5   :38                    
    ##  NA's: 1           NA's: 1            NA's: 1                    
    ##  alcohol_or_narcotics mentor mentor_meetings
    ##  0:69                 0:60   0:54           
    ##  1:30                 1:41   1:29           
    ##  2: 1                        2:15           
    ##  3: 1                        3: 3           
    ##                                             
    ##                                             
    ##  D - 1. \r\nWrite two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                               
    ##  Class :character                                                                         
    ##  Mode  :character                                                                         
    ##                                                                                           
    ##                                                                                           
    ##                                                                                           
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No GRADE       ICA1        
    ##  0:96                                       A:23   Min.   :-1.7397  
    ##  1: 5                                       B:25   1st Qu.:-0.8713  
    ##                                             C:22   Median :-0.1351  
    ##                                             D:25   Mean   : 0.0000  
    ##                                             E: 6   3rd Qu.: 0.8374  
    ##                                                    Max.   : 2.0194  
    ##       ICA2              ICA3              ICA4               ICA5        
    ##  Min.   :-1.6749   Min.   :-4.5763   Min.   :-2.24303   Min.   :-2.7431  
    ##  1st Qu.:-0.6246   1st Qu.:-0.4551   1st Qu.:-0.79228   1st Qu.:-0.6486  
    ##  Median :-0.2464   Median : 0.2033   Median :-0.06048   Median :-0.1620  
    ##  Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.00000   Mean   : 0.0000  
    ##  3rd Qu.: 0.3858   3rd Qu.: 0.6948   3rd Qu.: 0.88237   3rd Qu.: 0.2863  
    ##  Max.   : 4.2505   Max.   : 1.9254   Max.   : 1.99493   Max.   : 4.3337  
    ##       ICA6              ICA7               ICA8         
    ##  Min.   :-8.0568   Min.   :-2.28722   Min.   :-3.89325  
    ##  1st Qu.:-0.3228   1st Qu.:-0.52078   1st Qu.:-0.44861  
    ##  Median : 0.1643   Median :-0.01807   Median : 0.09068  
    ##  Mean   : 0.0000   Mean   : 0.00000   Mean   : 0.00000  
    ##  3rd Qu.: 0.5386   3rd Qu.: 0.30972   3rd Qu.: 0.66752  
    ##  Max.   : 1.1925   Max.   : 3.38340   Max.   : 2.12764
