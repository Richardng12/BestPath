function [pathRow,pathCol,pathElev] = BestGreedyPathHeadingEast(E)
%This function will find the best greedy path starting from the westerly
%position, i.e all the paths from column 1, heading to the end of the last
%column. If there is more than one path that has the lowest cost, the path
%that started with the lowest row number will be returned.

%Inputs:   E = the elevation data stored in a 2d r x c matrix
%Outputs:  pathRow = a 1d array representing the row indices of the path
%          pathCol = a 1d array representing the column indices of the path
%          pathElev = a 1d array representing the elevations for the
%                     corresponding row and column indices for the path
%Author: Richard Ng
Orientation = 1; %heading east only

%create empty arrays for the outputs, and also an empty costs array
costs = [];
pathRow = [];
pathCol = [];
pathElev = [];
for i = 1:size(E,1) %for loop that loops the whole of the first column
    
    %sets the current position, as looping through the each number in the
    %first column, as we are always going to start from the westerly edge.
    %So, the column number will always be 1, and the row number will start
    %from 1, and end at the last row number. So this effectively gets the
    %currentPosition for every number in the first column
    currentPos = [i,1];
    
    %call function which finds the Greedypath from a specified start
    %position.
    [pathRows,pathCols] = GreedyWalk(currentPos,Orientation,E);
    
    %call function to find elevation data and cost of that greedypath
    [elev,cost] = FindPathElevationsAndCost(pathRows,pathCols,E);
    
    %Puts the elevation data, cost data and path data into 2d arrays.
    pathElev = [pathElev;elev];
    pathRow = [pathRow;pathRows];
    pathCol = [pathCol;pathCols];
    costs = [costs;cost];
end

%finds the row number, in which the minimum cost is held
costRow = find(costs == min(costs));


%if there is more than two paths with same lowest cost, displays the path
%that has the lower row number, e.g row 1. This is done by comparing the
%position in the array that has the lowest cost, and relating it to the
%position of the pathRow, pathCol and pathElev that resulted in that lowest
%cost, as they will be in the same position in their relative array. E.g
%the lowest cost, and its corresponding pathElev, pathRow and pathCol will
%all be in row 3 of their respective arrays. If there is only one path, the
%same method will work.
if size(costRow,1)>=1
    pathRow = pathRow(costRow(1),:);
    pathCol = pathCol(costRow(1),:);
    pathElev = pathElev(costRow(1),:);
end
end



