function [smallestPos] = FindSmallestElevationChange(cElevation,...
    nElevation)
%This function takes the current elevation as a number, and compares it
%with an 1d array of new elevations, then displaying the element which
%gives the smallest change in elevation (the minimum). If there is more
%than one element which gives the smallest change, both positions will be
%displayed

%Inputs:
%cElevation = Current Elevation
%nElevation = New Elevations

%Outputs:
%smallestPosition = the position of the element in the array which gives
%the smallest change in elevation
%Author: Richard Ng


%The values of the new elevations minus the current elevation to find
%the difference in elevation for each value in the nElevation array.
%These differences are compared to the minimum of these differences
%If that difference was a minimum, then a value of one is returned in the
%array. The find function will cycle through this array, only returning the
%positions with the ones, as the find function only returns non-zero
%numbers.Note the use of the abs function, incase negative values are
%calculated

smallestPos = find(abs(nElevation-cElevation)==min(abs(nElevation...
    - cElevation)));
end







