function d = getdistance( rssi, model)
% Our model for distance
% rssi to be estimated
% model is an array of coefficients for distance polynomial
% d is the estimated distance
    rssi = abs(rssi);
    d = (model(1,1)*rssi + model(1,2))*1.1;
  %model(1,4)^3*rssi + model(1,3)^2 + model(1,2)*rssi + model(1,1);

end