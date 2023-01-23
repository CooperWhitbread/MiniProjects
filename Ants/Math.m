%Math

classdef Math
    methods
        function dist = DistanceXY(obj, x, y)
            %Calculates the distance between two values
            dist = sqrt(x^2+y^2);
        end

        function magnitude = Magnitude(obj, v)
            %calculates the magnitutde of a vector
            magnitude = sqrt(v(1)^2+v(2)^2);
        end

        function vector = Normalize(obj, v)
            %converts a vector into a unit vector
            length = obj.Magnitude(v);
            vector = v / length;
        end

        function r = WaveFunction(obj, x, min)
            %the math function that renders the waves
            r = (255-min) * x * exp(-0.4*x) + min;
        
            %Cap off the minimum value at min
            if (r < min)
                r = min;
            end
        end

        function r = LeafFunction(obj, x)
            r = 10*cos(x / 4) + 5;
        end

        function [r, g, b] = NestFunction(obj, distance)
            r = 250/(1+150*exp(-0.65*distance));
            g = 220/(1+150*exp(-0.65*distance));
            b = 170/(1+150*exp(-0.65*distance));

        end

        function r = LimitValue(obj, x, min, max)
            %limit the value of x to between min and max
            %Adjust using the range
            r = zeros(size(x));
            for i = 1:length(x)
                if (x(i) < min(i))
                    r(i) = min(i);
                elseif (x(i) > max(i))
                    r(i) = max(i);
                else
                    r(i) = x(i);
                end
            end
        end

        function r = CycleValue(obj, x, min, max)
            %limit the value of x to between min and max
            %Adjust using the range
            if (x < min)
                r = x + max - min;
            elseif (x > max)
                r = x - max + min;
            else
                r = x;
            end
        end

        function angle = CalculateAngle(obj, direction)
            %Set the axis for calculating the angle of rotation off of
            zeroAxis = [0, 1];
        
            %Calculate the angle of rotation by usig the angle between two vectors
            %formula
            angle = acos(dot(zeroAxis, direction) / ...
                (obj.Magnitude(zeroAxis) * obj.Magnitude(direction)));
            
            %control angle's sign based on the initial direction's x value
            if (direction(1) < 0)
                angle = -angle;
            end
            
        end

        function number = GetNumberAtIndex(obj, number, index)
            number = number - floor(number/10^(index))*10^index;
            number = floor(number/10^(index-1));
        end

        function [m, s] = ConvertTime(obj, time)
            m = floor(time/60);
            s = time - m * 60;
        end

        function direction = GenerateRandomDirection45(obj)
            direction = randi([-1,1], [1,2]);
            while (direction == [0,0])
                direction = randi([-1,1], [1,2]);
            end
        end
        
    end %methods
end