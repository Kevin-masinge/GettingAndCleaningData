# Code Book

This code book describes the variables, the data, and the
transformations performed to create `tidy_data.txt` from the raw
**UCI HAR Dataset** (Human Activity Recognition Using Smartphones).

## Study design and data collection

The original data was collected from 30 volunteers (subjects), aged
19-48, each performing six activities (`WALKING`, `WALKING_UPSTAIRS`,
`WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`) while wearing a
Samsung Galaxy S smartphone on their waist. Using the phone's
embedded accelerometer and gyroscope, 3-axial linear acceleration and
3-axial angular velocity were captured at a constant rate of 50 Hz.

The original data set was randomly partitioned into a training set
(70% of volunteers) and a test set (30% of volunteers). The sensor
signals were pre-processed by applying noise filters and sampled in
fixed-width sliding windows of 2.56 sec with 50% overlap (128
readings/window). From each window, a vector of features was
computed from the time and frequency domain (via Fast Fourier
Transform).

For full details on the original feature set, see
`features_info.txt` in the raw data download.

## Transformations performed by `run_analysis.R`

1. The training (`X_train.txt`, `y_train.txt`, `subject_train.txt`)
   and test (`X_test.txt`, `y_test.txt`, `subject_test.txt`) data sets
   were combined into a single data set with `rbind()`, after first
   binding each set's subject ID, activity ID, and feature columns
   together with `cbind()`.
2. Column names for the 561 feature variables were assigned from
   `features.txt`.
3. Only the columns whose original names contained `mean()` or
   `std()` were retained, along with `subject` and `activity_id`.
   These represent the mean value and standard deviation for each
   measurement, respectively. (Note: variables containing
   `meanFreq()` -- the weighted average of the frequency components --
   were **not** included, since this code book only retains literal
   `mean()` and `std()` measurements as specified by the project.)
4. The numeric `activity_id` (1-6) was replaced with a descriptive
   `activity_name` (e.g. `WALKING`) by merging with
   `activity_labels.txt`. The `activity_id` column was then removed.
5. Variable names were cleaned up to be more descriptive and
   human-readable:
   - Leading `t` was expanded to `Time`
   - Leading `f` was expanded to `Frequency`
   - `Acc` was expanded to `Accelerometer`
   - `Gyro` was expanded to `Gyroscope`
   - `Mag` was expanded to `Magnitude`
   - `BodyBody` (a typo in the original data set) was corrected to
     `Body`
   - `-mean()` was replaced with `Mean`
   - `-std()` was replaced with `Std`
   - All remaining hyphens (`-`) were removed
6. The columns were reordered so that `subject` and `activity_name`
   appear first.
7. A second, independent tidy data set (`tidy_data.txt`) was created
   by grouping the cleaned data by `subject` and `activity_name`, and
   computing the **mean of every measurement variable** within each
   group using `dplyr::summarise(across(everything(), mean))`.

## Variables in `tidy_data.txt`

The final tidy data set contains **68 columns** and **180 rows**
(30 subjects x 6 activities).

### Identifier variables

| Variable        | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `subject`        | Integer ID (1-30) identifying the volunteer who performed the activity      |
| `activity_name`  | Activity performed: `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING` |

### Measurement variables

Each of the remaining 66 variables is the **average across all
observations** (within a given subject/activity combination) of one
of the original mean() or std() feature measurements. All values are
**unitless**, as the original signals were normalized and bounded
within `[-1, 1]`.

Variable names follow a consistent naming pattern, built from the
components below:

| Component        | Meaning                                                                |
|-------------------|--------------------------------------------------------------------|
| `Time`            | Measurement taken in the time domain (original prefix `t`)          |
| `Frequency`       | Measurement taken in the frequency domain, via FFT (original prefix `f`) |
| `Body`            | Signal component related to body motion                              |
| `Gravity`         | Signal component related to gravity                                  |
| `Accelerometer`   | Signal from the accelerometer sensor                                 |
| `Gyroscope`       | Signal from the gyroscope sensor                                     |
| `Jerk`            | Jerk signal, derived by deriving the body acceleration/angular velocity |
| `Magnitude`       | Magnitude of the 3-axial signal, calculated using the Euclidean norm |
| `Mean`            | Mean value of the signal within the window (original suffix `-mean()`) |
| `Std`             | Standard deviation of the signal within the window (original suffix `-std()`) |
| `X`, `Y`, `Z`     | Axis along which the measurement was taken (3-axial signals only)   |

The 66 measurement variable names are:

1. `TimeBodyAccelerometerMeanX`
2. `TimeBodyAccelerometerMeanY`
3. `TimeBodyAccelerometerMeanZ`
4. `TimeBodyAccelerometerStdX`
5. `TimeBodyAccelerometerStdY`
6. `TimeBodyAccelerometerStdZ`
7. `TimeGravityAccelerometerMeanX`
8. `TimeGravityAccelerometerMeanY`
9. `TimeGravityAccelerometerMeanZ`
10. `TimeGravityAccelerometerStdX`
11. `TimeGravityAccelerometerStdY`
12. `TimeGravityAccelerometerStdZ`
13. `TimeBodyAccelerometerJerkMeanX`
14. `TimeBodyAccelerometerJerkMeanY`
15. `TimeBodyAccelerometerJerkMeanZ`
16. `TimeBodyAccelerometerJerkStdX`
17. `TimeBodyAccelerometerJerkStdY`
18. `TimeBodyAccelerometerJerkStdZ`
19. `TimeBodyGyroscopeMeanX`
20. `TimeBodyGyroscopeMeanY`
21. `TimeBodyGyroscopeMeanZ`
22. `TimeBodyGyroscopeStdX`
23. `TimeBodyGyroscopeStdY`
24. `TimeBodyGyroscopeStdZ`
25. `TimeBodyGyroscopeJerkMeanX`
26. `TimeBodyGyroscopeJerkMeanY`
27. `TimeBodyGyroscopeJerkMeanZ`
28. `TimeBodyGyroscopeJerkStdX`
29. `TimeBodyGyroscopeJerkStdY`
30. `TimeBodyGyroscopeJerkStdZ`
31. `TimeBodyAccelerometerMagnitudeMean`
32. `TimeBodyAccelerometerMagnitudeStd`
33. `TimeGravityAccelerometerMagnitudeMean`
34. `TimeGravityAccelerometerMagnitudeStd`
35. `TimeBodyAccelerometerJerkMagnitudeMean`
36. `TimeBodyAccelerometerJerkMagnitudeStd`
37. `TimeBodyGyroscopeMagnitudeMean`
38. `TimeBodyGyroscopeMagnitudeStd`
39. `TimeBodyGyroscopeJerkMagnitudeMean`
40. `TimeBodyGyroscopeJerkMagnitudeStd`
41. `FrequencyBodyAccelerometerMeanX`
42. `FrequencyBodyAccelerometerMeanY`
43. `FrequencyBodyAccelerometerMeanZ`
44. `FrequencyBodyAccelerometerStdX`
45. `FrequencyBodyAccelerometerStdY`
46. `FrequencyBodyAccelerometerStdZ`
47. `FrequencyBodyAccelerometerJerkMeanX`
48. `FrequencyBodyAccelerometerJerkMeanY`
49. `FrequencyBodyAccelerometerJerkMeanZ`
50. `FrequencyBodyAccelerometerJerkStdX`
51. `FrequencyBodyAccelerometerJerkStdY`
52. `FrequencyBodyAccelerometerJerkStdZ`
53. `FrequencyBodyGyroscopeMeanX`
54. `FrequencyBodyGyroscopeMeanY`
55. `FrequencyBodyGyroscopeMeanZ`
56. `FrequencyBodyGyroscopeStdX`
57. `FrequencyBodyGyroscopeStdY`
58. `FrequencyBodyGyroscopeStdZ`
59. `FrequencyBodyAccelerometerMagnitudeMean`
60. `FrequencyBodyAccelerometerMagnitudeStd`
61. `FrequencyBodyAccelerometerJerkMagnitudeMean`
62. `FrequencyBodyAccelerometerJerkMagnitudeStd`
63. `FrequencyBodyGyroscopeMagnitudeMean`
64. `FrequencyBodyGyroscopeMagnitudeStd`
65. `FrequencyBodyGyroscopeJerkMagnitudeMean`
66. `FrequencyBodyGyroscopeJerkMagnitudeStd`

All measurement values represent the **average** (across all windows
for that subject/activity combination) of the original normalized
sensor reading, and therefore range between **-1 and 1** (unitless).
