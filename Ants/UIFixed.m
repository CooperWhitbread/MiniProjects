%UI class for UI shown at a fixed position on the screen at all times
classdef UIFixed
    properties
        m_button;
        m_display = '';
        m_show = true;
        m_textColor = [255, 255, 255];
    end

    methods
        %Constructor
        function obj = UIFixed(topLeft, bottomRight, color, display)
            if nargin > 0
                obj.m_button = Button(topLeft, bottomRight, color);
                obj.m_display = display;
            end
        end

        function r = PressingButton(obj, mouseCoordinates)
            if (obj.m_show)
                r = obj.m_button.PressingButton(mouseCoordinates);
            else
                r = false;
            end
        end

        function cameraRef = Render(obj, cameraRef)
            if (obj.m_show)
                cameraRef = obj.m_button.RenderButton(cameraRef);
                
                switch obj.m_display
                    case '0'
                        cameraRef = obj.Render0(cameraRef);
                    case '1'
                        cameraRef = obj.Render1(cameraRef);
                    case '2'
                        cameraRef = obj.Render2(cameraRef);
                    case '3'
                        cameraRef = obj.Render3(cameraRef);
                    case '4'
                        cameraRef = obj.Render4(cameraRef);
                    case '5'
                        cameraRef = obj.Render5(cameraRef);
                    case '6'
                        cameraRef = obj.Render6(cameraRef);
                    case '7'
                        cameraRef = obj.Render7(cameraRef);
                    case '8'
                        cameraRef = obj.Render8(cameraRef);
                    case '9'
                        cameraRef = obj.Render9(cameraRef);
                    case 'x'
                        cameraRef = obj.RenderX(cameraRef);
                    case ':'
                        cameraRef = obj.RenderCol(cameraRef);
                    case 'A'
                        cameraRef = obj.RenderA(cameraRef);
                    case 'As'
                        cameraRef = obj.RenderAs(cameraRef);
                    case 'F'
                        cameraRef = obj.RenderF(cameraRef);
                    case 'Q'
                        cameraRef = obj.RenderQ(cameraRef);
                    case '-'
                        cameraRef = obj.RenderDash(cameraRef);
                    case 'T'
                        cameraRef = obj.RenderT(cameraRef);
                    case 'N'
                        cameraRef = obj.RenderN(cameraRef);
                    case 'P'
                        cameraRef = obj.RenderP(cameraRef);
                    case 'L'
                        cameraRef = obj.RenderL(cameraRef);
                    case 'Y'
                        cameraRef = obj.RenderY(cameraRef);
                    case 'E'
                        cameraRef = obj.RenderE(cameraRef);
                    case 'X'
                        cameraRef = obj.RenderXLarge(cameraRef);
                    case 'I'
                        cameraRef = obj.RenderI(cameraRef);
                    case 'S'
                        cameraRef = obj.RenderS(cameraRef);
                    case '+'
                        cameraRef = obj.RenderPlus(cameraRef);
                    case 'Leaf'
                        cameraRef = obj.RenderLeaf(cameraRef);
                    case ''
                        %render nothing
                    otherwise
                        disp("Unrecognised UI symbol")
                end
            end
        end

        %%%UI DisplayFunctions%%%
        function cameraRef = RenderX(obj, cameraRef)
            dimensions = obj.m_button.m_bottomRight - obj.m_button.m_topLeft;
            for i = 1:dimensions(1) - 1
                for j = 1: obj.m_button.m_bottomRight(2) - 1
                    if (i-j == 0 || (dimensions(1)-i-j) == 0)
                        cameraRef.m_sceneImage(i + obj.m_button.m_topLeft(1), ...
                            j + obj.m_button.m_topLeft(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + obj.m_button.m_topLeft(1), ...
                            j + obj.m_button.m_topLeft(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + obj.m_button.m_topLeft(1), ...
                            j + obj.m_button.m_topLeft(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        %Numbers%
        function cameraRef = Render1(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || j == 0 || (i == -1 && j ==-1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render2(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == -2 || (i == -1 && j ==1) || ...
                            (i == 0 && j == 0) || (i == 1 && j ==-1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render3(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == -2 || j == 1 || ...
                            (i == 0 && j == 0))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render4(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (j == 1 || (i <= 0 && j == -1) || i == 0)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render5(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == 0 || i == -2 || ...
                            (i == -1 && j ==-1) || (i == 1 && j ==1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render6(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == 0 || i == -2 || j == -1 || ...
                            (i == 1 && j ==1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render7(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == -2 || j == 1)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render8(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == -2 || i == 0 || j == -1 || j ==1)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render9(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == 0 || i == -2 || ...
                            j == 1 || (i == -1 && j ==-1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = Render0(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i == 2 || i == -2 || j == -1 || j == 1)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        %Small Text
        function cameraRef = RenderCol(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if ((j == 0 && i == 1) || (j == 0 && i == -1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderF(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (j == -1 || i == -2 || i == 0)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderQ(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if ((j == 0 && i == -2) || (j == 0 && i == 1) || ...
                            (j == -1 && i == -1) || (j == -1 && i == 0) || ...
                            (j == 1 && i == -1) || (j == 1 && i == 0) || ...
                            (j == 1 && i == 2))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderDash(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -1:1
                    if (i==0)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderPlus(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -2:3
                for j = -2:3
                    if (i == 0 || i == 1 || j == 0 || j == 1)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderLeaf(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft;
            for i = -2:2
                for j = -2:2
                    if ~((j == -2 && i == -2) || (j == 2 && i == 2) || ...
                            (j == -1 && i == -2) || (j == 1 && i == 2) || ...
                            (j == -2 && i == -1) || (j == 2 && i == 1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderAs(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -2:3
                for j = -2:3
                    if ((i == -2 && j == 0) || (i == -2 && j == 1) || ...
                            (i == -1 && j == 0) || (i == -1 && j == 1) || ...
                            (i == 0 && j>=-1 && j <= 2) || ...
                            (i == 1 && j == -1) || (i == 1 && j == 2) || ...
                            (i == 2 ) || ...
                            (i == 3 && j == -2) || (i == 3 && j == -1) || ...
                            (i == 3 && j == 2) || (i == 3 && j == 3))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        %Large Text%
        function cameraRef = RenderA(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if ((i == -3 && j == 0) || (i == -3 && j == 1) || ...
                            (i == -2 && j == 0) || (i == -2 && j == 1) || ...
                            (i == -1 && j <= 2 && j >= -1) || ...
                            (i == 0 && j == -1) || (i == 0 && j == 2) || ...
                            (i == 1 && j == -2) || (i == 1 && j == -1) || ...
                            (i == 1 && j == 2) || (i == 1 && j == 3)|| ...
                            (i == 2 && j >= -2 && j <= 3) || ...
                            (i == 3 && j == -3) || (i == 3 && j == -2) || ...
                            (i == 3 && j == 3) || (i == 3 && j == 4) || ...
                            (i == 4 && j == -3) || (i == 4 && j == -2) || ...
                            (i == 4 && j == 3) || (i == 4 && j == 4))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderN(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (j == -3 || j == -2 || j == 3 || j == 4 || ...
                            (j - i <= 2 && j - i >= -1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderS(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (i == -3 || i == -2 || i == 3 || i == 4 || ...
                            i == 0 || i == 1 || (j == -3 && i ~= 2) || ...
                            (j == -2 && i ~= 2) || (j == 4 && i ~= -1) || ...
                            (j == 3 && i ~= -1))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderT(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (i == -3 || i == -2 || j == 0 || j == 1)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end
        
        function cameraRef = RenderP(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (j == -3 || j == -2 || ...
                        (j ~= -3 && j ~= 4 && ...
                        (i == -3 || i == -2 || i == 0 || i == 1)) || ...
                        (j == 3 && i == -1) || (j == 3 && i == 0) || ...
                        (j == 2 && i == -1) || (j == 2 && i == 0))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderXLarge(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if ((j - i <= 1 && j - i >= -1) || ...
                            (j + i >= 0 && j + i <= 2))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderI(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (j == 0 || j == 1 || i == -3 || i == -2 || ...
                            i == 3 || i == 4)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderE(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if ( j ~= -3 && j ~= 4 && (i == -3 || i == -2 || ...
                        i == 3 || i == 4 || i == 1 || i == 0 ) || ...
                        j == -1 || j == -2)
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderL(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if (j == -1 || j == -2 || (j ~= -3 && j ~= 4 && ...
                            (i == 3 || i == 4)))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end

        function cameraRef = RenderY(obj, cameraRef)
            midPoint = ceil((obj.m_button.m_bottomRight - obj.m_button.m_topLeft)/2) + ...
                obj.m_button.m_topLeft - 1;
            for i = -3:4
                for j = -3:4
                    if ((i >= -1 && (j == 0 || j == 1)) || ...
                        i <= 0 && ((j - i <= 1 && j - i >= -1) || ...
                            (j + i >= 0 && j + i <= 2)))
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 1) = obj.m_textColor(1);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 2) = obj.m_textColor(2);
                        cameraRef.m_sceneImage(i + midPoint(1), ...
                            j + midPoint(2), 3) = obj.m_textColor(3);
                    end
                end
            end
        end


    end %methods
end