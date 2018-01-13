/*
 * Copyright (c) 2018 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package;

import kha.System;
import jasper.*;

class Main {
    public static function main() : Void
    {
        var _width :Float = 780;
        var _height :Float = 400;
        var solver = new Solver();

        var window = new Rectangle(0xff00ff00);
        solver.addConstraint(window.x == 0);
        solver.addConstraint(window.y == 0);
        solver.addConstraint((window.width == _width) | Strength.WEAK);
        solver.addConstraint((window.height == _height) | Strength.WEAK);

        var leftChild = new Rectangle(0xfff0ff00);
        solver.addConstraint(leftChild.x == window.x + 10);
        solver.addConstraint(leftChild.y == window.y + 10);
        solver.addConstraint(leftChild.width == (window.width/2 - 20));
        solver.addConstraint(leftChild.height == (window.height - 20));

        var rightChild = new Rectangle(0xfff0ffff);
        solver.addConstraint(rightChild.x == (window.x + window.width) - (window.width/2 - 10));
        solver.addConstraint(rightChild.y == window.y + 10);
        solver.addConstraint(rightChild.width == (window.width/2 - 20));
        solver.addConstraint(rightChild.height == (window.height - 20));

        var centerChild = new Rectangle(0xffffff00);
        solver.addConstraint(centerChild.x == window.width/4);
        solver.addConstraint(centerChild.y == window.height/4);
        solver.addConstraint(centerChild.width == (window.width/2));
        solver.addConstraint(centerChild.height == (window.height/2));
        


        _rectangles = 
            [ window
            , leftChild
            , rightChild
            , centerChild
            ];
        solver.updateVariables();
        solver.addEditVariable(window.width, Strength.MEDIUM);
        solver.addEditVariable(window.height, Strength.MEDIUM);

        System.init({title: "jasper-example", width: 1366, height: 768}, function() {
            System.notifyOnRender(render);

            var _isDown :Bool = false;
            kha.input.Mouse.get().notify(function(a,x,y) {
                _isDown = true;
            }, function(a,x,y) {
                _isDown = false;

            }, function(x,y,c,d) {
                if(_isDown) {
                    solver.suggestValue(window.width, x);
                    solver.suggestValue(window.height, y);
                    solver.updateVariables();
                }
                
            }, function(a) {

            });
        });
    }

    public static function render(framebuffer: kha.Framebuffer): Void 
    {
        framebuffer.g2.begin();
        for(rectangle in _rectangles) {
            rectangle.render(framebuffer);
        }
        framebuffer.g2.end();
	}

    private static var _rectangles :Array<Rectangle>;
}