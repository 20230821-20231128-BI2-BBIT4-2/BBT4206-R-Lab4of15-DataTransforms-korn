.libPaths()

lapply(.libPaths(), list.files)

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## factoextra --
if (require("factoextra")) {
  require("factoextra")
} else {
  install.packages("factoextra", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## FactoMineR ----
if (require("FactoMineR")) {
  require("FactoMineR")
} else {
  install.packages("FactoMineR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}



## STEP 2. Load the Datasets ----
student_performance_dataset <-
  readr::read_csv(
    "data/20230412-20230719-BI1-BBIT4-1-StudentPerformanceDataset.CSV", # nolint
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

## STEP 3. Apply a Scale Data Transform ----
# BEFORE
summary(student_performance_dataset)
# The code below converts column number 4 into unlisted and numeric data first
# so that a histogram can be plotted. Further reading:
student_performance_dataset_TOTAL <- as.numeric(unlist(student_performance_dataset[, 99]))
hist(student_performance_dataset_TOTAL, main = names(student_performance_dataset)[99])

model_of_the_transform <- preProcess(student_performance_dataset, method = c("scale"))
print(model_of_the_transform)
student_performance_data_scale_transform <- predict(model_of_the_transform, student_performance_dataset)

# AFTER
summary(student_performance_data_scale_transform)
student_performance_dataset_TOTAL <- as.numeric(unlist(student_performance_data_scale_transform[, 99]))
hist(student_performance_dataset_TOTAL, main = names(student_performance_data_scale_transform)[99])


## STEP 4. Apply a Centre Data Transform ----
summary(student_performance_dataset)
model_of_the_transform <- preProcess(student_performance_dataset, method = c("center"))
print(model_of_the_transform)
student_performance_data_center_transform <- predict(model_of_the_transform, student_performance_dataset)
summary(student_performance_data_center_transform)


## STEP 5. Apply a Standardize Data Transform ----
# BEFORE
summary(student_performance_dataset)
sapply(student_performance_dataset[, 99], sd)
model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
student_perfromance_data_standardize_transform <- predict(model_of_the_transform, student_performance_dataset) # nolint

# AFTER
summary(student_perfromance_data_standardize_transform)
sapply(student_perfromance_data_standardize_transform[, 99], sd)

## STEP 6. Apply a Normalize Data Transform ----
summary(student_performance_dataset)
model_of_the_transform <- preProcess(student_performance_dataset, method = c("range"))
print(model_of_the_transform)
student_perfromance_data_normalize_transform <- predict(model_of_the_transform, student_performance_dataset)
summary(student_perfromance_data_normalize_transform)


## STEP 7. Apply a Box-Cox Power Transform ----
# BEFORE
summary(student_perfromance_data_standardize_transform)

# Calculate the skewness before the Box-Cox transform
sapply(student_perfromance_data_standardize_transform[, 99],  skewness, type = 2)
sapply(student_perfromance_data_standardize_transform[, 99], sd)

model_of_the_transform <- preProcess(student_perfromance_data_standardize_transform,
                                     method = c("BoxCox"))
print(model_of_the_transform)
student_perfromance_data_box_cox_transform <- predict(model_of_the_transform,
                                       student_perfromance_data_standardize_transform)

# Calculate the skewness after the Box-Cox transform
sapply(student_perfromance_data_box_cox_transform[, 99],  skewness, type = 2)
sapply(student_perfromance_data_box_cox_transform[, 99], sd)


## STEP 8. Apply a Yeo-Johnson Power Transform ----
# BEFORE
summary(student_perfromance_data_standardize_transform)

# Calculate the skewness before the Yeo-Johnson transform
sapply(student_perfromance_data_standardize_transform[, 99],  skewness, type = 2)
sapply(student_perfromance_data_standardize_transform[, 99], sd)

model_of_the_transform <- preProcess(student_perfromance_data_standardize_transform,
                                     method = c("YeoJohnson"))
print(model_of_the_transform)
student_perfromance_data_yeo_johnson_transform <- predict(model_of_the_transform, # nolint
                                           student_perfromance_data_standardize_transform)

# AFTER
summary(student_perfromance_data_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(student_perfromance_data_yeo_johnson_transform[, 99],  skewness, type = 2)
sapply(student_perfromance_data_yeo_johnson_transform[, 99], sd)


## STEP 9.a. PCA Linear Algebra Transform for Dimensionality Reduction ----
summary(student_performance_dataset)

model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center", "pca"))
print(model_of_the_transform)
student_performance_dataset_pca_dr <- predict(model_of_the_transform, student_performance_dataset)

summary(student_performance_dataset_pca_dr)
dim(student_performance_dataset_pca_dr)


## STEP 9.b. PCA Linear Algebra Transform for Feature Extraction ----

student_performance_dataset_fe <- princomp(cor(student_performance_dataset[, 98:99]))
summary(student_performance_dataset_fe)


#### Scree Plot ----
# The Scree Plot shows that the 1st 2 principal components can cumulatively
# explain 92.8% of the variance, i.e., 87.7% + 5.1% = 92.8%.
factoextra::fviz_eig(student_performance_dataset_fe, addlabels = TRUE)

student_performance_dataset_fe$loadings[, 1:2]

factoextra::fviz_cos2(student_performance_dataset_fe, choice = "var", axes = 1:2)

#### Biplot and Cos2 Combined Plot ----
# This can be confirmed using the following visualization.

# Points to note when interpreting the visualization:
#    (i) All the variables that are grouped together are positively correlated.
#    (ii) The longer the arrow, the better represented the variable is.
#    (iii) Variables that are negatively correlated are displayed in the
#          opposite side of the origin.

factoextra::fviz_pca_var(student_performance_dataset_fe, col.var = "cos2",
                         gradient.cols = c("red", "orange", "green"),
                         repel = TRUE)


if (!is.element("fastICA", installed.packages()[, 1])) {
  install.packages("fastICA", dependencies = TRUE)
}
require("fastICA")


### ICA for Dimensionality Reduction on the Boston Housing Dataset ----
summary(student_performance_dataset)

model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center", "ica"),
                                     n.comp = 8)
print(model_of_the_transform)
student_performance_ica_dr <- predict(model_of_the_transform, student_performance_dataset)

summary(student_performance_ica_dr)
