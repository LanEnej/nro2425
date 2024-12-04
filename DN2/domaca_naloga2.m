clc;
clear all;

data = readmatrix('vozlisca_temperature_dn2.txt', 'NumHeaderLines', 4);
x = data(:,1); % x-koodrinate vozlisc
y = data(:,2); % y-koordinate vozlisc
T = data(:,3); % temp

cells = readmatrix('celice_dn2.txt', 'NumHeaderLines', 2);

for i = 1:size(cells, 1)
    
    cell_points = cells(i,:); 

    cell_point1 = cell_points(1);
    cell_point2 = cell_points(2);
    cell_point3 = cell_points(3);
    cell_point4 = cell_points(4);

    x1 = x(cell_point1);
    x2 = x(cell_point2);
    x3 = x(cell_point3);
    x4 = x(cell_point4);

    y1 = y(cell_point1);
    y2 = y(cell_point2);
    y3 = y(cell_point3);
    y4 = y(cell_point4);

end

% Definiramo koordinate v katerih iščemo temperaturo T
X = 0.403;
Y = 0.503;

%UscatteredInterpolant
tic
T_interp_sc = scatteredInterpolant(x,y,T,'linear','none');
T1 = T_interp_sc(X,Y);
time1 = toc;
fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo scatteredInterpolant ' ...
    'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T1, time1);

%griddedInterpolant

xg = unique(x(:)); % vektor, odstrani podvojene vrednosti in razvrsti po velikosti
yg = unique(y(:));

[Xg, Yg] = ndgrid(xg, yg); 
% Izračun števila točk vzdolž osi x in y
stX = length(xg); % Število unikatnih vrednosti v xg
stY = length(yg); % Število unikatnih vrednosti v yg
Tg = reshape(T, stX ,stY); 

tic
T_interp_gr = griddedInterpolant(Xg,Yg,Tg,'linear','none');
T2 = T_interp_gr(X, Y);
time2 = toc;
fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo griddedInterpolant ' ...
    'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T2, time2);

% Interpolacija z bilinearno interpolacijo
tic;

for i = 1:size(cells, 1)
    cell_points = cells(i, :);
    
    % Koordinate vozlišč celice
    x_min = x(cell_points(1));
    x_max = x(cell_points(2));
    y_min = y(cell_points(1));
    y_max = y(cell_points(3));
    
    % Preverimo, če točka (X, Y) spada v to celico
    if (X >= x_min && X <= x_max && ...
        Y >= y_min && Y <= y_max)
        
        % Temperatura v vozliščih celice
        T11 = T(cell_points(1)); % T(x_min, y_min)
        T21 = T(cell_points(2)); % T(x_max, y_min)
        T22 = T(cell_points(3)); % T(x_min, y_max)
        T12 = T(cell_points(4)); % T(x_max, y_max)
        
        K1 = ((x_max - X) / (x_max - x_min)) * T11 + ...
             ((X - x_min) / (x_max - x_min)) * T21;
        K2 = ((x_max - X) / (x_max - x_min)) * T12 + ...
             ((X - x_min) / (x_max - x_min)) * T22;
        T3 = ((y_max - Y) / (y_max - y_min)) * K1 + ...
             ((Y - y_min) / (y_max - y_min)) * K2;
  
        time3 = toc;
        fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo lastne interpolacije ' ...
             'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T3, time3);
        
        break;
    end
end

% Največja temperatura in njene koordinate
[max_temp, max_index] = max(T);
max_x = x(max_index);
max_y = y(max_index);
fprintf('Največja temperatura: %.2f°C na koordinatah (%.3f, %.3f)\n', max_temp, max_x, max_y);
