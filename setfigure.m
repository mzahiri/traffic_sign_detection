function setfigure(xSize,ySize,xpos,ypos)
% creates a figure with size X,Y in position xpos ypos and prints the same
% size (units are cm).

set(gcf, 'Units','centimeters', 'Position',[xpos ypos xSize ySize])
set(gcf, 'PaperUnits','centimeters')
set(gcf, 'PaperSize',[xSize ySize])
set(gcf, 'PaperPosition',[0 0 xSize ySize])

x1=[0.73,0.54,0.4,0.33,0.3,0.26,0.23,0.22,0.18,0.17,0.161,0.14,0.129,0.12,0.11,0.09,0.079,0.07,0.065,0.06];

x2=[0.6,0.44,0.37,0.31,0.28,0.26,0.25,0.23,0.21,0.196,0.192,0.187,0.179,0.176,0.174,0.166,0.164,0.1638,0.1637,0.1635];