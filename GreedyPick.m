function [pick] = GreedyPick(currentPos,Orientation,E)
%This function chooses which array element to go next, depending on which
%adjacent element results in the smallest change in the elevation. If two
%elements result in the same smallest change, the northenmost value is
%chosen. The element chosen cannot be directly north or south of the
%current position, and must move a column across. The output is the row and
%column of that position that is picked.

%Inputs:E  = the elevation data stored in a 2d r by c matrix %where r is
%             the number of rows and c the number of columns.
%
%       Orientation = an integer representing the direction to head in
%       with a value of  1, heading east and a value of -1 heading west
%
%       currentPosition = a 2 element 1d array, where the first number is
%       the row number, and the second number the column number
%Author: Richard Ng

r = currentPos(1); %row number
c = currentPos(2); %column number
cElevation = E(r,c); %current elevation

%if first row & going east
%nElevation = the possible elevations we can move to in an array, in
%this case there are only two possible positions - this is because if
%starting in row 1, the two accessible choices, is the same row, and
%the row directly underneath it. The row above the first row would be
%outside the matrix, thus we do not look at it

if (r == 1) && (Orientation == 1)
    nElevation = E(r:r+1, c+1);
    
    %same as above, note the c-1, for west
elseif (r == 1) && (Orientation == -1)
    nElevation = E(r:r+1, c-1);
    
    %For positions where we are on the last row, note we are now choosing
    %the nElevations to be either one row above, or the same row, as we
    %cannot pick outside the matrix dimensions
    
elseif (r == size(E,1)) && (Orientation == 1)
    nElevation = E(r-1:r, c+1);
elseif (r == size(E,1)) && (Orientation == -1) %note the c-1 for west.
    nElevation = E(r-1:r, c-1);
    
    %Anywhere else, but the first row and last row, therefore there will be
    %three nElevations instead of 2.
elseif Orientation == 1
    nElevation = E(r-1:r+1, c+1);
elseif Orientation == -1
    nElevation = E(r-1:r+1, c-1);
end



%Call function to get the smallest elevation change, comparing the
%currentPosition, to N, which is a 1d array of newElevations, and
%outputting the element with the smallest change in elevation
[smallestPos] = FindSmallestElevationChange(cElevation,nElevation);

%will get the northernmost value
smallestPos = smallestPos(1);

%The following code will take the element that had the smallest change in
%elevation and manipulate it to get the rows and columns for the position
%picked.

if Orientation == 1 && r == 1 %if row == 1 & heading east
    
    %Array slicing, at row 1 heading east, the next position will always be
    %one column across (either west or east, whereas the row number will be
    %the current row minus 1, plus the position of the element that has the
    %smallest change in elevation.
    pick = [r-1 + smallestPos,c+1];
    
    %The following code executes similarly to the code above, but changed
    %slightly depending on whether we are moving west or east, or depending
    %on whether we are on row 1, the last row, or anywhere else.
elseif Orientation == 1 && r == size(E,1)
    pick = [r-2 + smallestPos,c+1];
elseif Orientation == 1
    pick = [r-2 + smallestPos,c+1];
elseif Orientation == -1 && r == 1
    pick = [r-1 + smallestPos,c-1] ;
elseif Orientation == -1 && r == size(E,1)
    pick = [r-2 + smallestPos,c-1];
elseif Orientation == -1
    pick = [r-2 + smallestPos,c-1];
end
end