function [pathRow,pathCol,pathElev] =BestGreedyPath(E)
%This function will find the best greedypath, by calculating greedypaths
%for every element in the array, the array will be read like a book,
%starting from row 1 column 1, and then moving across the columns until the
%entire row 1 has been checked. For column 1, the best greedypath will be
%from the west going east, whereas for the last column, the best greedypath
%will be from east going to the west. Anywhere inbetween, the greedypaths
%going from the east and west must be added together to find the path data.
%If more than one path is discovered that has the lowest cost, the first
%path to be discovered will be returned.

%Inputs:  E = the elevation data stored in a 2d r x c matrix
%Outputs:  pathRow = a 1d array representing the row indices of the path
%          pathCol = a 1d array representing the column indices of the path
%          pathElev = a 1d array representing the elevations for the
%                     corresponding row and column indices for the path
%Author: Richard Ng

%Preallocation of arrays
pathRow = zeros(size(E,1)*size(E,2),size(E,2));
pathCol = zeros(size(E,1)*size(E,2),size(E,2));
pathElev = zeros(size(E,1)*size(E,2),size(E,2));

costArray = []; %create cost array

%counter to make sure each time a path is found, the pathRow,
%pathCol and pathElev data is added to the next row, so that a cost matrix
%is produced
count = 1;

for i = 1:size(E,1) %for loop, so it goes down the column
    for j = 1:size(E,2) %for loop so it reads like a book, going across row
        
        %sets currentPosition, starting from row 1, column 1
        currentPos = [i,j];
        if j == 1 %if on first column
            Orientation = 1; %going east
            
            %Call greedywalk function, to get the greedypath from column
            %one to the end of the array
            [pathRows,pathCols] = GreedyWalk(currentPos,Orientation,E);
            
            %call pathelevandcost function to get the cost and elevations
            %for that particular starting position
            [tempPathElev,cost] = FindPathElevationsAndCost(pathRows,...
                pathCols,E);
            
            
            %Put all the data into their respective arrays
            pathRow(count,:) = pathRows;
            pathCol(count,:) = pathCols;
            pathElev(count,:) = tempPathElev;
            costArray = [costArray;cost];
            
            %counter +1 so that the next data will be put into the next row
            %in the pathRow, pathCol and pathElev arrays
            count = count + 1;
            
        elseif j == size(E,2) %if on last column
            Orientation = -1; %going west
            
            %call greedywalk function
            [pathRows,pathCols] = GreedyWalk(currentPos,Orientation,E);
            
            %reverse the pathRows and pathCols, so that when the elevation
            %data is displayed, it is shown going from left to right. So
            %that if a path is found starting at the last column, it is
            %instead displayed as if starting from the first column, and
            %heading to the last column.
            pathRows = Reverse(pathRows);
            pathCols = Reverse(pathCols);
            
            %Call PathElevationAndCost function
            [tempPathElev,cost] = FindPathElevationsAndCost(pathRows,...
                pathCols,E);
            
            %Put all the data into arrays again
            pathRow(count,:) = pathRows;
            pathCol(count,:) = pathCols;
            pathElev(count,:) = tempPathElev;
            costArray = [costArray;cost];
            
            %Again a counter, so that the previous data is not overwritten,
            %but is instead saved on the next row, so that every pathCol,
            %pathRow and pathElev is saved
            count = count + 1;
            
            %If the position is anywhere else, besides the first and last
            %column
        else
            Orientation = -1; %going west first
            
            %Call greedywalk function
            [pathRowsWest,pathColsWest] = GreedyWalk(currentPos,...
                Orientation,E);
            
            %flip the paths so that they display from left to right, e.g if
            %the pathRows and pathCols was 3 4, and 2 1 respectively it
            %would now be [4 3] and [2 1]. This is so that the final path
            %returned will always be going east
            pathRowsWest = flip(pathRowsWest);
            pathColsWest = flip(pathColsWest);
            
            %Same as west, but going east this time.
            Orientation = 1;
            [pathRowsEast,pathColsEast] = GreedyWalk(currentPos,...
                Orientation,E);
            pathRowsEast = pathRowsEast(2:length(pathRowsEast));
            pathColsEast = pathColsEast(2:length(pathColsEast));
            
            %Concatenating both the western paths and eastern paths
            %together so the path spans the length of the array.
            tempPathRow = [pathRowsWest,pathRowsEast];
            tempPathCol = [pathColsWest,pathColsEast];
            
            %Puts the full path into the pathRow and PathCol arrays
            pathRow(count,:) = tempPathRow;
            pathCol(count,:) = tempPathCol;
            
            %Finds the cost and elevation for the full length path.
            [tempPathElev,cost] = FindPathElevationsAndCost(tempPathRow,...
                tempPathCol,E);
            
            %Puts this data into the elevation and cost arrays.
            pathElev(count,:) = tempPathElev;
            costArray = [costArray;cost];
            
            count = count + 1; %counter so data is put in next row
        end
    end
end

%finds the row number in which the minimum cost is found.
costRow = find(costArray == min(costArray));


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
