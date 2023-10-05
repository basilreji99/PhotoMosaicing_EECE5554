close all

% Load images.
direc = ["latino_center","bricks","ruggles","caliberation"];
scene = imageDatastore(direc(4));

% Display images to be stitched.
montage(scene.Files)

% Create a set of calibration images.
images = imageDatastore(fullfile(toolboxdir("vision"), "visiondata", ...
    "calibration", "mono"));
imageFileNames = images.Files;

% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% Generate world coordinates of the corners of the squares.
squareSize = 29; % millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera.
I = readimage(images, 1); 
imageSize = [size(I, 1), size(I, 2)];
[params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
                                     ImageSize=imageSize);


figure; 
showExtrinsics(params, "CameraCentric");

figure; 
showExtrinsics(params, "PatternCentric");

figure; 
showReprojectionErrors(params,'ScatterPlot');

displayErrors(estimationErrors, params);
