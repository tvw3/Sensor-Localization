function d = getdistance( rssi)
% Our model for distance
% rssi to be estimated
% model is an array of coefficients for distance polynomial
% d is the estimated distance
    rssi = abs(rssi);
    model = [-2.18246080708627,-68.1159769450309];
    d = polyval(model, rssi);
  %model(1,4)^3*rssi + model(1,3)^2 + model(1,2)*rssi + model(1,1);

end