clc
clear all

file1 = 'Dataset_T2_40d_CFS_BIN.arff';
file2 = 'Dataset_T2_40d_PCA_BIN.arff';
file3 = 'Dataset_T2_40d_REL_BIN.arff';
file4 = 'DatasetMinusIds.arff';

data1 = importdata(file1);
data2 = importdata(file2);
data3 = importdata(file3);
data4 = importdata(file4);


numFeatures1 = size(data1.data,2)-1;
myNames1 = [1:numFeatures1];
names1 = cellstr(num2str(myNames1'))';
names12 = names1;
names1{end+1} = 'Y';

featuresCFS = data1.data(:,1:end);
inputTableCFS = array2table(featuresCFS, 'VariableNames', names1);
predictorsCFS = inputTableCFS(:, names12);
isCategoricalPredictorCFS(numFeatures1) = false;


numFeatures2 = size(data2.data,2)-1;
myNames2 = [1:numFeatures2];
names2 = cellstr(num2str(myNames2'))';
names22 = names1;
names2{end+1} = 'Y';

featuresPCA = data2.data(:,1:end);
inputTablePCA = array2table(featuresPCA, 'VariableNames', names2);
predictorsPCA = inputTablePCA(:, names22);
isCategoricalPredictorPCA(numFeatures2) = false;



numFeatures3 = size(data3.data,2)-1;
myNames3 = [1:numFeatures3];
names3 = cellstr(num2str(myNames3'))';
names32 = names3;
names3{end+1} = 'Y';

featuresREL = data3.data(:,1:end);
inputTableREL = array2table(featuresREL, 'VariableNames', names3);
predictorsREL = inputTableREL(:, names32);
isCategoricalPredictor3(numFeatures2) = false;



numFeatures4 = size(data4,2)-1;
myNames4 = [1:numFeatures4];
names4 = cellstr(num2str(myNames4'))';
names42 = names4;
names4{end+1} = 'Y';

featuresAll = data4(:,1:end);
inputTableAll = array2table(featuresAll, 'VariableNames', names4);
predictorsAll = inputTableAll(:, names42);
isCategoricalPredictorAll(numFeatures4) = false;



alpha = 0.05;
distance = 'euclidean';
NumNeighbours = 15;
distanceWeight = 'equal';


CCFS = fitcknn(predictorsCFS, inputTableCFS.Y, 'Distance', distance, 'Exponent', [], ...
    'NumNeighbors', NumNeighbours, 'DistanceWeight', distanceWeight, ...
    'Standardize', true, 'ClassNames', [0; 1]);

CPCA = fitcknn( predictorsPCA, inputTablePCA.Y, 'Distance', distance, 'Exponent', [], ...
    'NumNeighbors', NumNeighbours, 'DistanceWeight', distanceWeight, ...
    'Standardize', true, 'ClassNames', [0; 1]);

CREL = fitcknn( predictorsREL, inputTableREL.Y, 'Distance', distance, 'Exponent', [], ...
    'NumNeighbors', NumNeighbours, 'DistanceWeight', distanceWeight, ...
    'Standardize', true, 'ClassNames', [0; 1]);

CAll = fitcknn( predictorsAll, inputTableAll.Y, 'Distance', distance, 'Exponent', [], ...
    'NumNeighbors', NumNeighbours, 'DistanceWeight', distanceWeight, ...
    'Standardize', true, 'ClassNames', [0; 1]);

[h1,p1,e11,e21] = testckfold(CCFS, CPCA, inputTableCFS, inputTablePCA, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h2,p2,e12,e22] = testckfold(CCFS, CREL, inputTableCFS, inputTableREL, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h3,p3,e13,e23] = testckfold(CCFS, CAll, inputTableCFS, inputTableAll, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)



[h5,p5,e15,e25] = testckfold(CPCA, CCFS, inputTablePCA, inputTableCFS, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h6,p6,e16,e26] = testckfold(CPCA, CREL, inputTablePCA, inputTableREL, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h7,p7,e17,e27] = testckfold(CPCA, CAll, inputTablePCA, inputTableAll, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)


[h8,p8,e18,e28] = testckfold(CREL, CCFS, inputTableREL, inputTableCFS, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h9,p9,e19,e29] = testckfold(CREL, CPCA, inputTableREL, inputTablePCA, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h10,p10,e110,e210] = testckfold(CREL, CAll, inputTableREL, inputTableAll, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)


[h11,p11,e111,e211] = testckfold(CAll, CCFS, inputTableAll, inputTableCFS, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h12,p12,e112,e212] = testckfold(CAll, CPCA, inputTableAll, inputTablePCA, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)
[h13,p13,e113,e213] = testckfold(CAll, CREL, inputTableAll, inputTableREL, ...
    'Test','10x10t', 'Alternative','greater', 'Alpha', alpha)


pvalues = [0 p1 p2 p3; p5 0 p6 p7; p8 p9 0 p10; p11 p12 p13 0];

hresults = [0 h1 h2 h3; h5 0 h6 h7; h8 h9 0 h10; h11 h12 h13 0];


