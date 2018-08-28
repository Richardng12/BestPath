function [elev,cost] = FindPathElevationsAndCost(rows,columns,E)
%This function takes a specified path, in rows and columns as its input,
%and finds the elevations encountered during this path, and also calculates
%the total cost travelling through this path. The total cost is calculated
%by summing up all the differences in each elevation.

%Inputs: rows = a 1D array  containing the row indices of the path
%        columns = a 1D array containing the  column indices of the path
%        E  = the elevation data stored in 2d matrix
%Author: Richard Ng

elev = []; %Set empty array

%spans the length of the array until it hits an edge(last column)
for i = 1:length(columns)
    %finds the current elevation given the rows and columns inputted
    currentElev = E(rows(i),columns(i));
    elev = [elev,currentElev]; %Puts this elevation data into an array
end

cost = 0; %set initial cost to 0

%spans the length of array until it hits the edge
for i = 1:length(columns)-1
    %finds the positive difference between the elevation data given.(this
    %is the cost)
    tempCost = abs(elev(i+1) - elev(i));
    %Get the total cost, by adding on the previous
    %costs until the end of the array has been reached
    cost = cost + tempCost;
end
