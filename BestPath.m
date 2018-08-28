function [pathRow,pathCol,pathElev] =BestPath(E)
%Implementation of DIJKSTRAS SHORTEST PATH ALGORITHM
%Sources used:
%http://vasir.net/blog/game_development/dijkstras_algorithm_shortest_path

%Computerphile - Dijkstras Algorithm
%https://www.youtube.com/watch?v=GazC3A4OQTE

%This function will find the best possible path from the west side of the
%array to the east side. The best possible path would be the path that
%results in the smallest elevation change.

%This function utilises dijkstras algorithm, using a cost matrix, and also
%a pathrow matrix in order to find the best path. This function cycles
%through every element in the array, going down the rows first, and then
%moving to the next column. In each element, the cost to move to the next
%element is saved and this is how the best path is selected. The function
%first sets the first column in the cost matrix to all zero's, this is
%because in the starting positions, there is no cost. Every other value in
%the cost matrix is set to infinity, as we do not know the costs for those
%yet. So for the first element, (1,1) the function looks at the possible
%new elevations, depending on whether we are currently on the first row,
%last row, or anywhere else. The function then calculates the cost to move
%to each of those new elevations, if this cost, plus the cost of the
%current position is less than the cost of the new elevation, then replace
%that cost with the new cost in the cost matrix. For the first element,
%(1,1) it will always replace (1,2) and (2,2) as those values would be set
%to infinity in the cost matrix. Then, if this cost is replaced with the
%new cost, we add the current row number to that same position we are
%moving to. For example, if we starting at (1,1) and changed the cost of
%position (2,2) in the cost matrix, in the path row matrix, the value of
%(2,2) would be 1, as it was at row 1 of the cost matrix that resulted in
%the change in cost. This process is repeated for every element, therefore
%some costs will be replaced, until the smallest cost for that position is
%achieved. Thus at the last column of the cost matrix, the smallest number
%would be the smallest cost to get from one side to the other. This cost is
%then backtracked in order to find the path row indices that the function
%took to get that smallest cost. Once the path row indices have been found,
%the resulting elevation data can be found for the best path can be found.

%Inputs:  E = the elevation data stored in a 2d r x c matrix
%Outputs:  pathRow = a 1d array representing the row indices of the path
%          pathCol = a 1d array representing the column indices of the path
%          pathElev = a 1d array representing the elevations for the
%                     corresponding row and column indices for the path
%Author:Richard Ng

%Preallocate the cost array
costArray = zeros(size(E,1),size(E,2));

%Set everything except the first column to infinity, as per dijkstras
%algorithm, so that the costs can be compared, to see if they are lower.
%The first column is still set to zero, as there is no initial cost in the
%starting position
costArray(:,2:end) = inf;

%Preallocate the pathRowMatrix
pathRowMatrix = zeros(size(E,1),size(E,2));

%the pathCols will always go from 1 to the number of columns of the array,
%so we set it before the majority of the code
pathCol = [1:size(E,2)];

for i = 1:size(E,2)-1 %moving to next column
    for j = 1:size(E,1) %going down the row, i.e row 1,2,3,4
        currentPos = [j,i]; %Set the current position, in rows and columns
        cElevation = E(j,i); %Set the current elevation of that position
        
        %set r = j and c = i to simplify the code, making it easier to see
        %whether we are dealing with rows or columns.
        r = j;
        c = i;
        
        
        if r == 1 %if the current position is in row 1
            
            %Find the possible elevations that we can move to, since we are
            %on the first row, we can only move to the same row, or the row
            %underneath (both one column after, as we are heading east). We
            %do not look at any other elevations, as we cannot move to
            %them.
            nElevation = E(r:r+1, c+1);
            
            %Works out the cost to move to each position.
            Cost = abs(nElevation - cElevation);
            
            
            %implementation of dijkstras algorithim, if the cost of the
            %element you are currently on, plus the cost of moving to the
            %new elevation is less than the cost of that position you are
            %moving to, replace the cost, and also add to the path matrix,
            %the current row that this comparison is taking place in.
            if Cost(1) + costArray(r,c) < costArray(r,c+1)
                costArray(r,c+1) = Cost(1) + costArray(r,c);
                pathRowMatrix(r,c+1) = r;
                
                %need a end here, so if the first if statement is true,it will
                %still check the second if statement.
            end
            %Same as the above, but checking for the second elevation.
            if Cost(2) + costArray(r,c) < costArray(r+1,c+1)
                costArray(r+1,c+1) = Cost(2) + costArray(r,c);
                pathRowMatrix(r+1,c+1) = r;
            end
            
            
        elseif r == size(E,1) %if the currrent position is in the last row
            
            %Find the possible elevations that we can move to, since we are
            %on the last row, we can only move to the same row, or the row
            %above (both one column after, as we are heading east). We
            %do not look at any other elevations, as we cannot move to
            %them.
            nElevation = E(r-1:r, c+1);
            
            %Works out the cost to move to each position.
            Cost = abs(nElevation - cElevation);
            
            %Same process as line 92
            if Cost(1) +  costArray(r,c) < costArray(r-1,c+1)
                costArray(r-1,c+1) = Cost(1) + costArray(r,c);
                pathRowMatrix(r-1,c+1) = r;
            end
            if Cost(2) +  costArray(r,c) < costArray(r,c+1)
                costArray(r,c+1) = Cost(2) + costArray(r,c);
                pathRowMatrix(r,c+1) = r;
            end
            
            
            %Same process, but for anywhere else, thus there are now three
            %possible costs that can change, the same row, the row above,
            %and the row below.
        else
            nElevation = E(r-1:r+1, c+1);
            Cost = abs(nElevation - cElevation);
            if Cost(1) +  costArray(r,c) < costArray(r-1,c+1)
                costArray(r-1,c+1) = Cost(1) + costArray(r,c);
                pathRowMatrix(r-1,c+1) = r;
            end
            if Cost(2) +  costArray(r,c) < costArray(r,c+1)
                costArray(r,c+1) = Cost(2) + costArray(r,c);
                pathRowMatrix(r,c+1) = r;
            end
            if Cost(3) +  costArray(r,c) < costArray(r+1,c+1)
                costArray(r+1,c+1) = Cost(3) + costArray(r,c);
                pathRowMatrix(r+1,c+1) = r;
            end
        end
    end
end

%This section is to backtrack the cost array, using the path row matrix
%formed. This finds the path taken that gave the lowest cost.

%Finds the row number that the lowest cost is in, only looking at the last
%column. We first find the minimum number in the last column of the
%costArray. This number is then compared to all the numbers in the last
%column of the costArray, if it is equal, then the find function will find
%the position of where the minimum number is. Since we do not need the
%columns we only return the row. Also creates a 1d array.
rowArray(1,:) = find(min(costArray(:,size(E,2))) == costArray(:,size(E,2)));

%Set col to last column (number of columns in array)
Col = size(E,2);

%Line 172:line 178. Goes to the next position in the pathRowMatrix, i.e if
%the smallest numberin the last column of the pathRowMatrix was 3, we would
%go to row 3, and then look at that number in that position, if it was we
%would then go to row 2, this loops until we reach the west side of the
%array. The columns would be in descending order, (minus 1 column each time
%as we are backtracking, i.e going west)

for i = 2:size(E,2) %loops until the end of the array is reached
    
    %selects which row to go to next,depending on the number of the current
    %position you are at.
    nextRow = pathRowMatrix(rowArray(i-1),Col);
    rowArray(i) = nextRow; %Puts this number into the rowArray
    i = i+1; %add 1 to i each time to avoid infinite loop
    Col = Col -1; %columns are descending
    
end
%Since we backtracked, we have to flip the row indices, in order to make it
%go from west to east.
pathRow = flip(rowArray);

%Call FindPathElevationsAndCost function, to find the pathElev as we
%already have the row and column indices.
[pathElev] = FindPathElevationsAndCost(pathRow,pathCol,E);
end

