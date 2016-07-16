# From features_info.txt in the original dataset, containing information about features.txt
### Please read README.md before proceeding.

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

# Data Preparation Process. Steps done out of order to simplify process.

### Download and open dataset if necessary.
Downloads as humanactivity.zip. It's extracted directly to the working directory.

### Get activity and feature labels.
There are two columns in activity_labels.txt: the numerical represent the physical activity labels, and the physical activity labels.
The labels are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.
The features are organized the same way in features.txt, but the first column is unnecessary.
They describe what columns to look at in the training and testing sets, because the sets don't have column names of their own.
See above for a more detailed description of this file.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
X_train.txt and X_test.txt contain the numerical measurements. The features that the columns show measurements for
are in the same order as the features in features.txt. A logical vector is created by matching any entry that contains "mean()" or "std()".
This is used to extract the correct columns of data in the correct order.

### 3. Uses descriptive activity names to name the activities in the data set.
y_train.txt and y_test.txt contain one column of numbers each, that represent the activity measured in each row.
This is attached to the datasets as a column of factors. This is necessary for the last steps.
If it's simply converted to text, the data in tidy.txt won't be in the right order.
Assign each row to a person from subject_train.txt and subject_test.txt the same way.
These don't need to be converted because they are already numbers, from 1 to 30.
Some of those are only in the training set and the rest are only in the testing set.

### 1. Merges the training and the test sets to create one data set.
### 4. Appropriately labels the data set with descriptive variable names.
Add another column to each, identifying them as part of the testing set or training set.
Stack the two sets one on top of the other.
Set the first three column names for the test status, person, and activity label.
The rest should be the features from features.txt, extracted by the logical vector.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Convert the data to longform with "melt" because R can handle that more efficiently. Select the first three columns as identifiers.
This will allow you to use dcast to quickly and easily find the average value for each feature, of each activity, for each person, and reshape the dataframe
in the order that you want.
The alternative requires ordering the data, first by person and then by activity,
looping through each person and activity, finding the mean, and attaching it to a new dataframe.
This takes more time and many more lines of code.

### tidy.txt
The original sets contained many values for each feature/activity/person combo. This dataset contains the averages for those values.
There are 180 rows; each of the 30 people has 6 rows, 1 for each activity.
The format is:
| Person  | Relevance to the dataset  |  Activity label | Feature 1  | Feature 2... |
| Subject1  | testing  |  WALKING | mean of feature 1  | mean of feature 2... |
| Subject2  | training  |  STANDING | mean of feature 1  | mean of feature 2... |